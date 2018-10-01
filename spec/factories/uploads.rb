FactoryBot.define do
  factory :upload do
    title { "Doc" }
    description { "my document" }
    passphrase { "femi" }

    trait :small_file do
      after(:build) do |fileupload|
        fileupload.files.attach(io: File.open(Rails.root.join('public', 'file.png')), filename: 'file.png', content_type: 'image/png')
      end
    end
  end
end
