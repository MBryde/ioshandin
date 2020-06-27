//
//  QueryServiceAPI.swift
//  18_QuarantineApp
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation

class QueryServiceAPI {
    // function which gets the countries available on the API
    func getCountriesAvailable(completion: @escaping ([CountrySlug]) -> Void){
        // holds the available countries
        var availableCountries = [CountrySlug]()
        
        // guard which makes sure that we create the URL properly
        guard let url = URL(string: "https://api.covid19api.com/countries") else { return }
        
        // uses URLSession to access the api
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                   
            // we make sure that we get the data and the error is nil or else we print an error
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Response error")
                return
            }
            
            do{
                // then we use JSONSerialization to convert the JSON to objects
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                
                // we cast the jsonResponse to an array of dictionaries and makes sure of it by using guard
                guard let jsonArray = jsonResponse as? [[String: Any]] else { return }
                
                
                // handle the dictionaries and creates CountrySlug objects and appends them to our list
                for dic in jsonArray{
                    if let country = dic["Country"] as? String,
                        let slug = dic["Slug"] as? String,
                        let iso2 = dic["ISO2"] as? String{
                        
                        let countrySlug = CountrySlug(country: country, slug: slug, iso2: iso2)
                        availableCountries.append(countrySlug)
                    }
                }
                
                // completionhandler which returns the list of available countries
                completion(availableCountries)
                
            }catch let parsingError {
                print("Error", parsingError)
            }
        }
        // starts the task we initiated
        // tasks are initialized in a suspended state
        task.resume()
    }
    
    // function which is responsible for getting the data on the country
    func getCountry(queryFor country: String, completion: @escaping ([Country]) -> Void){
        
        // gets the dates needed to get the newest data from the API
        let dates = getDateAndTime()
        
        // holds the countrys data
        var countryData = [Country]()
        
        // guard which makes sure that we create the URL properly
        guard let url = URL(string: "https://api.covid19api.com/country/\(country)?from=\(dates.0)T00:00:00Z&to=\(dates.1)T00:00:00Z") else { return }
        
        // uses URLSession to access the api
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // we make sure that we get the data and the error is nil or else we print an error
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Response error")
                return
            }
            
            do{
                // then we use JSONSerialization to convert the JSON to objects
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                
                // we cast the jsonResponse to an array of dictionaries and makes sure of it by using guard
                guard let jsonArray = jsonResponse as? [[String: Any]] else { return }
                
                // handle the dictionaries and creates Country objects and appends them to our list
                for dic in jsonArray{
                    if let country = dic["Country"] as? String,
                        let countryCode = dic["CountryCode"] as? String,
                        let province = dic["Province"] as? String,
                        let city = dic["City"] as? String,
                        let cityCode = dic["CityCode"] as? String,
                        let lat = dic["Lat"] as? String,
                        let lon = dic["Lon"] as? String,
                        let confirmed = dic["Confirmed"] as? Int,
                        let deaths = dic["Deaths"] as? Int,
                        let recovered = dic["Recovered"] as? Int,
                        let active = dic["Active"] as? Int,
                        let date = dic["Date"] as? String{
                        
                        let country = Country(country: country, countryCode: countryCode, province: province, city: city, cityCode: cityCode, lat: lat, lon: lon, confirmed: confirmed, deaths: deaths, recovered: recovered, active: active, date: date)
                        
                        countryData.append(country)
                    }
                }
                // completionhandler which returns the country data
                completion(countryData)
                
            }catch let parsingError {
                print("Error", parsingError)
            }
        }
        // starts the task we initiated
        // tasks are initialized in a suspended state
        task.resume()
    }
    
    // function which is responsible for getting the world overview
    func getWorld(completion: @escaping (World) -> Void){
        
        // guard which makes sure that we create the URL properly
        guard let url = URL(string: "https://api.covid19api.com/world/total") else { return }
        
        // uses URLSession to access the api
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // we make sure that we get the data and the error is nil or else we print an error
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Response error")
                return
            }
            
            do{
                // then we use JSONSerialization to convert the JSON to objects
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                
                // we cast the jsonResponse to an array and makes sure of it by using guard or else we return
                guard let jsonArray = jsonResponse as? [String: Any] else { return }
                
                // declares a world object
                let world: World
                
                // handle the array and creates the world object
                if let confirmed = jsonArray["TotalConfirmed"] as? Int,
                    let deaths = jsonArray["TotalDeaths"] as? Int,
                    let recovered = jsonArray["TotalRecovered"] as? Int{
                    
                    world = World(confirmed: confirmed, deaths: deaths, recovered: recovered)
                    
                    // completionhandler which returns the world object
                    completion(world)
                }
                
            }catch let parsingError {
                print("Error", parsingError)
            }
        }
        // starts the task we initiated
        // tasks are initialized in a suspended state
        task.resume()
    }
    
    // function which returns the two dates used to fetch the newest data from the API
    func getDateAndTime() -> (String, String) {
        
        // Creates a Date object to find the date and time
        let today = Date.init()
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) else { return ("","")}
        
        // Creates a dateformatter and changes format
        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyy-MM-dd"
        
        // Gets the string representation of the days
        let yesterdayString = dateTimeFormatter.string(from: yesterday)
        let todayString = dateTimeFormatter.string(from: today)

        
        return (yesterdayString, todayString)
    }
}

