//
//  ImageSelecterCollectionViewController.swift
//  CaseAssistant
//
//  Created by HerrKaefer on 15/6/3.
//  Copyright (c) 2015年 HerrKaefer. All rights reserved.
//

import UIKit


class ImageSelecterCollectionViewController: UICollectionViewController {

    var patient: Patient?

    var imageItems = [[UIImage]]()
    var selectionStatusOfImages = [[Bool]]()
    var numberOfSelectedImages: Int = 0
    
    let imageForSelected = UIImage(named: "checkmark-24")
    let imageForUnselected: UIImage? = nil//UIImage(named: "checkmark-blank-24")
    
    // called by presenting VC
    func setInitialSelectionStatus(_ status: [[Bool]]) {
        selectionStatusOfImages = status
        numberOfSelectedImages = 0
        for s1 in status {
            for s2 in s1 {
                if s2 == true {
                    numberOfSelectedImages += 1
                }
            }
        }
    }
    
    func loadData() {
        imageItems.removeAll()
        let records = patient!.recordsSortedAscending
        for i in 0..<records.count {
            let r = records[i]
            let pms = r.photoMemosSortedByCreationDateAscending
            imageItems.append([UIImage]())
            for j in 0..<pms.count {
                if let im = pms[j].thumbnailImage {
//                    let resizedImage =  RBResizeImage(im, CGSizeMake(collectionView!.frame.width*0.5, CGFloat.max))
                    imageItems[imageItems.count-1].append(im)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageItems.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageItems[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageSelecterCell", for: indexPath) as! ImageSelecterCollectionViewCell
        cell.photoImageView.image = imageItems[indexPath.section][indexPath.row]
        if selectionStatusOfImages[indexPath.section][indexPath.row] == true {
            cell.statusImageView.image = imageForSelected
        } else {
            cell.statusImageView.image = imageForUnselected
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    // section header and footer view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "imageSelectorHeaderCell", for: indexPath) as! ImageSelecterCollectionHeaderView
            let title = DateFormatter.localizedString(from: patient!.records[indexPath.section].date, dateStyle: .long, timeStyle: .none)
            headerView.titleLabel.text = title
            
            return headerView
        }
        
        else //if (kind == UICollectionElementKindSectionFooter) // no footer view in this app
        {
            return UICollectionReusableView()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageSelecterCollectionViewCell
        print("select \(indexPath.section), \(indexPath.row)")
        if selectionStatusOfImages[indexPath.section][indexPath.row] == true {
            selectionStatusOfImages[indexPath.section][indexPath.row] = false
            numberOfSelectedImages -= 1
            cell.statusImageView.image = imageForUnselected
        } else {
            selectionStatusOfImages[indexPath.section][indexPath.row] = true
            numberOfSelectedImages += 1
            cell.statusImageView.image = imageForSelected
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
//    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
