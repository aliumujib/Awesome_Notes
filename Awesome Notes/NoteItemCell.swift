//
//  NoteItemCell.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/7/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import MapKit
import UIKit

class NoteItemCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var borderView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mapView.layer.borderWidth = 1
        mapView.layer.borderColor = SHADOW_COLOR.cgColor
        
        photoView.layer.borderWidth = 1
        photoView.layer.borderColor = SHADOW_COLOR.cgColor
        
    }
    
    func configureCell(note: Note) {
        self.titleLabel.text = note.title
        self.contentLabel.text = note.content
        
        if let image = note.relToImage?.image as? UIImage{
            self.photoView.image = image
        }else{
            self.photoView.isHidden = true
        }
        
        print(note.relToLocation?.longitude)
        print(note.relToLocation?.latitude)

        if((note.relToLocation?.longitude) != nil && (note.relToLocation?.latitude) != nil){
            let initialLocation = CLLocation(latitude: (note.relToLocation?.latitude)!, longitude: (note.relToLocation?.longitude)!)
            centerMapOnLocation(location: initialLocation)
        }else{
            mapView.isHidden = true
        }
        
    }

    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
