//
//  ViewController.swift
//  api
//
//  Created by Keshav Raj Kashyap on 28/01/21.
//

//delegat protocole

import UIKit
import SDWebImage

class ViewController: UIViewController, didLoadDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtField: UITextField!
    
    
    var page = 0
    var txtFiledEntry = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApiManager.shareInstance.delegate = self
       // ApiManager.shareInstance.handleApi(query: "ocean", page: 1)
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func didUpdateCollectionView() {
        self.collectionView.reloadData()
    }
    
}

// MARK:- COLLECITONVIEW METHOD

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.results.count ?? 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        DispatchQueue.main.async {
            if let imgUrl = model?.results[indexPath.item].urls.regular {
                cell.imageview.sd_setImage(with: URL(string: imgUrl), completed: nil)
            }
            
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: (collectionView.frame.size.width - 10) / 2, height: 200)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (model?.results.count ?? 5) - 1 {
            print("Index -> \(indexPath.item)")
            
            // page increase
            page += 1
            print("Page -> \(page)")
            // call api
            ApiManager.shareInstance.handleApi(query: txtFiledEntry, page: page)
            
            
            
        }
    }
    
}

// MARK:- HANDLE TEXTFIELD

extension ViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let txt = textField.text {
            print(txt)
            txtFiledEntry = txt
            model?.results = []
            self.collectionView.reloadData()
            
            // api call
            ApiManager.shareInstance.handleApi(query: txt, page: page)
            textField.endEditing(true)
        }
        return true
    }
}


