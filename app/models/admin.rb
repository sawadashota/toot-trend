class Admin
  SECURE = 'GAFSTAHSGTAGSHJKOLAKSJAYSHGAFSKJ'
  CIPHER = 'aes-256-cbc'

  include Mongoid::Document
  include Mongoid::Timestamps
  field :email, type: String
  field :password, type: String

  validates :email, :password, presence: true
  before_save :encrypt_password

  def self.decrypt(password)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.decrypt_and_verify(password)
  end

  def encrypt_password
    if self.password.present?
      self.password = encrypt(self.password)
    end
  end


  private

  def encrypt(password)
    crypt = ActiveSupport::MessageEncryptor.new(SECURE, CIPHER)
    crypt.encrypt_and_sign(password)
  end

end
