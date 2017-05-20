require 'active_support'

class TootsController < ApplicationController
  include RequestMastodon
  include MecabNatto

  # GET /toots
  def index
    @toots = Toot.order(words: :desc, created_at: :asc)
  end

  # POST /toots
  def create
    @toot = Toot.new(instance: toot_params[:instance], updating: true)

    if @toot.save
      Thread.start do
        words = analysis_text(fetch_posts(@toot.instance))
        @toot.update(words: words, updating: false)
      end

      redirect_to root_path, notice: 'Instance was successfully add!'
    else
      @toots = Toot.all
      render :index
    end
  end

  # GET /api/instance
  def api
    instance = params[:instance]
    @toot    = Toot.find_by(instance: instance)
    render json: @toot[:words]
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_toot
    @toot = Toot.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def toot_params
    params.require(:toot).permit(:instance)
  end

  def should_fetch?
    (@toot.words.nil? || fresh?) && alive_instance?
  end

  def fresh?
    @toot.updated_at < Time.now - 1.week
  end

end
