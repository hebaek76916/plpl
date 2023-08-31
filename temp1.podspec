Pod::Spec.new do |spec|
    spec.name            = "temp1"
    spec.version         = "1.0.21"
    spec.summary         = "A brief description of temp1"
    spec.description     = "A longer description if needed"
    
    spec.homepage        = "temp1"
    spec.license         = "MIT"
    spec.author          = { "hebaek76916" => "qorgusdms15@gmail.com" }
    spec.source          = { :git => "https://github.com/hebaek76916/plpl", :tag => "1.0.21" }
    spec.source_files    = "temp1"
    spec.swift_version   = "5.0"
    spec.dependency      'Alamofire'
    spec.ios.deployment_target        = "10.0"
end
