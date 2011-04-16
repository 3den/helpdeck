class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :user
      t.references :topic
      t.text :body
      t.integer :total_votes, :default => 0
      t.integer :state, :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
