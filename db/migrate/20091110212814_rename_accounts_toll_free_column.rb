class RenameAccountsTollFreeColumn < ActiveRecord::Migration
  def self.up
    rename_column :accounts, :tall_free_phone, :toll_free_phone
  end

  def self.down
    rename_column :accounts, :toll_free_phone, :tall_free_phone
  end
end
