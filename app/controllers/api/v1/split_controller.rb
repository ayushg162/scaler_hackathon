class Api::V1::SplitController < ApplicationController
  def index
    users = User.all
    render json: users, status: 200
  end

  def show
  end

  def create
    user = User.new(
      name: params[:name],
      email: params[:email]
    )
    if user.save
      render json: user, status: 200
    else
      render json: {error: "Error creating user."}
    end
  end
  def update
    user = User.find(params[:id]).update(name: params[:name], email: params[:email])
    render json: user, status: 200
    # else
    #   render json: {error: "Error creating user."}
    # end
  end
  def create_group
    user = Group.new(
      name: params[:name],
    )
    if user.save
      render json: user, status: 200
    else
      render json: {error: "Error creating user."}
    end
  end
  private 
    def create_params
      params.require(:split).permit([
        :name,
        :email
      ])
    end
end
