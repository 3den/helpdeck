class UsersUpdate2 < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :state, :default => 1
      t.integer :total_votes, :default => 0
    end
  end

  def self.down
    remove_columns :users, :state, :total_votes
  end
end
