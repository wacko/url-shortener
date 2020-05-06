class Link < ApplicationRecord
  validates :code, uniqueness: true, format: /\A[a-zA-Z0-9]{6}\z/, allow_blank: true
  validates :url, presence: true

  before_create :generate_random_code

  def generate_random_code
    if code.blank?
      chars = ['a'..'z', 'A'..'Z', '0'..'9'].flat_map(&:to_a)
      self.code = 6.times.map{chars.sample}.join
    end
  end
end
