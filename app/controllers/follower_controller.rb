class FollowerController < ApplicationController
before_filter :confirm_logged_in



	#returns a list of users who want to follow you
	#GET /follower						
	def index
		userID = whoAreYou()
		
		#grab a list of pending follow requests 
		myFollowers = Followers.where(:user_id => userID, :Confirmed => false)
		
		#convert them into users
		myUsers = []
		myFollowers.each do |object|
			aUser = User.where(:id => object.follower_id)
			myUsers << aUser[0]
		end
		puts myUsers
		#set up the proper information to send back
		@myJSON = []
		myUsers.each do|aUser|
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
		
		render :json => @myJSON
		
	end
	

	
	
	
	#POST /follower 
	def create
	  	userID = whoAreYou()
	  	followerID = params[:followerID] 
	  	
	  	#set the Followers record to true
	  	myFollower = Followers.where(:user_id => userID, :follower_id => followerID)
	  	if myFollower[0] != nil 
	  		myFollower[0].Confirmed = true
	  		myFollower[0].save
	  		
	  		#create a record in the Follow
	  		Follow.create(:user_id => followerID, :follow_id => userID)
	  		puts "asdfasdfsadfasdfasdfasdfsadfsadf"
	  		
	  	end
	  	
	  	
	  	@test = ["success"]
	  	render :json => @test
	end
	
	




end
