class CreateNegotiations < ActiveRecord::Migration[6.1]
  def change
    create_table :negotiations do |t|
      t.integer :author_id
      t.timestamps
      t.integer :type
      t.string :value
      t.integer :iss_id
      t.integer :state
    end

    add_foreign_key :negotiations, :negotiation_stats, column: :state
    add_foreign_key :negotiations, :issues, column: :iss_id
    add_foreign_key :negotiations, :users, column: :author_id 
  end
end
