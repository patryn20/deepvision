class Host
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::AttributeMethods

  @r = LovelyRethink.db

  define_attribute_methods :id, :name, :account_id

  validates_presence_of :id
  validates_presence_of :name

  def save
    # find the existing one and update instead if exists
  end
end