//
//  DetailViewController.swift
//  CodingChallenge
//
//  Created by Siddhesh Mahadeshwar on 04/05/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import SDWebImage

protocol  DetailViewControllerDelegate: class{
    func getNumberOfPictures() -> Int
    func pictureAtIndexPath(indexPath: IndexPath) -> Picture
    func scrollToIndexPath(_ indexPath: IndexPath)
    func getPhotos(completionHandler: @escaping (Result<FeatureModel>) -> Void)
    func increaseCurrentPage()
}
class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    weak var delegate:DetailViewControllerDelegate?
    var selectedIndexPath:IndexPath!
    
    @IBAction func crossButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImageView.layer.cornerRadius  = userProfileImageView.frame.height/2
        userProfileImageView.layer.masksToBounds = true
        DispatchQueue.main.async {
            self.detailCollectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: false)
            self.updateBottomView(picture: self.delegate!.pictureAtIndexPath(indexPath: self.selectedIndexPath))
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.delegate!.scrollToIndexPath(self.selectedIndexPath)
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        DispatchQueue.main.async {
            self.detailCollectionView.collectionViewLayout.invalidateLayout()
            self.detailCollectionView.scrollToItem(at: self.selectedIndexPath, at: .centeredHorizontally, animated: false)
            self.updateBottomView(picture: self.delegate!.pictureAtIndexPath(indexPath: self.selectedIndexPath))
            self.userProfileImageView.layer.cornerRadius  = self.userProfileImageView.frame.height/2
            self.userProfileImageView.layer.masksToBounds = true
        }
    }
}

extension DetailViewController {
    
    func updateBottomView(picture:Picture){
        userName.text = picture.fullName
        likeCount.text = "\(picture.likesCount) people liked this photo"
        commentsCount.text = "\(picture.commentsCount) comments"
        guard let userImageString = picture.userProfilePicUrl, let userImageUrl = URL(string: userImageString) else {
            return
        }
        userProfileImageView.sd_setImage(with: userImageUrl, completed: nil)
    }
    
    func hideImageDetails(_ hidden:Bool) {
        UIView.animate(withDuration: 0.24) {
            self.bottomView.alpha = CGFloat(hidden.hashValue)
            self.topView.alpha = CGFloat(hidden.hashValue)
        }
    }
}
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row == delegate!.getNumberOfPictures() - 1 {
            delegate!.increaseCurrentPage()
            delegate!.getPhotos { (result) in
                switch result{
                case .Success( _):
                    self.detailCollectionView.reloadData()
                case .Failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate!.getNumberOfPictures();
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:DetailCollectionCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! DetailCollectionCell
        let picture = delegate!.pictureAtIndexPath(indexPath: indexPath)
        guard let imageURL = URL(string: picture.imageUrl) else { return cell}
        cell.imageView.sd_setImage(with: imageURL, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        hideImageDetails(bottomView.alpha == 1 ? false:true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentSelectedPath = detailCollectionView.indexPathsForVisibleItems[0]
        selectedIndexPath = currentSelectedPath
        delegate!.scrollToIndexPath(selectedIndexPath)
        updateBottomView(picture: delegate!.pictureAtIndexPath(indexPath: selectedIndexPath))
    }
}


