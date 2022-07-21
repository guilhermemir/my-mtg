class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.references :user, null: false, foreign_key: true
      t.string :scryfall_id, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
