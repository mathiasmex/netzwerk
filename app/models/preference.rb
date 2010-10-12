# == Schema Information
# Schema version: 53
#
# Table name: preferences
#
#  id                  :integer(4)      not null, primary key
#  domain              :string(255)     default(""), not null
#  smtp_server         :string(255)     default(""), not null
#  email_notifications :boolean(1)      not null
#  email_verifications :boolean(1)      not null
#  created_at          :datetime        
#  updated_at          :datetime        
#  analytics           :text            
#  server_name         :string(255)     
#  app_name            :string(255)     
#  about               :text            
#  demo                :boolean(1)      
#  node_number         :integer(4)      default(3), not null
#  number_of_companies :integer(4)      default(3), not null
#  sidebar_title       :string(255)     
#  sidebar_body        :text            
#  whitelist           :boolean(1)      
#

class Preference < ActiveRecord::Base
  attr_accessible :app_name, :server_name, :domain, :smtp_server, 
                  :email_notifications, :email_verifications, :analytics,
                  :about, :impressum, :privacy_policy, :demo, :whitelist, :node_number, :number_of_companies
                  
  validates_presence_of :domain,       :if => :using_email?
  validates_presence_of :smtp_server,  :if => :using_email?
  validates_presence_of :node_number,  :number_of_companies
  
  # Can we send mail with the present configuration?
  def can_send_email?
    not (domain.blank? or smtp_server.blank?)
  end
  
  private
  
    def using_email?
      email_notifications? or email_verifications?
    end
end
