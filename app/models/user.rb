class User < ActiveRecord::Base
  has_many :topics, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  has_many :votes, :dependent => :delete_all

  #login by oauth
  def self.login_by_oauth(data)
    user = User.find_by_provider_and_uid(data["provider"], data['uid'])
    if user
      user.update_attributes(data)
    else
      user = create!(data)
    end   
    user
  end

  # create new user with oauth data
  def self.create_with_oauth(data)
    create! do |u|
      u.provider = data["provider"]
      u.uid = data["uid"]
      u.token = data["credentials"]["token"]
      u.secret = data["credentials"]["secret"]

      u.name      = data["user_info"]["name"]
      u.username  = data["user_info"]["nickname"]
      u.location  = data["user_info"]["location"]
      u.image     = data["user_info"]["image"]

      u.lang      = data["extra"]["user_hash"]["lang"]
    end
  end

  # create new user with oauth data
  def update_with_oauth(data)

    self.update_attributes(
      #u.token = data["credentials"]["token"]
      #u.secret = data["credentials"]["secret"]

      :name      => data["user_info"]["name"],
      :username  => data["user_info"]["nickname"],
      :location  => data["user_info"]["location"],
      :image     => data["user_info"]["image"],

      :lang      => data["extra"]["user_hash"]["lang"])
  end
end
