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
    data = Point.prepare_parameters(params[:point])
    puts params[:point]
    @point = data[:point]

    if @point.save
      @json = build_map(@point)
      @center = {:longitude => params[:point]["longitude"], :latitude => params[:point]["latitude"]}

      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.js
      end

      return
    else
      redirect_to :action => :index
      return
    end
  end


  private

  def build_map(collection, options = {})
    collection.to_gmaps4rails do |point, marker|
      marker.infowindow render_to_string(:partial => "points/infowindow", :locals => {:point => point})
      #marker.title "#{city.name}"
      #marker.json({ :population => city.population})
      #options[:status] = point.status.blank? ? options[:status] : nil
      #status_dir = options[:status].blank? ? point.status : (point.status.blank? ? options[:status] : point.status)
      #width = options[:width].blank? ? 32 : options[:width]
      #height = options[:height].blank? ? 37 : options[:height]
      #marker.picture({:picture => "/assets/markers/#{status_dir}/pin-export.png",
      #                :width => width,
      #                :height => height})
    end
  end

end
