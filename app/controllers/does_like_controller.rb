class DoesLikeController < ApplicationController
#before_filter :confirm_logged_in


		#this will be our delete action (unliking a message)
		def index
			userID = whoAreYou()
			messageID = params[:messageID]
			
			@confirmation  = [""]
			#ATTEMPT to find the record
			@results = Like.where(:user_id => userID, :message_id => messageID)
			
			if @results.length == 0
				#you never liked it to begin with, so how can we delete it!
				@confirmation = ["you never liked it to begin with, so how can we delete it!"]
			else
				#destory the record
				@results[0].destroy
				
				#decrement the cumulativeLikes in Messages Table
				theMessage = Message.where(:id => messageID)[0]
				likeCount = theMessage.likes
				likeCount = likeCount - 1
				theMessage.likes = likeCount
				theMessage.save
				
				@confirmation = ["You successfully deleted the record in Likes Table"]
			end
			
			render :json => @confirmation
			
		end

		#POST verb
		def create
			userID = whoAreYou()
			messageID = params[:messageID]
			
			@confirmation = [""]
			#search Likes Table
			@results = Like.where(:user_id => userID, :message_id => messageID)
			
			#if record exists do nothing; user already liked that message
			if @results.length == 1
				#do nothing
				@confirmation = ["Record exists, you can't like the same message twice"]
			else #record == 0
			
				#create a record in the Likes table
				myLike = Like.create(:user_id => userID, :message_id => messageID, :favors => true)
				
				#increment the cumulativeLikes in Messages Table
				theMessage = Message.where(:id => messageID)[0]
				likeCount = theMessage.likes
				likeCount = likeCount + 1
				theMessage.likes = likeCount
				theMessage.save
				
				@confirmation = ["Like was created, thankyou cutie"]
				
				
				#notify xyz that userID liked their message
				result = Message.where(:id => messageID)[0]
				if(result)
					#find the deviceToken for recipient of message
					recipientID = result.user_id
					recipient = User.find(recipientID)
					deviceID = recipient.deviceTokens
					
					#create full name string
					yourUser = User.find(userID)
					firstName = yourUser.first_name
					lastName = yourUser.last_name
					fullName = firstName + " " + lastName
					alertMessage = yourUser.userName + " likes: '" + theMessage.message_content + "' "
					
					pusher = Grocer.pusher(
					  certificate: "lib/assets/ckProduction.pem",      # required
					  passphrase:  "",                       # optional
					  gateway:     "gateway.push.apple.com", # optional; See note below.
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
				end
				
			end
			
		render :json => @confirmation	
			
		end




end
