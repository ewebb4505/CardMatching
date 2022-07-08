//
//  GameViewController.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 6/20/22.
//

import UIKit
import CoreData

class GameViewController: UIViewController {

    @IBOutlet weak var gameCollectionView: UICollectionView!
    @IBOutlet weak var currentGameTimeLabel: UILabel!
    @IBOutlet weak var bestGameTimeLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var endGameButton: UIButton!
    
    //models
    let cardModel: CardModel = CardModel()
    var gameModel: GameViewModel<CardCollectionViewCell>?
    
    var managedContext: NSManagedObjectContext!
    var bestPreviousGame: PreviousGame?
    
    //timers
    var timer: Timer = Timer()
    var timerCount: Int = 0
    var timerCounting: Bool = false
    var resetTimer: Timer?
    var resetTimerStartingCount: Int = 3
    var resetTimerCount: Int = 0
    var resetTimerIsCounting: Bool = false
    
    //Most of this should be in the GameViewModel class
    var cards: [Card] = []
    let cellID = "cardCell"
    var isGameComplete: Bool = false
    var didUserCompleteGame: Bool = false
    var didUserEndGame: Bool = false
    var numberOfTaps: Int16 = 0
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cards = cardModel.getCards(shuffleCards: true)
        self.gameModel = GameViewModel(cards: cards)
        
        self.setUpGameCollectionView()
        self.setUpGameLabels()
        self.setUpTimer(withSmallDelay: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
    }
    
