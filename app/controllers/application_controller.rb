class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method [:current_user, :is_admin?, :is_owner?]
  before_filter :set_locale

  # Set locale
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
      :oauth_token => session['token'],
      :oauth_token_secret => session['secret']
    ) if session['token']
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
    msg = "#{item.status} #{url}" if url
    begin
      status = twitter_user.update(msg, :trim_user => true)
    rescue Exception => e
      return nil
    else
      item.update_attribute(:status_id, status.id)
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
