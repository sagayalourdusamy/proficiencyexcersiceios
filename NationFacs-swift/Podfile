platform :ios, '10.0'

workspace 'NationFacts'

def shared_pods
pod 'SwiftLint'
pod 'MBProgressHUD', '~> 1.1.0'
end

target 'NationFacts' do
  use_frameworks!

  # Pods for NationFacts

  shared_pods

  target 'NationFactsTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
