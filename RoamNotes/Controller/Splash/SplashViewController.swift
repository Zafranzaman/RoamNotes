//
//  SplashViewController.swift
//  RoamNotes
//
//  Created by Zafran Mac on 05/10/2023.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    @IBAction func letStartButtonTapped(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "StartViewController") as! StartViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

