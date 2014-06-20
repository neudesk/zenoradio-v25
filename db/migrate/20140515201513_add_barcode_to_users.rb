class AddBarcodeToUsers < ActiveRecord::Migration
  def change
    add_column :sys_user, :barcode, :string
  end
end
