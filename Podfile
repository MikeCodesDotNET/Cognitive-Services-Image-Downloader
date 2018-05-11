# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BingImageDownloader' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire', '~> 4.7'
  pod 'SDWebImage', '~> 4.3.3'
  pod 'SwiftLint'
  pod 'SwiftyBeaver'
  pod 'Locksmith' 
  pod 'AppCenter'
 


  # Pods for BingImageDownloader

  target 'BingImageDownloaderTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BingImageDownloaderUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
installer.pods_project.build_configurations.each do |config|
config.build_settings[‘PROVISIONING_PROFILE_SPECIFIER’] = ''
end
end
