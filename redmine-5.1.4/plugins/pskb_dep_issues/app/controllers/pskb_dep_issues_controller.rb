class PskbDepIssuesController < ApplicationController

  def index
    @dep_issues = PskbDepIssue.all
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
    redirect_to :index
  end

  def edit
    @dep_issue = PskbDepIssue.find(params(:id))
  end

  def update
    @dep_issue = PskbDepIssue.find(params(:id))

    if @dep_issue.update(dep_issues_params)
      redirect_to @dep_issue
    else 
      render :edit
    end
  end

  private

  def dep_issues_params
    params.require(:pskb_dep_issues).permit(:dep_id, :user_id) 
  end
end
