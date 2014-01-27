class UpdateTokenController < ApplicationController
before_filter :confirm_logged_in

	def create
		userID = whoAreYou() #identify you
		deviceToken = params[:token]
		deviceToken = deviceToken.split().join[1..-2] #strips the spaces and the '<' '>' characters from the front and back of the string
		
		#find the user record
		myUser = User.find(userID)
		
		#update the user's deviceToken field
		myUser.deviceTokens = deviceToken		#you may want to make deviceTokens column unique
		
		@result = ["token not updated"]
		if myUser.save							
			@result = [deviceToken]
		end
		render :json => @result
	end


end
