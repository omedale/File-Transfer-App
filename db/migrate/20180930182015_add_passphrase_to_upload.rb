class AddPassphraseToUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :passphrase, :string
  end
end
