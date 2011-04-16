class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true

  # Validations
  validates :user, :presence => true
  validates :voteable, :presence => true

  # The Vote method
  def self.create_or_update(user, voteable, value)
    # fix value
    case value.downcase
    when "down", "-1", "againt"
      value = -1
    else
      value = +1
    end

    # Get
    vote = voteable.votes.find_by_user(user)
    if vote # update
      if vote.vote == value
        #no change
        return nil
      end
      # vote
      vote.vote += value
    else # create
      vote = voteable.votes.new
      vote.user = user
      vote.vote = value
    end

    # Save
    voteable.total_votes += value
    voteable.user.total_votes += value
    self.transaction do
      voteable.user.save!
      voteable.save!
      vote.save!
    end

    # return
    return vote
  end

  def self.find_by_user(user)
    return self.where(:user_id => user.id).first if user
  end

  def self.find_vote_by_user(user)
    vote = self.select("vote").find_by_user(user)
    vote &&= vote.vote
    return vote
  end
end
