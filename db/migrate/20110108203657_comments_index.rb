class CommentsIndex < ActiveRecord::Migration
  def self.up
    change_table(:comments) do |t|
      t.index :user_id
      t.index :topic_id
      t.index :state
      t.index :total_votes
    end
  end

  def self.down
    remove_index :comments, :user_id
    remove_index :comments, :state
    remove_index :comments, :total_votes
    remove_index :comments, :total_views
  end
end
