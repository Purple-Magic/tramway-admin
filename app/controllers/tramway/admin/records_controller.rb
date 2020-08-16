# frozen_string_literal: true

class Tramway::Admin::RecordsController < ::Tramway::Admin::ApplicationController
  def index
    scope = params[:scope].present? ? params[:scope] : :all
    records = model_class.active.order(id: :desc).send scope
    records = records.full_text_search params[:search] if params[:search].present?
    records = records.ransack(params[:filter]).result if params[:filter].present?
    params[:list_filters]&.each do |filter, value|
      case decorator_class.list_filters[filter.to_sym][:type]
      when :select
        records = decorator_class.list_filters[filter.to_sym][:query].call(records, value) if value.present?
      when :dates
        begin_date = params[:list_filters][filter.to_sym][:begin_date]
        end_date = params[:list_filters][filter.to_sym][:end_date]
        if begin_date.present? && end_date.present?
          if value.present?
            records = decorator_class.list_filters[filter.to_sym][:query].call(records, begin_date, end_date)
          end
        end
      end
    end
    records = records.send "#{current_admin.role}_scope", current_admin.id
    @records = decorator_class.decorate records.page params[:page]
  end

  def show
    @record = decorator_class.decorate model_class.active.find params[:id]
  end

  def new
    @record_form = admin_form_class.new model_class.new
  end

  def create
    @record_form = admin_form_class.new model_class.new
    if @record_form.submit params[:record]
      redirect_to params[:redirect].present? ? params[:redirect] : record_path(@record_form.model)
    else
      render :new
    end
  end

  def edit
    @record_form = admin_form_class.new model_class.active.find params[:id]
  end

  def update
    @record_form = admin_form_class.new model_class.active.find params[:id]
    if @record_form.submit params[:record]
      redirect_to params[:redirect].present? ? params[:redirect] : record_path(@record_form.model)
    else
      render :edit
    end
  end

  def destroy
    record = model_class.active.find params[:id]
    record.remove
    redirect_to params[:redirect].present? ? params[:redirect] : records_path
  end
end
