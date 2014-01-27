class FollowController < ApplicationController
#before_filter :confirm_logged_in

		#user sends a request to follow someone
		
	def index
		userID = whoAreYou()
		peopleIFollow = Follow.where(:user_id => userID)
		@myJSON = []
		
		puts "kasdjfa;lksdjfla;ksjdflasjdkfa"
		puts peopleIFollow
		
		
		if peopleIFollow != nil && peopleIFollow.length != 0 #assuming i am following people
			#transform Follow objects into User objects
			myUsers = []
			peopleIFollow.each do |object|
				puts "object coming up"
				puts object.follow_id
				aUser = User.where(:id => object.follow_id)
				puts "laskdjfalskdjflaskdjfasdf"
				puts aUser
				myUsers << aUser[0]
			end
			
	
			myUsers.each do |aUser|
				diction = {}
				diction[:pictureURL] = aUser.pictureURL
				firstName = aUser.first_name
				lastName = aUser.last_name
				diction[:fullName] = firstName + " " + lastName
				diction[:userName] = aUser.userName
				diction[:bio] = aUser.Bio
				diction[:userID] = aUser.id
				diction[:profilePic] = aUser.profilePic
				@myJSON << diction
			end
		else
			@myJSON = []
		end
		render :json => @myJSON
	end	
		
		
	def create
		userID = whoAreYou()
		#targetFollow contains the userID for the person 
	  	targetUser = params[:targetFollow]
	  	
	  	#make a request to follow someone by creating a record in the Followers table and setting confirmed to 0
	  	#but first make sure a record doesn't exist (you aren't make multiple request)
	  	if Followers.where({:user_id => targetUser, :follower_id => userID}).length == 0 #a record doesnt exist yet
	  		myRequest = Followers.new({:user_id => targetUser, :follower_id => userID})
	  		myRequest.save
	  		
	  		#Send a push notification to targetUser that userID requests to follow them
	  		#get targetUser
	  		myUser = User.find(targetUser)
	  		deviceID = myUser.deviceTokens
	  		yourUser = User.find(userID)
	  		firstName = yourUser.first_name
	  		lastName = yourUser.last_name
	  		fullName = firstName + " " + lastName
	  		alertMessage = fullName + " has requested to follow you on chatsy! :) "
	  		
	  		pusher = Grocer.pusher(
			  certificate: "lib/assets/ckProduction.pem",      # required
			  passphrase:  "",                       # optional
			  gateway:     "gateway.push.apple.com", # optional
			  port:        2195,                     # optional
			  retries:     3                         # optional
		  )
		  
		  notification = Grocer::Notification.new(
			  device_token: deviceID,
			  alert:        alertMessage,
			  badge:        0,
			  sound:        "",         			# optional
			  expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
			  identifier:   1234                  # optional
			)			
		 pusher.push(notification)
	  		
	  		@confirm = ["Request Sent"]
	  		render :json => @confirm
	  	else #record already exists, could be pending or could be confirmed
	  		@confirm = ["Your request is pending, please dont try again"]
	  		render :json => @confirm
	  	end

	end
	
	
	#      follow/1      i didnt know how to call DELETE http verb. and i was too lazy to write another controller
	def show
		userID = whoAreYou()
		followerID = params[:followerID]
		
		#destroy the record where it shows i follow someone
		Follow.where(:user_id => userID, :follow_id => followerID)[0].destroy
		
		# destroy the record that shows how I was a follower to someone else
		Followers.where(:user_id => followerID, :follower_id => userID)[0].destroy
		
	    @result = ["method complete"]
	    render :json => @result
	end
	
	
end
