
class ApplicationController < ActionController::Base
  protect_from_forgery

  protected #so it cant be called as an action
	def confirm_logged_in
		password = params[:password]
		password = User.hashMe(password)
		
		email = params[:email]
		
		if email != nil
			email = email.downcase
		end
		myUser = User.find_by_email(email)
		if myUser && myUser.hashed_password == password
			return true
		else
			render :file => "public/401.html", :status => :unauthorized
			return false
		end
	end

	protected
	def current_ability
  		@current_ability ||= Ability.new(@user)
	end

	protected
	def proofIdent
		#hash the password
		password = params[:password]
		password = User.hashMe(password)
		
		#is who you are and the params[:id] you are trying to access one and the same?
		myUser = User.find_by_email(params[:email])
		if myUser && myUser.hashed_password == password
			if myUser.id.to_i == params[:id].to_i
				return true
			end
		end
		return false
	end
	

	
	
	protected
	def whoAreYou
		#hash the password
		password = params[:password]
		password = User.hashMe(password)
		
		emailLowered = params[:email]
		emailLowered = emailLowered.downcase
		
		myUser = User.find_by_email(emailLowered)
		if myUser && myUser.hashed_password == password
			return myUser.id
		end
	end
	
	protected
	def	baseURLFunc
		return "/Users/omarthanawalla/Desktop/ChattyMacBook/chattybackend/public"	
	end

end
