class ConversationController < ApplicationController
before_filter :confirm_logged_in
	
	#GET ALL conversations
	def index
		userID = whoAreYou()
		
		#grab a list of the users friends
									#change this to userID						
		myListofFriends = Follow.where(:user_id => userID)
		#this will hold a collection of most recent messages for each of the user's friends
		myFriendsConversations =[]
	   	myListofFriends.each do |friend|
		#this block of code finds the most recent 20 message for most recent convo for a given user
			#find 20 conversation id's for the friend
		    myConvo = UserConversationMmTable.where({:user_id => friend.follow_id}).order("updated_at DESC").limit(20)
		    #this array will hold the 20 messages
		    #iterate through the 20 most recent conversations
		    myConvo.each do |conversation|
			     #find the most recent message for each conversation
			     #remember this can't be an array
			     myMessage = Message.where(:conversation_id => conversation.conversation_id).order("created_at DESC").limit(1)
			     #append the most recent message
			     myFriendsConversations << myMessage[0]
		    end
		end
		
		
		
		
		#i must also append to myFriendsConversations list the conversations that I am involved in as well
												#change this to userID
		myConvo = UserConversationMmTable.where({:user_id => userID}).order("updated_at DESC").limit(20)
		#this array will hold the 20 messages
		#iterate through the 20 most recent conversations
		myConvo.each do |conversation|
			  #find the most recent message for each conversation
			  #remember this can't be an array
			  myMessage = Message.where(:conversation_id => conversation.conversation_id).order("created_at DESC").limit(1)
			  #append the most recent message
			  myFriendsConversations << myMessage[0]
		 end
		 #sort the messages by created at with most recent coming up first
		 myFriendsConversations.sort_by!{|message| message.created_at}.reverse!		#this will give an older conversation with a more recent message higher on the list because it will sort ahead of the newer conversation but with a message not as new as an older conversation
		 
		 #remove doubles (conversations) because multiple friends in same conversation
		 myFriendsConversationNoDoubles = []
		 myFriendsConversations.each do |object|
			flag = false
			myFriendsConversationNoDoubles.each do |object2|
				if object.conversation_id == object2.conversation_id
					flag = true
					break
				end
			end
			if flag == false
				myFriendsConversationNoDoubles << object
			end
		 end

		 #deliver only 25 messages to the user
		 myFriendsConversationNoDoubles = myFriendsConversationNoDoubles.take(25)
		 
		 
		 #create JSON
		 @myJSON=[]
		 	#store message object attributes in a a dictionary
			myFriendsConversationNoDoubles.each do |message|
				diction = {}
				diction[:conversation_id] = message.conversation_id
					#look up all participants in the conversation
					linkingUserConvoList = UserConversationMmTable.where(:conversation_id => message.conversation_id)
					#iterate this list to find the names of the users
					recipient = ""
					linkingUserConvoList.each do |record|
						myUser = User.find_by_id(record.user_id) #find the user
						if(myUser != nil)
							firstName = myUser.first_name
							name = firstName + ". " 
							recipient << name
						end	
					end
				diction[:recipient] = recipient
				diction[:created_at] = message.created_at
				diction[:id] = message.id
				diction[:message_content] = message.message_content
				diction[:user_id] = message.user_id
					#look up the user's name
					myUser = User.find_by_id(message.user_id)
					firstName = myUser.first_name
					lastName = myUser.last_name
					name = firstName + " " + lastName
				diction[:full_name] = name
				diction[:userName] = myUser.userName
				
				#after setting up Amazon S3 the commented out is no longer needed
				#form URL for the profilePicture
				#locationOfQ = myUser.profilePic.url.rindex('?')
				#relativePath = myUser.profilePic.url[0...locationOfQ]
				#baseURL = baseURLFunc()
				
				diction[:profilePic] = myUser.profilePic 				#baseURL + relativePath
				
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
				
				#append messageID data
				diction[:message_id] = message.id
				
				#append the dictionary into the array
				@myJSON << diction
			end
		puts @myJSON.length	
		 render :json => @myJSON
		 	
	end
	
	#GET
	def new
	  render "new"
	end
	
	def create
	end
	
	#GET
	def show
	  render "show"
	end	
	
	
	#GET
	def edit
	  render"edit"
	end
	
	def update
	end
	
	def destroy
	end
	
end
