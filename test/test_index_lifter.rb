require File.dirname(__FILE__) + '/test_helper.rb'

require 'active_support'

class TestIndexLifter < Test::Unit::TestCase
  
  class TestConnection
    #<struct ActiveRecord::ConnectionAdapters::IndexDefinition 
    #  table="movies",
    #  name="index_movies_on_title",
    #  unique=false,
    #  columns=["title"]>
    class IndexDefinition < Struct.new(:table, :name, :unique, :columns)
      def to_hash
        { :table => table, :name => name, :unique => unique, :columns => columns }
      end
    end
      
    def initialize(*defs)
      @indexes = defs.inject({}) do |memo, idef|
        memo[idef[:table].to_s] ||= []
        memo[idef[:table].to_s] << IndexDefinition.new(
          idef[:table].to_s,
          idef[:name].to_s,
          idef[:unique],
          Array(idef[:columns]).map { |c| c.to_s }
        )
        memo
      end
    end
    def tables
      @indexes.keys.sort
    end
    def indexes(table)
      @indexes[table.to_s]
    end
  end
  
  def setup
    @index_people_on_lastname_firstname_unique = {
      :name => 'index_people_on_lastname_firstname',
      :table => 'people', :columns => ['lastname', 'firstname'], :unique => true
    }
    @index_movies_on_title = {
      :name => 'index_movies_on_title',
      :table => 'movies', :columns => ['title'], :unique => false
    }
    @connection = TestConnection.new(
      @index_movies_on_title,
      @index_people_on_lastname_firstname_unique
    )
  end
  
  def test_find_indexes
    lifter = IndexLifter.new(:connection => @connection)
    assert_equal [@index_movies_on_title, @index_people_on_lastname_firstname_unique], 
      lifter.indexes.map(&:to_hash)
  end
  
  def test_exclude_unique_indexes
    lifter = IndexLifter.new(:connection => @connection,
      :except_unique => true)
    assert_equal [@index_movies_on_title], 
      lifter.indexes.map(&:to_hash)
  end
  
  def test_exclude_index_by_name_as_string
    lifter = IndexLifter.new(:connection => @connection,
      :except => 'index_people_on_lastname_firstname')
    assert_equal [@index_movies_on_title], 
      lifter.indexes.map(&:to_hash)
  end

  def test_exclude_index_by_hashed_name
    lifter = IndexLifter.new(:connection => @connection,
      :except => { :name => 'index_people_on_lastname_firstname' })
    assert_equal [@index_movies_on_title], 
      lifter.indexes.map(&:to_hash)
  end

  def test_exclude_index_by_name_array
    lifter = IndexLifter.new(:connection => @connection,
      :except => ['index_people_on_lastname_firstname'])
    assert_equal [@index_movies_on_title], 
      lifter.indexes.map(&:to_hash)
  end

  def test_exclude_index_by_table_and_column
    lifter = IndexLifter.new(:connection => @connection,
      :except => { :table => :movies, :column => :title})
    assert_equal [@index_people_on_lastname_firstname_unique], 
      lifter.indexes.map(&:to_hash)
  end

  def test_exclude_index_by_table_and_columns
    lifter = IndexLifter.new(:connection => @connection,
      :except => { :table => :people, :columns => [:lastname, :firstname]})
    assert_equal [@index_movies_on_title], 
      lifter.indexes.map(&:to_hash)
  end

end
