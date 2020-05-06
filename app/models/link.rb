class Link < ApplicationRecord
  validates :code, uniqueness: true, format: /\A[a-zA-Z0-9]{6}\z/, allow_blank: true
  validates :url, presence: true

  before_create :generate_random_code

  def self.with_code! code
    where(code: code).first!
  end

  def increment_visits!
    increment :usage_count
    save
  end

  def generate_random_code
    if code.blank?
      chars = ['a'..'z', 'A'..'Z', '0'..'9'].flat_map(&:to_a)
      self.code = 6.times.map{chars.sample}.join
    end
  end

  def to_json
    response = {
      start_date: created_at.iso8601,
      last_usage: updated_at.iso8601,
      usage_count: usage_count
    }
    response.delete(:last_usage) if usage_count == 0

    response.to_json
  end

end
