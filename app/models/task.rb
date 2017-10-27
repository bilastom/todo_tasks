class Task < ApplicationRecord
  validates :title, presence: true
  validate :deadline_valid

  private

  def deadline_valid
    return if deadline.nil? || deadline.is_a?(Time)
    errors.add(:deadline, 'value is invalid')
    false
  end
end
