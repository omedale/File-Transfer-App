class Upload < ApplicationRecord
  has_many_attached :files
  validates :title, presence: true
  validates :description, presence: true
  validate :validate_file

  private

  def validate_file
    if files.attached? == false
      files.purge_later
      errors[:base] << 'File is not attached'
    elsif files.attached?
      files.each do |file|
        if file.byte_size > 10485760
          file.purge
          errors[:base] << 'File is too large. It has to be below 10MB'
        end
      end
    end
  end
end
