//
//  homeExtention.swift
//  Halan
//
//  Created by Hesham on 10/16/18.
//  Copyright © 2018 alatheertech. All rights reserved.
//

import Foundation
import UIKit
extension HomeVC {
    
    
    
    @IBAction func LogOut(_ sender: UIButton) {
        Helper.logout()
    }
    //    var urlstr = ""
    // var titlestr = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DriverSegue" {
            let destinationVC = segue.destination as! WebViewVC
            destinationVC.urlstr = Config.main
            destinationVC.titlestr = NSLocalizedString("Driver Registeration", comment: " driver registration")
        }
        
        
    }
    @IBAction func Cancelorder(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.OrderButtomConstrain.constant = 200
            self.view.layoutIfNeeded()
            
        })
    }
    ///
    
    
    
    
    @IBAction func MuteAction(_ sender: UISwitch) {
        if MuteSwich.isOn {
            
            
            print("on")
        }else{
            print("off")
            
        }
    }
    
    @IBAction func Profile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ProfileSegue", sender: self)
    }
    
    @IBAction func registDriver(_ sender: UIButton) {
        if  Helper.isDriver() == false{
            self.performSegue(withIdentifier: "DriverSegue", sender: self)
        }
        
    }
    
    
    @IBAction func gesturerec(_ sender: UIPanGestureRecognizer) {
        
        if sender.state == .began || sender.state == .changed{
            let translation = sender.translation(in: self.view).x
            
            if translation > 0 {
                //swipe right
                if NavmenuLeading.constant < 20{
                    self.menuButton.setFAIcon(icon: .FAClose, iconSize: 35)
                    isnaveopen =  false
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.NavmenuLeading.constant += translation/10
                        self.view.layoutIfNeeded()
                        
                    })
                    
                }
                
            }else{
                ////swipe left
                
                if NavmenuLeading.constant > -300{
                    self.menuButton.setFAIcon(icon: .FANavicon, iconSize: 35)
                    isnaveopen =  true
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.NavmenuLeading.constant += translation/10
                        self.view.layoutIfNeeded()
                        
                    })
                    
                }
                
                
            }
            
        }else if sender.state == .ended {
            if NavmenuLeading.constant < -300{
                UIView.animate(withDuration: 0.2, animations: {
                    self.NavmenuLeading.constant = -300
                    self.view.layoutIfNeeded()
                    
                })
            }else{
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.NavmenuLeading.constant = 0
                    self.view.layoutIfNeeded()
                    
                })
                
            }
        }
    }
    
    //////slide menu
    @IBAction func NavigationButton(_ sender: UIBarButtonItem) {
        if isnaveopen {
            isnaveopen =  false
            self.menuButton.setFAIcon(icon: .FAClose, iconSize: 35)
            NavView.layer.shadowColor = UIColor.black.cgColor
            NavView.layer.shadowOpacity = 0.5
            NavView.layer.shadowOffset = CGSize(width: 25, height: 0)
            NavmenuLeading.constant = 0
        }else{
            NavmenuLeading.constant = -300
            self.menuButton.setFAIcon(icon: .FANavicon, iconSize: 35)
            isnaveopen =  true
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    /////////////////////////////////////////
    func ordermenu(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.OrderButtomConstrain.constant = 0
            self.view.layoutIfNeeded()
            
        })    }
    
    //next
    @IBAction func Addordertocaret(_ sender: UIButton) {
        
        
        if Helper.isguest() == false{
            UIView.animate(withDuration: 0.2, animations: {
                self.OrderButtomConstrain.constant = 200
                self.view.layoutIfNeeded()
                self.orderButtomConst.constant = 0
            })
        }else{
            // Create the alert controller
            let alertController = UIAlertController(title: "تقرير", message: "عفوا  يرجي تسجيل الدخول لاتمام الحجز", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "موافق", style: UIAlertAction.Style.default) {
                UIAlertAction in
                // NSLog("OK Pressed")
                Helper.logout()
            }
            let cancelAction = UIAlertAction(title: "الغاء", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                //NSLog("Cancel Pressed")
            }
            
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
        }
    
    
}
    
    
    @IBAction func sendOrderToDriver(_ sender: UIButton) {
        
        
        var costOFway:String = WayCost.text!
        if costOFway.isEmpty {
            costOFway = "50"
        }
        
        
        Api.requestOrderTodriver(clientlocation: clientLocation.text!, clientLat: location.latitude, clientLong: location.longitude, marketlocation: MarketLocation.text!, marketlat:  self.marketDestination.longitude, marketlong:  self.marketDestination.longitude, distance: distance.text!, orderdetailes: OrderText.text!, cost:costOFway , drivers: driverArr) { (error:Error?, success:Bool) in
            
            
        }
        
        UIView.animate(withDuration: 0.05, animations: {
            self.orderButtomConst.constant = 300
            self.view.layoutIfNeeded()
            
        })
        
        
        let title:String = NSLocalizedString("report", comment: "")
        let message:String = NSLocalizedString("your order hase been sent successfuly ", comment: "")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .destructive, handler: nil))
        self.present(alert,animated: true)

        
        
        // print(driverArr)
    }
}
