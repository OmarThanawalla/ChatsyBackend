class UserConversationMmTable < ActiveRecord::Base
	belongs_to :user
	belongs_to :conversation
	
	validates_presence_of :user_id, :conversation_id
	
	#i think this enforces the fact that a user can only be in a conversation onces
	validates_uniqueness_of :user_id, :scope => [:conversation_id]
end
