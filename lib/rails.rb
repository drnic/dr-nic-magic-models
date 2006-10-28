module Dependencies #:nodoc:#

  @@models_dir = File.expand_path(File.join(RAILS_ROOT,'app','models'))

  # don't reload models... it doesn't work anyway, not sure why they haven't done this?
  # submit as patch?
  alias require_or_load_old require_or_load
  def require_or_load(file_name, *args)
    file_name = $1 if file_name =~ /^(.*)\.rb$/
    expanded = File.expand_path(file_name)
    old_mechanism = Dependencies.mechanism
    if expanded =~ /^#{@@models_dir}/
      RAILS_DEFAULT_LOGGER.debug "*** Not reloading #{file_name}"
      Dependencies.mechanism = :require
    end
    require_or_load_old(file_name, *args)
    Dependencies.mechanism = old_mechanism
  end
end