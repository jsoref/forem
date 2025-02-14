class LogoUploader < BaseUploader
  MAX_FILE_SIZE = 3.megabytes
  STORE_DIRECTORY = "uploads/logos/".freeze
  EXTENSION_ALLOWLIST = %w[svg png jpg jpeg jpe].freeze
  IMAGE_TYPE_ALLOWLIST = %i[svg png jpg jpeg jpe].freeze
  CONTENT_TYPE_ALLOWLIST = %w[image/svg+xml image/png image/jpg image/jpeg].freeze

  def store_dir
    STORE_DIRECTORY
  end

  def extension_allowlist
    EXTENSION_ALLOWLIST
  end

  def image_type_whitelist
    # this is needed by CarrierWave::BombShelter
    IMAGE_TYPE_ALLOWLIST
  end

  def size_range
    1..MAX_FILE_SIZE
  end

  def content_type_allowlist
    CONTENT_TYPE_ALLOWLIST
  end

  def filename
    # random_string in the filename to avoid caching issues
    "original_logo_#{random_string}.#{file.extension}" if original_filename
  end

  version :resized_logo, if: :not_svg? do
    process resize_to_limit: [nil, 80]
    def full_filename(_for_file = file)
      "resized_logo_#{random_string}.#{file.extension}" if original_filename
    end
  end

  private

  def random_string
    SecureRandom.alphanumeric(20)
  end

  def not_svg?(file)
    file.content_type.exclude?("svg")
  end
end
