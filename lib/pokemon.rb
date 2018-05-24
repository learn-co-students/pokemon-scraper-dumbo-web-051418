require 'pry'
require_relative '../bin/environment.rb'

class Pokemon
  attr_accessor :id, :name, :type, :hp, :db

  def initialize(attrs)
    mass_assign_attrs(attrs)
  end

  def save(db)
    sql = <<-SQL
      UPDATE pokemon SET name = ?, type = ?, hp = ?
      WHERE id = ?;
    SQL
    # binding.pry
    db.execute(sql, name, type, hp, id)
  end

  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?);
    SQL
    # binding.pry
    db.execute(sql, name, type)
  end

  def self.find(id, db)
    db.results_as_hash = true
    sql = <<-SQL
      SELECT * FROM pokemon WHERE id = ?;
    SQL
    # binding.pry
    res = db.execute(sql, id)[0]
    db.results_as_hash = false
    Pokemon.new(res)
  end

  def self.create_table(db)
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS pokemon (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        type TEXT
      );
        SQL
    db.execute(sql)
  end

  def alter_hp(hp, db)
    self.hp = hp
    self.save(db)
  end

  private
  def mass_assign_attrs(attrs)
    attrs.each {|k, v|
      self.send("#{k}=", v) if self.respond_to?("#{k}=")
    }
  end
end
