//
//  ClosetSportController.swift
//  TorontoBiker
//
//  Created by HSIAO JENHAO on 2017-08-23.
//  Copyright © 2017 HSIAO JENHAO. All rights reserved.
//

import SystemConfiguration
import Foundation
import MapKit
import CoreLocation


final class ClosetSportController {

    public static let sharedInstance = ClosetSportController()

    // for all
    public var stationID: Int!

    // info part
    public var infoURLSource :String!
    public var infoLastUpdated :Double!
    public var infoTTL : Int!
    public var infoUrlToLocalDic = [String:Any]()
    public var infoLocalDic = [String: StationInfo]()
    private let inforURL: String = "https://tor.publicbikesystem.net/ube/gbfs/v1/en/station_information"

    // status
    public var statusURLSource :String!
    public var statusLastUpdated :Double!
    public var statusTTL : Int!
    public var statusUrlToLocalDic = [String:Any]()
    public var statusLocalDic = [String: StationStatus]()
    private let statURL: String = "https://tor.publicbikesystem.net/ube/gbfs/v1/en/station_status"

    //distance

    public let mapManager = CLLocationManager()
    public var distance: Double!
    public var keysArray:[String] = []



  private init(){

        self.infoURLSource = self.inforURL
        self.statusURLSource = self.statURL

        getSourceData()

    }

    func getSourceData(){

        self.infoUrlToLocalDic.removeAll()
        self.statusUrlToLocalDic.removeAll()

        do{

            let infoDownloadedData = try Data(contentsOf: URL(string: self.infoURLSource)!)
            let statusDownloadedData = try Data(contentsOf: URL(string: self.statusURLSource)!)

            let infoJson = try JSONSerialization.jsonObject(with: infoDownloadedData, options: [])
            let statusJson = try JSONSerialization.jsonObject(with: statusDownloadedData, options: [])

            if let infoJsonDict = infoJson as? [String:Any]{
                self.infoUrlToLocalDic = infoJsonDict
            }

            if let statusJsonDict = statusJson as? [String:Any]{
                self.statusUrlToLocalDic = statusJsonDict
                //                print("statusUrlToLocalDic =",(statusUrlToLocalDic))
            }


        }catch{
            print("Source has errer:\(error.localizedDescription)")
        }

        self.creatinfoLocalDic()
        self.creatStatusLocalDic()

    }

    func getDistance(lat:Double, lon:Double)-> Double {


        let coordinate1: CLLocationCoordinate2D =
            CLLocationCoordinate2DMake(CurrentCoordinate.currentLoction.latitude,
                                       CurrentCoordinate.currentLoction.longitude)
        let point1 = MKMapPointForCoordinate(coordinate1)

        let coordinate2: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        let point2 = MKMapPointForCoordinate(coordinate2)
        let getdistance = MKMetersBetweenMapPoints(point1, point2)
        //        let distancKM = (getdistance / 1000).rounded()

        let distancKM = Double(getdistance / 1000).roundTo(places: 2)


        return distancKM

    }

    func creatinfoLocalDic(){

        if let josonDic = infoUrlToLocalDic as? [String:Any]{

            guard let stationsDataArray = josonDic["data"] as? [String: Any] else { print("stationsDataArray not an [String: Any]" ); return}
            //            print("stationsDataArray=",(stationsDataArray))

            guard let lastUpdate = josonDic["last_updated"] as? Double else { print("lastUpdate not an Double" ); return}
            self.infoLastUpdated = lastUpdate
            //            print ("infoLastUpdated =",(self.infoLastUpdated))

            guard let statinfoTTL = josonDic["ttl"] as? Int else { print("statinfoTTL not an Int" ); return}
            self.infoTTL = statinfoTTL
            //            print ("infoTTL =",(self.infoTTL))

            guard let stationsArray = stationsDataArray["stations"] as? [Any] else { print("not an [Any]" ); return}
            //            print("stationsArray=",(stationsArray))

            var no = 1

            for station in stationsArray {

                guard let stationDict = station as? [String: Any] else { print("not an [String: Any] Dictionary");return}

                guard let stationId = stationDict["station_id"] as? Int else { print(" station_id not an Int" ); return}
                guard let stationName = stationDict["name"] as? String else { print(" name not an String" ); return}
                guard let stationLat = stationDict["lat"] as? Double else { print("lat not an Double" ); return}
                guard let stationLon = stationDict["lon"] as? Double else { print("lon not an Double" ); return}
                guard let stationAddress = stationDict["address"] as? String else { print("address not an String" ); return}
                guard let stationCapacity = stationDict["capacity"] as? Int else { print(" capacity not an Int" ); return}

                guard let distanceValue = getDistance(lat: stationLat, lon: stationLon) as? Double else { print(" distance not an Double" ); return}

                self.stationID = stationId

                let addInfo = StationInfo(
                    stationName: stationName,
                    stationAddress: stationAddress,
                    stationCapaCity: stationCapacity,
                    stationLat: stationLat,
                    stationLon: stationLon,
                    //                    distance:self.distance
                    distance: distanceValue
                )


                self.infoLocalDic.updateValue(addInfo, forKey: String(stationId))

                no = no + 1

            }

        }

        //        print("infoLocalDic=",(infoLocalDic))
        print("infoLocalDic.count=",(infoLocalDic.count))

        //        let date = NSDate(timeIntervalSince1970: self.infoLastUpdated)
        //        print("date=",(date))


    }

    func creatStatusLocalDic(){


        if let josonDic = statusUrlToLocalDic as? [String:Any]{
            guard let stationsStatusArray = josonDic["data"] as? [String: Any] else { print("stationsStatusArray not an [String: Any]" ); return}
            //print("stationsStatusArray=",(stationsStatusArray))

            guard let lastUpdate = josonDic["last_updated"] as? Double else { print("statusLastUpdated not an Double" ); return}
            self.statusLastUpdated = lastUpdate
            //print ("statusLastUpdated =",(self.infoLastUpdated))

            guard let statinfoTTL = josonDic["ttl"] as? Int else { print("statusTTL not an Int" ); return}
            self.statusTTL = statinfoTTL
            //print ("statusTTL =",(self.infoTTL))

            guard let stationsArray = stationsStatusArray["stations"] as? [Any] else { print("not an [String: Any]" ); return}
            //print("stationsArray=",(stationsArray))

            var no = 1

            for station in stationsArray {

                guard let stationDict = station as? [String: Any] else { print("not an [String: Any] Dictionary");return}

                guard let stationId = stationDict["station_id"] as? Int else { print(" station_id not an Int" ); return}
                guard let bikesAvailable = stationDict["num_bikes_available"] as? Int else {print("num_bikes_available not an Int" ); return}
                guard let docksAvailable = stationDict["num_docks_available"] as? Int else {print("num_docks_available not an Int" ); return}

               
                
                self.stationID = stationId
                
                let addStatus = StationStatus(
                    bikesAvailable: bikesAvailable,
                    docksAvailable: docksAvailable
                    
                    
                )
                
                self.statusLocalDic.updateValue(addStatus, forKey: String(stationId))
                
                no = no + 1
                
            }
            
        }
        
        //        print("infoLocalDic=",(infoLocalDic))
        print("statusLocalDic.count=",(statusLocalDic.count))
        //
        //        let  date = NSDate(timeIntervalSince1970: self.statusLastUpdated)
        //        print("Status date=",(date))
        
    }
    
    
    
}

