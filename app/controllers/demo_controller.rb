class DemoController < ApplicationController
before_filter :confirm_logged_in
  def index
  	#@test = User.find(1)
  	
  	render :json => @test
  end
  
  def hello
  	#@user = User.find(1)
  	render('hello')
  end

  def upload
  	render('hello')
  end	

end
