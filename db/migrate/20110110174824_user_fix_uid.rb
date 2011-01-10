class UserFixUid < ActiveRecord::Migration
  def self.up
    change_column :users, :uid, :integer
  end

  def self.down
    change_column :users, :uid, :string
  end
end
