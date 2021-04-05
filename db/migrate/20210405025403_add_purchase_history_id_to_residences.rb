class AddPurchaseHistoryIdToResidences < ActiveRecord::Migration[6.0]
  def change
    add_reference :residences, :purchase_history, null: false, foreign_key: true
  end
end
