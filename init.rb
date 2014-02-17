Redmine::Plugin.register :redmine_project_id_restrictor do
  name 'Redmine Project Id Restrictor plugin'
  author 'Joffrey DECOURSELLE'
  description 'This plugin requires a prefix to the IDs of projects created by users whose identifier follows the regex [a-zA-Z] [0-9] + (the prefix will this identifier)'
  version '0.0.1'
  settings :default => {
        :login_regexp => '/[a-z][0-9]+/'
  },
  :partial => 'settings/redmine_project_restrictor'
end

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'namer_project'
  unless Project.included_modules.include? NameRestriction::ProjectPatch
    Project.send(:include, NameRestriction::ProjectPatch)
  end
end