    private func setUpGameCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 75)
        self.gameCollectionView.collectionViewLayout = layout
        
        self.gameCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reusableID)
        self.gameCollectionView.delegate = self
        self.gameCollectionView.dataSource = self
    }
    
    @IBAction func endGameButtonTapped(_ sender: UIButton) { self.endGame() }
    
    @IBAction func restartGameButtonTapped(_ sender: Any) { self.restartGame() }
    
    @objc func timerCounter() {
        guard let gameModel = gameModel else {
            fatalError("Timer started without gameModel set")
        }

        if !gameModel.isGameComplete() {
            timerCount = timerCount + 1
            let minutes = Int(timerCount) / 60
            let seconds = Int(timerCount) % 60
            let secondsString: String = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            currentGameTimeLabel.text = "Time: \(minutes):\(secondsString)"
        } else {
            self.timer.invalidate()
        }
    }
    
    @objc func resetTimerCounter() {
        if self.resetTimerCount < self.resetTimerStartingCount {
            self.currentGameTimeLabel.text = "Start in \(self.resetTimerStartingCount - self.resetTimerCount)"
            self.resetTimerCount = self.resetTimerCount + 1
            self.currentGameTimeLabel.textColor = UIColor.systemGreen
        } else {
            self.resetTimerIsCounting = false
            self.resetTimer?.invalidate()
            
            self.currentGameTimeLabel.textColor = UIColor.black
            self.currentGameTimeLabel.text = "Time: 0:00"
            self.enableUserInteractionForAllCards()
            
            self.setUpTimer(withSmallDelay: false)
            self.timerCount = 0
            self.resetTimerCount = 0
            
            self.endGameButton.isEnabled = true
        }
    }
    
    private func setUpGameLabels() {
        self.currentGameTimeLabel.text = "Time: "
        setBestGameLabel()
    }
    
    private func setUpTimer(withSmallDelay: Bool) {
        if withSmallDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
                self.timerCounting = true
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
            })
        } else {
            self.timerCounting = true
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCounter), userInfo: nil, repeats: true)
        }
        
    }
    
    private func restartGame() {
        //first stop current game
        // - flip cards and disable cards
        self.endGameButton.isEnabled = false
        
        guard let gameModel = gameModel else {
            fatalError("Trying to reset a game when the gameViewModel was not set up")
        }

        //if the user ended the game first, this would be repetative.
        if !gameModel.getUserDidEndGame() {
            flipAllCards(setUserInteraction: false)
            // - stop timer
            self.timer.invalidate()
        }
        
        //reload the collection view (make sure they are reshuffled)
        self.resetGame()
    
        //self.currentGameTimeLabel.text = "Start in "
        //start a timer that starts from 3 and counts down until the start of the next game (Starts in 3...)
        
        self.numberOfTaps = 0
        
        self.resetTimerIsCounting = true
        self.resetTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.resetTimerCounter), userInfo: nil, repeats: true)
    
        //once timer hits 0, enable the collection view, start a new timer and game
        
    }
    
    private func resetGame() {
        guard let game = self.gameModel else {
            fatalError("Trying to reset game with nil GameViewModel reference.")
        }
        //reset the gameViewModel
        game.resetGame()
        
        //shuffle the cards
        game.shuffleCards()
        
        //shuffle the cards and reset the collection view
        self.gameCollectionView.reloadData()
        
        //reset the card cell references for the next game
    }
    
    private func endGame() {

        // - flip cards and disable cards
        flipAllCards(setUserInteraction: false)
        // - stop current timer
        self.timer.invalidate()
        // - change the timer label to indicate that the game is finished and not paused
        self.currentGameTimeLabel.text = "Game ended!"
        self.currentGameTimeLabel.textColor = UIColor.systemRed
        
        self.gameModel?.setUserDidEndGame(true)
        // what should I do from here?
        // - idea 1: replace the end game / restart buttons with a new "Start Game" button.
        // - idea 2: just leave it here and make the user go back or hit restart.
        
        //TODO: DISABLE THE END GAME BUTTON AFTER A USER TAPS IT. ONLY ENABLE IT WHEN ANOTHER GAME HAS STARTED.
    }
    
    private func flipAllCards(setUserInteraction: Bool) {
        for cell in gameCollectionView.visibleCells as! [CardCollectionViewCell] {
            cell.resetCard()
            cell.isUserInteractionEnabled = setUserInteraction
        }
    }
    
    private func enableUserInteractionForAllCards() {
        for cell in gameCollectionView.visibleCells as! [CardCollectionViewCell] {
            cell.isUserInteractionEnabled = true
        }
    }
    
    private func showSimpleAlert() {
        
        //TODO: make sure the message accounts for different times.
        let minutes = Int(timerCount) / 60
        let seconds = Int(timerCount) % 60
        var minutesString: String = ""
        var secondsString: String = ""
        
        if minutes > 0{
            minutesString = (minutes > 0 && minutes == 1) ? "\(minutes) minute and " : "\(minutes) minutes and "
        }
        
        secondsString = seconds < 10 ? ((seconds == 1) ? "0\(seconds) second" : "0\(seconds) seconds") : "\(seconds) seconds"
        //TODO: grab users personal best and if the user beat it, make sure it's in the message.
        
        let alert = UIAlertController(title: "Great Job!",
                                      message: "You completed the game in \(minutesString)\(secondsString).",
                                      preferredStyle: UIAlertController.Style.alert)

        //TODO: Add exit action here (should go to the home screen)
        alert.addAction(UIAlertAction(title: "Exit",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        //TODO: Add play again action here (resets the game)
        alert.addAction(UIAlertAction(title: "Play Again",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            self.setBestGameLabel()
            self.restartGame()
            
        }))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: {
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    
    private func addGameToPreviousGames() -> Bool {
        guard let gameComplete = self.gameModel?.isGameComplete() else {
            fatalError("Trying to add a nil gameModel to the previousGames model")
        }
        
        var isBetterThanBestPreviousGames = false
        
        if gameComplete {
            let entity = NSEntityDescription.entity( forEntityName: "PreviousGame", in: managedContext)!
            let prevGame = PreviousGame(entity: entity, insertInto: managedContext)
            
            prevGame.date = Date()
            prevGame.time = Int32(self.timerCount) 
            prevGame.numOfTaps = self.numberOfTaps
            
            if let bestPreviousGame = bestPreviousGame {
                if prevGame.time == bestPreviousGame.time {
                    isBetterThanBestPreviousGames = prevGame.numOfTaps < bestPreviousGame.numOfTaps
                } else if prevGame.time < bestPreviousGame.time {
                    isBetterThanBestPreviousGames = true
                }
            } else {
                isBetterThanBestPreviousGames = true
            }
            
            try? managedContext.save()
            
            if isBetterThanBestPreviousGames {
                self.bestPreviousGame = prevGame
            }
        } else {
            fatalError("Trying to add an incomplete game as a previousGame")
        }
        
        return isBetterThanBestPreviousGames
    }
    
    private func setBestGameLabel() {
        guard let bestPreviousGame = bestPreviousGame else {
            self.bestGameTimeLabel.text = "No Best Time Yet!"
            return
        }
        
        let minutes = Int(bestPreviousGame.time) / 60
        let seconds = Int(bestPreviousGame.time) % 60
        let minutesString: String = (minutes > 9) ? "\(minutes)" : "0\(minutes)"
        let secondsString: String = (seconds > 9) ? "\(seconds)" : "0\(seconds)"
        self.bestGameTimeLabel.text = "Best Game: \(minutesString):\(secondsString)"

    }
}


extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gameCollectionView.deselectItem(at: indexPath, animated: false)
        
        guard let game = self.gameModel else {
            fatalError("The game model wasn't set when the user picked a card")
        }
        
        let cardCell = gameCollectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardCell.getCard()
        
        if !card.isMatched {
            numberOfTaps = numberOfTaps + 1
            
            if game.isFirstSelectionEmpty() {
                
                game.setFirstCardInSelectedPair(cardCell)
                //card.isFlipped = true
                game.flipFirstCardSelected(withDelay: false)
                //making the first selected card out of the pair disabled will prevent an
                //event from firing off if the user taps it again. MAKE SURE TO RESET THIS AFTER SECOND SELECTION
                game.disableFirstCardSelection()
                
            } else if game.isSecondSelectionEmpty() {
                
                game.setSecondCardInSelectedPair(cardCell)
                
                //TODO: card is flipped should only be set in the cardCell class since
                //card.isFlipped = true
                game.flipSecondCardSelected(withDelay: false)
                game.disableSecondCardSelection()
                
                if game.checkSelectedPairForMatch() {
                    
                    print("You got a match!")
                    //making the second selected card out of the pair when there is a match disabled
                    //so users can't fire an event if it is tapped again.
                    //game.disableSecondCardSelection()
                    game.setCardMatchPropForSelectedCards()
                    game.setCardSelectionToMatchedState()
                    
                    game.resetCardSelection()
                    //check for the end of the game
                    if game.isGameComplete() {
                        
                        self.isGameComplete = true
                        if addGameToPreviousGames() {
                            
                        }
                        showSimpleAlert()
                    }
                    
                } else {
                    
                    print("That wasn't a match!")
                    
                    //enable the selected pair since they were not a match
                    game.enableFirstCardSelection()
                    game.enableSecondCardSelection()
                    
                    //flip both cards back since they were not matches
                    game.flipFirstCardSelected(withDelay: true)
                    game.flipSecondCardSelected(withDelay: true)
                    
                    game.resetCardSelection()
                }
                
            } else {
                //getting this after picking two matching cards
                print("What happened here?")
            }
        } else {
            print("A card that has already been matched has been selected")
        }
    }
}

extension GameViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let game = self.gameModel else {
            fatalError("Trying to set the number of cards in the collection view but the game model is not set.")
        }
        return game.getNumberOfCards()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reusableID, for: indexPath) as! CardCollectionViewCell
        //this is where we configure the card!
        //first, set the card info (should the cardCollectionViewCell have a reference to a Card object?)
        guard let game = self.gameModel else {
            fatalError("Trying to set the card collection view cells in the collection view but the game model is not set.")
        }
        
        cell.setCard(card: game.getCards()[indexPath.item])
        
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 75)
    }
}
