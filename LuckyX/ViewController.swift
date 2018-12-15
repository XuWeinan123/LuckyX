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
    @objc dynamic var wish = "未填写心愿"
    override static func primaryKey() -> String? {
        return "number"
    }
}
class Prize: Object{
    @objc dynamic var name = ""
    @objc dynamic var masterNumber = -1
}

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var prizes:[PrizeInEgg] = []
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
    var 🥉Colors = ["绿","红","黄","粉","蓝","紫"]
    @IBOutlet weak var getSomeLuckyBitchsBtn: UIButton!
    @IBOutlet weak var animPlaceHolderView: UIView!
    
    @IBOutlet weak var personCollectionViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sunshineBtn: UIButton!
    @IBOutlet weak var LeftBtnsView: UIView!
    @IBOutlet weak var rules: UIImageView!
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
            return prizes.count
        }else{
            print(personForNow.count)
            return personForNow.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            if indexPath.row == prizes.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PrizeCell
                cell.textLabel.isHidden = true
                cell.prizeImageView.isHidden = true
                cell.selectMask.image = UIImage(named: "添加按钮")
                cell.selectMask.isHidden = false
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PrizeCell
                cell.textLabel.text = "\(prizes[indexPath.row].name)\(prizes[indexPath.row].number == 1 ? "" : " × \(prizes[indexPath.row].number)")"
                   //
                cell.prizeImageView.imageFromURL(prizes[indexPath.row].imageUrl, placeholder: UIImage.init(named: "OPPO")!, fadeIn: true, shouldCacheImage: true) { (image) in
                }
                cell.selectMask.isHidden = !prizes[indexPath.row].isSelectd
                return cell
            }
            //cell.selectMask.isHidden = !prizes[indexPath.row].isSelectd
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PersonCell
            let tempPerson = personForNow[indexPath.row]
            var numberStr = tempPerson.number.description
            //还原字母工号
            let numberStrFirst = numberStr.removeFirst()
            switch numberStrFirst.description {
            case "6":
                numberStr = "IN\(numberStr)"
            case "7":
                numberStr = "S\(numberStr)"
            default:
                numberStr = "8\(numberStr)"
            }
            cell.label.text = "\(tempPerson.name)\n\(numberStr)"
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
        //奖品选择
        if collectionView.tag == 0{
            if indexPath.row != prizes.count{
                //选择前判断颜色是否选中
                guard current🎨 != "无" else{
                    let alertController = UIAlertController.init(title: "无颜色", message: "给个面子，请先选择合适的颜色", preferredStyle:.alert)
                    let cancel = UIAlertAction.init(title: "好的", style: UIAlertAction.Style.cancel) { (action:UIAlertAction) ->() in
                        print("处理完成\(action)")
                    }
                    alertController.addAction(cancel);
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                //调整UI
                rules.isHidden = true
                for i in 0..<prizes.count{
                    prizes[i].isSelectd = false
                }
                prizes[indexPath.row].isSelectd = true
                currentPrizeIndex = indexPath.row
                current🎁 = prizes[currentPrizeIndex].name
                collectionView.reloadData()
                print("当前所选择的\(prizes[currentPrizeIndex].name)")
                
                //抽奖
                getSomeLuckyBitchs()
                
                //播放动画，联动UI
                player.seek(to: CMTime.init(seconds: 0, preferredTimescale: CMTimeScale(1.0)))
                player.play()
                eggPersonCollectionView.alpha = 0
                UIView.animate(withDuration: 0.2, delay: 1.5, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.eggPersonCollectionView.alpha = 1
                }, completion: nil)
                sunshineBtn.alpha = 0
                UIView.animate(withDuration: 0.2, delay: 1, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.sunshineBtn.alpha = 1
                }, completion: nil)
            }else{
                for i in 0..<(prizes.count){
                    prizes[i].isSelectd = false
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
    
    @IBAction func lotteryModeSettingAction(_ sender: UIButton) {
        self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "LotteryModeSetting"))!, animated: true);
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
    @IBOutlet var bottomPrizeCollectionView: UICollectionView!
    @IBOutlet var eggPersonCollectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        switch2🥉(LeftBtnOne)
        sideBtnsSelect(LeftBtnOne)
        self.navigationController?.navigationBar.isHidden = true
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
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
        bottomPrizeCollectionView.dataSource = self
        bottomPrizeCollectionView.delegate = self
        eggPersonCollectionView.dataSource = self
        eggPersonCollectionView.delegate = self
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
                current🎨 = "粉"
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
        
        //清空底部奖品选择
        for i in 0..<prizes.count{
            prizes[i].isSelectd = false
        }
        bottomPrizeCollectionView.reloadData()
    }
    @IBAction func switch2🥇(_ sender: UIButton){
        //把右侧按钮都enable
        for btn in rightBtns{
            btn.isEnabled = true
        }
        
        current🎁Mode.text = "一等奖"
        eggPersonCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.image = UIImage(named: "一等奖 规则")
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 200
        //清空鸡蛋区域
        personsInEgg.removeAll()
        eggPersonCollectionView.reloadData()
        prizes.removeAll()
        prizes.append(PrizeInEgg(name: "网易按摩椅", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc8ypn02qj30by0byn0e.jpg",order:11))
        prizes.append(PrizeInEgg(name: "PS4", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxh1zo6mp8j30ci0cijs0.jpg",order:12))
        prizes.append(PrizeInEgg(name: "平衡车", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh20zbcbrj30by0by0t3.jpg",order:13))
        prizes.append(PrizeInEgg(name: "Switch", number: 1, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxc93ga4m8j30by0byjty.jpg",order:14))
        prizes.append(PrizeInEgg(name: "家庭影院投影仪", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxh22pv8fmj308z08zgm7.jpg",order:15))
        prizes.append(PrizeInEgg(name: "R17", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxc95vqz1ij30by0bywff.jpg",order:16))
        winnersNumber = 1
        bottomPrizeCollectionView.reloadData()
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
        eggPersonCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.image = UIImage(named: "二等奖 规则")
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 410
        //清空鸡蛋区域
        personsInEgg.removeAll()
        eggPersonCollectionView.reloadData()
        prizes.removeAll()
        prizes.append(PrizeInEgg(name: "700元购物卡", number: 2, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr69t4kquj305k05kq3g.jpg", order: 21))
        prizes.append(PrizeInEgg(name: "IH电饭煲", number: 2, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr6intxvej305k05k3z3.jpg", order: 22))
        prizes.append(PrizeInEgg(name: "cherry键盘", number: 2, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxh39jiaa8j30by0byaaw.jpg", order: 23))
        prizes.append(PrizeInEgg(name: "ofree耳机", number: 2, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxh39o5wzbj30u00u0wgi.jpg", order: 24))
        prizes.append(PrizeInEgg(name: "蓝牙音箱", number: 2, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr6n67g88j305k05kmxk.jpg", order: 25))
        prizes.append(PrizeInEgg(name: "SKII套装", number: 2, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr6ovxsbwj305k05kt9c.jpg", order: 26))
        winnersNumber = 2
        bottomPrizeCollectionView.reloadData()
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
        eggPersonCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.image = UIImage(named: "三等奖 规则")
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 620
        //清空鸡蛋区域
        personForNow.removeAll()
        eggPersonCollectionView.reloadData()
        prizes.removeAll()
        prizes.append(PrizeInEgg(name: "松下吹风机", number: 3, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr5fmz0fnj305k05k3z8.jpg", order: 31))
        prizes.append(PrizeInEgg(name: "雅诗兰黛", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr5nv915qj305k05kq3i.jpg", order: 32))
        prizes.append(PrizeInEgg(name: "飞利浦电动牙刷", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr5n7tdzwj305k05kmxl.jpg", order: 33))
        prizes.append(PrizeInEgg(name: "飞利浦剃须刀", number: 3, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxr5q4zf32j305k05kdgh.jpg", order: 34))
        prizes.append(PrizeInEgg(name: "300元购物卡", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxh3uek0qcj309q09q3yz.jpg", order: 35))
        prizes.append(PrizeInEgg(name: "行李箱", number: 3, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr5xl3odbj305k05k3yz.jpg", order: 36))
        winnersNumber = 3
        bottomPrizeCollectionView.reloadData()
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
        eggPersonCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        //rules.text = "特等奖的规则"
        rules.image = UIImage(named: "特等奖 规则")
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 200
        //清空鸡蛋区域
        personForNow.removeAll()
        eggPersonCollectionView.reloadData()
        prizes.removeAll()
        prizes.append(PrizeInEgg(name: "心愿大奖", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxq74geo70j305k05kq33.jpg", order: 101))
        winnersNumber = 1
        bottomPrizeCollectionView.reloadData()
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
        eggPersonCollectionView.isHidden = true
        sunshineBtn.isHidden = false
        rules.image = UIImage(named: "阳光普照奖 规则")
        rules.isHidden = false
        current🎁 = "无奖品"
        sunshineBtn.alpha = 0
        
        personForNow.removeAll()
        prizes.append(PrizeInEgg(name: "100元购物卡", number: 88, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxh3waxw10j309q09qt9b.jpg", order: 41))
        winnersNumber = 88
        bottomPrizeCollectionView.reloadData()
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
        eggPersonCollectionView.isHidden = false
        sunshineBtn.isHidden = true
        rules.image = UIImage(named: "红包雨 规则")
        rules.isHidden = false
        current🎁 = "无奖品"
        personCollectionViewWidthConstraint.constant = 410
        //清空鸡蛋区域
        personForNow.removeAll()
        eggPersonCollectionView.reloadData()
        prizes.removeAll()
        prizes.append(PrizeInEgg(name: "陈景远的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2oyhqqrj305k05kaa2.jpg", order: 51))
        prizes.append(PrizeInEgg(name: "卓世杰的红包", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxp2ov4zdwj305k05kt8p.jpg", order: 52))
        prizes.append(PrizeInEgg(name: "谢琴的红包", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxp2opdlkej305k05kweh.jpg", order: 53))
        prizes.append(PrizeInEgg(name: "张广伟的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2okejv5j305k05kweh.jpg", order: 54))
        prizes.append(PrizeInEgg(name: "陈希的红包", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxp2ofcc13j305k05kq2x.jpg", order: 55))
        prizes.append(PrizeInEgg(name: "吴振宇的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2o91jndj305k05k0sq.jpg", order: 56))
        prizes.append(PrizeInEgg(name: "黄轶轩的红包", number: 1, imageUrl: "https://ws4.sinaimg.cn/large/006tNbRwgy1fxp2j2guctj305k05kdfu.jpg", order: 57))
        prizes.append(PrizeInEgg(name: "张玉的红包", number: 1, imageUrl: "https://ws1.sinaimg.cn/large/006tNbRwgy1fxp2iyndr9j305k05kgll.jpg", order: 58))
        prizes.append(PrizeInEgg(name: "刘齐虎的红包", number: 1, imageUrl: "https://ws3.sinaimg.cn/large/006tNbRwgy1fxp2iuwt7gj305k05k74a.jpg", order: 59))
        prizes.append(PrizeInEgg(name: "谢松涛的红包", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr7dwdbdgj305k05kq2y.jpg", order: 60))
        prizes.append(PrizeInEgg(name: "Andy的红包", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr7dwdbdgj305k05kq2y.jpg", order: 61))
        prizes.append(PrizeInEgg(name: "姜晗的红包", number: 1, imageUrl: "https://ws2.sinaimg.cn/large/006tNbRwgy1fxr7dwdbdgj305k05kq2y.jpg", order: 62))
        winnersNumber = 2
        bottomPrizeCollectionView.reloadData()
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
            //移除金蛋数组
            personForNow.removeAll()
            //按条件抽取中奖用户
            //-选定随机颜色
            if 🥉Colors.count <= 0{
                🥉Colors = ["绿","红","黄","粉","蓝","紫"]
            }
            🥉Colors.sort { (str1, str2) -> Bool in
                return arc4random() % 2 > 0
            }
            var tempColor = 🥉Colors.removeFirst()
            //按条件抽取中奖用户
            var resultPersons = newGetSomeLuckyBitchsByColor(number: 3, color: tempColor)
            //放入金蛋数组
            for resultPerson in resultPersons{
                personForNow.append(resultPerson)
            }
            eggPersonCollectionView.reloadData()
            
//
//            personsInEgg.removeAll()
//            //获取颜色
//            var tempColor = "全"
//            if 🥉Colors.count <= 0{
//                🥉Colors = ["绿","红","黄","粉","蓝","紫"]
//            }
//            tempColor = 🥉Colors.removeFirst()
//            for _ in 0..<winnersNumber{
//                let tempPerson = getALuckyBitchByColor(color: tempColor)
//                personsInEgg.append(ViewController.PersonInEgg(name: tempPerson.name, number: tempPerson.number,color:tempPerson.color))
//            }
//            //抽完统统恢复可用状态
//            for person in personForNow{
//                try! realm.write {
//                    person.isAvailable = true
//                }
//            }
//            eggPersonCollectionView.reloadData()
        //剩下一二等奖
        }else{
            personsInEgg.removeAll()
            for _ in 0..<winnersNumber{
                let tempPerson = getALuckyBitchByColor(color: current🎨)
                personsInEgg.append(ViewController.PersonInEgg(name: tempPerson.name, number: tempPerson.number,color:tempPerson.color))
            }
            eggPersonCollectionView.reloadData()
            //抽完统统恢复可用状态
            for person in personForNow{
                try! realm.write {
                    person.isAvailable = true
                }
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
    
    /**直接访问数据库抽取一个数据实例，不做其他处理*/
    func newGetALuckyBitch()->Person{
        //获取到当前可用的用户
        let realm = try! Realm()
        let availablePerson = realm.objects(Person.self).filter("isAvailable = true")
        guard availablePerson.count > 0 else{
            let tempPerson = Person()
            tempPerson.name = "没有人可以抽了"
            tempPerson.number = 10000000
            return tempPerson
        }
        var availablePersonArray = availablePerson.sorted { (person1, person2) -> Bool in
            return arc4random() % 2 > 0
        }
        let luckyperson = availablePersonArray.removeFirst()
        return luckyperson
    }
    /**直接访问数据库抽取一个指定颜色的数据实例，不做其他处理*/
    func newGetALuckyBitchByColor(color:String)->Person{
        //获取到当前可用的用户
        let realm = try! Realm()
        let availablePerson = realm.objects(Person.self).filter("isAvailable = true AND color = '\(color)'")
        guard availablePerson.count > 0 else{
            let tempPerson = Person()
            tempPerson.name = "没有人可以抽了"
            tempPerson.number = 10000000
            return tempPerson
        }
        var availablePersonArray = availablePerson.sorted { (person1, person2) -> Bool in
            return arc4random() % 2 > 0
        }
        let luckyperson = availablePersonArray.removeFirst()
        return luckyperson
    }
    /**直接访问数据库抽取number个数据实例，不做其他处理*/
    func newGetSomeLuckyBitchs(number:Int)->[Person]{
        let realm = try! Realm()
        var returnPersons:[Person] = []
        for _ in 0..<number{
            let tempPerson = newGetALuckyBitch()
            try! realm.write {
                tempPerson.isAvailable = false
            }
            returnPersons.append(tempPerson)
        }
        for person in returnPersons{
            try! realm.write {
                person.isAvailable = true
            }
        }
        return returnPersons
    }
    /**直接访问数据库依据颜色抽取number个数据实例，不做其他处理*/
    func newGetSomeLuckyBitchsByColor(number:Int,color:String)->[Person]{
        let realm = try! Realm()
        var returnPersons:[Person] = []
        for _ in 0..<number{
            let tempPerson = newGetALuckyBitchByColor(color: color)
            try! realm.write {
                tempPerson.isAvailable = false
            }
            returnPersons.append(tempPerson)
        }
        for person in returnPersons{
            try! realm.write {
                person.isAvailable = true
            }
        }
        return returnPersons
    }
    /**直接访问数据库抽取一个有心愿的数据实例，不做其他处理*/
    func newGetALuckyBitchHasWish()->Person{
        //获取到当前可用的用户
        let realm = try! Realm()
        let availablePerson = realm.objects(Person.self).filter("isAvailable = true AND wish != '未填写心愿'")
        guard availablePerson.count > 0 else{
            let tempPerson = Person()
            tempPerson.name = "没有人可以抽了"
            tempPerson.number = 10000000
            return tempPerson
        }
        var availablePersonArray = availablePerson.sorted { (person1, person2) -> Bool in
            return arc4random() % 2 > 0
        }
        let luckyperson = availablePersonArray.removeFirst()
        return luckyperson
    }
    func getALuckyBitchByColor(color:String)->PersonInEgg {
        if color == "全"{
            return getALuckyBitch()
        }
        //获取到当前可用的用户
        let realm = try! Realm()
        let availablePerson = realm.objects(Person.self).filter("isAvailable = true").filter("color = '\(color)'")
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
        let optionMenu = UIAlertController(title: nil,message: "有人不想要这个奖，再抽一个人", preferredStyle:.actionSheet)
        
        let getPictureFromLibraryButton = UIAlertAction(title: "开始抽取", style:.destructive){ (action) in
            let tempPerson = self.newGetALuckyBitch()
            let cheatingResultAlert = UIAlertController(title: "随机抽取", message: "\(tempPerson.color)色方阵的\(tempPerson.name)\(tempPerson.name == "周璇" ? "(\(tempPerson.number))" : "")中奖了！", preferredStyle: .alert)
            let cheatingResultAlertCancel = UIAlertAction(title: "这个不要", style: .cancel, handler: nil)
            let cheatingResultAlertSure = UIAlertAction(title: "就这个", style: .default, handler: { (action) in
                //新建一个奖品条目
                var tempPersonTempPrize = Prize()
                tempPersonTempPrize.masterNumber = tempPerson.number
                tempPersonTempPrize.name = "\(self.current🎁Mode.text!)中临时抽出的奖"
                let realm = try! Realm()
                try! realm.write {
                    tempPerson.isAvailable = false
                    realm.add(tempPersonTempPrize)
                }
            })
            cheatingResultAlert.addAction(cheatingResultAlertCancel)
            cheatingResultAlert.addAction(cheatingResultAlertSure)
            self.present(cheatingResultAlert, animated: true, completion: nil)
        }
        
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
