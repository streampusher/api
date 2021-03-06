class VjController < ApplicationController
  def index
    authorize! :vj, :dashboard, params[:format]
    @radio = @current_radio
    respond_to do |format|
      format.html
    end
  end
  def enabled
    @radio = @current_radio
    respond_to do |format|
      format.html
      format.json {
        response.headers["Access-Control-Allow-Origin"] = "*" # This is a public API, maybe I should namespace it later
        render json: {vj_enabled: @radio.vj_enabled?}.to_json
      }
    end
  end
  def update
    authorize! :vj, :dashboard
    @radio = @current_radio
    @radio.attributes = update_params
    if @radio.save && VjUpdater.perform(@radio.vj_enabled, @radio.name)
      flash[:notice] = "radio settings updated."
      redirect_to vj_path
    else
      flash[:error] = "error updating radio settings."
      render 'index'
    end
  end

  private
  def update_params
    params.require(:radio).permit(:vj_enabled)
  end
end
