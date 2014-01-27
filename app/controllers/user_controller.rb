class UserController < ApplicationController
	#before_filter :confirm_logged_in, :except => [:new, :create]
  
#load_and_authorize_resource
#skip_load_resource :only => :index
require 'twilio-ruby'

	def index #show me a list of users
	  #find out who are you
	  #@user = User.find(session[:user_id])
	  #@users = User.all()
	 # render "index"
	 @test = ["you can see this index "]
	  render :json => @test
	end
	
	#GET	/user/new
	def new #a form to create a new user
	  @test = ["you can see this new"]
	  render :json => @test
	end
	
	#POST
	def create 
		email = params[:email]
		email = email.downcase
		
		#have to hash this password and store in the database
		password = params[:password]
		password = User.hashMe(password)
		
		userName = params[:userName]
		userName = userName.downcase
		firstName = params[:firstName]
		firstName = firstName.strip #remove spaces; i prolly want to put this in the model
		firstName = firstName.downcase.capitalize
		
		lastName = params[:lastName]
		lastName = lastName.strip	#remove spaces; i prolly want to put this in the model
		lastName = lastName.downcase.capitalize
		bio = params[:Bio]
		
		#create a new record and save
		myUser = User.new(:email => email, :hashed_password => password, :first_name => firstName, :last_name => lastName, :Bio => bio)
		#append @ to the username
		if	userName[0] != "@"
			userName.insert(0, "@")
		end
		
		#lowercase the userName
		userName = userName.downcase
		myUser.userName = userName
		recordSave = myUser.save
		
		
		if recordSave
			response = ["YES"]
			render :json => response
			
			##send me a text message
			@account_sid = 'AC22d3120e5e0ec3c8c2560e647bcef3b1'
			@auth_token = '4dd4eef0fa82a776e814d7553df64f81'
				# set up a client to talk to the Twilio REST API
			@client = Twilio::REST::Client.new(@account_sid, @auth_token)
			@account = @client.account
			body = "\n" + "Name: " + firstName + " " + lastName + "\n" + "Email: " + email + "\n" + "Bio: "+ bio 
			@message = @account.sms.messages.create({:from => '+19728107682', :to => '+14695697074', :body => body})
			puts @message			
		else
			response =["NO"]
			render :json => response
		end
		
	end
	
	#GET	/user/:id		display a specific user
	def show 
	 if proofIdent() == true
	 	#@test = "okay you got to the user/id action"
	  	render :json => @user
	  	 #render "show"
	 else
	 	render :file => "public/401.html", :status => :unauthorized
	 #else
	 #	@test = "Okay  you still got to the user/id show action"
	 #	render :json => @test
	  	 #redirect_to :controller => "login", :action => "index"
	  end	 
	end
	
	#returns a form with the user credentials so i can edit them
	#GET	/user/:id/edit	return an HTML form for editing a photo
	def edit #give me a form with the user in question so that i may edit his information
		if proofIdent() == true
		   #@user.hashed_password = ""
	  	   #render "edit"
	  	   @test = "you can see me"
	  	   render :json => @test
	 	else
	 		render :file => "public/401.html", :status => :unauthorized
	  	end	 
	end
	
	
	#PUT(post)	/user/:id		update a specific photo
	#just updates the user and redirects to index
	def update #the process of updating that user information
		if proofIdent() == true
			#puts "this is the value of @user.updatetheatrributesparamsuser"
			#puts @user.update_attributes(params[:user])
			#hash the password
			#if password is blank it will try to hash it again
			#params[:user][:hashed_password] = User.hash_with_salt(params[:user][:hashed_password])
			if @user.update_attributes(params[:user])
				redirect_to :action => "show"
			else
				@user.hashed_password = ""
				render "edit"
			end
		else
			redirect_to :controller => "login", :action => "index"
		end		
	end
	
	def prompt #the web page given to ask you are you sure you want to delete the user
		#@user = User.find(params[:id])
		if proofIdent() == true
			render "prompt"
		else
			redirect_to :controller => "login", :action => "index"
		end
	end
	
	#just destroy the user and redirects to index
	#DELETE	/my_conversation/:id		delete a specific conversation
	def destroy #the process of destroying the user
	  if proofIdent() == true
		#@user = User.find(params[:id])
		if @user.destroy
			redirect_to :controller => "login", :action => "logout"
		else 
		    render "destroy"
		end
	  else
	  	 redirect_to :controller => "login", :action => "index"
	  end	
	end
	
end
