class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method [:current_user, :is_admin?, :is_owner?]
  before_filter :set_locale

  #
  # Set locale
  #
  def set_locale
    lang = current_user.lang if current_user
    case lang
    when "en"
      I18n.locale = lang
    else
      I18n.locale = "en"
    end
  end

  #
  # User
  #
  def current_user
    session[:user_id] ||= cookies.permanent[:user_id]
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  # twitter friends
  def friend_uids
    session[:friend_uids] ||= twitter_user.friend_ids(current_user.username).ids if current_user
  end

  # Twitter config
  def twitter_user
    @tw_user ||= Twitter::Client.new(
      :oauth_token => current_user.token,
      :oauth_token_secret => current_user.secret
    ) if current_user
  end

  # is admin
  def is_admin?
    @current_user && @current_user.is_admin
  end

  #is owner
  def is_owner?(item, user=nil)
    user ||= current_user
    return (item.user == user) if user
  end
  
  #update Status
  def update_status(item, url="")
    begin
      msg = "#{item.status} #{url}" if url
      twitter_user.update(msg[0..140], :trim_user => true)
    rescue
      debugger
      return nil
    end
  end

  #
  # The ACL
  #
  def filter_access(access, redirect=:back, set_back=false)
    # access denied
    if (!access)
      session[:back] = request.url if set_back
      flash[:alert] = t('user.access.denied')
      redirect_to redirect
    end 
  end

  #
  # Render Error
  #
  def render_error(msg)
    @error = msg
    return render "error/error"
  end
end
