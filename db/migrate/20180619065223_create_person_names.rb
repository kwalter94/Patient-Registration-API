class CreatePersonNames < ActiveRecord::Migration[5.2]
  def change
    create_table :person_names do |t|
      t.string :firstname
      t.string :lastname
      t.integer :person_id
      t.datetime :deleted_at, default: nil
      t.timestamps
    end
  end
end
