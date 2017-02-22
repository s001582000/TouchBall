//
//  ViewController.swift
//  TouchBall
//
//  Created by 梁雅軒 on 2017/2/22.
//  Copyright © 2017年 zoaks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblScore: UILabel!
    var score = 0
    var ballCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func startGame() {
        ballCount = 0
        score = 0
        for subView in self.view.subviews{
            if subView is UIImageView {
                subView.removeFromSuperview()
            }
        }
        self.addBall(time: 1)
    }
    
    func addBall(time:TimeInterval) {
        var time = time
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { (timer) in
            time *= 0.9
            if self.ballCount > 30 {
                self.gameOver()
                
            }else{
                let random:CGFloat = CGFloat(arc4random() % 10) + 50
                let ball = Ball(frame: CGRect(x: random, y: random, width: 40, height: 40))
                ball.getScore =  {() -> Void in
                    self.score += 1
                    self.lblScore.text = "\(self.score)"
                }
                self.view.addSubview(ball)
                self.ballCount += 1
                self.addBall(time: time)
            }
        }
    }
    
    func gameOver() {
        let alert = UIAlertController(title: "你輸了", message: "嫩", preferredStyle: .alert)
        let actionAgain = UIAlertAction(title: "再一次", style: .default) { (action) in
            self.startGame()
            self.lblScore.text = "0"
        }
        alert.addAction(actionAgain)
        self.present(alert, animated: true, completion: nil)
    }

}

class Ball: UIImageView {
    typealias blockScore = () -> Void
    var getScore:blockScore?
    var xDirection:CGFloat = 1
    var yDirection:CGFloat = 1
    var speed:CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var arrImags = [UIImage]()
        self.isUserInteractionEnabled = true
        speed = CGFloat(arc4random() % 5) + 1
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchDown)))
        for i in 1...4 {
            if let image = UIImage.init(named: "ball\(i)"){
                arrImags.append(image)
            }
        }
        
        
        self.animationImages = arrImags
        self.animationDuration = 1
        self.startAnimating()
        self.xDirection = arc4random() % 2 == 0 ? 1 : -1
        self.yDirection = arc4random() % 2 == 0 ? 1 : -1
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { (timer) in
            let baseRect = UIScreen.main.bounds
            var center = self.center
            if center.x > baseRect.size.width || center.x < 0{
                self.xDirection *= -1
            }
            if center.y > baseRect.size.height || center.y < 0{
                self.yDirection *= -1
            }
            center.x += self.speed * self.xDirection
            center.y += self.speed * self.yDirection
            self.center = center
        }
    }
    
    func touchDown(sender:UITapGestureRecognizer) {
        
        getScore?()
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
