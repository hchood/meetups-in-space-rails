class MeetupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
  end

  def show
    @meetup = Meetup.find(params[:id])
    @comment = @meetup.comments.build # Comment.new(meetup: @meetup)
  end

  def new
    @meetup = Meetup.new
  end

  def create
    @meetup = Meetup.new(meetup_params)
    if @meetup.save
      redirect_to meetup_path(@meetup), notice: "Success! Your meetup has been created."
    else
      flash.now[:notice] = "ERRAH"
      render :new
    end
  end

  private

  def meetup_params
    params.require(:meetup).permit(:name, :location, :description)
  end
end
