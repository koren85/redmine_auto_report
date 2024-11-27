class CreateAutoReports < ActiveRecord::Migration[5.2]
  def change
    create_table :auto_reports do |t|
      t.integer :number, null: false
      t.string :name, null: false
      t.references :version, null: false, foreign_key: true
      t.string :period_type, null: false
      t.date :period_start, null: false
      t.date :period_end, null: false
      t.decimal :total_hours, precision: 16, scale: 2
      t.string :status, default: 'draft'
      t.text :rejection_reason
      t.references :created_by, null: false, index: true
      t.references :updated_by, index: true
      t.timestamps
    end

    add_index :auto_reports, :number, unique: true
    add_index :auto_reports, :status
  end
end