class UploadsController < ApplicationController
  def create
    @upload = Upload.new(upload_params)
    respond_to do |format|
      if @upload.save
        format.html do
          redirect_to root_path
        end
        format.json { render json: @upload.to_json }
      else
        @upload.files.purge_later
        format.html do
          redirect_to root_path
        end
        format.json { render json: @upload.errors, status: 422 }
      end
    end
  end

  private

  def upload_params
    params.require(:upload).permit(:title, :description, files: [])
  end
end
