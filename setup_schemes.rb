require 'xcodeproj'

project_path = 'BBTestAppBundleIdentifiers.xcodeproj'
xcconfig_path = 'EnterpriseStaging.xcconfig'
target_name = 'BBTestAppBundleIdentifiers'
configuration_name = xcconfig_path.sub('.xcconfig', '')

project = Xcodeproj::Project.open(project_path)

xcconfig_file = project.new_file(xcconfig_path)

generated_configuration = project.add_build_configuration(configuration_name, :release)
generated_configuration.base_configuration_reference = xcconfig_file

target_for_scheme = nil
project.targets.each do |target|
  if target.name == target_name
      target_for_scheme = target
  end
end

scheme = Xcodeproj::XCScheme.new
scheme.add_build_target(target_for_scheme)
scheme.set_launch_target(target_for_scheme)
scheme.launch_action.build_configuration = configuration_name
scheme.archive_action.build_configuration = configuration_name
scheme.save_as(project.path(), configuration_name, true)

project.save


# scheme = Xcodeproj::XCScheme.new
# scheme.add_build_target(target)
# if target.respond_to?(:product_reference)
#     scheme.set_launch_target(target)
# end
#
# scheme.launch_action.build_configuration = "<%- build_configuration %>"
