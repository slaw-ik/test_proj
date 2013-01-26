class PointsController < ApplicationController

  def index
    @point = Point.new
    @json = build_map(Point.all)
  end

  def get_address
    @address = Geocoder.search(params[:"latLng"])[0].data["formatted_address"]
    render :text => @address
  end

  def create
    @point = Point.new(params[:point])
    @point.no_geocode = true
    @point.user_id = current_user.id

    if @point.save
      @json = build_map(@point)
      @center = {:longitude => params[:point]["longitude"], :latitude => params[:point]["latitude"]}

      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.js
      end
    else
      redirect_to :action => :index
    end
  end

  def update
    point = params[:point]
    @point = current_user.points.where(['id = ?', point[:id]]).first

    if @point.update_attributes(:description => point[:description])
      @json = build_map(Point.all)
      @center = {:longitude => params[:point]["longitude"], :latitude => params[:point]["latitude"]}

      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.js
      end
    else
      redirect_to :action => :index
    end
  end

  def destroy
    @point = current_user.points.where(['id = ?', params[:id]]).first

    if @point.destroy()
      @json = build_map(Point.all)

      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.js
      end
    else
      redirect_to :action => :index
    end
  end

  private

  def build_map(collection, options = {})
    collection.to_gmaps4rails do |point, marker|
      marker.infowindow render_to_string(:partial => "points/infowindow", :locals => {:point => point, :owner => (point.user_id == current_user.id) ? "1" : "0"})
      status_dir = options[:status] || (point.user_id == current_user.id) ? "1" : "0"
      marker.picture({:picture => "/assets/markers/#{status_dir}/pin-export.png",
                      :width => 32,
                      :height => 37})
    end
  end

end
