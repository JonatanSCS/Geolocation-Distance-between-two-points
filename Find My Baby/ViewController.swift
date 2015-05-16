//

import UIKit
import CoreLocation
import MapKit
import Darwin
import Foundation



class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}



class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    @IBOutlet weak var theLabel: UILabel!
    @IBOutlet weak var theMap: MKMapView!
    @IBOutlet var background: UIView!
    @IBOutlet weak var longitudLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    
    
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Localización albitraria del niño
        
        var location = CLLocationCoordinate2D(latitude: 19.294045, longitude: -99.628181)
        var span = MKCoordinateSpanMake(0.01, 0.01)
        var region = MKCoordinateRegion(center:location,span:span)
    
        theMap.setRegion(region,animated: true)
        //var anotation = MKPointAnnotation()
        var annotation = CustomPointAnnotation()
        
        annotation.title = "Tu niño está aqui"
        annotation.imageName = "nino.png"
        
        
        
        theMap.addAnnotation(annotation)
        
        
        
        //Setup our Location Manager
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        
        //Setup our Map View
        theMap.delegate = self
        theMap.mapType = MKMapType.Satellite
        theMap.showsUserLocation = true
        
        
        
        
        /*
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        */
    }
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        
        if anView == nil {
            
            
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView.canShowCallout = true
            
        }
        else {
            
            anView.annotation = annotation
            
        }
        
               let cpa = annotation as! CustomPointAnnotation
        anView.image = UIImage(named:cpa.imageName)
        
        return anView
    }
    
    
    func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
        
        
        
        myLocations.append(locations[0] as! CLLocation)
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: theMap.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        theMap.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
          
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            theMap.addOverlay(polyline)
            
           
            
        }
        
            //Calculo de distancia de forma CLLocation
    
                //var distance: CLLocationDistance = locations[1].distanceFromLocation(locations[1] as CLLocation)
                //theLabel.text = "El ninio esta a \(distance) metros"

        //Obtención de ubicación de forma CLLocationCoordinate2D

        
            var centre = theMap.centerCoordinate as CLLocationCoordinate2D
        
            var getLat: CLLocationDegrees = centre.latitude
            var getLon: CLLocationDegrees = centre.longitude
            var getMovedMapCenter: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        
        
        
            //longitudLabel.text = "\(getLat)"
            //latitudeLabel.text = "\(getLon)"
        
        var z = getLat
        var x = getLon
        
        
        //Calcular la distancia (forma matemática)
        
        var R = 6371000.0
        var rad1 = (( z * 3.14159) / 180)
        var rad2 = ((19.294044*3.14159)/180)
        var difrad = (((19.294045 - z) * 3.14159)/180);
        var diflong = (((-99.628182 - x) * 3.14159)/180);
        
        
        var haversine = sin(difrad/2) * sin(difrad/2) + cos(rad1) * cos(rad2) * sin(diflong/2) *  sin(diflong/2);
        var c = 2 * atan2(sqrt(haversine), sqrt(1-haversine))
        var d = R * c
        var distancia = floor(d)
        
        
        
        
        if ( distancia <= 20){
           self.view.backgroundColor = UIColor.redColor()
        } else if ( distancia <= 40){
            
            self.view.backgroundColor = UIColor.yellowColor()
        }else{
            self.view.backgroundColor = UIColor.redColor()
        }
        
        
            theLabel.text = "El niño está a \(distancia) metros"

        
        
            //theLabel.text = "\(locations[0])"

        
}
    
        

    //Marca el trayecto del usuario
    
    
    /*
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 10
            //return polylineRenderer
            return nil
        }
        s
        
        return nil
        
    }
*/
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
