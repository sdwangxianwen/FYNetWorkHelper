#
#  Be sure to run `pod spec lint FYNetWorkhelper.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


s.name                = "FYNetWorkHelper"
s.version             = "1.0.1"
s.summary             = "AFNetworking 与YYCache封装"
s.homepage            = "https://github.com/sdwangxianwen/FYNetWorkHelper"
s.license             = { :type => "Copyright", :text => "Copyright 2011 - 2018 UMeng.com. All rights reserved.\n" }
s.author             = { "wangwen" => "x870183756@qq.com" }
s.platform            = :ios, "9.0"
s.source              = { :git => "https://github.com/sdwangxianwen/FYNetWorkHelper.git", :tag => s.version }
s.source_files        = "FYNetWorkHelper/FYNetTool/*.{h,m}"

s.dependency          "AFNetworking"
s.dependency          "YYCache"
s.requires_arc        = true

end
