class UsersIndexes < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.index :state
      t.index :total_votes
      t.index :total_topics
      t.index :total_comments
    end
  end

  def self.down
    remove_index :users, :state
    remove_index :users, :total_votes
    remove_index :users, :total_topics
    remove_index :users, :total_comments
  end
end
