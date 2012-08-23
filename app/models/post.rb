class Post < ActiveRecord::Base
  include Tripcode
  attr_accessible(:name,
                  :subject,
                  :body,
                  :tripcode,
                  :directory,
                  :parent_id,
                  :image_attributes)

  belongs_to :board
  
  belongs_to :parent, class_name: 'Post'
  has_many :children, class_name: 'Post', :foreign_key => :parent_id
  
  has_one :image
  accepts_nested_attributes_for :image, allow_destroy: true

  # TODO: Validate existance of directory
  validates_presence_of :directory

  before_save :parse_name


  def date
    self.created_at.strftime("%Y-%m-%d %l:%M %p %Z")
  end

  def parse_name
    # self.name will be nil if we're just 
    # instantiating objects via Rake.
    input = self.name || ''
    
    hash_pos = input.index('#')

    if hash_pos
      name = hash_pos == 0 ? 'Anonymous' : input[0...hash_pos]
      
      # Everything after the hash.
      password = input[ ((hash_pos + 1)..-1) ]

      self.tripcode = crypt_tripcode(password)
      self.name = name
    else
      self.name = input.empty? ? "Anonymous" : input
    end
  end

  def destroy(input)
    self.delete if (self.tripcode == crypt_tripcode(input))
  end

end