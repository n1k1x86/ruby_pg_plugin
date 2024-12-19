class CreateNegotiationStats < ActiveRecord::Migration[6.1]
  def change
    create_table :negotiation_stats do |t|
      t.string :name
    end
  end
end
