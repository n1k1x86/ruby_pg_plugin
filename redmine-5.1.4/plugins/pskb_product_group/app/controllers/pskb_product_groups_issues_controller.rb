require 'mailer'

class PskbProductGroupsIssuesController < ApplicationController

  def create
    pg_issues_by_status = params["pgIssuesData"]
    all_pg_issues = pg_issues_by_status["0"] + pg_issues_by_status["1"] + pg_issues_by_status["2"]
    issue_id = all_pg_issues[0]["issueId"]
    if !check_percentage(all_pg_issues)
      render json: {"error": "Сумма процентов должна равняться 100", "error_code": "0"}, status: :unprocessable_entity
      return
    end
    if check_null_data(all_pg_issues)
      render json: {"error": "Не допускаются пустые поля", "error_code": "1"}, status: :unprocessable_entity
      return
    end
    if !dublicate_check(all_pg_issues)
      render json: {"error": "Дубликаты групп не допускаются", "error_code": "2"}, status: :unprocessable_entity
      return
    end
    if pg_issues_by_status["3"].length != 0
      if !delete_operation(pg_issues_by_status["3"])
        render json: {"error": "delete errors", "error_code": "3"}, status: 500
        return
      end
    end
    if pg_issues_by_status["2"].length != 0
      if !update_operation(pg_issues_by_status["2"])
        render json: {"error": "update errors", "error_code": "4"}, status: 500
        return
      end
    end
    if pg_issues_by_status["1"].length != 0
      if !create_operation(pg_issues_by_status["1"])
        render json: {"error": "create errors", "error_code": "5"}, status: 500
        return
      end
    end
    puts "LOGI start"

    send_mails(get_owners(all_pg_issues), issue_id)
    render json: {"success": "good"}, status: 201
  end

  private

  def get_owners(all_pg_issues)
    owners = []
    for record in all_pg_issues do 
      puts record
      pg = PskbProductGroups.find(record["pgId"])
      owners << User.find(pg.owner_id)
    end
    Rails.logger.info("OWNERS LOG")
    Rails.logger.info(owners)
    return owners
  end

  def send_mails(owners, issue_id)
    for owner in owners do
      Rails.logger.info("OWNER LOG")
      Rails.logger.info(owner)
      Mailer.deliver_product_groups_added(owner, "Продуктовые группы", "Вы были добавлены в долю", Issue.find(issue_id))
    end
  end

  def check_percentage(records)
    sum = 0
    puts records
    for record in records do 
      sum += record["percentage"].to_i
    end
    return sum == 100
  end

  def check_null_data(records)
    for record in records do 
      if record.values.any? { |value| value.nil? || value == '' } 
        return true
      end
    end
    false
  end

  def dublicate_check(records) 
    pg_id_arr = []
    for record in records do 
      pg_id_arr << record["pgId"]
    end
    return pg_id_arr.length == pg_id_arr.uniq.length
  end

  def product_groups_issue_params 
    params.permit(:issue_id, :pskb_product_groups_id, :percentage)
  end

  def update_params_pg_issue
    params.require(:pskb_product_groups_issue).permit(:id, :issue_id, :pskb_product_groups_id, :percentage)
  end

  def delete_operation(pg_issues_deleted)
    for record in pg_issues_deleted do 
      @pg_issue = PskbProductGroupsIssue.find_by(id: record["pgIssueId"])
      if !@pg_issue.destroy
        return false
      end
    end
    return true
  end

  def update_operation(pg_issues_updated)
    for record in pg_issues_updated do 
      @pg_issue = PskbProductGroupsIssue.find_by(id: record["pgIssueId"])
      @pg_issue.percentage = record["percentage"]
      @pg_issue.pskb_product_groups_id = record["pgId"]

      if !@pg_issue.save 
        return false
      end
    end
    return true
  end

  def create_operation(pg_issues_created)
    for record in pg_issues_created
      @pg_issue = PskbProductGroupsIssue.new(issue_id: record["issueId"], pskb_product_groups_id: record["pgId"], percentage: record["percentage"])
      if !@pg_issue.save 
        return false
      end
    end
    return true
  end
end
