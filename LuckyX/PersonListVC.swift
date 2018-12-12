//
//  PersonListVC.swift
//  LuckyX
//
//  Created by XuWeinan on 2018/11/16.
//  Copyright © 2018 XuWeinan. All rights reserved.
//

import UIKit
import RealmSwift

class PersonListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var leftPersons:[Person]?
    var rightPersons:[Person]?
    
    @IBOutlet var leftTableView: UITableView!
    @IBOutlet var rightTableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initTwoLists()
        leftTableView.delegate = self
        leftTableView.dataSource = self
        rightTableView.delegate = self
        rightTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func initTwoLists(){
        let realm = try! Realm()
        leftPersons = Array(realm.objects(Person.self).filter("isAvailable = true"))
        rightPersons = Array(realm.objects(Person.self).filter("isAvailable = false"))
        print("\(leftPersons?.count)+\(rightPersons?.count)")
        //初始化title
        self.navigationItem.title = "抽奖列表(\(leftPersons?.count.description ?? "NaN")/\(rightPersons?.count.description ?? "NaN"))"
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! LeftPersonCell
            cell.name.text = leftPersons![indexPath.row].name
            var numberStr = leftPersons![indexPath.row].number.description
            let numberStrFirst = numberStr.removeFirst()
            switch numberStrFirst.description {
            case "6":
                numberStr = "IN\(numberStr)"
            case "7":
                numberStr = "S\(numberStr)"
            default:
                numberStr = "8\(numberStr)"
            }
            cell.number.text = numberStr
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RightPersonCell
            cell.name.text = rightPersons![indexPath.row].name
            var numberStr = rightPersons![indexPath.row].number.description
            let numberStrFirst = numberStr.removeFirst()
            switch numberStrFirst.description {
            case "6":
                numberStr = "IN\(numberStr)"
            case "7":
                numberStr = "S\(numberStr)"
            default:
                numberStr = "8\(numberStr)"
            }
            cell.number.text = numberStr
            let realm = try! Realm()
            let tempNumber = rightPersons![indexPath.row].number
            let tempPrize = realm.objects(Prize.self).filter("masterNumber = \(tempNumber)").first
            cell.prize.text = tempPrize!.name
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1{
        //点击右侧列表将人物放回到未抽奖人员
        print("点击了\(rightPersons![indexPath.row].name)")
            let moveRightToLeftAlert = UIAlertController(title: "撤销中奖者", message: "撤销\(rightPersons![indexPath.row].name)的中奖纪录？\n\(rightPersons![indexPath.row].name)将会被挪到未中奖人员名单中", preferredStyle: .alert)
            let moveRightToLeftAlertCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let moveRightToLeftAlertSure = UIAlertAction(title: "确定", style: .default) { (action) in
                print("移动人物\(action)")
                let realm = try! Realm()
                try! realm.write {
                    self.rightPersons![indexPath.row].isAvailable = true
                }
                //删除奖品数据库中的条目
                var tempPrize = realm.objects(Prize.self).filter("masterNumber = \(self.rightPersons![indexPath.row].number)").first
                try! realm.write {
                    realm.delete(tempPrize!)
                }
                self.initTwoLists()
                self.leftTableView.reloadData()
                self.rightTableView.reloadData()
            }
            moveRightToLeftAlert.addAction(moveRightToLeftAlertCancel)
            moveRightToLeftAlert.addAction(moveRightToLeftAlertSure)
            self.present(moveRightToLeftAlert, animated: true, completion: nil)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView.tag == 0{
            return (leftPersons?.count)!
        }else{
            return (rightPersons?.count)!
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
