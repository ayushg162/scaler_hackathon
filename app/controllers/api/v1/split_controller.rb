class Api::V1::SplitController < ApplicationController
  def index
    users = User.all
    render json: users, status: 200
  end

  def show

  end

  def get_groups
    groups = Group.all
    render json: groups, status: 200
  end

  def get_transactions
    transactions = Transaction.all
    data = []
    transactions.each do |transacts|
      d = {}
      d["paid_by"] = transacts.user
      d["group_members"] = transacts.group.users
      d["cost"] = transacts.cost rescue 0
      data << d
    end
    render json: data, status: 200
  end

  def split_payment
    trans = Transaction.new(user_id: params[:paid_by], group_id: params[:group_id], cost: params[:cost])
    if trans.save
      puts group_ids = Group.find(params[:group_id]).users.pluck(:id)
      debts = []
      if group_ids.include? params[:paid_by].to_i and group_ids.length > 0
        group_ids.each do |ids|
          next if ids == params[:paid_by]
          checkId = UserDebt.find_by(person_id: params[:paid_by], person_with_id: ids)
          if checkId.nil?
            abc = UserDebt.new(person_id: params[:paid_by], person_with_id: ids, group_id: params[:group_id], debt: params[:cost])
            abc.save
          else
            abc = UserDebt.new(person_id: params[:paid_by], person_with_id: ids, group_id: params[:group_id], debt: (((params[:cost].to_i/group_ids.length) rescue 0)+(checkId.cost rescue 0)))
            checkId.update(group_id: params[:group_id], debt: (((params[:cost].to_i/group_ids.length) rescue 0)+(checkId.cost rescue 0)))
          end
          debts << abc
        end
        render json: debts, status: 200
      else
        render json: {"error" => "Some Error"}, status: 200
      end
      # render json: "Success", status: 200
    else
      render json: {"error" => "Some Error"}, status: 200
    end

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
