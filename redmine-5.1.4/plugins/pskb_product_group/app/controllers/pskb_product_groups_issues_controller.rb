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
    if product_groups_issue_params[:issue_id].nil? || product_groups_issue_params[:pskb_product_groups_id].nil?
      redirect_to request.referer, notice: 'Необходимо выбрать допустимые параметры.'
      return
    end
    
    percentage = product_groups_issue_params[:percentage].to_i
    if (get_percentage_sum(product_groups_issue_params[:issue_id]) + percentage) > 100
      redirect_to request.referer, flash: {error: 'Сумма процентов не может быть больше 100'}
      return
    end 

    @pskb_product_groups_issue = PskbProductGroupsIssue.new(product_groups_issue_params)
    
    if @pskb_product_groups_issue.save 
      redirect_to request.referer
    else
      redirect_to 'new'
    end
  end

  def update
    @pskb_product_groups_issue = PskbProductGroupsIssue.find(params[:id])
    percentage = update_params_pg_issue[:percentage].to_i
    sum = get_percentage_sum(update_params_pg_issue[:issue_id], update_params_pg_issue[:id])
    puts "LOGLOG"
    puts sum
    if (sum + percentage) > 100
      redirect_to request.referer, flash: {error: "Сумма процентов не может быть больше 100, допустимое значение: #{100-sum}"}
      return
    end 

    if @pskb_product_groups_issue.update(update_params_pg_issue)
      redirect_to '/issues/' + update_params_pg_issue[:issue_id]
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

  def update_params_pg_issue
    params.require(:pskb_product_groups_issue).permit(:id, :issue_id, :pskb_product_groups_id, :percentage)
  end

  def get_percentage_sum(issue_id, id = nil)
    sum = 0
    for el in PskbProductGroupsIssue.where(issue_id: issue_id).where.not(id: id) do
      sum += el.percentage
    end
    sum
  end
end
