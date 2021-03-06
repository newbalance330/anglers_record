class FishController < ApplicationController

  def new
    @fish = Fish.new
  end


  def create
    @fish = Fish.new(fish_params)
    @fish.user_id = current_user.id
    if fish_params[:address] == ""
       flash[:notice] = "ポイントを記入してください。"
       render :new and return
    end
    results = Geocoder.search(fish_params[:address])
    lat, lng = results.first.coordinates
    @fish.latitude = lat
    @fish.longitude = lng
    if @fish.save
      redirect_to fish_path(@fish), notice: "新規投稿が完了しました！"
    else
      render 'new'
    end
  end

  def show
    @fish = Fish.find(params[:id])
    @fish_comment = FishComment.new
    @user = @fish.user

  end

  def fish
    results = Geocoder.search(params[:address])
    @latlng = results.first.coordinates
    # これでmap.js.erbで、経度緯度情報が入った@latlngを使える。

    # respond_to以下の記述によって、
    # remote: trueのアクセスに対して、
    # map.js.erbが変えるようになります。
    respond_to do |format|
     format.js
    end
  end

  def index
    @fish = Fish.all
  end

  def edit
    @fish = Fish.find(params[:id])
    if @fish.user.id == current_user.id
      render "edit"
    else
      redirect_to fish_index_path
    end
  end

  def update
    @fish = Fish.find(params[:id])
    if fish_params[:address] == ""
       flash[:notice] = "ポイントを記入してください。"
     render :edit and return
    end
    results = Geocoder.search(fish_params[:address])
    lat, lng = results.first.coordinates
    @fish.update(fish_params.merge(latitude: lat, longitude: lng))
    redirect_to fish_path(@fish.id)
  end

  def destroy
    fish = Fish.find(params[:id])
    fish.destroy
    redirect_to fish_index_path
  end


  private

   def fish_params
    params.require(:fish).permit(:image, :fish_name, :lure, :body, :address, :latitude, :longitude)
   end

end
