class HasFriendshipController < ApplicationController
before_filter :confirm_logged_in


#def index
#	userId = whoAreYou()
#	targetUser = params[:targetFollow]
#	if Followers.where({:user_id => targetUser, :follower_id => userID}).length == 0
#		@response = [0] #request has not been sent
#		render :json => @response
#	else
#		@response = [1] #request has been sent
#		render :json => @response
#	end


#end


end
