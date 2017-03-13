require 'xcodeproj'

# Set up various properties
project_path = 'BBTestAppBundleIdentifiers.xcodeproj'
xcconfig_path = 'EnterpriseStaging.xcconfig'
target_name = 'BBTestAppBundleIdentifiers'
configuration_to_clone = 'Enterprise'
configuration_name = xcconfig_path.sub('.xcconfig', '')

# Open the xcode project
project = Xcodeproj::Project.open(project_path)

# Add the .xcconfig file to the xcode project
xcconfig_file = project.new_file(xcconfig_path)

# Basically we are going to clone an existing build configuration, then
# override the xcconfig

# Loop over the project-level build configurations
project.build_configurations.each do |build_configuration|
    if build_configuration.name === configuration_to_clone

        # This is the project-level build configuration we want to clone
        # Make a new build configuration
        generated_configuration = project.add_build_configuration(configuration_name, :release)

        # Use the new .xcconfig
        generated_configuration.base_configuration_reference = xcconfig_file
        
        # Mark any properties we want the xcconfig to override as $(inherited) in the new config.
        # HACK! -- This is done by hand, there may be a way better way via a list of variable names
        # from the .xcconfig, but haven't looked into it yet.
        generated_configuration.build_settings["CODE_SIGN_ENTITLEMENTS"] = "$(inherited)"
        generated_configuration.build_settings["GCC_PREPROCESSOR_DEFINITIONS"] = "$(inherited)"
        generated_configuration.build_settings["PROVISIONING_PROFILE"] = "$(inherited)"
        generated_configuration.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "$(inherited)"
        generated_configuration.build_settings["DEVELOPMENT_TEAM"] = "$(inherited)"
        generated_configuration.build_settings["CODE_SIGN_IDENTITY"] = "$(inherited)"

        # Copy over the build settings from the original build configuration
        generated_configuration.build_settings = build_configuration.build_settings
    end
end

# Now we also need to make sure the new build configuration has settings
# for each target, so loop over the targets
project.targets.each do |target|
    # Find the build configuration on the target we are trying to copy
    target.build_configurations.each do |build_configuration|
        if build_configuration.name === configuration_to_clone

            # This is the target-level build configuration that we need to clone
            # So, make a new build configuration
            generated_target_configuration = project.new(Xcodeproj::Project::Object::XCBuildConfiguration)

            # Set the name
            generated_target_configuration.name = configuration_name

            # Copy over the target-level build settings
            generated_target_configuration.build_settings = build_configuration.build_settings
            
            # Mark any properties we want the xcconfig to override as $(inherited) in the new config.
            # HACK! -- This is done by hand, there may be a way better way via a list of variable names
            # from the .xcconfig, but haven't looked into it yet.
            generated_target_configuration.build_settings["CODE_SIGN_ENTITLEMENTS"] = "$(inherited)"
			generated_target_configuration.build_settings["GCC_PREPROCESSOR_DEFINITIONS"] = "$(inherited)"
			generated_target_configuration.build_settings["PROVISIONING_PROFILE"] = "$(inherited)"
			generated_target_configuration.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = "$(inherited)"
			generated_target_configuration.build_settings["DEVELOPMENT_TEAM"] = "$(inherited)"
			generated_target_configuration.build_settings["CODE_SIGN_IDENTITY"] = "$(inherited)"

            # Now add the new build configuration
            target.build_configuration_list.build_configurations << generated_target_configuration
        end
    end
end

# Loop over the targets, and find the one we want our scheme to actually build
target_for_scheme = nil
project.targets.each do |target|
    if target.name == target_name
        target_for_scheme = target
    end
end

# Generate a new scheme, set various properties then save it
scheme = Xcodeproj::XCScheme.new
scheme.add_build_target(target_for_scheme)
scheme.set_launch_target(target_for_scheme)
scheme.launch_action.build_configuration = configuration_name
scheme.archive_action.build_configuration = configuration_name
scheme.save_as(project.path(), configuration_name, true)

# Save the main project (to persist the build configuration changes)
project.save
