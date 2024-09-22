//
//  HomeVC.swift
//  TeacherAssistantApp
//
//  Created by Muaaz on 24/04/2024.
//

import UIKit

class HomeVC: BaseClass {
    
    @IBOutlet weak var sideMenuNameLbl: UILabel!
    @IBOutlet weak var menuContianerVw: UIView!
    @IBOutlet weak var collVw: UICollectionView!
    @IBOutlet weak var tblVw: UITableView!
    
    var dataSource = [ "Schedule" , "Attendece" , "Setting" , "Booking"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collVw.delegate = self
        collVw.dataSource = self
        collVw.register(UINib(nibName: HomeColVwCell.id, bundle: nil), forCellWithReuseIdentifier: HomeColVwCell.id)
        
        tblVw.delegate = self
        tblVw.dataSource = self
        
    }
    @IBAction func logoutBtnPressed(_ sender: Any) {
        print(#function)
        menuContianerVw.isHidden = true
        showAlertTwoBtns(msg: AlertConstants.LogoutMsg)
    }
    
    @IBAction func sideMenuBtnPressed(_ sender: Any) {
        menuContianerVw.isHidden = false
    }
    
    @IBAction func sideMenuCrossBtnPressed(_ sender: Any) {
        menuContianerVw.isHidden = true
    }
    
}
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeColVwCell.id, for: indexPath) as! HomeColVwCell
        cell.titleLbl.text = dataSource[indexPath.row]
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
//        switch indexPath.row {
//        case 0 : pushVC(storyboard: .Home, id: TabbarVC.id)
//        case 1 : goBack()
//        case 2 : pushVC(storyboard: .Home, id: TabbarVC.id)
//        case 3 : pushVC(storyboard: .Home, id: TabbarVC.id)
//        default:
//            break
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: collVw.frame.width/2 - 5, height: collVw.frame.height/4 - 25)
        return size
    }
}
extension HomeVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTblCell.id, for: indexPath) as! SideMenuTblCell
        cell.lbl.text = dataSource[indexPath.row]
        cell.borderColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch indexPath.row {
        case 0 : pushVC(storyboard: .Home, id: TabbarVC.id)
            tblVw.reloadData()
            menuContianerVw.isHidden = true
        case 1 : pushVC(storyboard: .Home, id: TabbarVC.id)
            tblVw.reloadData()
            menuContianerVw.isHidden = true
        case 2 : pushVC(storyboard: .Home, id: TabbarVC.id)
            tblVw.reloadData()
            menuContianerVw.isHidden = true
        case 3 : pushVC(storyboard: .Home, id: TabbarVC.id)
            tblVw.reloadData()
            menuContianerVw.isHidden = true
        default:
            break
        }
    }
}
