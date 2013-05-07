class Article
  include Mongoid::Document
  field :url, type: String
  field :title, type: String

  has_many :recommendeds, dependent: :destroy
  has_many :pickings, dependent: :destroy
end
