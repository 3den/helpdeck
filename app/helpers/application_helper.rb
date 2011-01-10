module ApplicationHelper

  def title
    @title if  @title
  end

  
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def voted(item, user=nil)
    user ||= current_user
    vote = item.votes.find_vote_by_user(user)
    
    case vote
    when 1
      "voted_up"
    when -1
      "voted_down"
    else
      "v_#{vote.to_yaml}"
    end
  end

  def clear_flash!
    session[:flash] = nil;
  end


  #
  # IS current Page
  #
  def current_page?(options={})
    is_current = true
    options.each do |name, value|
      is_current &&= (params[name] == value)
      break if !is_current
    end
    return is_current
  end

  # current url
  def current_page(options={})
    return url_for params.merge(options)
  end

  # Add Pagination
  def pagination(pag, items_title)
     # none
     return "" if (!pag || pag[:total_pages] < 2)

     # Add Pagination
     pag[:items_title] = items_title
     pag[:start] = (pag[:page] > 5 and pag[:total_pages] > 5)? pag[:page] - 5 : 1;
     pag[:end] = pag[:total_pages];
     return render (:partial => 'pagination/pagination', :locals => {:pag => pag})
  end

  # RSS feed
  def rss_link_tag
    return auto_discovery_link_tag :rss, "#{request.url}.rss"
  end
end
