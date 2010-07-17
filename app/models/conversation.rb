# == Schema Information
# Schema version: 53
#
# Table name: conversations
#
#  id :integer(4)      not null, primary key
#

class Conversation < ActiveRecord::Base
  has_many :messages, :order => :created_at
end
