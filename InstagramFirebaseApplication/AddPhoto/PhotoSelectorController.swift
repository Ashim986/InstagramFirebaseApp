//
//  PhotoController.swift
//  InstagramFirebaseApplication
//
//  Created by ashim Dahal on 3/8/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit
import Photos


class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    let headerID = "headerID"
    var images = [UIImage]()
    var selectedImage : UIImage?
    var asset = [PHAsset]()
    var photoSelectorHeader : PhotoSelectorHeader?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super .viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(PhotoSelectorCell.self , forCellWithReuseIdentifier: cellID)
        setupNavitationButtons()
        collectionView?.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
        fetchPhotos()
    }
    fileprivate func fetchPhotos() {
        
       let allPhotos = PHAsset.fetchAssets(with: .image, options: assetFetchOptions())
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option, resultHandler: { (image, info) in
                    
                    if let image = image {
                        self.images.append(image)
                        self.asset.append(asset)
                        if self.selectedImage == nil {
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    
                    }
                    
                })
            }
        }
       
    }
    
    fileprivate func assetFetchOptions() -> PHFetchOptions {
        
        let fetchOption = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOption.fetchLimit = 30
        fetchOption.sortDescriptors = [sortDescriptor]
        return fetchOption
    }
 
    fileprivate func setupNavitationButtons() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        UINavigationBar.appearance().tintColor = .black
    }
  
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func handleNext() {
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = photoSelectorHeader?.photoHeaderImageView.image 
       navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 4 - 0.75
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoSelectorCell
        cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! PhotoSelectorHeader
        self.photoSelectorHeader = header
        
        if let selectedImage = selectedImage{
            if let index =  self.images.index(of: selectedImage) {
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                imageManager.requestImage(for: asset[index], targetSize: targetSize, contentMode: .aspectFit, options: option) { (image, info) in
                    header.photoHeaderImageView.image = image
                }
            }
        }
   
        
        
        return header
    }
    
}
