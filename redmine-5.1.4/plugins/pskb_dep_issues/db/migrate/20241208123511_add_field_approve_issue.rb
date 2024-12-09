class AddFieldApproveIssue < ActiveRecord::Migration[6.1]
  def change
    add_column :issues, :approved_owner, :boolean
  end
end
