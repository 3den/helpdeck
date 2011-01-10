class UpdateTopics3 < ActiveRecord::Migration
  def self.up
    change_column :topics, :total_comments, :integer, :default => 0
  end

  def self.down
  end
end
