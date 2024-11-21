# plugins/redmine_auto_report/app/controllers/contract_works_controller.rb
class ContractWorksController < ApplicationController
  before_action :find_version
  before_action :find_work, only: [:edit, :update, :destroy]
  before_action :authorize_global

  def new
    @work = @version.contract_works.build
    respond_to do |format|
      format.js
    end
  end

  def create
    @work = @version.contract_works.build(work_params)
    respond_to do |format|
      if @work.save
        @version.update_total_planned_hours
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    respond_to do |format|
      if @work.update(work_params)
        @version.update_total_planned_hours
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  def destroy
    @work.destroy
    @version.update_total_planned_hours
    respond_to do |format|
      format.js
    end
  end

  def sort
    params[:work].each_with_index do |id, index|
      ContractWork.where(id: id).update_all(position: index + 1)
    end
    head :ok
  end

  def contract_works_for_version
    @version = Version.find(params[:version_id])
    render json: @version.contract_works.select(:id, :name)
  end

  def update_issues
    issue_ids = params[:issue_ids] || []
    @version.fixed_issues.where(id: issue_ids).update_all(contract_work_id: @work.id)
    @version.fixed_issues.where.not(id: issue_ids).where(contract_work_id: @work.id).update_all(contract_work_id: nil)

    respond_to do |format|
      format.js { head :ok }
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
    params.require(:contract_work).permit(:name, :planned_hours, :start_date, :due_date)
  end
end