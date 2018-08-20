//
//  GameSetupViewController.swift
//  Spaccaquindici
//
//  Created by Giovi on 31/05/2018.
//  Copyright © 2018 Unibo App Mobili. All rights reserved.
//

import UIKit
import YPImagePicker
import Photos

class GameSetupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var boardLayoutSegmented: UISegmentedControl!
    
    var images = [#imageLiteral(resourceName: "fedora"), #imageLiteral(resourceName: "unibo"), #imageLiteral(resourceName: "smile") ]
    private var boardSize = 4
    @IBOutlet weak var imageUIPicker: UIPickerView!
    var rotationAngle: CGFloat!
    let width:CGFloat = 190
    let height:CGFloat = 190
    
    @IBAction func addImage(_ sender: UIBarButtonItem) {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = true
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .cappedTo(size: 480)
        config.usesFrontCamera = true
        config.showsFilters = true
        config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
                          YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "Spaccaquindici"
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.showsCrop = .rectangle(ratio: (1/1))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)

        // Once the user chose an image, add it to the picker
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.images.append(photo.image)
                self.imageUIPicker.reloadAllComponents()
                self.imageUIPicker.selectRow( (self.images.count*150) - 1 + self.images.count, inComponent: 0, animated: true)
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    // returns the number of columns of the picker
    // each column is a new picker eg: return 2 -> |pick|pick|
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of elements to choose from, within a single component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count*300
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return height + 10
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return width + 10
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        let imageToChoose = UIImageView()
        imageToChoose.frame = CGRect(x: 0, y: 0, width: width, height: height)
        imageToChoose.image = images[row % images.count]
        
        // rotate the image
        imageToChoose.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
        
        view.addSubview(imageToChoose)
        
        return view
    }
    
    func FetchAlbumPhotos() -> Void
    {
        let albumName = "Spaccaquindici"
        var assetCollection = PHAssetCollection()
        var photoAssets = PHFetchResult<AnyObject>()
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _:AnyObject = collection.firstObject {
            // if album is found
            assetCollection = collection.firstObject!
        } else {
            return
        }

        photoAssets = PHAsset.fetchAssets(in: assetCollection, options: nil) as! PHFetchResult<AnyObject>
        let imageManager = PHCachingImageManager()
        
        photoAssets.enumerateObjects{(object: AnyObject!,
            count: Int,
            stop: UnsafeMutablePointer<ObjCBool>) in
            
            if object is PHAsset{
                let asset = object as! PHAsset
                
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true

                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: {
                    (image, info) -> Void in
                        self.images.append(image!)
                })

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load images from 'Spaccaquindici' folder in the photo library
        FetchAlbumPhotos()
        self.imageUIPicker.reloadAllComponents()
        
        // Play button rounded corner
        playButton.layer.cornerRadius = 10
        
        imageUIPicker.delegate = self
        imageUIPicker.dataSource = self
        
        // rotate the pickerview, then resize the frame
        // with the old coordinates
        rotationAngle = -90 * (.pi/180)
        let oldY = imageUIPicker.frame.origin.y
        imageUIPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        imageUIPicker.frame = CGRect(x: -50, y: oldY, width: view.frame.width + 100, height: 216)

        imageUIPicker.selectRow(imageUIPicker.numberOfRows(inComponent: 0)/2-1, inComponent: 0, animated: true)
        
        self.view.addSubview(imageUIPicker)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Play Game" {
            if let gvcontroller = segue.destination as? GameViewController {
                
                // Pass the size to gameController
                switch boardLayoutSegmented.selectedSegmentIndex {
                    case 0: gvcontroller.boardSideLength = 4
                    case 1: gvcontroller.boardSideLength = 5
                    case 2: gvcontroller.boardSideLength = 6
                    default:    gvcontroller.boardSideLength = 4
                }
                
                // Pass the image to gameController
                gvcontroller.gameImage = images[(imageUIPicker.selectedRow(inComponent: 0) % images.count)]
            }
        }
    }
 

}
