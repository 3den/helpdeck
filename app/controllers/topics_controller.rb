class TopicsController < ApplicationController
  
  # before filter
  before_filter :filter_access

  # GET /topics/from
  # GET /topics/from.xml
  def from
    # is me?
    username = params[:user]
    if current_user and username == current_user.username
      return redirect_to :action => "from_me"
    end

    # Get user
    @user = User.find_by_username(username)
    if not @user
      flash[:alert] = t('topics.from.user.error.not_found', :user => username)
      return redirect_to :action => "from_me"
    end
    @topics = @user.topics.filter(
      topics_order, params[:search]
    ).paginate(page, page_limit)
    @pagination = Topic.pagination
    @title = t('topics.from.user.title', :user => @user.name)

    return render_error t('topics.from.user.no_items', :username => username) if no_items?
    respond_to_index
  end

  # GET /topics/from_friends
  # GET /topics/from_friends.xml
  def from_friends
    @topics = Topic.from_friends(friend_uids).filter(
      topics_order, params[:search]
    ).paginate(page, page_limit)
    @pagination = Topic.pagination
    @title = t('topics.from.friends.title')
    
    return render_error t('topics.from.friends.no_items') if no_items?
    respond_to_index
  end

  # GET /topics/from_me
  # GET /topics/from_me.xml
  def from_me
    @user = current_user
    @topics = @user.topics.filter(
      topics_order, params[:search]
    ).paginate(page, page_limit)
    @pagination = Topic.pagination
    @title = t('topics.from.me.title', :user => @user.name)

    return render_error t('topics.from.me.no_items') if no_items?
    respond_to_index
  end

  # GET /topics/from
  # GET /topics/from.xml
  def index
    @topics = Topic.filter(
      topics_order, params[:search]
    ).paginate(page, page_limit)
    @pagination = Topic.pagination
    @title = t('topics.all.title')
    
    return render_error t('topics.from.me.no_items') if no_items?
    respond_to_index
  end

  
  # GET /topics/1
  # GET /topics/1.xml
  def show
    begin
      @topic = Topic.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = t('topic.not_found')
      return redirect_to topics_path
    end
    @topic.increment!(:total_views, 1)
    @comments = @topic.comments.filter(
      comments_order, params[:comment_id]
    ).paginate(page)
    @pagination = Comment.pagination
    @title = @topic.title

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/new
  # GET /topics/new.xml
  def new
    @title = t('topic.new.title')
    @topic = Topic.new(params[:topic])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @topic }
    end
  end

  # GET /topics/1/edit
  def edit
    @title = t('topic.edit.title')   
  end

  # POST /topics
  # POST /topics.xml
  def create
    @topic = Topic.new(params[:topic])
    @topic.user = current_user
    @topic.total_views = 0
    @topic.total_votes = 0
    @topic.state = 1

    respond_to do |format|
      if @topic.save
        update_status(@topic, topic_url(@topic.id))
        flash[:success] = t('topic.create.success')
        format.html { redirect_to @topic }
        format.xml  { render :xml => @topic, :status => :created, :location => @topic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    attrs = {:body   => params[:topic][:body]}

    respond_to do |format|
      if @topic.update_attributes(attrs)
        flash[:success] = t('topic.update.success')
        format.html { redirect_to(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic.destroy
    
    flash[:success] = t('topic.delete.success')
    respond_to do |format|
      format.html { redirect_to(topics_url) }
      format.xml  { head :ok }
    end
  end

  # /topics/:id/vote/up
  # /topics/:id/vote/down
  def vote
    @topic = Topic.find(params[:id])
    @vote = Vote.create_or_update(current_user, @topic, params[:vote])

    if @vote
      flash[:success] = t("votes.save.success")
    else
      flash[:alert] = t("votes.save.warning")
    end
  
    respond_to do |format|
      format.html { redirect_to(@topic) }
      format.xml  { head :ok }
      format.js
    end
  end


  private
  def topics_order
    if params[:order]
      cookies[:topics_order] = params[:order]
    else
      params[:order] = cookies[:topics_order] || "unanswered"
    end
  end
  
  def comments_order
    if params[:order]
      cookies[:comments_order] = params[:order]
    else
      params[:order] = cookies[:comments_order] || "new"
    end
  end

  # Pagination
  def page
    params[:page] ||= "1"
    return params[:page].to_i
  end
  def page_limit
    params[:limit] ||= "10"
    return params[:limit].to_i
  end

  def no_items?
    if (@pagination[:total_items] < 1 and !params[:search])
      return true
    else
      return false
    end
  end

  # filter access to actions
  def filter_access
    case action_name
    # is logged in
    when "create", "new", "from_me", "from_friends"
      super(current_user, "/auth/twitter", true)

    # is owner
    when "edit", "update", "destroy"
      @topic = Topic.find(params[:id])
      super(is_owner?(@topic))
    end
  end

  def respond_to_index
    respond_to do |format|
      format.html { render 'index' } # index.html.erb
      format.xml  { render :xml => @topics }
      format.rss  { render 'index', :layout => false }
    end
  end
end