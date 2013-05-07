class Recommended
  include Mongoid::Document
  field :user_id
  field :article_id

  belongs_to :user
  belongs_to :article
end
