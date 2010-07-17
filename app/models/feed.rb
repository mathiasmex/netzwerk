# == Schema Information
# Schema version: 53
#
# Table name: feeds
#
#  id          :integer(4)      not null, primary key
#  person_id   :integer(4)      
#  activity_id :integer(4)      
#

class Feed < ActiveRecord::Base
  belongs_to :activity
  belongs_to :person
end
