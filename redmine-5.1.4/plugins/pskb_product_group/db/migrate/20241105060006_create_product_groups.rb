class CreateProductGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :product_groups do |t|
      t.string :name
      t.references :user, foreign_key: true
    end
  end
end
