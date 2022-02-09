class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    #ログインしている人(current_user)じゃない人の情報を取得
    rooms = current_user.user_room.pluck(:room_id)
    #user_roomsテーブルのuser_idがcurrent_userのレコードのroom_idを配列で取得
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)
    #user_idがBさん(@user)で、room_idがAさんの属するroom_id（配列）となるuser_roomsテーブルのレコードを取得して、user_room変数に格納
    #これによって、AさんとBさんに共通のroom_idが存在していれば、その共通のroom_idとBさんのuser_idがuser_room変数に格納される（1レコード）。存在しなければ、nilになる。

    room = nil
    if user_room.nil?
    # user_roomでルームを取得できなかった場合の処理(チャットがまだ存在していない場合)
      room = Room.new
      room.save
      # roomを新規作成して保存
      UserRoom.create(user_id: @user.id, room_id: room.id)
      # @user.idをuser_idとして、room.idを@room_idとしてUserRoomモデルのカラムに保存
      UserRoom.create(user_id: current_user.id, room_id: room.id)
      # current_userをuser_idにして、room.idをroom_idとしてUserRoomモデルのカラムに保存
      # 上記2行でcurrent_useと@user.idの共通のroom_idが作られた
    else
    # チャットが存在していれば
      room = user_room.room
      # user_roomに紐づくroomsテーブルのレコードをroomに格納
    end

    @chats = room.chats
    # roomに紐づくchatsテーブルのレコードを@chatsに格納
    @chat = Chat.new(room_id: room.id)
    # formで送られてくる際の空のインスタンス
    # ここでroom.idを@chatに代入しておかないと、form_withで記述するroom_idに値が渡らない
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    redirect_back(fallback_location: root_path)
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

end
