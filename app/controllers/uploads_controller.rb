class UploadsController < ApplicationController
  before_action :validate_user, only: %i[show destroy]
  before_action :set_upload, only: %i[show destroy]
  
  def create
    @upload = Upload.new(upload_params)
    @upload.files = params[:upload][:files] if !@upload.files.present? && params[:upload][:files].present?
    @upload.passphrase = encrpt_passphrase params[:upload][:passphrase].to_s
    respond_to do |format|
      if @upload.save
        format.json { render json: @upload.to_json, status: 201 }
        format.html { redirect_to root_path }
        flash[:success] = "File created successfully"
      else
        @upload.files.purge_later
        format.html do
          redirect_to root_path
        end
        format.json { render json: @upload.errors, status: 422 }
        flash[:danger] = "Something went wrong, please try again later"
      end
    end
  end

  def show
    @my_file = Upload.find(params[:id])
  end

  def destroy
    @my_file.destroy
    @my_file.files.purge_later
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
      flash[:success] = "File deleted successfully"
    end
  end

  private

  def set_upload
    @my_file = Upload.find(params[:id])
  end

  def encrpt_passphrase text
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.hex len
    key   = ActiveSupport::KeyGenerator.new(ENV['SECRET']).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    encrypted_data = crypt.encrypt_and_sign text
    "#{salt}$$#{encrypted_data}"
  end

  def decrypt_passphrase text
    salt, data = text.split "$$"
  
    len   = ActiveSupport::MessageEncryptor.key_len
    key   = ActiveSupport::KeyGenerator.new(ENV['SECRET']).generate_key salt, len
    crypt = ActiveSupport::MessageEncryptor.new key
    crypt.decrypt_and_verify data
  end

  def upload_params
    params.require(:upload).permit(:title, :description, :passphrase, files: [])
  end

  def validate_user
    puts '.........'
    authenticate_or_request_with_http_basic('Administration') do |username,password|
      file = Upload.find(params[:id])
      pass_phrase = decrypt_passphrase file.passphrase
      username == 'admin' && password == pass_phrase
    end
  end
end
