class Pokemon

  attr_reader :id, :name, :type, :db

  def initialize(id: id, name: name, type: type, db: db)
    @name = name
    @type = type
    @db = db
    @id = id
  end

  def self.save(name, type, db)
    sql = <<-SQL
    INSERT INTO pokemon (name, type) VALUES (?, ?);
    SQL
    db.execute(sql, name, type)
  end

  def self.find(id, db)
    sql = <<-SQL
    SELECT * FROM pokemon WHERE id = ?
    SQL

    pokemon_result_set = db.execute(sql, id).first
    Pokemon.new(id: pokemon_result_set[0].to_i, name: pokemon_result_set[1], type: pokemon_result_set[2], db: db)
  end

end
