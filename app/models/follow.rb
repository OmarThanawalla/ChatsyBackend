class Follow < ActiveRecord::Base
	belongs_to :user
	validates_presence_of :user_id, :follow_id
	
	#dangerous: I need a database index for this too!
	validates_uniqueness_of :user_id, :scope => [:follow_id]
end
