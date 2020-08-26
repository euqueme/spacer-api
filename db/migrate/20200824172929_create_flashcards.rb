class CreateFlashcards < ActiveRecord::Migration[6.0]
  def change
    create_table :flashcards do |t|
      t.references :user, null: false, foreign_key: true
      t.text :front
      t.text :back
      t.integer :counter, default: 0
      t.boolean :mastered, default: false
      t.boolean :waiting, default: false

      t.timestamps
    end
  end
end
