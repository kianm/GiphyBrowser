workspace 'GiphyBrowser'
use_frameworks!

platform :ios, '11.0'

def module_pods
    pod 'RxSwift',    '~> 5'
end

def app_pods
    pod 'RxSwift',    '~> 5'
    pod 'RxCocoa',    '~> 5'
end

def testing_pods
    pod 'Nimble'
    pod 'Quick'
    # Rx
    pod 'RxBlocking', '~> 5'
    pod 'RxTest',     '~> 5'
end

target "KMOperation" do
    pod 'RxSwift',    '~> 5'
end
target "KMOperationTests" do
    pod 'RxSwift',    '~> 5'
    post_install do |installer|
   installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
         target.build_configurations.each do |config|
            if config.name == 'Debug'
               config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
            end
         end
      end
   end
end
end

target "GiphyClient" do
    module_pods
end

target "GiphyBrowser" do 
    app_pods
end

target "GiphyClientTests" do
    testing_pods
end

target "GiphyBrowserTests" do
    testing_pods
end
