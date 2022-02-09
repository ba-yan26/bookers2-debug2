class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @book_comment = BookComment.new
  end

  def index
    to = Time.current.at_end_of_day
    # Time.currentはrailsのapplication.rbのconfig.time_zoneをみている
    # 要は現在の時刻をとってきている
    # at_end_of_dayは1日の終わりを23:59に設定している
    from = (to - 6.day).at_beginning_of_day
    # (to - 6.day)は上記記述のtoに入っている時刻から前６日間
    # at_beginning_of_dayは時刻を1日の始まりの0:00に設定

    # 上記コードを要約すると
    # 6日前の0:00から今日の23:59までのデータを取ってくるという意味になる
    @books = Book.includes(:favorited_users).
    # bookモデルからデータを取得するときにfavorited_usersのデータもまとめて取得する
    # Book.allでも全データ取り出せるが、都度どのユーザーが投稿したのか取りに行かないといけない
    # includesを書くことでfavorited_usersテーブルのデータを事前に読み込まれているため無駄にSQL文が発行されない
      # sort {|a,b|
      # sortメソッドは降順、昇順の並び替えをするメソッド
      # 普通にsortすると2よりも10,11の方が小さいと判定されてしまうのでブロック|a,b|を渡してあげる
        # a.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        # b.favorited_users.includes(:favorites).where(created_at: from...to).size
        # a,b両辺(aが左辺,bが右辺)の値を比較していいね数を並び替えている
      # }.reverse

      sort_by {|x|
        x.favorited_users.includes(:favorites).where(created_at: from...to).size
      }.reverse
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    # ログインしているidを投稿するユーザのidに入れてあげないと投稿している人が誰かわからなくなる
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
