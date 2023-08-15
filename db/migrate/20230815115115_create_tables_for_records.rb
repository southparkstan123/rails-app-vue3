class CreateTablesForRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.text :description
      t.references :creator, class_name: 'User', foreign_key: { to_table: :users }
      t.references :updater, class_name: 'User', foreign_key: { to_table: :users }

      t.timestamps
    end

    create_table :publishers do |t|
      t.string :name
      t.text :description
      t.references :creator, class_name: 'User', foreign_key: { to_table: :users }
      t.references :updater, class_name: 'User', foreign_key: { to_table: :users }

      t.timestamps
    end

    create_table :books do |t|
      t.string :name
      t.text :abstract
      t.decimal :price, precision: 5, scale: 2
      t.references :creator, class_name: 'User', foreign_key: { to_table: :users }
      t.references :updater, class_name: 'User', foreign_key: { to_table: :users }
      t.references :publisher, class_name: 'Publisher', foreign_key: { to_table: :publishers, on_delete: :cascade }

      t.timestamps
    end

    create_table :authors_books, id: false do |t|
      t.belongs_to :author
      t.belongs_to :book
    end
  end
end
