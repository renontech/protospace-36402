class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :destroy] 
  before_action :move_to_index, only: [:new, :edit]
  before_action :prototype_find, only: [:show, :edit, :update, :destroy]
  before_action :cannot_other_user_proto_edit, only: :edit

  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(strong)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments
  end

  def edit
  end

  def update
    if @prototype.update(strong)
      redirect_to prototype_path(@prototype.id)
    else
      render :edit
    end
  end

  def destroy
    @prototype.destroy
    redirect_to root_path
  end

  private
  def strong
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def prototype_find
    @prototype = Prototype.find(params[:id])
  end

  def cannot_other_user_proto_edit
    if current_user.id != @prototype.user_id
      redirect_to action: :index
    end
  end
end
