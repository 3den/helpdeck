class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret

      t.string :name
      t.string :username
      t.string :image
      t.string :location
      
      t.string :lang, :default => 'en'
      t.timestamps
    end

    add_index   :users, :token
    add_index   :users, :secret
    add_index   :users, [:provider, :uid], :unique => true
    add_index   :users, :username
  end

  def self.down
    drop_table :users
  end
end
