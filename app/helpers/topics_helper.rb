module TopicsHelper

  def render_comment_form(topic, comment=nil)
    comment ||= topic.comments.new(:user => current_user)
    render :partial => 'comments/form', :locals => {:topic => topic, :comment => comment}
  end
end
