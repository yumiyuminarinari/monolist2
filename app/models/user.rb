class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :following_relationships, class_name:  "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :followed_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followed_users, through: :followed_relationships, source: :follower

  has_many :ownerships , foreign_key: "user_id", dependent: :destroy
  # through:で指定されるのが、DB上の中間テーブルを使用するモデル
  has_many :items ,through: :ownerships

  # class_name: "Want"を指定することで、ownershipsテーブルからtypeがWantであるものを取得
  has_many :wants, class_name: "Want", foreign_key: "user_id", dependent: :destroy
  has_many :want_items , through: :wants, source: :item

  # class_name: "Have"を指定することで、ownershipsテーブルからtypeがWantであるものを取得
  has_many :haves, class_name: "Have", foreign_key: "user_id", dependent: :destroy
  has_many :have_items , through: :haves, source: :item


  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following_users.include?(other_user)
  end


  ## TODO 実装
  # itemをhaveする。
  def have(item)
    haves.find_or_create_by(item_id: item.id)
  end

  # itemのhaveを解除する。
  def unhave(item)
    haves.find_by(item_id: item.id).destroy
  end

  # itemをhaveしている場合true、haveしていない場合falseを返す。
  def have?(item)
    have_items.include?(item)
  end

  # itemをwantする。
  def want(item)
    wants.find_or_create_by(item_id: item.id)
  end

  # itemのwantを解除する。
  def unwant(item)
    want = wants.find_by(item_id: item.id)
    want.destroy if want
    
    # wants.find_by(item_id: item.id).destroy
  end

  # itemをwantしている場合true、wantしていない場合falseを返す。
  def want?(item)
    want_items.include?(item)
  end

end
