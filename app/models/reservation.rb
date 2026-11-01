class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :check_in, presence: true
  validates :check_out, presence: true

  validate :check_in_cannot_be_in_the_past
  validate :check_out_is_after_check_in
  
  validates :guest, presence: true,
                    numericality: {
                      only_integer: true,
                      greater_than_or_equal_to: 1
                    }
  
  private

  def check_in_cannot_be_in_the_past
    return if check_in.blank?
    if Date.current > check_in
      errors.add(:check_in, "は今日以降の日付にしてください")
    end
  end

  def check_out_is_after_check_in
    return if check_in.blank? || check_out.blank?
    if check_in >= check_out
      errors.add(:check_out, "はチェックインより後の日付にしてください")
    end
  end
end
