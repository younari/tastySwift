//
//  Constants.swift
//  rainyshinycloudy
//
//  Created by Caleb Stultz on 7/27/16.
//  Copyright © 2016 Caleb Stultz. All rights reserved.
//

import Foundation
typealias DownloadComplete = () -> ()
let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "9eb78416466a2480d3da80192164b38c"

let latitude = Location.sharedInstance.latitude!
let longitude = Location.sharedInstance.longitude!

let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=42a1771a0b787bf12e734ada0cfc80cb"
let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(latitude)&lon=\(longitude)&cnt=10&mode=json&appid=42a1771a0b787bf12e734ada0cfc80cb"

