# plugins/redmine_auto_report/app/controllers/reports_controller.rb
class ReportsController < ApplicationController
  before_action :find_report, only: [:show, :edit, :update, :destroy, :approve, :reject]
  before_action :authorize_global

  helper :sort
  include SortHelper

  def index
    @status = params[:status]
    @reports_scope = Report.newest_first
    @reports_scope = @reports_scope.by_status(@status) if @status.present?

    sort_init 'number', 'desc'
    sort_update %w(number name period_type period_start period_end status)

    @report_count = @reports_scope.count
    @report_pages = Paginator.new @report_count, per_page_option, params['page']
    @reports = @reports_scope.offset(@report_pages.offset).limit(@report_pages.per_page).to_a
  end

  def show
  end

  def new
    @report = Report.new
    @report.created_by = User.current

    if params[:version_id]
      @report.version = Version.find(params[:version_id])
      @report.period_type = 'month'
      @report.period_start = Date.today.beginning_of_month
      @report.period_end = Date.today.end_of_month
    end
  end

  def create
    @report = Report.new(report_params)
    @report.created_by = User.current

    if @report.save
      flash[:notice] = l(:notice_auto_report_successful_create)
      redirect_to report_path(@report)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @report.updated_by = User.current

    if @report.update(report_params)
      flash[:notice] = l(:notice_auto_report_successful_update)
      redirect_to report_path(@report)
    else
      render :edit
    end
  end

  def destroy
    @report.destroy
    flash[:notice] = l(:notice_auto_report_successful_delete)
    redirect_to reports_path
  end

  def approve
    if @report.approve!
      flash[:notice] = l(:notice_auto_report_successful_approve)
    else
      flash[:error] = l(:error_auto_report_not_approvable)
    end
    redirect_to report_path(@report)
  end

  def reject
    if @report.reject!(params[:rejection_reason])
      flash[:notice] = l(:notice_auto_report_successful_reject)
    else
      flash[:error] = l(:error_auto_report_not_rejectable)
    end
    redirect_to report_path(@report)
  end

  private

  def find_report
    @report = Report.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def report_params
    params.require(:report).permit(
      :version_id, :period_type, :period_start, :period_end, :status
    )
  end
end