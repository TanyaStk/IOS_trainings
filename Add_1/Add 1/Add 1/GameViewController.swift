//
//  ViewController.swift
//  Add 1
//
//  Created by TanyaSamastr on 14.08.21.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel:UILabel?
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var numberLabel:UILabel?
    @IBOutlet weak var inputField:UITextField?
    @IBOutlet weak var reactionField:UITextField?
    @IBOutlet weak var scrollView: UIScrollView!
    
    let maxTime = 120
    
    var score = 0
    var timer:Timer?
    var seconds = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScoreLabel()
        updateNumberLabel()
        updateTimerLabel()
        
        inputFieldLayout()
        
        reactionField?.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        removeKeyboardNotifications()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func inputFieldLayout(){
        inputField?.layer.cornerRadius = 8
        inputField?.layer.masksToBounds = false
        
        inputField?.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        inputField?.layer.shadowOpacity = 0.8
        inputField?.layer.shadowRadius = 6.0
        inputField?.layer.shadowColor = UIColor.gray.cgColor
    }
    
    func updateScoreLabel() {
        scoreLabel?.text = String(score)
    }
    
    func updateNumberLabel() {
        numberLabel?.text = String.randomNumber(length: 4)
    }
    
    func updateTimerLabel() {
        let min = (seconds / 60) % 60
        let sec = seconds % 60
        
        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
    func updateReaction(answer : Bool){
        if answer {
            score += 1
            reactionField?.text = "👍"
        } else {
            score -= 1
            reactionField?.text = "👎"
        }
        
        reactionField?.isHidden = false
    }
    
    func settingTimer(time: Double) {
        if (timer != nil) {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: true) {
            timer in if self.seconds == 0 {
                self.finishGame()
            }else if self.seconds <= self.maxTime {
                self.seconds -= 1
                self.updateTimerLabel()
                self.reactionField?.isHidden = true
            }
        }
    }
    
    @IBAction func inputFieldDidChange() {
        guard let numberText = numberLabel?.text,
              let inputText = inputField?.text else{
            return
        }
        
        guard inputText.count == 4 else {
            return
        }
        
        var isCorrect = true
    
        for n in 0..<4 {
            var input = inputText.integer(at: n)
            let number = numberText.integer(at: n)
            
            if input == 0 {
                input = 10
            }
            
            if input != number + 1 {
                isCorrect = false
                break
            }
        }
        
        updateReaction(answer: isCorrect)
        updateNumberLabel()
        updateScoreLabel()
        inputField?.text = ""
        
        if timer == nil || score < 10{
            self.settingTimer(time: 1.0)
        }
        
        if score >= 10 {
            self.settingTimer(time: 0.5)
        }
    }
    
    func finishGame() {
        timer?.invalidate()
        timer = nil
        
        let alert = UIAlertController(title: "Time's Up!", message: "Your time is up! You got a score of \(score) points. Awesome!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK, start new game", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        score = 0
        seconds = self.maxTime
        reactionField?.isHidden = true
        
        updateNumberLabel()
        updateScoreLabel()
        updateTimerLabel()
    }
}
