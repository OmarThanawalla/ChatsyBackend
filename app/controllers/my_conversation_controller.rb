class MyConversationController < ApplicationController
before_filter :confirm_logged_in

	#returns a list of conversations that the user is a part of
	def index
	userID = whoAreYou()
	 #get a list of the 20 most recent conversations for the user
													#user_id has to be gotten from authentication
		  myConvo = UserConversationMmTable.where({:user_id => userID}).order("updated_at DESC").limit(20)
		  #this array will hold the most recent message for each conversation
		  mostRecentMessageForEachConversation = []
		  #iterate through the 20 most recent conversations
		  myConvo.each do |conversation|
			  #find the most recent message for each conversation
			  #remember this can't be an array
			  myMessage = Message.where(:conversation_id => conversation.conversation_id).order("created_at DESC").limit(1)
			  #append the most recent message
			  mostRecentMessageForEachConversation << myMessage[0]
		  end
		  #sort the messages by created at with most recent coming up first
		  mostRecentMessageForEachConversation.sort_by!{|message| message.created_at}.reverse!
		  
		  
		  @myJSON=[]
		 	#store message object attributes in a a dictionary
			mostRecentMessageForEachConversation.each do |message|
				diction = {}
				diction[:conversation_id] = message.conversation_id
				#look up all participants in the conversation
					linkingUserConvoList = UserConversationMmTable.where(:conversation_id => message.conversation_id)
					#iterate this list to find the names of the users
					recipient = ""
					linkingUserConvoList.each do |record|
						myUser = User.find(record.user_id) #find the user
						firstName = myUser.first_name
						name = firstName + ". " 
						recipient << name
					end
				diction[:recipient] = recipient	
				diction[:created_at] = message.created_at
				diction[:id] = message.id
				diction[:message_content] = message.message_content
				diction[:user_id] = message.user_id
					#look up the user's name
					myUser = User.find(message.user_id)
					firstName = myUser.first_name
					lastName = myUser.last_name
					name = firstName + " " + lastName
				diction[:full_name] = name
				diction[:userName] = myUser.userName
				diction[:profilePic] = myUser.profilePic
				
				#build a string of userNames that consists of all users in the conversation
				listOfMmObjects = UserConversationMmTable.where(:conversation_id =>message.conversation_id)
					#create a userIDs list of all people in the conversation
				userIDs = []
				listOfMmObjects.each do |x|
					userIDs << x.user_id
					puts x.user_id
				end
					#cultivate a list of userNames for all people in the conversation
				preAddressing = ""
				userIDs.each do | someUser |
					#don't add the person requesting the conversations into the preaddressing
					if(someUser == userID)
						next
					end
					myUser = User.where(:id => someUser)[0] #because User.where returns an array of length 1
					preAddressing = preAddressing + myUser.userName + " "
				end
				diction[:preAddressing] = preAddressing
				#append the number of likes that message has
				diction[:likes] = message.likes
				
				#check whether this message has been liked by the user asking for the message
				if( Like.where(:user_id => userID, :message_id => message.id).length == 0 ) #there is no record, therefore no like
					diction[:hasBeenLiked] = false
				else
					diction[:hasBeenLiked] = true
				end
				
				
				#append the dictionary into the array
				@myJSON << diction
			end
			
		 render :json => @myJSON
		 	
		  
		  
	end

	def new
	end
	
	def create
	end
	
	def show
	end
	
	def edit
	end
	
	def update
	end
	
	def destroy
	
	end
end	
