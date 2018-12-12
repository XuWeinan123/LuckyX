//
//  EditPersonVC.swift
//  LuckyX
//
//  Created by XuWeinan on 2018/11/26.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit
import RealmSwift

class EditPersonVC: UIViewController,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource {
    let realm = try! Realm()
    var editPersons:[Person] = []

    @IBOutlet weak var textViewInput: UITextView!
    @IBOutlet weak var editPersonTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewInput.delegate = self
        editPersonTableView.delegate = self
        editPersonTableView.dataSource = self
        //还原退出状态
        let userdefaultEditPerson = UserDefaults.standard.string(forKey: "UserDefaultEditPerson")
        if userdefaultEditPerson != nil{
            textViewInput.text = userdefaultEditPerson
            textViewDidChange(textViewInput)
        }
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editPersons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! EditPersonCell
        let tempPerson = editPersons[indexPath.row]
        switch tempPerson.color {
        case "红":
            cell.color.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.2039215686, blue: 0.2784313725, alpha: 1)
        case "绿":
            cell.color.backgroundColor = #colorLiteral(red: 0.1647058824, green: 0.8196078431, blue: 0.5058823529, alpha: 1)
        case "黄":
            cell.color.backgroundColor = #colorLiteral(red: 1, green: 0.7960784314, blue: 0.1058823529, alpha: 1)
        case "蓝":
            cell.color.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        case "紫":
            cell.color.backgroundColor = #colorLiteral(red: 0.4705882353, green: 0.1568627451, blue: 1, alpha: 1)
        case "粉":
            cell.color.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.4784313725, blue: 0.5098039216, alpha: 1)
        default:
            cell.color.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        cell.name.text = tempPerson.name
        var numberStr = tempPerson.number.description
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
        cell.wish.text = tempPerson.wish👀
        return cell
    }
    func textViewDidChange(_ textView: UITextView) {
        editPersons.removeAll()
        let eachPersons = textView.text?.split(separator: "\r")
        for eachPerson in eachPersons!{
            let eachItems = eachPerson.split(separator: " ")
//            for eachItem in eachItems{
//                print(eachItem)
//            }
            print(eachItems)
            if eachItems.count < 4{
                let tempPerson = Person()
                tempPerson.name = "输入错误"
                tempPerson.color = "❌"
                tempPerson.number = -1
                tempPerson.wish👀 = "输入错误"
                editPersons.append(tempPerson)
            }else{
                let tempPerson = Person()
                tempPerson.name = eachItems[0].description
                tempPerson.color = eachItems[1].description
                tempPerson.number = Int(eachItems[2].description.replacingOccurrences(of: "S", with: "7").replacingOccurrences(of: "IN", with: "6")) ?? -1
                tempPerson.wish👀 = eachItems[3].description
                editPersons.append(tempPerson)
            }
        }
        editPersonTableView.reloadData()
    }
    @IBAction func finishEdited(_ sender: UIBarButtonItem) {
        visitPersons()
        //添加至列表
        try! realm.write {
            realm.deleteAll()
        }
        for editPerson in editPersons{
            try! realm.write {
                realm.add(editPerson)
            }
        }
        //保存默认值
        UserDefaults.standard.set(textViewInput.text, forKey: "UserDefaultEditPerson")
        self.navigationController?.viewControllers[0]
        self.navigationController?.popToRootViewController(animated: true)
    }
    func visitPersons(){
        for editPerson in editPersons{
            print("人员的名字\(editPerson.name)")
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
