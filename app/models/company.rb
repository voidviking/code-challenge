class Company < ApplicationRecord
  has_rich_text :description

  validates_presence_of :name, :zip_code
  validates_length_of :zip_code, is: 5, message: 'should contain 5 digits'
  validates :email, format: {
    with: /\A([a-zA-Z0-9_.+-])+@getmainstreet.com\z/,
    message: "should be within 'getmainstreet.com' domain"
  }, allow_blank: true
  validates :color_code, format: {
    with: /\A#([A-Fa-f0-9]{6})\z/,
    message: "# must be followed by a valid 6 character hexadecimal code"
  }, allow_blank: false

  before_save :set_city_and_state, if: :zip_code_changed?

  def set_city_and_state
    zipcode_info = ZipCodes.identify(zip_code)
    if zipcode_info.present?
      self.city = zipcode_info.fetch(:city)
      self.state = zipcode_info.fetch(:state_code)
    else
      errors.add(:zip_code, 'is invalid')
      raise ActiveRecord::Rollback
    end
  end
end
