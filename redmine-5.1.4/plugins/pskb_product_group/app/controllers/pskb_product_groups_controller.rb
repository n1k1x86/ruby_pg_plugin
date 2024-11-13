class PskbProductGroupsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_404

  def index
    @pskb_product_group = PskbProductGroups.all
    @result = []
    for pg in  @pskb_product_group do
      @result << [pg, User.find(pg.owner_id)]
    end
  end

  def show
    id = params[:id]
    @pskb_product_group = PskbProductGroups.find(id)
  end

  def destroy
    id = params[:id]
    @pskb_product_group = PskbProductGroups.find(id)

    @pskb_product_group.destroy
    redirect_to '/pskb_product_groups'
  end

  def new
    @users = User.all
  end

  def create
    @pskb_product_group = PskbProductGroups.new(group_params_create)
    @pskb_product_group.save

    redirect_to @pskb_product_group
  end

  def edit
    @pskb_product_group = PskbProductGroups.find(params[:id])
    @users = User.all
  end

  def update
    @pskb_product_group = PskbProductGroups.find(params[:id])

    if @pskb_product_group.update(group_params_edit)
      redirect_to @pskb_product_group, notice: 'Group was successfully updated.'
    else
      @users = User.all
      render :edit
    end
  end

  private

  def group_params_edit
    params.require(:pskb_product_groups).permit(:name, :owner_id)
  end

  def group_params_create 
    params.permit(:name, :owner_id)
  end

  def not_found_404 
    render 'shared/not_found'
  end
end
