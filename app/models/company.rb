class Company < ApplicationRecord
  has_rich_text :description

  validates :email, format: {
    with: /\A([a-zA-Z0-9_.+-])+@getmainstreet.com\z/,
    message: "should be within 'getmainstreet.com' domain"
  }, allow_blank: true
end
