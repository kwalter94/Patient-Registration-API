class Patient < ApplicationRecord
    belongs_to :person, :required => false
    validates :person, presence: true
end
