class GetMessageController < ApplicationController
before_filter :confirm_logged_in


#do work here because youll be sending your convo_id through the post anyways
		def index
			userID = whoAreYou()
			convoIdent = params[:conversationID]
			
			@messages = Message.where(:conversation_id => convoIdent).order("updated_at ASC").limit(20)
			@myJSON = []
			@messages.each do |message|
				diction = {}
				diction[:id] = message.id
				diction[:message_content] = message.message_content
				diction[:user_id] = message.user_id
				diction[:conversation_id] = message.conversation_id
				diction[:created_at] = message.created_at
				diction[:updated_at] = message.updated_at
				#look up the user's name
					myUser = User.find(message.user_id)
					firstName = myUser.first_name
					lastName = myUser.last_name
					name = firstName + " " + lastName
				diction[:full_name] = name
				diction[:userName] = myUser.userName
				diction[:profilePic] = myUser.profilePic
				diction[:likes] = message.likes
				
				#check whether this message has been liked by the user asking for the message
				if( Like.where(:user_id => userID, :message_id => message.id).length == 0 ) #there is no record, therefore no like
					diction[:hasBeenLiked] = false
				else
					diction[:hasBeenLiked] = true
				end 
				
				@myJSON  << diction
			end
			render :json => @myJSON
		end
		
		def new
		end
		
		#submit a message to an existing conversation
		def create #POST
		
			#step 1: grab the conversationID and form the message
			userID = whoAreYou()
			aUser = User.find(userID)
			name = aUser.userName
			conversationID = params[:conversationID]
			messageContent = params[:message]
						
			
			#step 1.5:  attempt to make entry for the user posting the message, this is important because if they werent part of the conversation then they needed to be added
			#			this will silently do nothing if they are already a part of the conversation (postgre will ROLLBACK)
			UserConversationMmTable.create(:conversation_id => conversationID, :user_id => userID)
			
			#step 2: attempt entries into the UserConversationMM table for all people in the message content
			#		 people already in this conversation will have nothing happen to them (postgre will ROLLBACK), but people not in the conversation will have their userID hooked up to the convoID in MM table
			messageList = messageContent.split()
			
			messageList.each do |word|
				if word[0] == "@"
					wordLowered = word.downcase
					myUser = User.where(:userName => word)
					#if its a real user then make the entry
					if myUser != nil && myUser.length != 0
						#model validations and a postgresql index will make sure user cannot be in the same convo twice
						UserConversationMmTable.create(:user_id => myUser[0].id, :conversation_id => conversationID)
					end
				end
			end
			
			#step 3: Definantly post the message in the table
			myMessage = Message.new(:message_content => params[:message], :user_id => userID, :conversation_id => params[:conversationID])
			
			#step 4: Apple Push notification to everyone with @<user> in the content of the message 
			pusher = Grocer.pusher(
			  certificate: "lib/assets/ckProduction.pem",      # required
			  passphrase:  "",                       # optional
			  gateway:     "gateway.push.apple.com", # optional
			  port:        2195,                     # optional
			  retries:     3                         # optional
		  )	
			
			messageList.each do |word|
				if word[0] == "@"
					wordLowered = word.downcase
					myUser = User.where(:userName => wordLowered)
					#puts "al;dkjf;alfff????????"
					#puts wordLowered
					messagePush = name + ": " + messageContent + ""
					#if its a real user and they have a token on file then push notification
					if myUser != nil && myUser.length != 0 && (myUser[0].deviceTokens != "")
						#puts myUser[0].id
						deviceID = myUser[0].deviceTokens
						#puts deviceID
						#puts "that would be the best"
						#when submitting multiple notifications see the Grocer ReadMe for the best way to do this
					    notification = Grocer::Notification.new(
					    device_token: deviceID,
					    alert:        messagePush,
					    badge:        0,
					    sound:        "",         			# optional
					    expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
					    identifier:   1234                  # optional
					    )			
						pusher.push(notification)
						
					end
				end
			end
			
			
			
			if myMessage.save
				@result = ["Message sent"]
				render :json => @result
			else
				@result = ["Message failed"]
				render :json => @result
			end
		end
		
		#/get_message/:id
		def show
		end
		
		def edit #GET
		end
		
		def update #PUT
		end
		
		def destroy
		end


end
