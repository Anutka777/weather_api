class DeleteOld < ActiveRecord::Migration[6.0]
  def change
    drop_table :cities
  end
end
