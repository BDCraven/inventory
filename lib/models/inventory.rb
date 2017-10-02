require 'data_mapper'
require 'dm-postgres-adapter'

# Inventory database
class Inventory
  include DataMapper::Resource

  property :id,           Serial
  property :product,      String
  property :customer,     String
  property :measure,      String
  property :value,        Float
  property :valid_from,   Integer
  property :valid_to,     Integer
end

DataMapper.setup(:default, 'postgres://localhost/inventory')
DataMapper.finalize
DataMapper.auto_migrate!
