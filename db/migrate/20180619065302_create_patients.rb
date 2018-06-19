class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|
      t.integer :person_id
      t.timestamps
    end
  end
end
