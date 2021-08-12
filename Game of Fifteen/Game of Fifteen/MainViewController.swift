//
//  ViewController.swift
//  Game of Fifteen
//
//  Created by Dmitriy Mikitenko on 22.07.2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var baseView: UIView!
    @IBOutlet private weak var moveCountLabel: UILabel!
    
    private let rightSequenceArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    private let boardSizeSide = 4
    private var arrayWithPuzzleButton = [PuzzleButton]()
    private var zeroPuzzle = PuzzleButton()
    private var counterMoves = 0
    private var sideSizePuzzle = CGFloat()
    private let startText = "Количество ходов: Игра не начата"
    private let duringGameText = "Количество ходов: "
    
    private var rightOrderPuzzleForTag = [Int : CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideSizePuzzle = baseView.frame.width/CGFloat(boardSizeSide)
        moveCountLabel.text = startText
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arrayWithPuzzleButton = createPuzzleArrayForBoard()
        createRightOrderPuzzleDictionary(withArray: arrayWithPuzzleButton)
        let shuffledSequenceArray = rightSequenceArray.shuffled()
        presentPuzzle(withTags: shuffledSequenceArray)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        arrayWithPuzzleButton.removeAll()
        counterMoves = 0
        rightOrderPuzzleForTag.removeAll()
        for view in self.baseView.subviews {
            view.removeFromSuperview()
        }
    }
        
    private func createPuzzleArrayForBoard() -> [PuzzleButton] {
        var newArray = [PuzzleButton]()
        
        for y in 0..<boardSizeSide {
            for x in 0..<boardSizeSide {
                let newButton = PuzzleButton()
                newButton.addTarget(self, action: #selector(makeAMove(sender:)), for: .touchDown)
                newButton.frame = CGRect(x: CGFloat(x) * sideSizePuzzle, y: CGFloat(y) * sideSizePuzzle, width: sideSizePuzzle, height: sideSizePuzzle)
                newArray.append(newButton)
            }
        }
        return newArray
    }
    
    private func createRightOrderPuzzleDictionary(withArray array: [PuzzleButton]) {
        for index in 0..<rightSequenceArray.count {
            rightOrderPuzzleForTag.updateValue(array[index].frame.origin, forKey: rightSequenceArray[index])
        }
    }
    
    private func presentPuzzle(withTags tagSequence: [Int]) {
        
        if tagSequence.count == arrayWithPuzzleButton.count {
            for index in 0..<tagSequence.count {
                baseView.addSubview(arrayWithPuzzleButton[index])
                arrayWithPuzzleButton[index].tag = tagSequence[index]
                if tagSequence[index] == arrayWithPuzzleButton.count {
                    zeroPuzzle = arrayWithPuzzleButton[index]
                }
            }
        }
    }
    
    @objc private func makeAMove(sender: PuzzleButton)  {
        guard sender.tag != arrayWithPuzzleButton.count else {return}
        
        if ((zeroPuzzle.center.x == sender.center.x) && abs(zeroPuzzle.center.y - sender.center.y) ==  sideSizePuzzle) || ((zeroPuzzle.center.y == sender.center.y) && abs(zeroPuzzle.center.x - sender.center.x) == sideSizePuzzle){
            
            let senderFrame = sender.frame
            let zeroPuzzleFrame = zeroPuzzle.frame
            sender.frame = zeroPuzzleFrame
            zeroPuzzle.frame = senderFrame
            
            counterMoves += 1
            moveCountLabel.text = duringGameText + String(counterMoves)
            
            if сheckingGameIsOver() {
                guard let winViewController = self.storyboard?.instantiateViewController(withIdentifier: "GameOverViewController") else {return}
                winViewController.modalPresentationStyle = .fullScreen
                self.show(winViewController, sender: nil)
            }
        }
    }
    
    private func сheckingGameIsOver() -> Bool {
        
        var currentTagFramePairsDictionary = [Int : CGPoint]()
        for item in baseView.subviews {
            currentTagFramePairsDictionary.updateValue(item.frame.origin, forKey: item.tag)
        }
        for item in rightSequenceArray {
            guard let rightFrameForTag = rightOrderPuzzleForTag[item] else {return false}
            guard let currentFrameForTag = currentTagFramePairsDictionary[item] else {return false}
            
            guard rightFrameForTag == currentFrameForTag else {return false}
        }
        return true
    }
}

