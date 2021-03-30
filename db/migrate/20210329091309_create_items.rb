class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :describe, null: false
      t.integer :category_id, null: false
      t.integer :situation_id, null: false
      t.integer :fare_option_id, null: false
      t.integer :prefecture_id, null: false
      t.integer :need_days_id, null: false
      t.integer :fee, null: false
      t.references :user, foreign_key: :true
      t.timestamps
    end
  end
end
