class Status < ActiveRecord::Base
  
  has_many :promises

  def to_s
    return name unless name.nil?
  end
end
