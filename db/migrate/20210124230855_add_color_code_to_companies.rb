class AddColorCodeToCompanies < ActiveRecord::Migration[6.0]
  def change
    add_column :companies, :color_code, :string, nil: false, default: '#000000'
  end
end
