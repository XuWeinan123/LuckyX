//
//  LotteryModeAddVC.swift
//  LuckyX
//
//  Created by 徐炜楠 on 2018/12/9.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit
import RealmSwift

class LotteryModeAddVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet var lotteryModeIconCollectionView: UICollectionView!
    @IBOutlet var lotteryModeName: UITextField!
    @IBOutlet var lotteryModeRuleCollectionView: UICollectionView!
    @IBOutlet var isRemoveWinnerBtn: UIButton!
    @IBOutlet var isLotteryFromNonwinnerBtn: UIButton!
    @IBOutlet var prizeSettingCollectionView: UICollectionView!
    var iconImages:[UIImage] = []
    var lotteryRules:[LotteryRule] = []
    var prizeSettingItems:[PrizeInSetting] = []
    var tempLotteryMode = LotteryMode()
    let photoPickerViewController:UIImagePickerController = UIImagePickerController()
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "添加新抽奖模式"
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        photoPickerViewController.sourceType = UIImagePickerController.SourceType.photoLibrary
        photoPickerViewController.delegate = self
        photoPickerViewController.allowsEditing = true
        
        prizeSettingCollectionView.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        lotteryModeIconCollectionView.delegate = self
        lotteryModeIconCollectionView.dataSource = self
        lotteryModeRuleCollectionView.delegate = self
        lotteryModeRuleCollectionView.dataSource = self
        prizeSettingCollectionView.delegate = self
        prizeSettingCollectionView.dataSource = self
        
        //初始化资源数组
        iconImages.append(UIImage(named: "抽奖小icon🌞")!)
        iconImages.append(UIImage(named: "抽奖小icon🌞")!)
        iconImages.append(UIImage(named: "抽奖小icon🌞")!)
        iconImages.append(UIImage(named: "抽奖小icon🌞")!)
        iconImages.append(UIImage(named: "抽奖小icon🌞")!)
        iconImages.append(UIImage(named: "抽奖小icon🌞")!)
        lotteryRules.append(LotteryModeAddVC.LotteryRule(name: "常规随机", background: UIImage(named: "抽奖规则选择背景")!))
        lotteryRules.append(LotteryModeAddVC.LotteryRule(name: "分类优先", background: UIImage(named: "抽奖规则选择背景")!))
        lotteryRules.append(LotteryModeAddVC.LotteryRule(name: "阳光普照", background: UIImage(named: "抽奖规则选择背景")!))
        
        //添加导航栏图标
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "添加", style: .plain, target: self, action: #selector(addNewLotteryMode))
        // Do any additional setup after loading the view.
    }
    @objc func addNewLotteryMode(){
        print("addNoewLotteryMode")
        tempLotteryMode.isRemoveWinner = isRemoveWinnerBtn.isSelected
        tempLotteryMode.isLotteryFromNonwinners = isLotteryFromNonwinnerBtn.isSelected
        tempLotteryMode.modeCreatedTime = "创建于 \(Date().description.replacingOccurrences(of: " +0000", with: ""))"
        tempLotteryMode.modeCreatedFrom = "in \(UIDevice.current.modelName)"
        let realm = try! Realm()
        try! realm.write {
            realm.add(tempLotteryMode)
        }
        //返回上级
        self.navigationController?.popViewController(animated: true)
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return iconImages.count
        }else if collectionView.tag == 1{
            return lotteryRules.count
        }else{
            return prizeSettingItems.count+1
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! LotteryModeAddIconCell
            cell.icon.image = iconImages[indexPath.row]
            cell.layer.opacity = 0.5
            return cell
        }else if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RuleCell", for: indexPath) as! LotteryModeAddRuleCell
            cell.ruleName.text = lotteryRules[indexPath.row].name
            cell.ruleBackgroud.image = lotteryRules[indexPath.row].background
            cell.layer.opacity = 0.5
            return cell
        }else{
            if indexPath.row < prizeSettingItems.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrizeSettingCell", for: indexPath) as! PrizeSettingCell
                cell.prizeImageView.image = prizeSettingItems[indexPath.row].image
                cell.nameAndNumber.text = "\(prizeSettingItems[indexPath.row].name) × \(prizeSettingItems[indexPath.row].number)"
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PrizeSettingCell", for: indexPath) as! PrizeSettingCell
                cell.prizeImageView.image = UIImage(named: "奖品设置添加奖品")
                cell.nameAndNumber.text = "添加新奖品"
                return cell
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.opacity = 1
            switch indexPath.row{
            case 0:
                tempLotteryMode.modeImageName = "抽奖小icon🌞"
            case 1:
                tempLotteryMode.modeImageName = "抽奖小icon🌞"
            case 2:
                tempLotteryMode.modeImageName = "抽奖小icon🌞"
            case 3:
                tempLotteryMode.modeImageName = "抽奖小icon🌞"
            case 4:
                tempLotteryMode.modeImageName = "抽奖小icon🌞"
            case 5:
                tempLotteryMode.modeImageName = "抽奖小icon🌞"
            default:
                tempLotteryMode.modeImageName = "抽奖小icon🌞"
                break
            }
        }else if collectionView.tag == 1{
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.opacity = 1
            tempLotteryMode.modeName = lotteryRules[indexPath.row].name
        }else{
            if indexPath.row < prizeSettingItems.count{
                
            }else{
                self.present(photoPickerViewController, animated: true, completion: nil)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0{
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.opacity = 0.5
        }else if collectionView.tag == 1{
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layer.opacity = 0.5
        }
    }
    @IBAction func isRemoveWinnerAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func isLotteryFromNonwinners(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        prizeSettingItems.append(LotteryModeAddVC.PrizeInSetting(name: "奖品", number: 1, image: selectedImage))
        prizeSettingCollectionView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    struct LotteryRule {
        var name = ""
        var background = UIImage(named: "OPPO")
        init(name:String,background:UIImage) {
            self.name = name
            self.background = background
        }
    }
    struct PrizeInSetting {
        var name = "奖品"
        var number = 0
        var image = UIImage(named: "OPPO")
        init(name:String,number:Int,image:UIImage) {
            self.name = name
            self.number = number
            self.image = image
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIDevice {
    //获取设备具体详细的型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                 return "iPod Touch 5"
        case "iPod7,1":                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":   return "iPhone 4"
        case "iPhone4,1":                return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":         return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":         return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":         return "iPhone 5s"
        case "iPhone7,2":                return "iPhone 6"
        case "iPhone7,1":                return "iPhone 6 Plus"
        case "iPhone8,1":                return "iPhone 6s"
        case "iPhone8,2":                return "iPhone 6s Plus"
        case "iPhone9,1":                return "iPhone 7 (CDMA)"
        case "iPhone9,3":                return "iPhone 7 (GSM)"
        case "iPhone9,2":                return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                return "iPhone 7 Plus (GSM)"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":      return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":      return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":      return "iPad Air"
        case "iPad5,3", "iPad5,4":           return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":      return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":      return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":      return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":           return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":           return "iPad Pro"
        case "AppleTV5,3":               return "Apple TV"
        case "i386", "x86_64":             return "Simulator"
        default:                    return identifier
        }
    }
}
