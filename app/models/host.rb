class Host
  include ActiveModel::Validations
  include ActiveModel::Serialization
  include ActiveModel::AttributeMethods

  @r = LovelyRethink.db

  define_attribute_methods :id, :name, :account_id

  validates_presence_of :id
  validates_presence_of :name

  def self.key_valid_and_active?(apikey, host = false)
    
    if !host
      host = Host.get_by_id(apikey)
    end

    if !host.nil? && host["active"].to_i == 1
      return true
    end
    false
  end

  def save
    # find the existing one and update instead if exists
  end

  def self.get_by_id(id)
    @r.table('hosts').get(id).run(LovelyRethink.connection.raw)
  end
end