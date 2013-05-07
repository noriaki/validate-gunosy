class User
  include Mongoid::Document
  field :name

  has_many :recommendeds, dependent: :destroy

  def url(date=Date.yesterday)
    "http://gunosy.com/#{name}/#{date.strftime("%Y/%m/%d")}"
  end
end
