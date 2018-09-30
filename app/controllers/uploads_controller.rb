class UploadsController < ApplicationController
  before_action :validate_user, only: %i[show]
  def create
    @upload = Upload.new(upload_params)
    pass_phrase = params[:upload][:passphrase]
    @upload.passphrase = encrpt_passphrase pass_phrase.to_s
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

  def show
    @my_file = Upload.find(params[:id])
  end

  private

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
    authenticate_or_request_with_http_basic do |username,password|
      file = Upload.find(params[:id])
      pass_phrase = decrypt_passphrase file.passphrase
      username == 'admin' && password == pass_phrase
    end
  end
end
