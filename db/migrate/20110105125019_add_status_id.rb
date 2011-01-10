class AddStatusId < ActiveRecord::Migration
  def self.up
    add_column :topics, :status_id, :integer
    add_column :comments, :status_id, :integer

    add_index :topics, :status_id, :unique => true
    add_index :comments, :status_id, :unique => true
  end

  def self.down
    remove_column :topics, :status_id
    remove_column :comments, :status_id
  end
end
