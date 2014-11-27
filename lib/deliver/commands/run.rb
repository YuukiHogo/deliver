

command :run do |c|
  c.syntax = 'deliver'
  c.description = 'Run a deploy process using the Deliverfile in the current folder'
  c.option '--force', 'Runs a deployment without verifying any information (PDF file). This can be used for build servers.'
  c.option '--beta-activate', 'Enables beta build activation for testers.'
  c.action do |args, options|
    Deliver::DependencyChecker.check_dependencies

    if File.exists?(deliver_path)
      # Everything looks alright, use the given Deliverfile
      Deliver::Deliverer.new(deliver_path, force: options.force, beta_activate: options.beta_activate)
    else
      Deliver::Helper.log.warn("No Deliverfile found at path '#{deliver_path}'.")
      if agree("Do you want to create a new Deliverfile at the current directory? (y/n)", true)
        Deliver::DeliverfileCreator.create(enclosed_directory)
      end
    end
  end
end