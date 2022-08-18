class OffersController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if params[:query].present?
      @offers = policy_scope(Offer).search_by_game_and_user(params[:query])
    else
      @offers = policy_scope(Offer)
    end
  end

  def show
    @offer = Offer.find(params[:id])
    authorize @offer
    @booking = Booking.new
  end

  def new
    # this instance is for the form
    @offer = Offer.new
    authorize @offer
  end

  def create
    @offer = Offer.new(offer_params)
    @offer.user = current_user
    authorize @offer
    if @offer.save
      redirect_to my_offers_path
    else
      # render 'new.html.erb'
      # redirect_to new_restaurant_path
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @offer = Offer.find(params[:id])
    authorize @offer
    @offer.destroy
    redirect_to my_offers_path, status: :see_other
  end

  private

  # strong params -> whitelisting the attributes that the user can give us
  def offer_params
    params.require(:offer).permit(:title, :description, :duration, :price, :game_id)
  end
end
