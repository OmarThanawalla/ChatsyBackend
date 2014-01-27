class FriendListFbController < ApplicationController

	#returns back a list of friends who are registered on chatty after calling facebook API
	def index
		userID = whoAreYou() #identify you
		userID = User.find(userID) #returns user object  
		#@test = [params[:fbToken]]
		user = FbGraph::User.me(params[:fbToken])
		#puts user.friends.length
		#returns a list of friends
		collection = []
		user.friends.each do |myUser|
			adNomen = myUser.name.split
			firstName =  adNomen[0]
			lastName =  adNomen[-1]
			result = User.where(:first_name => firstName, :last_name => lastName)[0]
			if(result)
				#puts result
				diction = {}
				diction[:firstName] = result.first_name
				diction[:lastName] = result.last_name
				diction[:userName] = result.userName
				diction[:profilePic] = result.profilePic
				diction[:id] = result.id
				
				#test for followingship
				length = Followers.where({:user_id => result.id, :follower_id => userID.id}).length
				areWeFriends = ""
				if length == 0 #because no records were found
					areWeFriends = "NO"
				else
					areWeFriends = "YES" #what this really means is have I asked to be friends, not are we really friends
				end
			diction[:is_friend] = areWeFriends #see above comment
				collection << diction
			end	
		end
		
		
		render :json => collection
	end

end
