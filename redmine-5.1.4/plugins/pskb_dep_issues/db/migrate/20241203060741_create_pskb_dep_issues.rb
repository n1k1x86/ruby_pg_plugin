class CreatePskbDepIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :pskb_dep_issues do |t|
      t.integer :dep_id
      t.integer :user_id
    end

    add_foreign_key :pskb_dep_issues, :users, column: :user_id
    add_foreign_key :pskb_dep_issues, :departments, column: :dep_id
  end
end
