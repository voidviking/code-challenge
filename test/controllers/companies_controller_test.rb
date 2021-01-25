# frozen_string_literal: true

require 'test_helper'
require 'application_system_test_case'

class CompaniesControllerTest < ApplicationSystemTestCase

  def setup
    @company = companies(:hometown_painting)
  end

  test 'Index' do
    visit companies_path

    assert_text 'Companies'
    assert_text 'Hometown Painting'
    assert_text 'Wolf Painting'
  end

  test 'Show' do
    visit company_path(@company)

    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_equal 'Atlanta, GA', "#{@company.city}, #{@company.state}"
  end

  test 'Update' do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in('company_name', with: 'Updated Test Company')
      fill_in('company_zip_code', with: '30301')
      click_button 'Update Company'
    end

    assert_text 'Changes Saved'

    @company.reload
    assert_equal 'Updated Test Company', @company.name
    assert_equal '30301', @company.zip_code
  end

  test 'update_without_phone' do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in('company_name', with: 'Updated Test Company')
      fill_in('company_phone', with: '')
      click_button 'Update Company'
    end

    assert_text 'Changes Saved'

    @company.reload
    assert_equal 'Updated Test Company', @company.name
    assert_equal '30301', @company.zip_code
  end

  test 'update_with_invalid_phone' do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in('company_name', with: 'Updated Test Company')
      fill_in('company_phone', with: '5555555555')
      click_button 'Update Company'
    end

    assert_text 'Error while saving!'
  end

  test 'update_with_valid_phone' do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in('company_name', with: 'Updated Test Company')
      fill_in('company_phone', with: '9999999999')
      click_button 'Update Company'
    end

    assert_text 'Changes Saved'
  end

  test 'Create' do
    visit new_company_path

    within('form#new_company') do
      fill_in('company_name', with: 'New Test Company')
      fill_in('company_zip_code', with: '30301')
      fill_in('company_phone', with: '9999999999')
      fill_in('company_email', with: 'new_test_company@getmainstreet.com')
      click_button 'Create Company'
    end

    assert_text 'Saved'

    last_company = Company.last
    assert_equal 'New Test Company', last_company.name
    assert_equal '30301', last_company.zip_code
  end

  test 'Destroy' do
    visit companies_path
    find_all('.delete')[0].click
    page.driver.browser.switch_to.alert.accept
    assert_text "Company, '#{@company.name}' has been deleted"
  end

  test 'invalid_zip_code' do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in('company_name', with: 'Updated Test Company')
      fill_in('company_zip_code', with: '226026')
      click_button 'Update Company'
    end

    assert_text 'Error while saving!'
  end

  test 'set_city_and_state' do
    visit edit_company_path(@company)

    within("form#edit_company_#{@company.id}") do
      fill_in('company_zip_code', with: '94203')
      click_button 'Update Company'
    end

    assert_text 'Changes Saved'

    @company.reload
    assert_equal '94203', @company.zip_code
    assert_equal 'Sacramento', @company.city
    assert_equal 'CA', @company.state
  end
end
