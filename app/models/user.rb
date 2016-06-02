class User < ActiveRecord::Base
  include ::User::Roles

  has_one :subscription
  has_many :radios, through: :user_radios
  has_many :user_radios
  has_many :shows, foreign_key: :dj_id
  has_many :recordings
  has_many :social_identities

  default_scope { order(created_at: :desc) }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_presence_of :time_zone
  validates_inclusion_of :time_zone, :in => ActiveSupport::TimeZone.all.map { |m| m.name }, :message => "is not a valid Time Zone"

  before_validation :set_username, :set_initial_time_zone

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def connected_identity? provider
    self.social_identities.where(provider: provider).any?
  end

  private
  def set_username
    self.username = email.split('@').first if self.username.blank?
  end

  def set_initial_time_zone
    # TODO should set time zone from browser timezone in form
    unless self.time_zone.present?
      self.time_zone = Time.zone.name
    end
  end
end
