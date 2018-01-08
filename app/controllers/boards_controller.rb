class BoardsController < ApplicationController

  def index
    @posts=Post.all
  end

  def new
  end

  def create
    @post=Post.create(params[:id])
  end

  def show
    @post=Post.find(params[:id])
  end

  def edit
  end

  def update
    @post=Post.find(params[:id])
    @post.update
  end

  def destroy
    @posts=Post.find(params[:id])
    @post.destroy
  end

end
