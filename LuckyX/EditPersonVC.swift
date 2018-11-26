//
//  EditPersonVC.swift
//  LuckyX
//
//  Created by XuWeinan on 2018/11/26.
//  Copyright © 2018 徐炜楠. All rights reserved.
//

import UIKit
import RealmSwift

class EditPersonVC: UIViewController,UITextViewDelegate {
    let realm = try! Realm()
    var editPersons:[Person] = []

    @IBOutlet weak var textViewInput: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewInput.delegate = self
        // Do any additional setup after loading the view.
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
                tempPerson.number = Int(eachItems[2].description) ?? -1
                tempPerson.wish👀 = eachItems[3].description
                editPersons.append(tempPerson)
            }
        }
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
