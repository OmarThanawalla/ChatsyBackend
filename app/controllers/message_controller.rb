class MessageController < ApplicationController
before_filter :confirm_logged_in

	
	def index
	pusher = Grocer.pusher(
			  certificate: "lib/assets/ckProduction.pem",      # required
			  passphrase:  "",                       # optional
			  gateway:     "gateway.push.apple.com", # optional; See note below.
			  port:        2195,                     # optional
			  retries:     3                         # optional
		  )
		  
		  notification = Grocer::Notification.new(
			  device_token: "23ea13c2670add66676a1b850c5c9e6857a9925bc62772465013ae4c8dc02ef7",
			  alert:        "Hello from Grocer!",
			  badge:        0,
			  sound:        "",         			# optional
			  expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
			  identifier:   1234                  # optional
			)			
		 pusher.push(notification)
	  render "index"
	end
	
	def new	  
	
		pusher = Grocer.pusher(
			  certificate: "lib/assets/ckProduction.pem",      # required
			  passphrase:  "",                       # optional
			  gateway:     "gateway.push.apple.com", # optional; See note below.
			  port:        2195,                     # optional
			  retries:     3                         # optional
		  )
		  
		  notification = Grocer::Notification.new(
			  device_token: "23ea13c2670add66676a1b850c5c9e6857a9925bc62772465013ae4c8dc02ef7",
			  alert:        "Hello from Grocer!",
			  badge:        0,
			  sound:        "",         			# optional
			  expiry:       Time.now + 60*60,     # optional; 0 is default, meaning the message is not stored
			  identifier:   1234                  # optional
			)			
		 pusher.push(notification)
	  render "new"
	end
	
	#CREATES MESSAGE AND CONVERSATION
	def create
		userID = whoAreYou()

		#make sure message is valid
		if params[:message] != "" && params[:message].length >= 1
			
			
			#STEP 1: create a conversation record
			myConvo = Conversation.create
			
			#STEP 2: create a linking record in UserConversation..MM Table
			myHookup = UserConversationMmTable.create(:conversation_id => myConvo.id, :user_id => userID)
			
			#STEP 3: create the message and link it to the convo record and user record
			myMessage = Message.create(:user_id => userID, :conversation_id => myConvo.id, :message_content => params[:message])
			
			#STEP 4: add any users in the message as part of the conversation
			messageList = params[:message].split()
			
			messageList.each do |word|
			
				if word[0] == "@"
					wordLowered = word.downcase
					myUser = User.where(:userName => wordLowered)
					#if its a real user then make the entry
					if myUser != nil && myUser.length != 0
						puts myUser[0].id
						#model validations and a postgresql index will make sure user cannot be in the same convo twice
						UserConversationMmTable.create(:user_id => myUser[0].id, :conversation_id => myConvo.id)
					end
				end
			end
			
			#STEP 5: APPLE PUSH NOTIFICATION to everyone with @<username> in the content of the message
			
			#create body of push notification payload
			aUser = User.find(userID)
			name = aUser.userName
			messageContent = params[:message]
			messagePush = name + " : " + messageContent + ""
			
			#set credentials 
			pusher = Grocer.pusher(
			  certificate: "lib/assets/ckProduction.pem",      # required
			  passphrase:  "",                       # optional
			  gateway:     "gateway.push.apple.com", # optional; See note below.
			  port:        2195,                     # optional
			  retries:     3                         # optional
		  )	
			
			#for each user create and send push notification
			messageList.each do |word|
				if word[0] == "@"
					wordLowered = word.downcase
					myUser = User.where(:userName => wordLowered)
					
					#if its a real user and they have a token on file then push notification
					if myUser != nil && myUser.length != 0 && (myUser[0].deviceTokens != "")
						puts myUser[0].id
						deviceID = myUser[0].deviceTokens
						
						#create push notification
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

			@confirmation = ["Message Sent"] #i lost one hour on this stupid error, not putting message sent in brackets lol.
			render :json => @confirmation
			#redirect_to => (:action => "index")
		end
	end
	
	def edit
	  render"edit"
	end
	
	def show
	  render "show"
	end
	
end
