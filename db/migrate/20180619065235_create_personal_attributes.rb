class CreatePersonalAttributes < ActiveRecord::Migration[5.2]
  def change
    create_table :personal_attributes do |t|
      t.string :value
      t.integer :person_id
      t.integer :personal_attributes_type_id
      t.timestamps
    end
  end
end
