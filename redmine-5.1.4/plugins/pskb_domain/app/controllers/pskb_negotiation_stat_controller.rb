class PskbNegotiationStatController < ApplicationController
  layout 'admin'

  def index
    @pskb_neg_stats = NegotiationStat.all
  end

  def new
    @new_neg_stat = NegotiationStat.new
  end

  def create
    id = params[:id]

    @new_neg_stat = NegotiationStat.new(pskb_neg_stats_params)
    if @new_neg_stat.save
      redirect_to pskb_negotiation_stat_index_path
    end
  end

  def show
    id = params[:id]
    @pskb_neg_stat = NegotiationStat.find_by(id: id)
    if @pskb_neg_stat.nil?
      render_404
    end
  end

  def destroy
    id = params[:id]
    @pskb_neg_stat = NegotiationStat.find_by(id: id)
    if @pskb_neg_stat.nil?
      render_404
    end
    if @pskb_neg_stat.destroy
      redirect_to pskb_negotiation_stat_index_path
    end
  end

  def edit
    id = params[:id]
    @pskb_neg_stat = NegotiationStat.find_by(id: id)
    if @pskb_neg_stat.nil?
      render_404
    end
  end

  def update
    id = params[:id]
    @pskb_neg_stat = NegotiationStat.find_by(id: id)
    if @pskb_neg_stat.nil?
      render_404
    end
    if @pskb_neg_stat.update(pskb_neg_stats_params)
      redirect_to pskb_negotiation_stat_index_path
    end
  end

  private 

  def pskb_neg_stats_params 
    params.require('negotiation_stat').permit(:name)
  end
end
