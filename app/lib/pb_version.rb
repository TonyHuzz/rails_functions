class PbVersion
  extend PbString::Name
  include PbString::Description

  def self.number           #self的意思就是讓他變成class method，要使用number這個方法的話不用先new一個class，而是可以直接使用  ex: PbVersion.number
    "1.0.0"
  end

  def self.author
    Info.author
  end
end