class AddDeletedAtToPersonalAttributeTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :personal_attribute_types, :deleted_at, :datetime, nil
  end
end
