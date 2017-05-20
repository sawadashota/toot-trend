class AdminsController < ApplicationController
  include RequestMastodon
  include MecabNatto

  before_action :set_toot, only: [:fetch, :destroy]
  before_action :redirect_unless_auth

  # GET /admin
  def index
    @toots = Toot.all
  end

  # DELETE /admin/toot/:id
  def destroy
    @toot.destroy
    redirect_to admin_path, notice: 'Toot was successfully destroyed.'
  end

  # PUT /admin/fetch/:id
  def fetch
    @toot.update(updating: true)
    Thread.start do
      words = analysis_text(fetch_posts(@toot.instance))
      @toot.update(words: words, updating: false)
    end
    redirect_to admin_path
  end

  private

  def set_toot
    @toot = Toot.find(params[:id])
  end
end
