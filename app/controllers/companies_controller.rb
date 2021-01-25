# frozen_string_literal: true

# used to manipulate Company's records
class CompaniesController < ApplicationController
  before_action :set_company, except: %i[index create new]

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def show; end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to companies_path, notice: 'Saved'
    else
      flash.merge!(error: 'Error while saving!')
      render :new
    end
  end

  def edit; end

  def update
    if @company.update(company_params)
      redirect_to companies_path, notice: 'Changes Saved'
    else
      flash.merge!(error: 'Error while saving!')
      render :edit
    end
  end

  def destroy
    # Since we don't have any need to track object transaction
    # Its better to use delete than destroy
    if @company.delete
      flash.merge!(alert: "Company, '#{@company.name}' has been deleted")
    else
      flash.merge!(error: 'Something went wrong!')
    end
    redirect_to companies_path
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :legal_name,
      :description,
      :zip_code, :phone,
      :email, :owner_id,
      :color_code,
      services: []
    )
  end

  def set_company
    @company = Company.find(params[:id])
  end
end
