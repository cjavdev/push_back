class MergeLastAndFirstName < ActiveRecord::Migration
  def change
    rename_column :users, :f_name, :name
    remove_column :users, :l_name
  end
end
