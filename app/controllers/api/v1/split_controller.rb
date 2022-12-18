class Api::V1::SplitController < ApplicationController
  def index
    users = User.all.pluck(:id,:name)
    render json: users, status: 200
  end

  def show

  end

  def get_groups
    groups = Group.all
    arr=[]
    groups.each do |group|
      data={}
      data["name"] = group.name.to_s rescue ""
      data["members"] = group.users.pluck(:id,:name)
      arr << data
    end
    render json: arr, status: 200
  end

  def make_group
    group = Group.new(name: params[:name])
    if group.save
      users_list = JSON.parse(params[:users])
      users_name_list = []
      users_list.each do |user_id|
        new_entry = UserGroup.new(group_id: group.id, user_id: user_id)
        users_name_list << User.find(user_id).name
        new_entry.save
      end
      render json:{"group_id" => group.id, "members_added" => users_name_list }, status: 200
    end
  end

  def get_transactions
    transactions = Transaction.includes(:user).all
    data = []
    transactions.each do |transacts|
      d = {}
      d["paid_by"] = {
        "name" => transacts.user.name,
        "id" => transacts.user.id
      }
      d["group_members"] = transacts.group.users.pluck(:id,:name)
      d["cost"] = transacts.cost rescue 0
      data << d
    end
    render json: data, status: 200
  end

  def get_expenses
    users = UserDebt.where(person_id: params[:user_id])
    check = false
    if users.nil? or users.length == 0
      puts users = UserDebt.where(person_with_id: params[:user_id])
      check = true

    end
    js = []
    users.each do |a|
      hash = {}
      milneKa = a.debt.to_i rescue 0
      puts check_debt = UserDebt.find_by(person_id: a.person_with_id, person_with_id: params[:user_id]) if check == false
      puts check_debt = UserDebt.find_by(person_id: a.person_id, person_with_id: params[:user_id]) if check == true
      actualDebt = check_debt.debt.to_i rescue 0
      personName = User.find(params[:user_id]).name rescue "NIL"
      fromName = User.find(a.person_with_id).name rescue "NIL" if check == false
      fromName = User.find(a.person_id).name rescue "NIL" if check == true
      final = milneKa - actualDebt rescue 0
      if final < 0
        msg = fromName + " ko dene ha "
      else
        msg = personName+" ko milege from "+fromName rescue ""
      end
      # msg = final < 0 ? (fromName + " ko dene ha ") : (personName+" ko milege from "+fromName)
      hash[msg] = (final).abs
      js << hash
    end
    render json: js, status: 200
  end

  def split_payment
    trans = Transaction.new(user_id: params[:paid_by], group_id: params[:group_id], cost: params[:cost])
    if trans.save
      puts group_ids = Group.find(params[:group_id]).users.pluck(:id)
      debts = []
      if group_ids.include? params[:paid_by].to_i and group_ids.length > 0
        group_ids.each do |ids|
          next if ids == params[:paid_by].to_i
          checkId = UserDebt.find_by(person_id: params[:paid_by], person_with_id: ids)
          if checkId.nil?
            abc = UserDebt.new(person_id: params[:paid_by], person_with_id: ids, group_id: params[:group_id], debt: ((params[:cost].to_i/group_ids.length) rescue 0))
            abc.save
          else
            abc = UserDebt.new(person_id: params[:paid_by], person_with_id: ids, group_id: params[:group_id], debt: (((params[:cost].to_i/group_ids.length) rescue 0)+(checkId.debt rescue 0)))
            checkId.update(group_id: params[:group_id], debt: (((params[:cost].to_i/group_ids.length) rescue 0)+(checkId.cost rescue 0)))
          end
          debts << abc
        end
        render json: debts, status: 200
      else
        render json: {"error" => "Payer not a part of the group"}, status: 200
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
