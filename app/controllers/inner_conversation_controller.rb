class InnerConversationController < ApplicationController
before_filter :confirm_logged_in


	
	#GET inner circle conversations
	def index
		userID = whoAreYou()
		#grab a list of the users friends
									#change this to userID
														
		myListofFriends = Follow.where({:user_id => userID, :Favorite => true}) #only grab friends who are my favorite
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
			     myMessage = Message.where(:conversation_id => conversation.conversation_id).order("updated_at DESC").limit(1)
			     #append the most recent message
			     myFriendsConversations << myMessage[0]
		    end
		end
		
		
		#######################################################################################################################
		#i must also append to myFriendsConversations list the conversations that I am involved in as well
												#change this to userID
		myConvo = UserConversationMmTable.where({:user_id => userID}).order("updated_at DESC").limit(20)
		#this array will hold the 20 messages
		#iterate through the 20 most recent conversations
		myConvo.each do |conversation|
			  #find the most recent message for each conversation
			  #remember this can't be an array
			  myMessage = Message.where(:conversation_id => conversation.conversation_id).order("updated_at DESC").limit(1)
			  #append the most recent message
			  myFriendsConversations << myMessage[0]
		 end
		 #######################################################################################################################
		 
		 
		 #sort the messages by created at with most recent coming up first
		 myFriendsConversations.sort_by!{|message| message.created_at}.reverse!
		 #deliver only 25 messages to the user
		 myFriendsConversations = myFriendsConversations.take(25)		 
		 #create JSON
		 @myJSON=[]
		 	#store message object attributes in a a dictionary
			myFriendsConversations.each do |message|
				diction = {}
				diction[:conversation_id] = message.conversation_id
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
				#append the dictionary into the array
				@myJSON << diction
			end
			
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
