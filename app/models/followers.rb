class Followers < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :user_id, :follower_id
	
	#dangerous: I need a database index for this too!
	validates_uniqueness_of :user_id, :scope => [:follower_id]	
end
