config_template = ERB.new File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = YAML.load(config_template.result(binding))[Rails.env].symbolize_keys
