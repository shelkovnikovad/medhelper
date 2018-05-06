class Task < ApplicationRecord
  belongs_to :user
  #validates :title, :diagnosis, :status, presence: true
  before_save :default_values

  def default_values
    self.status = status.presence || false
  end

end
