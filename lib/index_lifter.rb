
class IndexLifter
  VERSION = '0.0.3'
  SYSTEM_TABLES = ['schema_migrations'].freeze
  attr_reader :tables, :indexes
  
  def self.without_indexes(*tables, &block)
    IndexLifter.new(*tables).without_indexes(&block)
  end
  
  def initialize(*tables)
    @options = tables.extract_options!
    @connection = @options[:connection] || ActiveRecord::Base.connection
    @tables = (tables.empty? ? @connection.tables : tables) - SYSTEM_TABLES
    @indexes = index_definitions
    @tables.freeze
    @indexes.freeze
  end
  
  def without_indexes(&block)
    lift_indexes(indexes)
    yield
  ensure
    reinstate_indexes(indexes)
  end
  
  private

  def index_definitions
    indexes = @tables.inject([]) { |defs, table|
      defs += @connection.indexes(table)
    }
    if @options[:except_unique]
      indexes.delete_if(&:unique)
    end
    exceptions = [@options[:except]].flatten
    
    exception_names = exceptions.map { |exc|
      (exc.kind_of?(::Hash) ? exc[:name] : exc)
    }.compact.map(&:to_s)
    indexes.delete_if { |idx| exception_names.include?(idx.name) }
    
    exception_hashes = exceptions.select { |exc| exc.kind_of?(::Hash) }.map { |exc|
      { :table => exc[:table].to_s,
        :columns => Array(exc[:column] || exc[:columns]).map(&:to_s)
      }}
    indexes.delete_if { |idx| exception_hashes.any? { |exc|
        exc[:table]   == idx.table && 
        exc[:columns] == idx.columns
      }}
    
    indexes
  end
  
  def lift_indexes(indexes)
    indexes.each do |idx|
      @connection.remove_index(idx.table, :name => idx.name)
    end
  end
  
  def reinstate_indexes(indexes)
    indexes.each do |idx|
      @connection.add_index(idx.table, idx.columns, :unique => idx.unique)
    end
  end
end
