class AddFkNegotiation < ActiveRecord::Migration[6.1]
  def change
    rename_column :negotiations, :type, :type_id

    add_foreign_key :negotiations, :pskb_obj_types, column: :type_id
  end
end
