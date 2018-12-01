//
//  ViewController.swift
//  LuckyX
//
//  Created by 徐炜楠 on 2018/11/18.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit
import RealmSwift
import Lottie
import AVKit

class Person: Object {
    @objc dynamic var name = ""
    @objc dynamic var number = -1
    @objc dynamic var isAvailable = true
    @objc dynamic var color = "无"
    @objc dynamic var wish👀 = "无心愿"
    override static func primaryKey() -> String? {
        return "number"
    }
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
    @IBOutlet var current🎁Mode:UILabel!
    var current🎨 = "全"
    var player = AVPlayer()
    var playerItem = AVPlayerItem(url: URL(fileURLWithPath: Bundle.main.path(forResource: "抽颜色方阵动画", ofType: "mp4")!))
    /**用来保存暂存的抽奖用户名*/
    var personForNow:[Person] = []
    var 🥉Colors = ["绿","红","黄","青","蓝","紫"]
    @IBOutlet weak var getSomeLuckyBitchsBtn: UIButton!
    @IBOutlet weak var animPlaceHolderView: UIView!
    
    @IBOutlet weak var personCollectionViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sunshineBtn: UIButton!
    @IBOutlet weak var LeftBtnsView: UIView!
    @IBOutlet weak var rules: UITextView!
    //左侧按钮
    @IBOutlet var LeftBtnOne: UIButton!
    @IBOutlet var LeftBtnTwo: UIButton!
    @IBOutlet var LeftBtnThird: UIButton!
    @IBOutlet var LeftBtnFour: UIButton!
    @IBOutlet var LeftBtnSix: UIButton!
    @IBOutlet var LeftBtnFive: UIButton!
    @IBOutlet var LeftBtnSeven: UIButton!
    var leftBtns:[UIButton] = []
    //右侧按钮
    @IBOutlet var RightBtnOne: UIButton!
    @IBOutlet var RightBtnTwo: UIButton!
    @IBOutlet var RightBtnThird: UIButton!
    @IBOutlet var RightBtnFour: UIButton!
    @IBOutlet var RightBtnFive: UIButton!
    @IBOutlet var RightBtnSix: UIButton!
    @IBOutlet var RightBtnSeven: UIButton!
    var rightBtns:[UIButton] = []
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
                cell.textLabel.text = "\(🎁s[indexPath.row].name)\(🎁s[indexPath.row].number == 1 ? "" : " × \(🎁s[indexPath.row].number)")"
                   //
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
            if current🎁Mode.text == "三等奖"{
                cell.goldEggImage.image = UIImage(named: "\(tempPerson.color)蛋")
            }else{
                cell.goldEggImage.image = UIImage(named: "金蛋")
            }
            cell.unsmash()
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //奖品选择,选择前判断颜色是否选中
        if collectionView.tag == 0{
            if indexPath.row != 🎁s.count{
                guard current🎨 != "无" else{
                    let alertController = UIAlertController.init(title: "无颜色", message: "给个面子，请先选择合适的颜色", preferredStyle:.alert)
                    let cancel = UIAlertAction.init(title: "好的", style: UIAlertAction.Style.cancel) { (action:UIAlertAction) ->() in
                        print("处理完成\(action)")
                    }
                    alertController.addAction(cancel);
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                rules.text = "抽奖规则"
                rules.isHidden = true
                for i in 0..<🎁s.count{
                    🎁s[i].isSelectd = false
                }
                🎁s[indexPath.row].isSelectd = true
                currentPrizeIndex = indexPath.row
                current🎁 = 🎁s[currentPrizeIndex].name
                collectionView.reloadData()
                print("当前所选择的\(🎁s[currentPrizeIndex].name)")
                //播放动画
                player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
                player.play()
                getSomeLuckyBitchs()
                personCollectionView.alpha = 0
                UIView.animate(withDuration: 0.2, delay: 1.5, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.personCollectionView.alpha = 1
                }, completion: nil)
                sunshineBtn.alpha = 0
                UIView.animate(withDuration: 0.2, delay: 1, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.sunshineBtn.alpha = 1
                }, completion: nil)
            }else{
                for i in 0..<(🎁s.count){
                    🎁s[i].isSelectd = false
                }
                print("添加新奖品")
            }
        }else{
            //砸蛋
            if current🎁 == "无奖品"{
                let alertController = UIAlertController.init(title: "无奖品", message: "请在下方奖品栏选择合适奖品", preferredStyle:.alert)
                let cancel = UIAlertAction.init(title: "好的", style: UIAlertAction.Style.cancel) { (action:UIAlertAction) ->() in
                    print("处理完成\(action)")
                }
                alertController.addAction(cancel);
                self.present(alertController, animated: true, completion: nil)
                return
            }else{
                (collectionView.cellForItem(at: indexPath) as! PersonCell).smash()
                let realm = try! Realm()
                try! realm.write {
                    personForNow[indexPath.row].isAvailable = false
                }
                //写入奖品
                let prize = Prize()
                prize.name = current🎁
                prize.masterNumber = personForNow[indexPath.row].number
                try! realm.write {
                    realm.add(prize)
                }
            }
        }
    }
    
    @IBAction func sunshineBtnAction(_ sender: UIButton) {
        //类似砸蛋，不过一次性出11个
        print(personForNow.count)
        if personForNow.count>0{
            let realm = try! Realm()
            var tempBtnStr = ""
            for i in 0..<11{
                let tempPerson = personForNow.removeFirst()
                try! realm.write {
                    tempPerson.isAvailable = false
                }
                //写入奖品
                let prize = Prize()
                prize.name = current🎁
                prize.masterNumber = tempPerson.number
                try! realm.write {
                    realm.add(prize)
                }
                tempBtnStr.append("\(tempPerson.name.count == 2 ? "\(tempPerson.name.first!)　\(tempPerson.name.last!)" : tempPerson.name)(\(tempPerson.number))　")
                if i == 2 || i == 5 || i == 8{
                    tempBtnStr.append("\n\n")
                }
            }
            sender.setTitle(tempBtnStr, for: .normal)
        }else{
            sender.setTitle("抽完了", for: .normal)
        }
    }
    /**底部的奖品视图*/
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var personCollectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        switch2🥉(LeftBtnOne)
        sideBtnsSelect(LeftBtnOne)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        leftBtns = [LeftBtnOne,LeftBtnTwo,LeftBtnThird,LeftBtnFour,LeftBtnSix,LeftBtnFive]
        rightBtns = [RightBtnOne,RightBtnTwo,RightBtnThird,RightBtnFour,RightBtnFive,RightBtnSix,RightBtnSeven]
        //配置一些UI组件LWithPath: Bundle.main.path(forResource: "抽颜色方阵动画", ofType: "mp4")!)
        //创建ACplayer：负责视频播放
        player = AVPlayer.init(playerItem: playerItem)
        player.rate = 1.0//播放速度 播放前设置
        player.pause()
        //创建显示视频的图层
        let playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = self.animPlaceHolderView.bounds
        //playerLayer.position = self.animPlaceHolderView.layer.position
        //self.view.layer.addSublayer(playerLayer)
        self.animPlaceHolderView.layer.addSublayer(playerLayer)
        //初始化奖品
        collectionView.dataSource = self
        collectionView.delegate = self
        personCollectionView.dataSource = self
        personCollectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func sideBtnsSelect(_ sender: UIButton?) {
        //如果传进来一个空值，那么说明要清空右侧的颜色按钮
        if sender == nil{
            for btn in rightBtns{
                btn.isSelected = false
            }
            current🎨 = "无"
            return
        }
        
        
        if sender!.tag <= 0{
            for btn in leftBtns{
                btn.isSelected = false
            }
        }else if sender!.tag >= 1{
            for btn in rightBtns{
                btn.isSelected = false
            }
            switch sender!.tag {
            case 1:
                current🎨 = "绿"
            case 2:
                current🎨 = "红"
            case 3:
                current🎨 = "黄"
            case 4:
                current🎨 = "青"
            case 5:
                current🎨 = "蓝"
            case 6:
                current🎨 = "紫"
            case 7:
                current🎨 = "全"
            default:
                break
            }
        }
        sender!.isSelected = true
    }
    @IBAction func switch2🥇(_ sender: UIButton){
        //把右侧按钮都enable
        for btn in rightBtns{
            btn.isEnabled = true
        }
        
        current🎁Mode.text = "一等奖"
        personCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.text = "一等奖的规则"
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 200
        //清空鸡蛋区域
        personsInEgg.removeAll()
        personCollectionView.reloadData()
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "网易按摩椅", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc8ypn02qj30by0byn0e.jpg",order:11))
        🎁s.append(PrizeInEgg(name: "PS4", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxh1zo6mp8j30ci0cijs0.jpg",order:12))
        🎁s.append(PrizeInEgg(name: "平衡车", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh20zbcbrj30by0by0t3.jpg",order:13))
        🎁s.append(PrizeInEgg(name: "Switch", number: 1, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxc93ga4m8j30by0byjty.jpg",order:14))
        🎁s.append(PrizeInEgg(name: "家庭影院投影仪", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxh22pv8fmj308z08zgm7.jpg",order:15))
        🎁s.append(PrizeInEgg(name: "R17", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc95vqz1ij30by0bywff.jpg",order:16))
        winnersNumber = 1
        collectionView.reloadData()
        sideBtnsSelect(nil)
        //调整动画时间戳
        player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
    }
    @IBAction func switch2🥈(_ sender: UIButton){
        //把右侧按钮都enable
        for btn in rightBtns{
            btn.isEnabled = true
        }
        
        current🎁Mode.text = "二等奖"
        personCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.text = "二等奖的规则"
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 410
        //清空鸡蛋区域
        personsInEgg.removeAll()
        personCollectionView.reloadData()
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "700元购物卡", number: 2, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr69t4kquj305k05kq3g.jpg", order: 21))
        🎁s.append(PrizeInEgg(name: "IH电饭煲", number: 2, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr6intxvej305k05k3z3.jpg", order: 22))
        🎁s.append(PrizeInEgg(name: "cherry键盘", number: 2, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxh39jiaa8j30by0byaaw.jpg", order: 23))
        🎁s.append(PrizeInEgg(name: "ofree耳机", number: 2, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxh39o5wzbj30u00u0wgi.jpg", order: 24))
        🎁s.append(PrizeInEgg(name: "蓝牙音箱", number: 2, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr6n67g88j305k05kmxk.jpg", order: 25))
        🎁s.append(PrizeInEgg(name: "SKII套装", number: 2, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr6ovxsbwj305k05kt9c.jpg", order: 26))
        winnersNumber = 2
        collectionView.reloadData()
        sideBtnsSelect(nil) //传入空值，清空选择
        //调整动画时间戳
        player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
    }
    @IBAction func switch2🥉(_ sender: UIButton){
        //把右侧按钮都disable掉
        for btn in rightBtns{
            btn.isEnabled = false
        }
        
        current🎁Mode.text = "三等奖"
        personCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.text = "三等奖的规则"
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 620
        //清空鸡蛋区域
        personsInEgg.removeAll()
        personCollectionView.reloadData()
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "松下吹风机", number: 3, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr5fmz0fnj305k05k3z8.jpg", order: 31))
        🎁s.append(PrizeInEgg(name: "雅诗兰黛", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr5nv915qj305k05kq3i.jpg", order: 32))
        🎁s.append(PrizeInEgg(name: "飞利浦电动牙刷", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr5n7tdzwj305k05kmxl.jpg", order: 33))
        🎁s.append(PrizeInEgg(name: "飞利浦剃须刀", number: 3, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr5q4zf32j305k05kdgh.jpg", order: 34))
        🎁s.append(PrizeInEgg(name: "300元购物卡", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh3uek0qcj309q09q3yz.jpg", order: 35))
        🎁s.append(PrizeInEgg(name: "行李箱", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr5xl3odbj305k05k3yz.jpg", order: 36))
        winnersNumber = 3
        collectionView.reloadData()
        sideBtnsSelect(RightBtnSeven)
        //调整动画时间戳x
        player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
    }
    @IBAction func switch2💥(_ sender: UIButton) {
        //把右侧按钮都enable
        for btn in rightBtns{
            btn.isEnabled = true
        }
        
        current🎁Mode.text = "特等奖"
        personCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.text = "特等奖的规则"
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 200
        //清空鸡蛋区域
        personsInEgg.removeAll()
        personCollectionView.reloadData()
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "Andy帮你实现心愿", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxq74geo70j305k05kq33.jpg", order: 101))
        winnersNumber = 1
        collectionView.reloadData()
        sideBtnsSelect(nil) //传入空值，清空选择
        //调整动画时间戳
        player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
    }
    @IBAction func switch2🌞(_ sender: UIButton){
        //把右侧按钮都disable
        for btn in rightBtns{
            btn.isEnabled = false
        }
        
        current🎁Mode.text = "阳光普照奖"
        personCollectionView.isHidden = true
        sunshineBtn.isHidden = false
        rules.text = "阳光普照等奖的规则"
        rules.isHidden = false
        current🎁 = "无奖品"
        sunshineBtn.alpha = 0
        
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "100元购物卡", number: 88, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxh3waxw10j309q09qt9b.jpg", order: 41))
        winnersNumber = 88
        collectionView.reloadData()
        sideBtnsSelect(RightBtnSeven)
        //调整动画时间戳
        player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
        
        sunshineBtn.setTitle("开始抽奖", for: .normal)
    }
    @IBAction func switch2🌧(_ sender: UIButton){
        //把右侧按钮都enable
        for btn in rightBtns{
            btn.isEnabled = true
        }
        
        current🎁Mode.text = "红包雨"
        personCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.text = "红包雨的规则"
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 410
        //清空鸡蛋区域
        personsInEgg.removeAll()
        personCollectionView.reloadData()
        🎁s.removeAll()
        🎁s.append(PrizeInEgg(name: "陈景远的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2oyhqqrj305k05kaa2.jpg", order: 51))
        🎁s.append(PrizeInEgg(name: "卓世杰的红包", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxp2ov4zdwj305k05kt8p.jpg", order: 52))
        🎁s.append(PrizeInEgg(name: "谢琴的红包", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxp2opdlkej305k05kweh.jpg", order: 53))
        🎁s.append(PrizeInEgg(name: "张广伟的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2okejv5j305k05kweh.jpg", order: 54))
        🎁s.append(PrizeInEgg(name: "陈希的红包", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxp2ofcc13j305k05kq2x.jpg", order: 55))
        🎁s.append(PrizeInEgg(name: "吴振宇的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2o91jndj305k05k0sq.jpg", order: 56))
        🎁s.append(PrizeInEgg(name: "黄轶轩的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2j2guctj305k05kdfu.jpg", order: 57))
        🎁s.append(PrizeInEgg(name: "张玉的红包", number: 1, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxp2iyndr9j305k05kgll.jpg", order: 58))
        🎁s.append(PrizeInEgg(name: "刘齐虎的红包", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxp2iuwt7gj305k05k74a.jpg", order: 59))
         🎁s.append(PrizeInEgg(name: "谢松涛的红包", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr7dwdbdgj305k05kq2y.jpg", order: 60))
        winnersNumber = 2
        collectionView.reloadData()
        sideBtnsSelect(nil)
        //调整动画时间戳
        player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
    }
    func getSomeLuckyBitchs() {
        let realm = try! Realm()

        personForNow.removeAll()
        //如果是阳光普照奖，直接出名字
        if current🎁Mode.text == "阳光普照奖"{
            personsInEgg.removeAll()
            for _ in 0..<winnersNumber{
                getALuckyBitchByColor(color: current🎨)
            }
            //抽完统统恢复可用状态
            for person in personForNow{
                print(person.name)
                try! realm.write {
                    person.isAvailable = true
                }
            }
        //如果是三等奖，需要先选颜色
        }else if current🎁Mode.text == "三等奖"{
            personsInEgg.removeAll()
            //获取颜色
            var tempColor = "全"
            if 🥉Colors.count <= 0{
                🥉Colors = ["绿","红","黄","青","蓝","紫"]
            }
            tempColor = 🥉Colors.removeFirst()
            for _ in 0..<winnersNumber{
                let tempPerson = getALuckyBitchByColor(color: tempColor)
                personsInEgg.append(ViewController.PersonInEgg(name: tempPerson.name, number: tempPerson.number,color:tempPerson.color))
            }
            //抽完统统恢复可用状态
            for person in personForNow{
                try! realm.write {
                    person.isAvailable = true
                }
            }
            personCollectionView.reloadData()
        //剩下一二等奖
        }else{
            personsInEgg.removeAll()
            for _ in 0..<winnersNumber{
                let tempPerson = getALuckyBitchByColor(color: current🎨)
                personsInEgg.append(ViewController.PersonInEgg(name: tempPerson.name, number: tempPerson.number,color:tempPerson.color))
            }
            personCollectionView.reloadData()
            //抽完统统恢复可用状态
            for person in personForNow{
                try! realm.write {
                    person.isAvailable = true
                }
            }
        }
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
            
            try! realm.write {
                personForNow.append(luckyperson)
                luckyperson.isAvailable = false
            }
            print(luckyperson.name)
            return PersonInEgg(name: luckyperson.name, number: luckyperson.number,color:luckyperson.color)
        }else{
            return PersonInEgg(name: "没有人可以抽了", number: -1,color:"全")
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
            try! realm.write {
                personForNow.append(luckyperson)
                luckyperson.isAvailable = false
            }
            print(luckyperson.name)
            return PersonInEgg(name: luckyperson.name, number: luckyperson.number,color:luckyperson.color)
        }else{
            return PersonInEgg(name: "没有人可以抽了", number: -1,color:"全")
        }
    }
    @IBAction func cheatingAction(_ sender: UIButton) {
        let optionMenu = UIAlertController(title: nil,message: "临时抽出的人是", preferredStyle:.actionSheet)
        
        let getPictureFromLibraryButton = UIAlertAction(title: "徐炜楠(80233577)", style:.destructive, handler: nil )
        
        let cancelButton = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        optionMenu.addAction(getPictureFromLibraryButton)
        
        optionMenu.addAction(cancelButton)
        
        // support iPad
        
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        optionMenu.popoverPresentationController?.sourceRect = CGRect(x: 173, y: 458, width: 0, height: 0)
        
        self.present(optionMenu, animated: true,completion: nil)
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
        var color = "全"
        init(name:String,number:Int,color:String){
            self.name = name
            self.number = number
            self.color = color
        }
    }
    
}
