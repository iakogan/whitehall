class WorldLocation < ActiveRecord::Base
  has_many :edition_world_locations
  has_many :editions,
            through: :edition_world_locations
  has_many :published_edition_world_locations,
            class_name: "EditionWorldLocation",
            include: :edition,
            conditions: { editions: { state: "published" } }
  has_many :published_editions,
            through: :published_edition_world_locations,
            source: :edition
  has_many :featured_edition_world_locations,
            class_name: "EditionWorldLocation",
            include: :edition,
            conditions: { edition_world_locations: { featured: true },
                          editions: { state: "published" } },
            order: "edition_world_locations.ordering ASC"

  accepts_nested_attributes_for :edition_world_locations

  def world_location_type
    WorldLocationType.find_by_id(world_location_type_id)
  end

  def world_location_type=(new_world_location_type)
    self.world_location_type_id = new_world_location_type && new_world_location_type.id
  end

  def display_type
    world_location_type.name
  end

  def self.all_by_type
    all.group_by(&:world_location_type).sort_by { |type, location| type.sort_order }
  end

  def self.countries
    where(world_location_type_id: WorldLocationType::Country.id).order(:name)
  end

  validates_with SafeHtmlValidator
  validates :name, :world_location_type_id, presence: true

  extend FriendlyId
  friendly_id
end