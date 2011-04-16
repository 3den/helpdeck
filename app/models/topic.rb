class Topic < ActiveRecord::Base
  belongs_to :user, :counter_cache => :total_topics
  has_many :comments, :dependent => :delete_all
  has_many :votes, :as => :voteable, :dependent => :delete_all

  # validation
  validates :title, :length => { :maximum => 101, :minimum => 3 }
  validates :user_id, :presence => true

  # events
  before_save :clean_html

  # Status
  def status
    @status ||= title
  end

  #
  # Only from friends
  #
  def self.from_friends(uids)
    return self.joins(:user).where("uid IN (?)", uids)
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
    when "hot"
      order = "total_comments DESC, total_views DESC"
    when "votes"
      order = "total_votes DESC"
    when "unanswered"
      order = "total_comments ASC, id ASC"
    else
      order = "id DESC"
    end

    #conditions
    if search
      search = "%#{search.gsub(/(\s)+/i, '%')}%"
      where = "title  LIKE ?", search
    end

    return self.order(order).where(where)
  end


  #
  # Paginate
  #
  def self.paginate(page, limit=10)
    total_items = self.scoped.count
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
    self.body = body.gsub(
      /(<(\/?)script(.+?)>)|(<(\/?)style(.+?)>)|(<(\/?)link(.+?)>)/i,
      ''
    )
  end
end
