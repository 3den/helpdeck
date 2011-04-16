class SessionController < ApplicationController

  # Callback
  def create
    data = omniauth_data
    #raise data.to_yaml #debug
    user = User.login_by_oauth(data)
    
    if user
      #session[:oauth_debug] = data #debug
      session[:user_id] = user.id
      cookies.permanent[:user_id] = user.id

      # TODO: Remove this
      session[:token]   = data[:token]
      session[:secret]  = data[:secret]

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

end
