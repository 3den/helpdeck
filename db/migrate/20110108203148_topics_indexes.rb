class TopicsIndexes < ActiveRecord::Migration
  def self.up
    change_table(:topics) do |t|
      t.index :user_id
      t.index :state
      t.index :total_votes
      t.index :total_views
      t.index :total_comments
    end
  end

  def self.down
    remove_index :topics, :user_id
    remove_index :topics, :state
    remove_index :topics, :total_votes
    remove_index :topics, :total_views
    remove_index :topics, :total_comments
  end
end
