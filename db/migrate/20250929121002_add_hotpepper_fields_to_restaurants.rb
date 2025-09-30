class AddHotpepperFieldsToRestaurants < ActiveRecord::Migration[7.0]
  def change
    add_column :restaurants, :external_shop_id, :string
    add_column :restaurants, :fetched_at, :datetime
  end
end
