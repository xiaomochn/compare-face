//
//  HomeVC.swift
//  compareface
//
//  Created by xiaomo on 16/5/5.
//  Copyright © 2016年 qiao. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let det = [["textLabel":"夫妻相","detailTextLabel":"快来测一测我们的夫妻相指数"],["textLabel":"明星相","detailTextLabel":"都说我和马云很像..."]]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate=self
        tableView.dataSource=self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  
}
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return det.count
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeVCcell")!
        if indexPath.row<det.count {
            cell.textLabel?.text=det[indexPath.row]["textLabel"]
            cell.detailTextLabel?.text=det[indexPath.row]["detailTextLabel"]
        }
        return cell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var controller:UIViewController
        switch indexPath.row {
        case 0:
             controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SingChoseViewController")
        case 1:
            controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("IamStarViewController")

        default:
             controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("IamStarViewController")
        }
        controller.title=tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
