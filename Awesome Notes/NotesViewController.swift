//
//  NotesViewController.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/7/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var fectchedResultsController : NSFetchedResultsController<Note>!
    var locationManager: CLLocationManager!
    var location :CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 333
        // Do any additional setup after loading the view.
    
        
      // generateTestData()
        attemptFetch()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initializeLocation()

    }
    
    
    
    func initializeLocation() {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            location = locationManager.location
           // print("\(location.coordinate.latitude) -- \(location.coordinate.latitude)")
            
            LocationLocal.sharedLocationInstance.latitude = location.coordinate.latitude as Double
            LocationLocal.sharedLocationInstance.longitude = location.coordinate.longitude as Double
            
            print("\(LocationLocal.sharedLocationInstance.latitude) -- \(LocationLocal.sharedLocationInstance.longitude)")

        }else{
            //locationManager.requestWhenInUseAuthorization() //CAUSES A CRASH... TO FIX LATER
            initializeLocation()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fectchedResultsController.sections {
            let sectionsInfo = sections[section]
            return sectionsInfo.numberOfObjects
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = self.fectchedResultsController.fetchedObjects{
            performSegue(withIdentifier: SHOW_DETAIL_FOR_EDIT, sender: objs[indexPath.row])
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SHOW_DETAIL_FOR_EDIT{
            if let destination = segue.destination as? DetailViewController{
                if let objToSend = sender as? Note{
                    destination.noteToEdit = objToSend
                    print("SENT OBJ")
                }else{
                    print("CAST TO NoteLocal DID NOT WORK")
                }
                
            }else{
                print("CAST TO DetailViewController DID NOT WORK")
            }
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fectchedResultsController.sections {
            return sections.count
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NOTES_CELL_REUSE_ID, for: indexPath) as! NoteItemCell
        configureCellForRow(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
        
    }
    
    
    func configureCellForRow(cell : NoteItemCell , indexPath : NSIndexPath){
        let note = fectchedResultsController.object(at: (indexPath) as IndexPath)
        cell.configureCell(note: note)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func generateTestData(){
        let note = Note(context: context)
        note.title = "To do once I get home today"
        note.content = "must be a property of your Core Data entity, not the name of the entity itself. So you should replace in the sort descriptor by some property of the Project entity, such"
        
        
        let note1 = Note(context: context)
        note1.title = "Animate the map camera"
        note1.content = "must be a property of your Core Data entity, not the name of the entity itself. So you should replace in the sort descriptor by some property of the Project entity, such"
        
        let note2 = Note(context: context)
        note2.title = "Add Mapbox to your Android app"
        note2.content = "must be a property of your Core Data entity, not the name of the entity itself. So you should replace in the sort descriptor by some property of the Project entity, such"
       
        let note3 = Note(context: context)
        note3.title = "Required configuration"
        note3.content = "must be a property of your Core Data entity, not the name of the entity itself. So you should replace in the sort descriptor by some property of the Project entity, such"
        
        let note4 = Note(context: context)
        note4.title = "API overview"
        note4.content = "must be a property of your Core Data entity, not the name of the entity itself. So you should replace in the sort descriptor by some property of the Project entity, such"

        appDel.saveContext()
        
    }
    
    

    func attemptFetch() {
        
        let fectchedRequest: NSFetchRequest<Note> = NoteLocal.fetchRequest()
        let dateSort = NSSortDescriptor(key: DATE_CREATION_KEY, ascending: false)
        fectchedRequest.sortDescriptors = [dateSort]
        
        let fectchedResultsControllerSmall = NSFetchedResultsController(fetchRequest: fectchedRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fectchedResultsControllerSmall.delegate = self
        
        self.fectchedResultsController = fectchedResultsControllerSmall
        
        
        do{
        
            try fectchedResultsControllerSmall.performFetch()
        }catch{
            let error = error as NSError
            print(error.localizedDescription)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if  let indexPath  = indexPath{
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
               let cell = tableView.cellForRow(at: indexPath) as! NoteItemCell
                configureCellForRow(cell: cell, indexPath: indexPath as NSIndexPath)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break            
        }
    }
    
}
