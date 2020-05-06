class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :url, null: false, default: ''
      t.string :code, null: false, default: ''
      t.integer :usage_count, default: 0

      t.timestamps
    end

    add_index :links, :code, unique: true
  end
end
