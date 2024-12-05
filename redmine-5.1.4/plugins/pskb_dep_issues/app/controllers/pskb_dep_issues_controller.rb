class PskbDepIssuesController < ApplicationController

  def index
    @dep_issues = PskbDepIssue.all
    @data = []
    for dep_issue in @dep_issues do 
      @data << [Department.find(dep_issue.dep_id), User.find(dep_issue.user_id), dep_issue]
    end
  end

  def new
    @dep_issue = PskbDepIssue.new
    @users = User.all
    @departments = Department.all
  end

  def create
    @dep_issue = PskbDepIssue.new(dep_issues_params)
    @dep_issue.save

    redirect_to @dep_issue
  end

  def show
    id = params[:id]
    @dep_issue = PskbDepIssue.find(id)
  end

  def destroy
    id = params[:id]

    @dep_issue = PskbDepIssue.find(id)
    @dep_issue.destroy
    redirect_to pskb_dep_issues_path
  end

  def edit
    id = params[:id]
    @dep_issue = PskbDepIssue.find(id)
    @departments = Department.all
    @users = User.all
  end

  def update
    id = params[:id]

    @dep_issue = PskbDepIssue.find(id)
    @departments = Department.all
    @users = User.all

    if @dep_issue.update(dep_issues_params)
      redirect_to @dep_issue
    else 
      render :edit
    end
  end

  private

  def dep_issues_params
    params.permit(:dep_id, :user_id) 
  end
end
