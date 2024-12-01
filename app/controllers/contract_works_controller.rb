# plugins/redmine_auto_report/app/controllers/contract_works_controller.rb
class ContractWorksController < ApplicationController
  before_action :find_version
  before_action :find_work, only: [:edit, :update, :destroy]
  before_action :authorize_global

  def new
    @work = @version.contract_works.build
    respond_to do |format|
      format.js { render :new }
    end
  end

  def create
    @work = @version.contract_works.build(work_params)
    respond_to do |format|
      if @work.save
        @version.update_total_planned_hours
        format.js { render :refresh_list }
      else
        format.js { render :new }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js { render :edit }
    end
  end

  def update
    respond_to do |format|
      if @work.update(work_params)
        @version.update_total_planned_hours
        format.js { render :refresh_list }
      else
        format.js { render :edit }
      end
    end
  end

  def destroy
    @work.destroy
    @version.update_total_planned_hours
    respond_to do |format|
      format.js { render :refresh_list }
    end
  end

  def merge_hours
    works = @version.contract_works.where(id: params[:work_ids])
    total_hours = works.sum(:planned_hours)

    merged = MergedHours.create!(version: @version, hours: total_hours)
    works.each do |work|
      ContractWorkMerge.create!(merged_hours: merged, contract_work: work)
    end

    respond_to do |format|
      format.js { render :refresh_list }
    end
  end

  def unmerge_hours
    work = @version.contract_works.find(params[:work_id])
    merged = work.merged_hours
    if merged
      work.contract_work_merge.destroy
      merged.destroy if merged.contract_works.empty?
    end

    respond_to do |format|
      format.js { render :refresh_list }
    end
  end

  private

  def find_version
    @version = Version.find(params[:version_id])
    @project = @version.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_work
    @work = @version.contract_works.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def work_params
    params.require(:contract_work).permit(:name, :planned_hours)
  end
end