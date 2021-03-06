class Medium < ActiveRecord::Base
	belongs_to :section	
  acts_as_list scope: :section
    
  has_one :image,     
    :conditions => "asset_type = #{Asset::TYPE[:media_image]}",    
    foreign_key: :item_id,
    class_name: "Asset",
    dependent: :destroy

  has_one :video,     
    :conditions => "asset_type = #{Asset::TYPE[:media_video]}",    
    foreign_key: :item_id,
    class_name: "Asset",
    dependent: :destroy

	TYPE = {image: 1, video: 2}

  validates :section_id, :presence => true
  validates :media_type, :presence => true, :inclusion => { :in => TYPE.values }  
  validates :title, :presence => true , length: { maximum: 255 }  

  validates :caption, length: { maximum: 2000 }  

  validates :image, presence: true, if: :image_type?
  validates :video, presence: true, if: :video_type?

  accepts_nested_attributes_for :image, :reject_if => lambda { |c| c[:asset].blank? }
  accepts_nested_attributes_for :video, :reject_if => lambda { |c| c[:asset].blank? }

  attr_accessor :video_date_changed

  before_save :check_video_date
  after_commit :create_video_image

  amoeba do
    enable
    clone [:image, :video]
  end
  
  # must call before the save because after save all dirty changes are lost
  def check_video_date
    self.video_date_changed = video_type? && self.video.asset_updated_at_changed?
    return true
  end

  # if this is a video, generate the image for the video
  def create_video_image
#Rails.logger.debug "@@@@@@@@@@@@@@@@   create_video_image"
#Rails.logger.debug "@@@@@@@@@@@@@@@@   video type #{video_type?}; exists #{video_exists?}; updated ad changed #{self.video_date_changed}"
    if video_type? && video_exists? && self.video_date_changed
      # get the image
      image_file = "#{Rails.root}/public#{self.video.asset.url(:poster, false)}"
#Rails.logger.debug "@@@@@@@@ file = #{image_file}"
      # check if exists
      if File.exists?(image_file)
#Rails.logger.debug "@@@@@@@@ file exists, saving!"
        File.open(image_file) do |f|
          # if image does not exist, create it
          # else, update it
          if self.image_exists?
            self.image.is_video_image = true
            self.image.asset = f
            self.image.save            
          else
            self.create_image(:asset_type => Asset::TYPE[:media_image], :is_video_image => true, :asset => f)
          end
        end 
      end
    end
    return true
  end
    
    
	def to_json(options={})
     options[:except] ||= [:created_at, :updated_at]
     super(options)
   end
  def image_exists?
    self.image.present? && self.image.asset.exists?
  end  
  def video_exists?
    self.video.present? && self.video.asset.exists?
  end  

  def is_processed?
    if video_type?
      video_exists? && self.video.processed
    elsif image_type?
      image_exists? && self.image.processed 
    end
  end

private
  def image_type?    
    self.media_type == TYPE[:image]
  end
  def video_type?    
    self.media_type == TYPE[:video]
  end
end
