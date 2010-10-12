require 'oauth/models/consumers/token'

class ConsumerToken < ActiveRecord::Base

  include Oauth::Models::Consumers::Token

  belongs_to :person
  validates_presence_of :person, :token, :secret

  def service_name
    @service_name||=self.to_s.underscore.scan(/^(.*?)(_token)?$/)[0][0].to_sym
  end

  def consumer
    @consumer||=OAuth::Consumer.new credentials[:key], credentials[:secret], credentials[:options]
  end

  def get_request_token(callback_url)
    consumer.get_request_token(:oauth_callback => callback_url)
  end

  def create_from_request_token(person, token, secret, oauth_verifier)
    request_token=OAuth::RequestToken.new consumer, token, secret
    options = {}
    options[:oauth_verifier] = oauth_verifier if oauth_verifier
    access_token = request_token.get_access_token options
    create :person_id => person.id, :token => access_token.token, :secret=>access_token.secret
  end

  protected

  def credentials
    @credentials||=OAUTH_CREDENTIALS[service_name]
  end

  # Main client for interfacing with remote service. Override this to use
  # preexisting library eg. Twitter gem.
  def client
    @client||=OAuth::AccessToken.new self.class.consumer, token, secret
  end

  def simple_client
    @simple_client||=SimpleClient.new OAuth::AccessToken.new( self.class.consumer, token, secret)
  end

end