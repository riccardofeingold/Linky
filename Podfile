# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'Linky' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Linky
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'

  # Optionally, include the Swift extensions if you're using Swift.
  pod 'FirebaseFirestoreSwift'
  
end

target 'LinkyShareExtension' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LinkyShareExtension
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'

  # Optionally, include the Swift extensions if you're using Swift.
  pod 'FirebaseFirestoreSwift'
  
  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
    end
   end
  end
end
