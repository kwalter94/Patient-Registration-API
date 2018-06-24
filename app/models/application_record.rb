class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  default_scope { where(deleted_at: nil) }

  # Soft delete record
  def destroy
    self.deleted_at = Time.now
    save
  end
end
