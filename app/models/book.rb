class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  # favorited_usersというモデルは存在しないので、favoritesモデルを介してuserモデルのデータを持ってくる
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(searches,words)
    if searches == "perfect_match"
      @book = Book.where("title LIKE(?) OR body LIKE(?)", "#{words}", "#{words}")
    elsif searches == "forward_match"
      @book = Book.where("title LIKE(?) OR body LIKE(?)", "#{words}%", "#{words}%")
    elsif searches == "backward_match"
      @book = Book.where("title LIKE(?) OR body LIKE(?)", "%#{words}", "%#{words}")
    elsif searches == "partial_match"
      @book = Book.where("title LIKE(?) OR body LIKE(?)", "%#{words}%", "%#{words}%")
    else
      @book = Book.all
    end
  end

end
