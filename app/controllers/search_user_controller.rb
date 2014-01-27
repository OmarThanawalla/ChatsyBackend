class SearchUserController < ApplicationController
before_filter :confirm_logged_in

	#return a list of users that match the query
	def index
		userID = whoAreYou() #identify you
		userID = User.find(userID)  
		query =  params[:searchQuery]
		#searchUsers is available in User Model 
		results = User.searchUsers(query,userID) #it will not return the user in the search results
		@myJSON =[]
		results.each do |user|
			diction ={}
			diction[:first_name] = user.first_name
			diction[:last_name] = user.last_name
			diction[:userName] = user.userName
			diction[:Bio] = user.Bio
			diction[:id] = user.id
				#test for followingship
				length = Followers.where({:user_id => user.id, :follower_id => userID.id}).length
				areWeFriends = ""
				if length == 0 #because no records were found
					areWeFriends = "NO"
				else
					areWeFriends = "YES" #what this really means is have I asked to be friends, not are we really friends
				end
			diction[:is_friend] = areWeFriends #see above comment
			diction[:profilePic] = user.profilePic
			puts diction[:is_friend]
			@myJSON << diction		
		end
		
		render :json => @myJSON
	end



end
