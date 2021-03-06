class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.date :birthdate
      t.string :gender
      t.datetime :deleted_at, default: nil
      t.timestamps
    end
  end
end
