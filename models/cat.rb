class Cat
  attr_reader :name, :owner

  def self.all
    @cat ||= []
  end

  def initialize(params = {})
    params ||= {}
    @name = params["name"] || params[:name]
    @owner = params["owner"] || params[:owner]
  end

  def save
    return false unless !@name.empty? && !@owner.empty?
    @id ||= Cat.all.length

    Cat.all << self
    true
  end

  def inspect
    { name: name, owner: owner }.inspect
  end
end
