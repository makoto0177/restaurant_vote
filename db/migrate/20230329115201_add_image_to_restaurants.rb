class AddImageToRestaurants < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :image, :string
  end
end
