class UpdateUserInfoController < ApplicationController
before_filter :confirm_logged_in

  #GET verb
  def index
  	userID = whoAreYou()
  	@user = User.find(userID)
  	#clear the password on outgoing
  	@user.hashed_password = ""
  	#puts ";lkasjdf;laskjdf;laskjdf;laskjfd;laskjdf;laskjdf;laskjdf;alskdjf;laskdjf;alskdfj;aslkdjf;alskdf"
  	puts @user.profilePic
  	
  	diction = {}
  	diction[:first_name] = @user.first_name
  	diction[:last_name] = @user.last_name
  	diction[:userName] = @user.userName
  	diction[:Bio] = @user.Bio
  	diction[:profilePic] = @user.profilePic
  	
  	render :json => diction
  end


  def hello
  	@user = User.find(1)
  	render('hello')
  	
  end

  #POST verb
  #UPDATE user's photo and other information
  def create
  	userID = whoAreYou()
  	@user = User.find(userID)
  	@user.profilePic = params[:profilePicture]
  	#limit the Bio to 60 chars
  	@user.Bio = params[:Bio][0..70]
  	@user.first_name = params[:first_name]
  	puts "////////////////////////////////////////////////////////////////////////////////////////////////"
  	puts params[:first_name]
  	@user.last_name = params[:last_name]
  	@user.save
  	@test = ["You attempted to change profile picture"]
  	render :json => @test
  end	
  
  def updatePicture
    puts "////////////adfadfasdfasdfadfasdfasdfafada//////////////////////////////////////////////////////"
  	puts "updatePicture method was called"
  	userID = whoAreYou()
  	@user = User.find(userID)
  	@user.profilePic = params[:profilePicture]
  	@user.save
  	@test = ["You attempted to change profile picture"]
  	render :json => @test
  end


end
