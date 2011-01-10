class Comment < ActiveRecord::Base
  belongs_to :user, :counter_cache => :total_comments
  belongs_to :topic, :counter_cache => :total_comments
  has_many :votes, :as => :voteable, :dependent => :delete_all


  # validation
  validates :body, :length => { :minimum => 3 }
  validates :user, :presence => true
  validates :topic, :presence => true
  
  # events
  before_save   :clean_html

  #
  # To status
  #
  def status
    @status ||= body.gsub(/<.*?>/i, '')[0..42].strip
    if(topic.user != user)
      @status = "@#{topic.user.username} #{@status}"
    end
    return @status
  end

  #
  # filter
  #
  def self.filter(order, search=nil)
    #select
    select = [:title, :user,
      :total_votes, :total_views, :total_comments,
      :created_at, :update_at]

    #ordering
    case order.downcase
    when "new"
      order = "id DESC"
    when "old"
      order = "id ASC"
    when "votes"
      order = "total_votes DESC"
    else
      order = "id ASC"
    end

    #conditions
    if search
      order = "(id = #{search}) DESC, #{order}"
    end

    return self.order(order)
  end


  #
  # Paginate
  #
  def self.paginate(page, limit=5)
    total_items = self.count
    @@pagination = {
      :page => page,
      :per_page => limit,
      :total_pages => ((total_items -1) / limit) + 1,
      :total_items => total_items
    }

    return self.limit(limit).offset((page - 1) * limit)
  end

  # Pagination
  def self.pagination
    @@pagination
  end

  private
  # Clear body html
  def clean_html
    self.body.gsub!(
      /(<(\/?)script(.+?)>)|(<(\/?)style(.+?)>)|(<(\/?)link(.+?)>)/i,
      ''
    )
  end
end
