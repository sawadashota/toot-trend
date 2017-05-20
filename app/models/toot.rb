class Toot
  include Mongoid::Document
  include Mongoid::Timestamps
  include RequestMastodon

  field :instance, type: String
  field :words, type: Array
  field :updating, type: Boolean

  validates :instance, presence: true, uniqueness: true
  validate :instance_exists, if: :new_instance?

  def instance_exists
    unless alive_instance?(instance)
      errors.add(:instance, ' is invalid instance.')
    end
  end

  def new_instance?
    !Toot.where(instance: instance).exists?
  end
end
