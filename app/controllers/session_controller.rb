class SessionController < ApplicationController

  #login
  def new
    request_token = oauth_consumer.get_request_token(:oauth_callback => callback_url)
    session[:token] = request_token.token
    session[:secret] = request_token.secret
    redirect_to request_token.authorize_url
  end

  # Callback
  def create
    data = oauth_data
    #raise data.to_yaml #debug
    user = User.login_by_oauth(data)
    
    if user
      #session[:oauth_debug] = data #debug
      session[:user_id] = user.id
      cookies.permanent[:user_id] = user.id

      # redirect
      if session[:back]
        target = session[:back]
        session[:back] = nil
      elsif (request.env["HTTP_REFERER"])
        target = :back
      else
        target = root_url
      end
      redirect_to target, :notice => t('user.sign_in.success')
    else
      redirect_to :back, :alert => t('user.sign_in.error')
    end 
  end

  # Logout
  def destroy
    reset_session
    cookies.permanent[:user_id] = nil
    redirect_to root_url, :notice => t('user.sign_out.success')
  end

  private
  def oauth_data
    request_token = OAuth::RequestToken.new(oauth_consumer, session[:token], session[:secret])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:token] = access_token.token
    session[:secret] = access_token.secret
    user = twitter_user.verify_credentials
    return {
      :provider => params[:provider],
      :token    => access_token.token,
      :secret   => access_token.secret,

      :uid      => user.id,
      :name     => user.name,
      :username => user.screen_name,
      :location => user.location,
      :image    => user.profile_image_url,

      :lang     => user.lang
    }
  end

  def omniauth_data
    data = request.env["omniauth.auth"]
    return {
      :provider => data["provider"],
      :token    => data["credentials"]["token"],
      :secret   => data["credentials"]["secret"],

      :uid      => data["uid"],
      :name     => data["user_info"]["name"],
      :username => data["user_info"]["nickname"],
      :location => data["user_info"]["location"],
      :image    => data["user_info"]["image"],

      :lang     => data["extra"]["user_hash"]["lang"]
    }
  end

  # OAuth
  def oauth_consumer
    @oauth_consumer ||= OAuth::Consumer.new(
      TWITTER_CONSUMER_KEY,
      TWITTER_CONSUMER_SECRET,
      :site => ENV['APIGEE_TWITTER_API_ENDPOINT'],
      :authorize_path => "/oauth/authenticate",
      :oauth_version => "1.0a",
      :scheme => :header
    )
  end
end
