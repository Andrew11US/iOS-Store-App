//
//  ViewController.swift
//  Store
//
//  Created by Andrew Foster on 6/6/17.
//  Copyright © 2017 Andrii Halabuda. All rights reserved.
//

import UIKit
import CoreData
import StoreKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SKProductsRequestDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var gallery = [Art]()
    var products = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        updateGallery()
        
        if gallery.count == 0 {
            
            createArt("LA", productIdentifier: "", imageName: "LA.jpg", purchased: true)
            createArt("sunrise", productIdentifier: "com.losAngelesBoy.Store.sunrise", imageName: "sunrise.jpg", purchased: false)
            createArt("trees", productIdentifier: "com.losAngelesBoy.Store.tree", imageName: "trees.jpg", purchased: false)
            
            updateGallery()
            self.collectionView.reloadData()
        }
        
        requestProducts()
    }
    
    func requestProducts() {
        let ids : Set<String> = ["com.losAngelesBoy.Store.tree", "com.losAngelesBoy.Store.sunrise"]
        let productsRequest = SKProductsRequest(productIdentifiers: ids)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Products ready: \(response.products.count)")
        print("Products not ready: \(response.invalidProductIdentifiers.count)")
        self.products = response.products
        self.collectionView.reloadData()
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath) as! ArtCell
        
        let art = self.gallery[indexPath.row]
        
        cell.imageView.image = UIImage(named: art.imageName!)
        cell.titleLbl.text = art.title!
        
        for subview in cell.imageView.subviews {
            subview.removeFromSuperview()
        }
        
        if art.purchased {
            cell.purchasedLbl.isHidden = true
        } else {
            cell.purchasedLbl.isHidden = false
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurView = UIVisualEffectView(effect: blurEffect)
            cell.layoutIfNeeded()
            blurView.frame = cell.imageView.bounds
            cell.imageView.addSubview(blurView)
            
            for product in self.products {
                if product.productIdentifier == art.productIdentifier {
                    
                    let formatter = NumberFormatter()
                    formatter.numberStyle = NumberFormatter.Style.currency
                    formatter.locale = product.priceLocale
                    if let price = formatter.string(from: product.price) {
                        cell.purchasedLbl.text = "Buy for \(price)"
                    } else {
                        cell.purchasedLbl.text = "No Info!"
                    }
                } else {
                    print("productID doesn't match!")
                    print(product.productIdentifier, "do not match with:", art.productIdentifier ?? "")
                }
            }

        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.collectionView.bounds.size.width - 80, height: self.collectionView.bounds.size.height - 40)
    }

}

