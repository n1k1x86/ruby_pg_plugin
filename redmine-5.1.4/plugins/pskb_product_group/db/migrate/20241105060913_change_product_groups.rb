class ChangeProductGroups < ActiveRecord::Migration[6.1]
  def change
    rename_column :product_groups, :user_id, :owner_id
  end
end
