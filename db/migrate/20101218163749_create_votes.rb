class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.references :user
      t.references :voteable, :polymorphic => true
      t.integer :vote

      t.timestamps
    end
    add_index :votes, [:user_id, :voteable_type, :voteable_id], :unique => true 
  end

  def self.down
    drop_table :votes
  end
end
