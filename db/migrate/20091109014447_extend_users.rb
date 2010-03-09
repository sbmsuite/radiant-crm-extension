class ExtendUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :uuid,       :string,  :limit => 36
    add_column :users, :title,      :string,  :limit => 64
    add_column :users, :company,    :string,  :limit => 64
    add_column :users, :alt_email,  :string,  :limit => 64
    add_column :users, :phone,      :string,  :limit => 32
    add_column :users, :mobile,     :string,  :limit => 32
    add_column :users, :aim,        :string,  :limit => 32
    add_column :users, :yahoo,      :string,  :limit => 32
    add_column :users, :google,     :string,  :limit => 32
    add_column :users, :skype,      :string,  :limit => 32
    add_column :users, :deleted_at, :datetime

    add_index :users, :deleted_at, :unique => true
    add_index :users, :email
  end

  def self.down
  end
end
