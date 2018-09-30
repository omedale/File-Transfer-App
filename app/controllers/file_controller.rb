class FileController < ApplicationController
  def index
    @upload =  Upload.new
    @files = Upload.all
  end

  def create

  end
end
