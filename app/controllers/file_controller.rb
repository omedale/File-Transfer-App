class FileController < ApplicationController
  def index
    @upload = Upload.new
    @files = Upload.paginate(page: params[:page], per_page: 10).order('id DESC')
  end

  def create

  end
end
