module NameRestriction
module ProjectPatch

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      before_create :prefix_user_login
      validates_length_of :name, :maximum => 21, :if => :name_restriction?
      validates_length_of :identifier, :in => 1..11, :if => :name_restriction?
    end  
  end  

  module ClassMethods
  end

  module InstanceMethods

    def name_restriction? 
      !self.identifier_frozen? and User.current.login.match(Regexp.new(eval("/"+Setting[:plugin_redmine_project_id_restrictor][:login_regexp]+"/")))
    end

    def prefix_user_login
      if self.name_restriction?
        self.identifier = User.current.login + "-" + self.identifier
        self.name = "[" + User.current.login + "] " + self.name
                Project.visible.each do |project|
                        if self.identifier == project.identifier
                        return false
                        end
                end
        end
        return true
    end

  end
end
end
