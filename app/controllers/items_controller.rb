class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id
    if @item.save
      redirect_to item_path(@item), notice: "アイテムが新しく登録されました!!"
    else
      render 'new'
    end
  end


  def show
    @item = Item.find(params[:id])
    @user = @item.user
  end

  def index
    if params[:format].present?
      @user = User.find(params[:format])
      @items = @user.items
    else
      @items = Item.all
    end
  end

  def edit
    @item = Item.find(params[:id])
    if @item.user.id == current_user.id
      render "edit"
    else
      redirect_to items_path
    end
  end

  def update
    item = Item.find(params[:id])
    item.update(item_params)
    redirect_to item_path(item.id)
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
    redirect_to items_path
  end

  private

   def item_params
    params.require(:item).permit(:item_image, :name, :body, :status)

   end

end
