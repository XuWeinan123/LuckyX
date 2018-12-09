//
//  LotteryModeSettingVC.swift
//  LuckyX
//
//  Created by 徐炜楠 on 2018/12/8.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit
import RealmSwift

class LotteryMode: Object {
    @objc dynamic var modeImageName = "模式默认图片"
    @objc dynamic var modeName = "模式名称"
    @objc dynamic var lotteryRule = "抽奖规则："
    @objc dynamic var isRemoveWinner = true
    @objc dynamic var isLotteryFromNonwinners = true
    @objc dynamic var modeCreatedTime = "创建于 "
    @objc dynamic var modeCreatedFrom = "来源"
    @objc dynamic var modePrizeImageData01:Data? = nil
    @objc dynamic var modePrizeImageData02:Data? = nil
    @objc dynamic var modePrizeImageData03:Data? = nil
    @objc dynamic var modePrizeImageData04:Data? = nil
    @objc dynamic var modePrizeImageData05:Data? = nil
}

class LotteryModeSettingVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    var modeItems:[LotteryMode] = []

    @IBOutlet var lotteryModeCollectionView: UICollectionView!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "抽奖模式设置"
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lotteryModeCollectionView.delegate = self
        lotteryModeCollectionView.dataSource = self
        lotteryModeCollectionView.contentInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        var lotteryMode = LotteryMode()
        lotteryMode.modeImageName = "三等奖模式"
        lotteryMode.modeName = "三等奖"
        lotteryMode.lotteryRule = "常规随机"
        lotteryMode.isRemoveWinner = true
        lotteryMode.isLotteryFromNonwinners = true
        lotteryMode.modeCreatedTime = "创建于 "
        lotteryMode.modeCreatedFrom = "in iPad"
        modeItems.append(lotteryMode)
        modeItems.append(lotteryMode)
        modeItems.append(lotteryMode)
        modeItems.append(lotteryMode)
        modeItems.append(lotteryMode)
        
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modeItems.count+1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row != modeItems.count{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LotteryModeSettingCell
        let tempItem = modeItems[indexPath.row]
        cell.modeImageView.image = UIImage(named: tempItem.modeImageName)
        cell.modeNameLabel.text = tempItem.modeName
        cell.lotteryRuleLabel.text = tempItem.lotteryRule
        cell.isRemoveWinner.isSelected = tempItem.isRemoveWinner
        cell.isLotteryFromNonwinners.isSelected = tempItem.isLotteryFromNonwinners
        cell.modeCreatedTimeLabel.text = tempItem.modeCreatedTime
        cell.modeCreatedFromLabel.text = tempItem.modeCreatedFrom
        return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddCell", for: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row < modeItems.count{
            
        }else{
            self.navigationController?.pushViewController((self.storyboard?.instantiateViewController(withIdentifier: "LotteryModeAdd"))!, animated: true)
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
