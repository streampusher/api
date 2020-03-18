class PublishMetadataController < ApplicationController
  before_action :current_radio_required
  def create
    if liq_authorized?
      MetadataPublisher.perform @current_radio.name, params[:metadata]
      flash[:notice] = "Updated!"
      render 'create'
    else
      flash[:error] = "Sorry, there was an error..."
      render 'error'
    end
  end

  private

  def liq_authorized?
    liq_secret = request.headers["liq-secret"]
    return liq_secret == Rails.application.secrets.liq_secret
  end
end
