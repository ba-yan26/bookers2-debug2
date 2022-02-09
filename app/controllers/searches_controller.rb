class SearchesController < ApplicationController
  
  def search
  # formで入力された情報をここで受け取る
    @range = params[:range]
    if @range == "User"
    # 選択された項目がユーザーならユーザー情報の検索結果を取得する
      search = params[:search]
      word = params[:word]
      @users = User.looks(search,word)
    # user.rbで作成したlooksメソッドを使い検索結果を@usersに代入
    # formで選択された検索方法は
    # f.select :search → params[:search] → search → User.looks(search, word)
    # → def self.looks(searches, words) → if searches == "perfect_match"
    else
      search = params[:search]
      word = params[:word]
      @books = Book.looks(search,word)
    end
  end
end
