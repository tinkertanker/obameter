class Promise < ActiveRecord::Base
  belongs_to :person
  belongs_to :status
end
