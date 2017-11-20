//
//  MenuPage1.swift
//  TorontoBike
//
//  Created by HSIAO JENHAO on 2017-08-19.
//  Copyright © 2017 HSIAO JENHAO. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class StartPage: UIViewController, UITableViewDelegate, UITableViewDataSource {

    internal var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()

    var btnClosest = UIButton(type: .custom)
    let fullScreenSize = UIScreen.main.bounds.size
    var imgViewLogo : UIImageView!
    var imgTorontoBG = UIImage(named: "backgroupToronto2")
    var imgViewTorontoBG : UIImageView!
    
    var SpotsTableView = UITableView()


    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        // Background image
        
        self.imgViewTorontoBG = UIImageView(frame: CGRect(
            x: 0 , y: 0  ,
            width: self.fullScreenSize.width ,
            height: self.fullScreenSize.height * 0.2))

        self.imgViewTorontoBG.image = imgTorontoBG
        self.imgViewTorontoBG.contentMode = .scaleAspectFill
        
//        self.imgViewTorontoBG.contentMode = .scaleAspectFit

        view.addSubview(imgViewTorontoBG)


        //MARK: LOGO

        let imgLogo = UIImage(named: "logo")
        imgViewLogo = UIImageView(frame: CGRect(x: 0 , y: 0  , width: fullScreenSize.width * 0.6 , height: 300))

        imgViewLogo.center = CGPoint(
            x: fullScreenSize.width * 0.5,
            y: fullScreenSize.height * 0.07)

        imgViewLogo.image = imgLogo
        imgViewLogo.contentMode = .scaleAspectFit
        imgViewLogo.alpha = 0.3
        view.addSubview(imgViewLogo)


        //MARK: Func1
        btnClosest = UIButton(frame: CGRect(
            x: fullScreenSize.width  * 0.1,
            y: fullScreenSize.height * 0.1,
            width: fullScreenSize.width * 0.1,
            height: fullScreenSize.width * 0.1))

        btnClosest.isEnabled = true
        btnClosest.setImage(UIImage(named:"button1"), for: .normal)
        btnClosest.addTarget( nil, action: #selector(closestSpotPage), for: .touchUpInside)
        btnClosest.alpha = 0
         self.view.addSubview(btnClosest)

        
        //MARK: TableView
        
        
        SpotsTableView = UITableView(frame: CGRect(
            x: 0, y: fullScreenSize.height * 0.25,
            width: fullScreenSize.width,
            height: fullScreenSize.height * 0.75),
                                     style: .plain)
        
        //enroll History cell
        
        SpotsTableView.register(ClosestSpotCell.self, forCellReuseIdentifier: "SpotCell")
        // set the delegate
        
        SpotsTableView.delegate = self
        SpotsTableView.dataSource = self
    
        
        //table view separator
        SpotsTableView.separatorStyle = .singleLine
        
        // separator space
        SpotsTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        SpotsTableView.allowsSelection = true
        SpotsTableView.allowsMultipleSelection = false
        self.view.addSubview(SpotsTableView)
        
        
        //get source data
        
        sortKeysArrayByDistance()

    }


    override func viewDidAppear(_ animated: Bool) {

        CurrentCoordinate.sharedInstance.getLoction()

        print("location=",(CurrentCoordinate.currentLoction))


        UIView.animate(withDuration: 1, delay: 0, options: [.repeat,.autoreverse,.curveEaseIn], animations: {

            self.imgViewLogo.alpha = 1


        })

        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {

            self.btnClosest.alpha = 1

        })


    }


    func closestSpotPage() {

        indicatorStart()
        self.present(ClosestSpotPage(), animated: true, completion: nil)
        indicatorStop()
    }





    func alert(){

        let alert = UIAlertController(title:nil,message: "This function \n isn't done yet",preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(actionOK)
        present(alert, animated: true, completion:nil)

    }

    func indicatorStart(){

        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true

//        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.white
        activityIndicator.color = UIColor.green

        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    func indicatorStop(){
        activityIndicator.stopAnimating()
        //        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return ClosetSportController.sharedInstance.infoLocalDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SpotCell"
        let cell = SpotsTableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ClosestSpotCell
        
        
        
        let key = ClosetSportController.sharedInstance.keysArray[indexPath.row]
        print("key=",(key))
        
        let name = ClosetSportController.sharedInstance.infoLocalDic[key]?.stationName
        let bikes = ClosetSportController.sharedInstance.statusLocalDic[key]?.bikesAvailable
        let docks = ClosetSportController.sharedInstance.statusLocalDic[key]?.docksAvailable
        let distance = ClosetSportController.sharedInstance.infoLocalDic[key]?.distance
        
        
        print("distance=",(distance)!)
        cell.satationName.text = name
        
        checkCellTextColor(cell: cell, bikes: bikes!,docks:docks!,distance:distance!)
        
        cell.bikesAvailable.text = String(describing: bikes!)
        cell.docksAvailable.text = String(describing: docks!)
        cell.distancelable.text = String(describing: distance!) + "km"
        
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor.init(red: 50 / 255, green: 170 / 255 , blue: 110 / 255 , alpha: 1)
        cell.labelBikes.highlightedTextColor = UIColor.white
        cell.labelDocks.highlightedTextColor = UIColor.white
        cell.labelDistance.highlightedTextColor = UIColor.white
        cell.satationName.highlightedTextColor = UIColor.white
        
        
        return cell
    }
    
    func checkCellTextColor(cell: ClosestSpotCell,bikes:Int, docks:Int, distance:Double) {
        
        cell.bikesAvailable.textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        if bikes == 0 {
            cell.bikesAvailable.textColor = UIColor.red
        }else if bikes >= 1 && bikes <= 3 {
            cell.bikesAvailable.textColor = UIColor.orange
        }
        
        cell.docksAvailable.textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        if docks == 0 {
            cell.docksAvailable.textColor = UIColor.red
        }else if docks >= 1 && docks <= 3 {
            cell.docksAvailable.textColor = UIColor.orange
        }
        
        cell.distancelable.textColor = UIColor.init (red: 0, green: 0.2353, blue: 0.7059, alpha: 1.0)
        if distance >= 10.0 && distance <= 20.0 {
            cell.distancelable.textColor = UIColor.orange
        }else if distance >= 20.1 {
            cell.distancelable.textColor = UIColor.red
        }
        
        
    }
    
    func sortKeysArrayByDistance(){
        
        //        let storByDistance = self.stationInfo.infoLocalDic.sorted { (s1, s2) -> Bool in
        let storByDistance = ClosetSportController.sharedInstance.infoLocalDic.sorted { (s1,s2) -> Bool in
            return s1.value.distance < s2.value.distance
        }
        
        var keys = [String]()
        for i in storByDistance {
            
            keys.append(i.key)
        }
        
        ClosetSportController.sharedInstance.keysArray = keys
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    
    
}
