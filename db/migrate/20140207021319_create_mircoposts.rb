class CreateMircoposts < ActiveRecord::Migration
  def change
    create_table :mircoposts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :mircoposts,   [:user_id, :created_at]
  end
end
