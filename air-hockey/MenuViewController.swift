//
//  MenuViewController.swift
//  air-hockey
//
//  Created by Masaya Hayashi on 2017/07/13.
//  Copyright © 2017年 Masaya Hayashi. All rights reserved.
//

import UIKit

enum Difficulty {
    case easy
    case medium
    case hard
}

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func startEasyGame(_ sender: Any) {
        moveToGame(of: .easy)
    }

    @IBAction func startMediumGame(_ sender: Any) {
        moveToGame(of: .medium)
    }

    @IBAction func startHardGame(_ sender: Any) {
        moveToGame(of: .hard)
    }

    private func moveToGame(of difficulty: Difficulty) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        nextVC.difficulty = difficulty
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
