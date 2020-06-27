//
//  ViewController.swift
//  18_QuarantineApp
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
        @IBOutlet weak var picker: UIPickerView!
        @IBOutlet weak var countryLabel: UILabel!
        @IBOutlet weak var provinceLabel: UILabel!
        @IBOutlet weak var currentlyInfectedLabel: UILabel!
        @IBOutlet weak var deathsLabel: UILabel!
        @IBOutlet weak var recoveredLabel: UILabel!
        @IBOutlet weak var totalInfectedLabel: UILabel!
        
        var queryServiceAPI = QueryServiceAPI()
        var countryData = [Country]()
        
        var countrySelected: CountrySlug?
        var provinceSelected: String?
            
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            picker.delegate = self
            picker.dataSource = self
            picker.isHidden = true
            
            
            countryLabel.text = "Global"
            provinceLabel.isHidden = true
            
            queryServiceAPI.getWorld { (world) in
                let world = world
                DispatchQueue.main.async {
                    self.currentlyInfectedLabel.text = "Currently infected: \(world.active) people"
                    self.deathsLabel.text = "Deaths: \(world.deaths) people"
                    self.recoveredLabel.text = "Recovered: \(world.recovered) people"
                    self.totalInfectedLabel.text = "Total Infected: \(world.confirmed) people"
                }
                
            }
            
        }
        
        func handleCountryChosen(country: CountrySlug){
            
            queryServiceAPI.getCountry(queryFor: country.slug) { (countryData) in
                self.countryData = countryData.sorted{($0.province < $1.province)}
                
                // since we're updating UI elements from a closure we need to wait for the main thread to be ready, so we use dispatchqueue
                DispatchQueue.main.async {
                    self.countryLabel.text = country.country
        
                // if there's no data about the country
                if countryData.count == 0{
                    print("0")
                        self.picker.isHidden = true
                        self.currentlyInfectedLabel.text = "Currently infected: No data registered"
                        self.deathsLabel.text = "Deaths: No data registered"
                        self.recoveredLabel.text = "Recovered: No data registered"
                        self.totalInfectedLabel.text = "Total Infected: No data registered"
                    
                // if we get one result then there is only data available for the country in total. we then set the fields to the value of the data
                }else if countryData.count == 1{
                    print("1")

                        self.picker.isHidden = true
                        self.currentlyInfectedLabel.text = "Currently infected: \(countryData[0].active)"
                        self.deathsLabel.text = "Deaths: \(countryData[0].deaths)"
                        self.recoveredLabel.text = "Recovered: \(countryData[0].recovered)"
                        self.totalInfectedLabel.text = "Total Infected: \(countryData[0].confirmed)"
                    
                // if there is multiple elements in the countryData list then we have gotten data about the different provinces in the country
                // so we need to calculate a total for the country, and show the picker so you can choose a province
                }else{
                    print("2")

                        var totalActive = 0
                        var totalDeaths = 0
                        var totalRecovered = 0
                        var totalConfirmed = 0
                        
                        for country in countryData{
                            totalActive += country.active
                            totalDeaths += country.deaths
                            totalRecovered += country.recovered
                            totalConfirmed += country.confirmed
                        }
                        
                        let countryTotalled = Country(country: "-- Total --", countryCode: "", province: "", city: "", cityCode: "", lat: "", lon: "", confirmed: totalConfirmed, deaths: totalDeaths, recovered: totalRecovered, active: totalActive, date: "")
                        
                        self.countryData.insert(countryTotalled, at: 0)
                        
                        self.currentlyInfectedLabel.text = "Currently infected: \(totalActive)"
                        self.deathsLabel.text = "Deaths: \(totalDeaths)"
                        self.recoveredLabel.text = "Recovered: \(totalRecovered)"
                        self.totalInfectedLabel.text = "Total Infected: \(totalConfirmed)"
                        
                        self.picker.reloadAllComponents()
                        self.picker.isHidden = false
                    }
                }
            }
        }

        
        
        @IBAction func chooseCountryPressed(_ sender: Any) {
            performSegue(withIdentifier: "chooseCountrySegue", sender: nil)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "chooseCountrySegue"{
                if let destination = segue.destination as? TableViewController{
                    destination.parentVC = self
                    
                    let presentationController = destination.popoverPresentationController
                    presentationController?.delegate = self
                }
            }
        }
        
        
    }

    extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return countryData.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            // hvis provincen og byen er der
            // hvis
            
            // if the province is empty then we return the countryname
            if countryData[row].province.isEmpty{
                return countryData[row].country
            
            // if the city field isn't empty, then we return the province and the city name
            }else if !(countryData[row].city.isEmpty){
                return "\(countryData[row].province) - \(countryData[row].city)"
            
            // or else we just return the province name
            }else{
                return countryData[row].province
            }
        }
        
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print("Hey")
            let province = countryData[row]
            
            provinceLabel.isHidden = false
            provinceLabel.text = province.province
            
            self.currentlyInfectedLabel.text = "Currently infected: \(province.active)"
            self.deathsLabel.text = "Deaths: \(province.deaths)"
            self.recoveredLabel.text = "Recovered: \(province.recovered)"
            self.totalInfectedLabel.text = "Total Infected: \(province.confirmed)"
        }
        
        
        
        
    }
