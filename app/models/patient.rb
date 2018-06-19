class Patient < ApplicationRecord
    belongs_to :person
    # validates :person_name, presense: true
end
