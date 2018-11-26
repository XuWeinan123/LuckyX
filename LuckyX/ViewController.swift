//
//  ViewController.swift
//  LuckyX
//
//  Created by 徐炜楠 on 2018/11/18.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit
import RealmSwift

class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var number = -1
    @objc dynamic var isAvailable = true
    @objc dynamic var color = "无"
    @objc dynamic var wish👀 = "无心愿"
}
class Prize: Object{
    @objc dynamic var name = ""
    @objc dynamic var masterNumber = -1
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var 🎁s:[PrizeInEgg] = []
    var personsInEgg:[PersonInEgg] = []
    var currentPrizeIndex = -1
    var winnersNumber = 1
    var current🎁 = "无奖品"
    var current🎁Mode = "一等奖"
    /**用来保存暂存的抽奖用户名*/
    var personForNow:[Person] = []
    @IBOutlet weak var getSomeLuckyBitchsBtn: UIButton!
    @IBOutlet weak var colorPicker: UISegmentedControl!
    
    @IBOutlet weak var personCollectionViewWidthConstraint: NSLayoutConstraint!
    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        current🎁Mode = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        print(current🎁Mode)
        switch current🎁Mode {
        case "一等奖":
            print("当前在抽一等奖")
            switch2🥇()
        case "二等奖":
            print("当前在抽二等奖")
            switch2🥈()
        case "三等奖":
            print("当前在抽三等奖")
            switch2🥉()
        case "阳光普照奖":
            print("当前在抽阳光普照奖")
            switch2🎖()
        case "👑特等奖":
            print("当前在抽特等奖")
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return 🎁s.count
        }else{
            return personsInEgg.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            if indexPath.row == 🎁s.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PrizeCell
                cell.textLabel.isHidden = true
                cell.prizeImageView.isHidden = true
                cell.selectMask.image = UIImage(named: "添加按钮")
                cell.selectMask.isHidden = false
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PrizeCell
                cell.textLabel.text = "\(🎁s[indexPath.row].name) × \(🎁s[indexPath.row].number)"
                cell.prizeImageView.imageFromURL(🎁s[indexPath.row].imageUrl, placeholder: UIImage.init(named: "OPPO")!, fadeIn: true, shouldCacheImage: true) { (image) in
                }
                cell.selectMask.isHidden = !🎁s[indexPath.row].isSelectd
                return cell
            }
            //cell.selectMask.isHidden = !prizes[indexPath.row].isSelectd
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PersonCell
            let tempPerson = personsInEgg[indexPath.row]
            cell.label.text = "\(tempPerson.name)\n\(tempPerson.number)"
//            //如果是一等奖需要改变蛋黄的颜色
//            print(current🎁Mode)
//            if current🎁Mode == "一等奖"{
//                switch tempPerson.number{
//                    case 0...100:
//                        cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
//                case 101...200:
//                    cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
//                case 201...300:
//                    cell.bgView.backgroundColor = #colorLiteral(red: 0.8922079206, green: 0.8658575416, blue: 0.003233423922, alpha: 1)
//                case 301...400:
//                    cell.bgView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
//                case 401...500:
//                    cell.bgView.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
//                case 501...600:
//                    cell.bgView.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//                default:
//                    break
//                }
//            }else{
                cell.bgView.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//            }
            cell.unsmash()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            if indexPath.row != 🎁s.count{
                for i in 0..<🎁s.count{
                    🎁s[i].isSelectd = false
                }
                🎁s[indexPath.row].isSelectd = true
                currentPrizeIndex = indexPath.row
                current🎁 = 🎁s[currentPrizeIndex].name
                collectionView.reloadData()
                print("当前所选择的\(🎁s[currentPrizeIndex].name)")
                getSomeLuckyBitchs(getSomeLuckyBitchsBtn)
            }else{
                for i in 0..<(🎁s.count){
                    🎁s[i].isSelectd = false
                }
                print("添加新奖品")
            }
        }else{
            if current🎁 == "无奖品"{
                let alertController = UIAlertController.init(title: "无奖品", message: "请在下方奖品栏选择合适奖品", preferredStyle:.alert)
                let cancel = UIAlertAction.init(title: "好的", style: UIAlertAction.Style.cancel) { (action:UIAlertAction) ->() in
                    print("处理完成\(action)")
                }
                alertController.addAction(cancel);
                self.present(alertController, animated: true, completion: nil)
            }else{
            (collectionView.cellForItem(at: indexPath) as! PersonCell).smash()
            let realm = try! Realm()
            try! realm.write {
                personForNow[indexPath.row].isAvailable = false
            }
            }
        }
    }
    /**底部的奖品视图*/
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var personCollectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化奖品
        switch2🥇()
        collectionView.dataSource = self
        collectionView.delegate = self
        personCollectionView.dataSource = self
        personCollectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func colorPickerValueChanged(_ sender: UISegmentedControl) {
        getSomeLuckyBitchs(getSomeLuckyBitchsBtn)
    }
    func switch2🥇(){
        colorPicker.isHidden = false
        personCollectionView.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 200
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "网易按摩椅", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc8ypn02qj30by0byn0e.jpg",order:11))
        🎁s.append(PrizeInEgg(name: "PS4", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxh1zo6mp8j30ci0cijs0.jpg",order:12))
        🎁s.append(PrizeInEgg(name: "平衡车", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh20zbcbrj30by0by0t3.jpg",order:13))
        🎁s.append(PrizeInEgg(name: "Switch", number: 1, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxc93ga4m8j30by0byjty.jpg",order:14))
        🎁s.append(PrizeInEgg(name: "家庭影院投影仪", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxh22pv8fmj308z08zgm7.jpg",order:15))
        🎁s.append(PrizeInEgg(name: "R17", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc95vqz1ij30by0bywff.jpg",order:16))
        winnersNumber = 1
        collectionView.reloadData()
        getSomeLuckyBitchs(getSomeLuckyBitchsBtn)
        colorPicker.selectedSegmentIndex = 6
    }
    func switch2🥈(){
        colorPicker.isHidden = true
        personCollectionView.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 450
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "700元购物卡", number: 2, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxhr3x9xv3j309q09qaav.jpgpe", order: 21))
        🎁s.append(PrizeInEgg(name: "IH电饭煲", number: 2, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh3991iygj30by0by3yw.jpg", order: 22))
        🎁s.append(PrizeInEgg(name: "cherry键盘", number: 2, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxh39jiaa8j30by0byaaw.jpg", order: 23))
        🎁s.append(PrizeInEgg(name: "ofree耳机", number: 2, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxh39o5wzbj30u00u0wgi.jpg", order: 24))
        🎁s.append(PrizeInEgg(name: "蓝牙音箱", number: 2, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxh39setmxj30ci0cidi0.jpg", order: 25))
        🎁s.append(PrizeInEgg(name: "SKII套装", number: 2, imageUrl: "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2217454266,3340342297&fm=26&gp=0.jpg", order: 26))
        winnersNumber = 2
        collectionView.reloadData()
        getSomeLuckyBitchs(getSomeLuckyBitchsBtn)
        colorPicker.selectedSegmentIndex = 6
    }
    func switch2🥉(){
        colorPicker.isHidden = true
        personCollectionView.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 700
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "松下吹风机", number: 3, imageUrl: "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2217454266,3340342297&fm=26&gp=0.jpg", order: 31))
        🎁s.append(PrizeInEgg(name: "雅诗兰黛小棕瓶15ml", number: 3, imageUrl: "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2217454266,3340342297&fm=26&gp=0.jpg", order: 32))
        🎁s.append(PrizeInEgg(name: "飞利浦电动牙刷", number: 3, imageUrl: "https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2217454266,3340342297&fm=26&gp=0.jpg", order: 33))
        🎁s.append(PrizeInEgg(name: "飞利浦剃须刀", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh3tcxrb9j309q09qq39.jpg", order: 34))
        🎁s.append(PrizeInEgg(name: "300元购物卡", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh3uek0qcj309q09q3yz.jpg", order: 35))
        🎁s.append(PrizeInEgg(name: "90分行李箱", number: 3, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxh3vb58voj30by0bydgd.jpg", order: 36))
        winnersNumber = 3
        collectionView.reloadData()
        getSomeLuckyBitchs(getSomeLuckyBitchsBtn)
        colorPicker.selectedSegmentIndex = 6
    }
    func switch2🎖(){
        colorPicker.isHidden = true
        personCollectionView.isHidden = true
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "100元购物卡", number: 88, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxh3waxw10j309q09qt9b.jpg", order: 41))
        collectionView.reloadData()
        colorPicker.selectedSegmentIndex = 6
    }
    @IBAction func getSomeLuckyBitchs(_ sender: Any) {
        personForNow.removeAll()
        //如果是阳光普照奖，直接出名字
        if current🎁Mode == "阳光普照奖"{
            current🎁 = "100元购物卡"
            var sunshinePersons:[String] = []
            for i in 0..<100{
                let tempPerson = getALuckyBitchByColor(color: "全")
                sunshinePersons.append(tempPerson.name)
            }
            for sunshinePerson in sunshinePersons{
                print(sunshinePerson)
            }
        }else{
            personsInEgg.removeAll()
            for i in 0..<winnersNumber{
                let tempPerson = getALuckyBitchByColor(color: colorPicker.titleForSegment(at: colorPicker.selectedSegmentIndex)!)
                personsInEgg.append(ViewController.PersonInEgg(name: tempPerson.name, number: tempPerson.number))
            }
            personCollectionView.reloadData()
        }
        
//        //仅供观察
//        for person in personForNow{
//            print("PersonForNow:\(person.name)")
//        }
    }
    @IBAction func resetPerson(_ sender: UIButton) {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        //删除所有对象
        let realm = try! Realm()
        try! realm.write{
            realm.deleteAll()
        }
        //添加新对象
        let personNames:[String] = ["赵〇〇","赵〇一","赵〇二","赵〇三","赵〇四","赵〇五","赵〇六","赵〇七","赵〇八","赵〇九","赵一〇","赵一一","赵一二","赵一三","赵一四","赵一五","赵一六","赵一七","赵一八","赵一九","赵二〇","赵二一","赵二二","赵二三","赵二四","赵二五","赵二六","赵二七","赵二八","赵二九","赵三〇","赵三一","赵三二","赵三三","赵三四","赵三五","赵三六","赵三七","赵三八","赵三九","赵四〇","赵四一","赵四二","赵四三","赵四四","赵四五","赵四六","赵四七","赵四八","赵四九","赵五〇","赵五一","赵五二","赵五三","赵五四","赵五五","赵五六","赵五七","赵五八","赵五九","赵六〇","赵六一","赵六二","赵六三","赵六四","赵六五","赵六六","赵六七","赵六八","赵六九","赵七〇","赵七一","赵七二","赵七三","赵七四","赵七五","赵七六","赵七七","赵七八","赵七九","赵八〇","赵八一","赵八二","赵八三","赵八四","赵八五","赵八六","赵八七","赵八八","赵八九","赵九〇","赵九一","赵九二","赵九三","赵九四","赵九五","赵九六","赵九七","赵九八","赵九九","钱〇〇","钱〇一","钱〇二","钱〇三","钱〇四","钱〇五","钱〇六","钱〇七","钱〇八","钱〇九","钱一〇","钱一一","钱一二","钱一三","钱一四","钱一五","钱一六","钱一七","钱一八","钱一九","钱二〇","钱二一","钱二二","钱二三","钱二四","钱二五","钱二六","钱二七","钱二八","钱二九","钱三〇","钱三一","钱三二","钱三三","钱三四","钱三五","钱三六","钱三七","钱三八","钱三九","钱四〇","钱四一","钱四二","钱四三","钱四四","钱四五","钱四六","钱四七","钱四八","钱四九","钱五〇","钱五一","钱五二","钱五三","钱五四","钱五五","钱五六","钱五七","钱五八","钱五九","钱六〇","钱六一","钱六二","钱六三","钱六四","钱六五","钱六六","钱六七","钱六八","钱六九","钱七〇","钱七一","钱七二","钱七三","钱七四","钱七五","钱七六","钱七七","钱七八","钱七九","钱八〇","钱八一","钱八二","钱八三","钱八四","钱八五","钱八六","钱八七","钱八八","钱八九","钱九〇","钱九一","钱九二","钱九三","钱九四","钱九五","钱九六","钱九七","钱九八","钱九九","孙〇〇","孙〇一","孙〇二","孙〇三","孙〇四","孙〇五","孙〇六","孙〇七","孙〇八","孙〇九","孙一〇","孙一一","孙一二","孙一三","孙一四","孙一五","孙一六","孙一七","孙一八","孙一九","孙二〇","孙二一","孙二二","孙二三","孙二四","孙二五","孙二六","孙二七","孙二八","孙二九","孙三〇","孙三一","孙三二","孙三三","孙三四","孙三五","孙三六","孙三七","孙三八","孙三九","孙四〇","孙四一","孙四二","孙四三","孙四四","孙四五","孙四六","孙四七","孙四八","孙四九","孙五〇","孙五一","孙五二","孙五三","孙五四","孙五五","孙五六","孙五七","孙五八","孙五九","孙六〇","孙六一","孙六二","孙六三","孙六四","孙六五","孙六六","孙六七","孙六八","孙六九","孙七〇","孙七一","孙七二","孙七三","孙七四","孙七五","孙七六","孙七七","孙七八","孙七九","孙八〇","孙八一","孙八二","孙八三","孙八四","孙八五","孙八六","孙八七","孙八八","孙八九","孙九〇","孙九一","孙九二","孙九三","孙九四","孙九五","孙九六","孙九七","孙九八","孙九九","李〇〇","李〇一","李〇二","李〇三","李〇四","李〇五","李〇六","李〇七","李〇八","李〇九","李一〇","李一一","李一二","李一三","李一四","李一五","李一六","李一七","李一八","李一九","李二〇","李二一","李二二","李二三","李二四","李二五","李二六","李二七","李二八","李二九","李三〇","李三一","李三二","李三三","李三四","李三五","李三六","李三七","李三八","李三九","李四〇","李四一","李四二","李四三","李四四","李四五","李四六","李四七","李四八","李四九","李五〇","李五一","李五二","李五三","李五四","李五五","李五六","李五七","李五八","李五九","李六〇","李六一","李六二","李六三","李六四","李六五","李六六","李六七","李六八","李六九","李七〇","李七一","李七二","李七三","李七四","李七五","李七六","李七七","李七八","李七九","李八〇","李八一","李八二","李八三","李八四","李八五","李八六","李八七","李八八","李八九","李九〇","李九一","李九二","李九三","李九四","李九五","李九六","李九七","李九八","李九九"]
        for i in 0..<personNames.count{
            let personTest = Person()
            personTest.name = personNames[i]
            personTest.number = i
            personTest.isAvailable = true
            switch i{
            case 0...100:
                personTest.color = "红"
            case 101...200:
                personTest.color = "橙"
            case 201...300:
                personTest.color = "黄"
            case 301...400:
                personTest.color = "蓝"
            case 401...500:
                personTest.color = "紫"
            case 501...600:
                personTest.color = "粉"
            default:
                break
            }
            let realm = try! Realm()
            try! realm.write {
                realm.add(personTest)
            }
        }
    }
    func getALuckyBitch()->PersonInEgg {
        //获取到当前可用的用户
        let realm = try! Realm()
        var availablePerson = realm.objects(Person.self).filter("isAvailable = true")
        print("数目\(availablePerson.count)")
        if availablePerson.count>0{
            //从中抽取一个用户
            var availablePersonArray = availablePerson.sorted { (person1, person2) -> Bool in
                return arc4random() % 2 > 0
            }
            let luckyperson = availablePersonArray.removeFirst()
            let prize = Prize()
            prize.name = current🎁
            prize.masterNumber = luckyperson.number
            try! realm.write {
                personForNow.append(luckyperson)
                realm.add(prize)
            }
            print(luckyperson.name)
            return PersonInEgg(name: luckyperson.name, number: luckyperson.number)
        }else{
            return PersonInEgg(name: "没有人可以抽了", number: -1)
        }
    }
    func getALuckyBitchByColor(color:String)->PersonInEgg {
        if color == "全"{
            return getALuckyBitch()
        }
        //获取到当前可用的用户
        let realm = try! Realm()
        var availablePerson = realm.objects(Person.self).filter("isAvailable = true").filter("color = '\(color)'")
        print("数目\(availablePerson.count)")
        if availablePerson.count>0{
            //从中抽取一个用户
            var availablePersonArray = availablePerson.sorted { (person1, person2) -> Bool in
                return arc4random() % 2 > 0
            }
            let luckyperson = availablePersonArray.removeFirst()
            let prize = Prize()
            prize.name = current🎁
            prize.masterNumber = luckyperson.number
            try! realm.write {
                personForNow.append(luckyperson)
                realm.add(prize)
            }
            print(luckyperson.name)
            return PersonInEgg(name: luckyperson.name, number: luckyperson.number)
        }else{
            return PersonInEgg(name: "没有人可以抽了", number: -1)
        }
    }
    struct PrizeInEgg {
        var name = "奖品"
        var number = 0
        var imageUrl = "https://www.baidu.com/img/bd_logo1.png?qua=high&where=super"
        var isSelectd = false
        var order = 0
        init(name:String,number:Int,imageUrl:String,order:Int) {
            self.name = name
            self.number = number
            self.imageUrl = imageUrl
            self.order = order
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



////
////  ViewController.swift
////  LuckyX
////
////  Created by XuWeinan on 2018/11/16.
////  Copyright © 2018 XuWeinan. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//class Person: Object {
//    @objc dynamic var name = ""
//    @objc dynamic var number = -1
//    @objc dynamic var isAvailable = true
//}
//class Prize: Object{
//    @objc dynamic var name = ""
//    @objc dynamic var masterNumber = -1
//}
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var theRichGuy: UILabel!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let paths =  NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
//        print(paths)
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//
//    @IBAction func letMeRich(_ sender: UIButton) {
//        //获取到当前可用的用户
//        let realm = try! Realm()
//        var availablePerson = realm.objects(Person.self).filter("isAvailable = true")
//        print("数目\(availablePerson.count)")
//        if availablePerson.count>0{
//            //从中抽取一个用户
//            var availablePersonArray = availablePerson.sorted { (person1, person2) -> Bool in
//                return arc4random() % 2 > 0
//            }
//            let luckyperson = availablePersonArray.removeFirst()
//            try! realm.write {
//                luckyperson.isAvailable = false
//            }
//            theRichGuy.text = luckyperson.name
//            print(luckyperson.name)
//        }
//    }
//    @IBAction func resetPersons(_ sender: UIButton) {
//        //删除所有对象
//        let realm = try! Realm()
//        try! realm.write{
//            realm.deleteAll()
//        }
//        //添加新对象
//        let personNames:[String] = ["赵〇〇","赵〇一","赵〇二","赵〇三","赵〇四","赵〇五","赵〇六","赵〇七","赵〇八","赵〇九","赵一〇","赵一一","赵一二","赵一三","赵一四","赵一五","赵一六","赵一七","赵一八","赵一九","赵二〇","赵二一","赵二二","赵二三","赵二四","赵二五","赵二六","赵二七","赵二八","赵二九","赵三〇","赵三一","赵三二","赵三三","赵三四","赵三五","赵三六","赵三七","赵三八","赵三九","赵四〇","赵四一","赵四二","赵四三","赵四四","赵四五","赵四六","赵四七","赵四八","赵四九","赵五〇","赵五一","赵五二","赵五三","赵五四","赵五五","赵五六","赵五七","赵五八","赵五九","赵六〇","赵六一","赵六二","赵六三","赵六四","赵六五","赵六六","赵六七","赵六八","赵六九","赵七〇","赵七一","赵七二","赵七三","赵七四","赵七五","赵七六","赵七七","赵七八","赵七九","赵八〇","赵八一","赵八二","赵八三","赵八四","赵八五","赵八六","赵八七","赵八八","赵八九","赵九〇","赵九一","赵九二","赵九三","赵九四","赵九五","赵九六","赵九七","赵九八","赵九九","钱〇〇","钱〇一","钱〇二","钱〇三","钱〇四","钱〇五","钱〇六","钱〇七","钱〇八","钱〇九","钱一〇","钱一一","钱一二","钱一三","钱一四","钱一五","钱一六","钱一七","钱一八","钱一九","钱二〇","钱二一","钱二二","钱二三","钱二四","钱二五","钱二六","钱二七","钱二八","钱二九","钱三〇","钱三一","钱三二","钱三三","钱三四","钱三五","钱三六","钱三七","钱三八","钱三九","钱四〇","钱四一","钱四二","钱四三","钱四四","钱四五","钱四六","钱四七","钱四八","钱四九","钱五〇","钱五一","钱五二","钱五三","钱五四","钱五五","钱五六","钱五七","钱五八","钱五九","钱六〇","钱六一","钱六二","钱六三","钱六四","钱六五","钱六六","钱六七","钱六八","钱六九","钱七〇","钱七一","钱七二","钱七三","钱七四","钱七五","钱七六","钱七七","钱七八","钱七九","钱八〇","钱八一","钱八二","钱八三","钱八四","钱八五","钱八六","钱八七","钱八八","钱八九","钱九〇","钱九一","钱九二","钱九三","钱九四","钱九五","钱九六","钱九七","钱九八","钱九九","孙〇〇","孙〇一","孙〇二","孙〇三","孙〇四","孙〇五","孙〇六","孙〇七","孙〇八","孙〇九","孙一〇","孙一一","孙一二","孙一三","孙一四","孙一五","孙一六","孙一七","孙一八","孙一九","孙二〇","孙二一","孙二二","孙二三","孙二四","孙二五","孙二六","孙二七","孙二八","孙二九","孙三〇","孙三一","孙三二","孙三三","孙三四","孙三五","孙三六","孙三七","孙三八","孙三九","孙四〇","孙四一","孙四二","孙四三","孙四四","孙四五","孙四六","孙四七","孙四八","孙四九","孙五〇","孙五一","孙五二","孙五三","孙五四","孙五五","孙五六","孙五七","孙五八","孙五九","孙六〇","孙六一","孙六二","孙六三","孙六四","孙六五","孙六六","孙六七","孙六八","孙六九","孙七〇","孙七一","孙七二","孙七三","孙七四","孙七五","孙七六","孙七七","孙七八","孙七九","孙八〇","孙八一","孙八二","孙八三","孙八四","孙八五","孙八六","孙八七","孙八八","孙八九","孙九〇","孙九一","孙九二","孙九三","孙九四","孙九五","孙九六","孙九七","孙九八","孙九九","李〇〇","李〇一","李〇二","李〇三","李〇四","李〇五","李〇六","李〇七","李〇八","李〇九","李一〇","李一一","李一二","李一三","李一四","李一五","李一六","李一七","李一八","李一九","李二〇","李二一","李二二","李二三","李二四","李二五","李二六","李二七","李二八","李二九","李三〇","李三一","李三二","李三三","李三四","李三五","李三六","李三七","李三八","李三九","李四〇","李四一","李四二","李四三","李四四","李四五","李四六","李四七","李四八","李四九","李五〇","李五一","李五二","李五三","李五四","李五五","李五六","李五七","李五八","李五九","李六〇","李六一","李六二","李六三","李六四","李六五","李六六","李六七","李六八","李六九","李七〇","李七一","李七二","李七三","李七四","李七五","李七六","李七七","李七八","李七九","李八〇","李八一","李八二","李八三","李八四","李八五","李八六","李八七","李八八","李八九","李九〇","李九一","李九二","李九三","李九四","李九五","李九六","李九七","李九八","李九九"]
//        for i in 0..<personNames.count{
//            let personTest = Person()
//            personTest.name = personNames[i]
//            personTest.number = i
//            personTest.isAvailable = true
//            let realm = try! Realm()
//            try! realm.write {
//                realm.add(personTest)
//            }
//        }
//    }
//
//
//}
//
