require 'rails_helper'
RSpec.describe UploadsController, :type => :controller do
  let!(:upload) {create(:upload, :small_file) }

  describe '#create' do
    it 'should create a file successfully' do
      file = fixture_file_upload(Rails.root.join('public', '1.png'), 'image/png')
      post :create, params: { upload: { title: 'pics', description: 'my picture', passphrase: 'femi', files: file } }, format: :json
      expect(response.status).to eq 201
    end
  end
end
