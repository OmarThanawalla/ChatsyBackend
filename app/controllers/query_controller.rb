class QueryController < ApplicationController
#before_filter :confirm_logged_in

def index
	query = params[:query]	
	#match by first,last,or userName, beginning only

	#the first method searches by first name, and lastname
	@result = User.search(:first_name_or_last_name_or_userName_start => query).result
	#this method searches by user name
	@result2 = User.search(:first_name_or_last_name_or_userName_start => query[1..-1]).result
	
	@result = @result + @result2
	
	@myJSON = []
	
	#provide only first,last, and user name
	@result.each do |user|
		diction = {}
		diction[:firstName] = user.first_name
		diction[:lastName] = user.last_name
		diction[:userName] = user.userName
		diction[:profilePic] = user.profilePic		
		@myJSON << diction	
	end
	#warning you will have duplicate users in autosuggestion, fix later
	render :json => @myJSON
end


end
