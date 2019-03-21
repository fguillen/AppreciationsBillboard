class RenamingProject
  def self.perform(new_name)
    Dir.glob("#{Rails.root}/**/*.*").each do |filepath|
      file_content = File.read(filepath)
      file_content = file_content.gsub("RailsSkeleton", new_name)
      file_content = file_content.gsub("railsskeleton", new_name.downcase)

      File.open(filepath, "w") { |f| f.write file_content }
    end
  end
end
