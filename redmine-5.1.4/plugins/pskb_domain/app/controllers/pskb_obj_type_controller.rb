class PskbObjTypeController < ApplicationController
  layout 'admin'

  def index
    @obj_types = PskbObjType.all
  end

  def new
    @new_obj_type = PskbObjType.new
  end

  def create
    params = pskb_type_obj_params

    @new_obj_type = PskbObjType.new(params)
    if @new_obj_type.save 
      redirect_to pskb_obj_type_index_path
    else
      Rails.logger.info("NOT OK")
    end
  end

  def show
    id = params[:id]
    @pskb_obj_type = PskbObjType.find_by(id: id)
    if @pskb_obj_type.nil?
      Rails.logger.info("NOT OK")
    else
      Rails.logger.info("OK")
    end
  end

  def destroy
    id = params[:id]
    @obj_type = PskbObjType.find_by(id: id)
    if @obj_type.destroy
      redirect_to pskb_obj_type_index_path
    else
      Rails.logger.info("NOT OK")
    end
  end

  def edit
    id = params[:id]
    @pskb_obj_type = PskbObjType.find_by(id: id)
    if @pskb_obj_type.nil?
      Rails.logger.info("NOT OK")
      return
    end
  end

  def update
    id = params[:id]
    @pskb_obj_type = PskbObjType.find_by(id: id)
    if @pskb_obj_type.nil?
      Rails.logger.info("NOT OK")
      return
    end
    if @pskb_obj_type.update(pskb_type_obj_params)
      redirect_to pskb_obj_type_index_path
    else
      Rails.logger.info("NOT OK")
    end
  end

  private

  def pskb_type_obj_params 
    params.require('pskb_obj_type').permit(:name, :description)
  end
end
