class TopicsUpdate1 < ActiveRecord::Migration
  def self.up
    add_column :topics,  :total_comments, :integer, :default => 0
  end

  def self.down
    remove_column(:topics, :total_comments)
  end
end
