class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title
      t.text :body, null: false
      t.integer :meetup_id, null: false

      t.timestamps
    end
  end
end
