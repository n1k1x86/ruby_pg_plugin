class CreateProductGroupsIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :pskb_product_groups_issues do |t|
      t.references :issue, foreign_key: true
      t.references :pskb_product_groups, foreign_key: true
      t.integer :percentage
    end
    add_index :pskb_product_groups_issues, :issue_id, if_not_exists: true
    add_index :pskb_product_groups_issues, :pskb_product_groups_id, if_not_exists: true
  end
end
