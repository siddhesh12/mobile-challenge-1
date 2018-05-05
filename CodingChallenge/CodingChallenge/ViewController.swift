//
//  ViewController.swift
//  CodingChallenge
//
//  Created by Siddhesh Mahadeshwar on 04/05/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "gridCell"
private let segueIdentifier = "detailSegueID"

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var pictures = [Picture]()
    var currentPage = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        getPhotos{_ in}
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier, let navVC = segue.destination as? UINavigationController, let detailVC = navVC.childViewControllers.first as? DetailViewController,
            let indexPath = sender as? IndexPath {
            detailVC.selectedIndexPath = indexPath
            detailVC.delegate = self
        }
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
          if indexPath.row == pictures.count - 1 {
            increaseCurrentPage()
            getPhotos{_ in}
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfPictures()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let picture = pictureAtIndexPath(indexPath: indexPath)
//        return CGSize(width: Double(picture.width!), height: Double(picture.height!))
        if indexPath.row % 2 == 0{
        return CGSize(width: 50, height: 50)
        }
        else if indexPath.row % 3 == 0{
            return CGSize(width: 100, height: 100)
        }
        else if indexPath.row % 5 == 0{
            return CGSize(width: 150, height: 150)
        }
        else{
            return CGSize(width: 200, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell:GridCollectionViewCell

        cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCollectionViewCell
        
        let picture = pictureAtIndexPath(indexPath: indexPath)
        guard let imageURL = URL(string: picture.imageUrl) else { return cell}
        cell.imageView.sd_setImage(with: imageURL, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: indexPath)
    }
}

extension ViewController:DetailViewControllerDelegate {
    
    func increaseCurrentPage() {
        currentPage += 1
    }
    func getPhotos(completionHandler: @escaping (Result<FeatureModel>) -> Void){
        APIManager.shared.getPhotos(currentPage: currentPage) { (result) in
            switch result{
            case .Success(let feature):
                self.pictures += feature.photos!
                self.collectionView.reloadData()
            case .Failure(let error):
                print(error)
            }
            completionHandler(result)
        }
    }

    func getNumberOfPictures() -> Int{
        return pictures.count
    }
    
    func pictureAtIndexPath(indexPath: IndexPath) -> Picture{
        return pictures[indexPath.row]
    }

    func scrollToIndexPath(_ indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
    }
}



