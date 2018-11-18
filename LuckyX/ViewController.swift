//
//  ViewController.swift
//  LuckyX
//
//  Created by 徐炜楠 on 2018/11/18.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var prizes:[Prize] = []
    var personsInEgg:[PersonInEgg] = []
    var currentPrizeIndex = -1
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return prizes.count
        }else{
            return personsInEgg.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PrizeCell
            cell.textLabel.text = "\(prizes[indexPath.row].name) × \(prizes[indexPath.row].number)"
            cell.prizeImageView.imageFromURL(prizes[indexPath.row].imageUrl, placeholder: UIImage.init(named: "OPPO")!, fadeIn: true, shouldCacheImage: true) { (image) in
            }
            //cell.selectMask.isHidden = !prizes[indexPath.row].isSelectd
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PersonCell
            let tempPerson = personsInEgg[indexPath.row]
            cell.label.text = "\(tempPerson.name)\n\(tempPerson.number)"
            cell.unsmash()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            //清空
            for i in 0..<prizes.count{
                (collectionView.cellForItem(at: IndexPath(row: i, section: indexPath.section)) as! PrizeCell).selectMask.isHidden = true
            }
            (collectionView.cellForItem(at: indexPath) as! PrizeCell).selectMask.isHidden = false
            currentPrizeIndex = indexPath.row
            print("当前所选择的\(prizes[currentPrizeIndex].name)")
        }else{
            (collectionView.cellForItem(at: indexPath) as! PersonCell).smash()
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var personCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化奖品
        prizes.append(Prize(name: "网易按摩椅", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc8ypn02qj30by0byn0e.jpg"))
        prizes.append(Prize(name: "Switch", number: 1, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxc93ga4m8j30by0byjty.jpg"))
        prizes.append(Prize(name: "R17", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc95vqz1ij30by0bywff.jpg"))
        //初始化鸡蛋
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 360))
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 361))
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 362))
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 363))
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 364))
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 365))
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 366))
        personsInEgg.append(ViewController.PersonInEgg(name: "徐炜楠", number: 367))
        collectionView.dataSource = self
        collectionView.delegate = self
        personCollectionView.dataSource = self
        personCollectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    struct Prize {
        var name = "奖品"
        var number = 0
        var imageUrl = "https://www.baidu.com/img/bd_logo1.png?qua=high&where=super"
        var isSelectd = false
        init(name:String,number:Int,imageUrl:String) {
            self.name = name
            self.number = number
            self.imageUrl = imageUrl
        }
    }
    struct PersonInEgg {
        var name = "名字"
        var number = -1
        init(name:String,number:Int){
            self.name = name
            self.number = number
        }
    }

}

