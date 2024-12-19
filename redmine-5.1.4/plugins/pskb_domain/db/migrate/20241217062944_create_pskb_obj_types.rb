class CreatePskbObjTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :pskb_obj_types do |t|
      t.string :name
      t.string :description
    end
  end
end
