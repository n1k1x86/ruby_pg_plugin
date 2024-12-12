class DeleteFkIssue < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :issues, column: :department_id
    remove_column :issues, :department_id

    add_column :issues, :department_id, :integer, null: true
    add_foreign_key :issues, :pskb_dep_issues, column: :department_id, on_delete: :restrict
  end
end
