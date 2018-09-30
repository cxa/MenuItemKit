# coding: utf-8
Pod::Spec.new do |s|
  s.name         = "MenuItemKit"
  s.version      = "3.1.3"
  s.summary      = "MenuItemKit provides image and closure(block) support for UIMenuItem."
  s.author       = "CHEN Xian’an <xianan.chen@gmail.com>"
  s.homepage     = "https://github.com/cxa/MenuItemKit"
  s.license      = 'MIT'
  s.source       = { :git => 'https://github.com/cxa/MenuItemKit.git', :branch => "master", :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.source_files = 'MenuItemKit/*.{h,m,swift}'
  s.requires_arc = true
  s.frameworks   = 'UIKit'
  s.swift_version= "4.2"
end
