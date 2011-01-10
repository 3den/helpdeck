class User < ActiveRecord::Base
  has_many :topics, :dependent => :delete_all
  has_many :comments, :dependent => :delete_all
  has_many :votes, :dependent => :delete_all

  #login by oauth
  def self.login_by_oauth(data)
    user = User.find_by_provider_and_uid(data[:provider], data[:uid])
    if user
      data.delete(:provider)
      data.delete(:uid)
      user.update_attributes(data)
    else
      user = create!(data)
    end   
    user
  end
end
