//
//  ViewController.swift
//  Sportz Cricket Team
//
//  Created by Ganesh Prasad on 30/04/21.
//  Copyright © 2021 Sportz Cricket Team. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: Properties
    var teams = [Team]()
    var customDataSource: CustomDataSource!
    var laodViewAlertViewController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        getTeamsInfo()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoader()
    }
    
    
    private func setUpView() {
        
        segmentControl.addTarget(
            self,
            action: #selector(segmentedControlValueChanged),
            for: .valueChanged
        )
    }
    
    
    private func showLoader() {
        
        DispatchQueue.main.async {
            self.laodViewAlertViewController = UIAlertController(
                title: nil,
                message: "Please wait...",
                preferredStyle: .alert
            )
            
            let loadingIndicator = UIActivityIndicatorView(
                frame: CGRect(x: 10, y: 5, width: 50, height: 50)
            )
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating()
            
            self.laodViewAlertViewController.view.addSubview(loadingIndicator)
            
            self.present(
                self.laodViewAlertViewController,
                animated: true,
                completion: nil
            )
        }
        
    }
    
    @objc private func segmentedControlValueChanged(
        _ sender: UISegmentedControl
    ) {
        DispatchQueue.main.async {
            if sender.selectedSegmentIndex == 0 {
                self.customDataSource.selectedIndex = 0
            }else {
                self.customDataSource.selectedIndex = 1
            }
        }
    }
    
    private func getTeamsInfo() {
        ApiClent.shared.get { [weak self](result) in
            
            guard let self = self else {return}
            
            switch result {
            case .success(let response):
                self.apiSuccsss(response)
                
            case .failure(let error):
                //Show alert for failure
                DispatchQueue.main.async {
                    self.laodViewAlertViewController.dismiss(
                        animated: true,
                        completion: nil
                    )
                    self.showErrorLoader(error)
                }
                
            }
        }
    }
    
    
    private func apiSuccsss(_ response: Response) {
        DispatchQueue.main.async {
            self.customDataSource = CustomDataSource(
                tableView: self.tableView,
                teams: response.teams,
                selectedIndex: 0
            )
            self.customDataSource.setUpTableView()
            self.teams = response.teams
            self.segmentControl.setTitle(response.teams.first?.shortName, forSegmentAt: 0)
            self.segmentControl.setTitle(response.teams.last?.shortName, forSegmentAt: 1)
            self.tableView.reloadData()
            self.laodViewAlertViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func showErrorLoader(_ error: APIServiceError) {
        let alert = UIAlertController(
            title: "Failure",
            message: "APi Error: \(error)"
            , preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}
