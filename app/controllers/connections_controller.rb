class ConnectionsController < ApplicationController
  
  before_filter :login_required, :setup
  before_filter :authorize_view, :only => :index
  before_filter :authorize_person, :only => [:edit, :update, :destroy]
  before_filter :redirect_for_inactive, :only => [:edit, :update]
  
  # Show all the contacts for a person.
  def index
    @contacts = @person.contacts.paginate(:page => params[:page],
                                          :per_page => RASTER_PER_PAGE)
  end
  
  def show
    # We never use this, but render "" for the bots sake.
    render :text => ""
  end
  
  def edit
    @contact = @connection.contact
  end
  
  def create
    @contact = Person.find(params[:person_id])

    respond_to do |format|
      if Connection.request(current_person, @contact)
        flash[:notice] =  t('flash.connection_request_sent')
        format.html { redirect_to(home_url) }
      else
        # This should only happen when people do something funky
        # like friending themselves.
        flash[:notice] = t('flash.invalid_connection')
        format.html { redirect_to(home_url) }
      end
    end
  end

  def update
    
    respond_to do |format|
      contact = @connection.contact
      name = contact.name
      case params[:commit]
      when t('connection.accept')
        @connection.accept
        flash[:notice] = t('flash.accepted_connection',
                           :person_link => person_url(contact),
                           :person_name => name)
      when t('connection.decline')
        @connection.breakup
        flash[:notice] = t('flash.declined_connection',
                           :person_name => name)
      end
      format.html { redirect_to(home_url) }
    end
  end

  def destroy
    @connection.breakup
    
    respond_to do |format|
      flash[:success] = t('flash.ended_connection',
                          :person_name => @connection.contact.name)
      format.html { redirect_to(person_connections_url(current_person)) }
    end
  end

  private

    def setup
      # Connections have same body class as profiles.
      @body = "profile"
    end

    def authorize_view
      @person = Person.find(params[:person_id])
      unless (current_person?(@person) or
              Connection.connected?(@person, current_person))
        redirect_to home_url
      end
    end
  
    # Make sure the current person is correct for this connection.
    def authorize_person
      @connection = Connection.find(params[:id],
                                    :include => [:person, :contact])
      unless current_person?(@connection.person)
        flash[:error] = t('flash.invalid_connection')
        redirect_to home_url
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t('flash.invalid_expired_connection_request')
      redirect_to home_url
    end
    
    # Redirect if the target person is inactive.
    # Suppose Alice sends Bob a connection request, but then the admin 
    # deactivates Alice.  We do not want Bob to be able to make the connection.
    def redirect_for_inactive
      if @connection.contact.deactivated?
        flash[:error] = t('flash.invalid_request_person_deactivated')
        redirect_to home_url
      end
    end

end