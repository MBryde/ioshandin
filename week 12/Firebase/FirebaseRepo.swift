//
//  FirebaseRepo.swift
//  12_Map
//
//  Created by Mads Bryde on 27/06/2020.
//  Copyright © 2020 Mads Bryde. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MapKit


// This class is responsible for interacting with the database
class FirebaseRepo{
    
    private static let db = Firestore.firestore()
    private static let collectionName = "annotations"
    
    static func startListener(vc:ViewController){
        db.collection(collectionName).addSnapshotListener { (snap, error) in
            if let snap = snap {
                vc.updateMarkersOnMap(snap: snap)
            }
        }
    }
    
    static func addAnnotation(marker: MKPointAnnotation){
        let docref = db.collection(collectionName).document()
        
        let geoPoint = GeoPoint(latitude: marker.coordinate.latitude, longitude: marker.coordinate.longitude)
        var map = [String:Any]()
        
        map["coordinates"] = geoPoint
        map["title"] = marker.title
        map["subtitle"] = marker.subtitle
        
        docref.setData(map)
    }
    
    static func updateAnnotation(){
        
    }
    
    static func deleteAnnotation(marker: MKPointAnnotation){
        let geoPoint = GeoPoint(latitude: marker.coordinate.latitude, longitude: marker.coordinate.longitude)
        
        db.collection(collectionName).whereField("coordinates", isEqualTo: geoPoint).getDocuments(){  (query, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for doc in query!.documents {
                    print("\(doc.documentID) => \(doc.data())")
                    db.collection(collectionName).document(doc.documentID).delete()
                    
                }
            }
        }
    }
    
}
