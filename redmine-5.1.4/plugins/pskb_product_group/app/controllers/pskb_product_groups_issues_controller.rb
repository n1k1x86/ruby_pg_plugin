class PskbProductGroupsIssuesController < ApplicationController

  def index
    @res = []
    for el in PskbProductGroupsIssue.all do
      issue = Issue.find_by(id: el.issue_id)
      if issue.nil?
        next
      end
      pg = PskbProductGroups.find_by(id: el.pskb_product_groups_id)
      if pg.nil?
        next
      end
      @res << [el, issue, pg]
    end
    @res
  end

  def show
    id = params[:id]
    @pskb_product_groups_issue = PskbProductGroupsIssue.find(id)
  end

  def destroy
    id = params[:id]
    @product_groups_issue = PskbProductGroupsIssue.find(id)
    @product_groups_issue.destroy
    redirect_to request.referer 
  end

  def create
    @pskb_product_groups_issue = PskbProductGroupsIssue.new(product_groups_issue_params)
    if @pskb_product_groups_issue.save 
      redirect_to request.referer
    else
      redirect_to 'new'
    end
  end

  def update
    @pskb_product_groups_issue = PskbProductGroupsIssue.find(params[:id])

    if @pskb_product_groups_issue.update(product_groups_issue_params)
      redirect_to @pskb_product_groups_issue, notice: 'Group was successfully updated.'
    else
      @users = User.all
      @issues = Issue.all
      render :edit
    end
  end

  def edit
    @pskb_product_groups_issue = PskbProductGroupsIssue.find(params[:id])
    @issues = Issue.all
    @pskb_product_groups = PskbProductGroups.all
  end

  def new
    @pskb_product_groups_issue = PskbProductGroupsIssue.new
    @issues = Issue.all
    @pskb_product_groups = PskbProductGroups.all
  end

  private

  def product_groups_issue_params 
    params.permit(:issue_id, :pskb_product_groups_id, :percentage)
  end
end
