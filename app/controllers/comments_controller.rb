class CommentsController < ApplicationController
  before_filter :filter_access

  # POST /comments
  # POST /comments.xml
  def create
    @topic = Topic.find(params[:topic_id])
    @comment = @topic.comments.new(params[:comment])
    @comment.user = current_user

    if @comment.save
      update_status(@comment, topic_url(@topic.id, @comment.id))
      flash[:success] = t('comment.create.success')
    else
      flash[:alert] = t('comment.create.error')
    end

    respond_to do |format|
      format.js
      format.html { redirect_to topic_url(@topic.id, @comment.id) }
      format.xml  { render :xml => @comment, :status => :created, :location => @comment }
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @id = @comment.id;
    @topic = @comment.topic
    @comment.destroy

    flash[:success] = t('comment.delete.success')
    respond_to do |format|
      format.html { redirect_to topic_url(@topic.id) }
      format.xml  { head :ok }
      format.js
    end
  end

  # /topics/:id/vote/up
  # /topics/:id/vote/down
  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create_or_update(current_user, @comment, params[:vote])

    if @vote
      flash[:success] = t("votes.save.success")
    else
      flash[:alert] = t("votes.save.warning")
    end

    respond_to do |format|
      format.html { redirect_to topic_url(@topic.id, @topic.comment.id) }
      format.xml  { head :ok }
      format.js
    end
  end

  private
  def filter_access
    case action_name
    when "destroy"
      @comment = Comment.find(params[:id])
      super((is_owner?(@comment) || is_owner?(@comment.topic)), "/auth/twitter")
    else
      super(current_user, "/auth/twitter")
    end
  end
end
