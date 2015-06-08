class SubscriptionsController < ApplicationController
  load_and_authorize_resource
  def edit

  end

  def update
    if @subscription.update create_params
      flash[:notice] = "Updated your subscription successfully."
      redirect_to edit_subscription_path @subscription
    else
      flash[:error] = "Error updating your subscription."
      render 'edit'
    end
  end

  private
  def create_params
    params.require(:subscription).permit(:plan_id)
  end
end
