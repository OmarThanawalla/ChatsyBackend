class Conversation < ActiveRecord::Base
	has_many :users, :through => :user_conversation_mm_tables #i think this is what it's suppose to look like
	has_many :messages
	
	
end
