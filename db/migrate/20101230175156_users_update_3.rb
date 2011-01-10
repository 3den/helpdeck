class UsersUpdate3 < ActiveRecord::Migration
  def self.up
    add_column :users, :total_topics, :integer, :default => 0
    add_column :users, :total_comments, :integer, :default => 0
  end

  def self.down
    remove_column(:users, :total_topics, :total_comments)
  end
end
