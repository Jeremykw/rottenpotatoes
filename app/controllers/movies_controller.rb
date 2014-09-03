class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Setup @all_ratings with array of all ratings in use in db
    @all_ratings ||= []
    Movie.all.each do |movie|
      @all_ratings << movie.rating
    end
    @all_ratings = @all_ratings.uniq

    # Create array @ratings of all checked ratings
    @ratings = params[:ratings]
    if @ratings != nil
      session[:ratings] = @ratings.keys
    end

    # Load movie list with @order and @rating filet
    session[:order] = params[:sort]
    @movies = Movie.where(:rating => session[:ratings]).order(session[:order])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort => session[:order])
  end

  def edit
    
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie), :sort => session[:order]
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path(:sort => session[:order])
  end

end
