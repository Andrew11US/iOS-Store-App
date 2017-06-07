//
//  ViewController.swift
//  Store
//
//  Created by Andrew Foster on 6/6/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var gallery = [Art]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        updateGallery()
        
        if gallery.count == 0 {
//            createArt("Horse", productIdentifier: "", imageName: "horse.jpeg", purchased: true)
//            createArt("Bird", productIdentifier: "com.zappycode.thegallery.bird", imageName: "bird.jpeg", purchased: false)
//            createArt("Baby", productIdentifier: "com.zappycode.thegallery.baby", imageName: "baby.jpeg", purchased: false)
            createArt("Hello", productIdentifier: "", imageName: "", purchased: true)
            createArt("Hello", productIdentifier: "", imageName: "", purchased: true)
            createArt("Hello", productIdentifier: "", imageName: "", purchased: true)
            updateGallery()
            self.collectionView.reloadData()
        }
    }
    
    func createArt(_ title:String, productIdentifier:String, imageName:String, purchased:Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Art", in: context) {
            let art = NSManagedObject(entity: entity, insertInto: context) as! Art
            art.title = title
            art.productIdentifier = productIdentifier
            art.imageName = imageName
            art.purchased = NSNumber(value: purchased) as! Bool
        }
        
        do {
            try context.save()
        } catch {}
    }
    
    func updateGallery() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Art")
        do {
            let artPieces = try context.fetch(fetch)
            self.gallery = artPieces as! [Art]
        } catch {}
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.bounds.size.width - 80, height: self.collectionView.bounds.size.height - 40)
    }

}

