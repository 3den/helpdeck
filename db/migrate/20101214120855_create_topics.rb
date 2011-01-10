class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.references :user
      t.string :title
      t.text :body
      t.integer :state, :default => 1
      t.integer :total_votes, :default => 0
      t.integer :total_views, :default => 0


      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
