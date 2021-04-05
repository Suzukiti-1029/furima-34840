class RemoveResidenceIdFromPurchaseHistories < ActiveRecord::Migration[6.0]
  def change
    remove_reference :purchase_histories, :residence, null: false, foreign_key: true
  end
end
