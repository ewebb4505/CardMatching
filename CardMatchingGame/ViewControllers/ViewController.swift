//
//  ViewController.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/6/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    //views
    var cardCollectionView: UICollectionView!
    @IBOutlet weak var demoCardsCollectionView: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var gameHistoryTableView: UITableView!
    @IBOutlet weak var cardMatchingText: UILabel!
    
    @NIBWrapped(TotalGameDataView.self)
    @IBOutlet var totalTapsDataView: UIView!
    
    @NIBWrapped(TotalGameDataView.self)
    @IBOutlet var totalTimeDataView: UIView!
    
    //previous game core data variables
    var managedContext: NSManagedObjectContext!
    var bestPrevGame: PreviousGame?
    var prevGames: [PreviousGame] = []
    
    //variables need for the game simulation
    let cardModel: CardModel = CardModel()
    var gameModel: GameViewModel<CardCollectionViewCell>?
    let cellID = "cardCell"
    
    //constants for setting up previous games table
    let lastThreePreviousGamesSectionNumber: Int = 0
    let bestPreviousGameSectionNumber: Int = 1
    let previousGamesTableSectionRowQuantity: Int = 3
    let numOfSections: Int = 2
    
    //computed UILabel for empty table
    let emptygameHistoryTableViewLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no game history! Play a game."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        self.gameHistoryTableView.delegate = self
        self.gameHistoryTableView.dataSource = self
        
        
        // Register the custom header view.
        gameHistoryTableView.register(PreviousGameHeaderView.self,
                                      forHeaderFooterViewReuseIdentifier: PreviousGameHeaderView.reusableID)
        gameHistoryTableView.register(BestGameHeaderView.self,
                                      forHeaderFooterViewReuseIdentifier: BestGameHeaderView.reusableID)
        
        gameHistoryTableView.register(UINib(nibName: "PreviousGameTableViewCell", bundle: nil), forCellReuseIdentifier: PreviousGameTableViewCell.reusableID)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("view will appear")

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        
        let request: NSFetchRequest<PreviousGame> = PreviousGame.fetchRequest()
        
        do {
          //3
          self.prevGames = try managedContext.fetch(request)
            print(prevGames.count)
        } catch let error as NSError {
          print("Could not fetch \(error), \(error.userInfo)")
        }
        
        //sort previous game data by date
        
        self.prevGames.sort {
            return $0.date! > $1.date!
        }
        
      
        self.gameModel = GameViewModel(cards: cardModel.getCardsForDemo())
        
        getBestPreviousGame()
        setUpPreviousGameDataTable()
        setUpTotalDataViews()
        setUpDemoGame()
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.startDemoGame()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let bestPrevGame = bestPrevGame {
            print(bestPrevGame)
            let destinationVC = segue.destination as! GameViewController
            destinationVC.bestPreviousGame = bestPrevGame
        }
    }
    
    private func setUpDemoGame() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 50, height: 75)
        self.demoCardsCollectionView.collectionViewLayout = layout
        
        self.demoCardsCollectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        self.demoCardsCollectionView.delegate = self
        self.demoCardsCollectionView.dataSource = self
        
        self.demoCardsCollectionView.contentInset = UIEdgeInsets(top: 8, left: 20, bottom: 0, right: 20)
    }
    
    
    
    private func setUpPreviousGameDataTable() {
        if prevGames.isEmpty {
            let gameHistoryTableViewFrame = self.gameHistoryTableView.frame
            self.emptygameHistoryTableViewLabel.frame.size = gameHistoryTableViewFrame.size
            self.emptygameHistoryTableViewLabel.textAlignment = .center
            self.emptygameHistoryTableViewLabel.font = UIFont(name: "Fredoka-Regular", size: 17)
            //self.emptygameHistoryTableViewLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            self.gameHistoryTableView.backgroundView = self.emptygameHistoryTableViewLabel
        }
        if self.gameHistoryTableView.backgroundView != nil && !prevGames.isEmpty {
            self.gameHistoryTableView.backgroundView = nil
        }
        self.gameHistoryTableView.reloadData()
    }
    
    private func setUpTotalDataViews() {
        _totalTapsDataView.unwrapped.label = "Total Taps"
        _totalTimeDataView.unwrapped.label = "Total Time"
        
        _totalTapsDataView.unwrapped.symbol = "hand.tap.fill"
        _totalTimeDataView.unwrapped.symbol = "clock.fill"
        
        _totalTimeDataView.unwrapped.layer.borderWidth = 2
        _totalTimeDataView.unwrapped.layer.borderColor = UIColor.black.cgColor
        _totalTimeDataView.unwrapped.layer.cornerRadius = 8
        
        _totalTapsDataView.unwrapped.layer.borderWidth = 2
        _totalTapsDataView.unwrapped.layer.borderColor = UIColor.black.cgColor
        _totalTapsDataView.unwrapped.layer.cornerRadius = 8
        
        //TODO: Get total number of taps from each game and sum them together
        
        let totalTapsString = getTotalTapsString()
        _totalTapsDataView.unwrapped.dataLabel.text = totalTapsString
        
        let totalTimeString = getTotalTimeString()
        _totalTimeDataView.unwrapped.dataLabel.text = totalTimeString
    }
    
    private func getBestPreviousGame() {
        //THIS ISN'T WORKING?
        if !prevGames.isEmpty {
            self.bestPrevGame = prevGames.min()
        }
    }
    
    private func setTimeString(time: Int32) -> String {

        let minutes = time / 60
        let seconds = time % 60
        
        if minutes == 0 && seconds == 0 {
            return ""
        }
        
        if minutes == 0 {
            if seconds == 1 {
                return "1 second"
            } else {
                return "\(seconds) seconds"
            }
        } else {
            if seconds == 0 {
                return "\(minutes) minutes"
            }
            if seconds > 1 && minutes > 1 {
                return "\(minutes) minutes and \(seconds) seconds"
            } else if minutes == 1 && seconds > 1 {
                return "1 minute and \(seconds) seconds"
            } else if minutes > 1 && seconds == 1 {
                return "\(minutes) minutes and 1 second"
            } else {
                return "1 minute and 1 second"
            }
        }
    }
    
    private func getTotalTimeString() -> String {
        if !prevGames.isEmpty {
            var totalTime = 0
            for game in prevGames {
                totalTime += Int(game.time)
            }
            
            var minutes = totalTime / 60
            let seconds = totalTime % 60
            
            if minutes == 0 {
                return "\(seconds) seconds"
            } else {
                if seconds > 30 {
                    minutes += 1
                    return (minutes > 1) ? "\(minutes) minutes" : "\(minutes) minute"
                } else {
                    return (minutes > 1) ? "\(minutes) minutes" : "\(minutes) minute"
                }
            }
            
        } else {
            return "none"
        }
    }
    
    private func getTotalTapsString() -> String {
        var totalTaps = 0
        for prevGame in prevGames {
            totalTaps = totalTaps + Int(prevGame.numOfTaps)
        }
        return "\(totalTaps)"
    }
    
//    private func setPreviousGamesRecentPerformance() -> String {
//        var recentPerformance = ""
//
//        return recentPerformance
//    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == lastThreePreviousGamesSectionNumber {
           let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: PreviousGameHeaderView.reusableID) as! PreviousGameHeaderView
           view.title.text = "Previous 3 Games"
        
            
           //view.subtitle.text = setPreviousGamesRecentPerformance()
//           view.image.image = UIImage(systemName: "arrow.up.square")

           return view
        } else {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: BestGameHeaderView.reusableID) as! BestGameHeaderView
            view.title.text = "Best Game"
            return view
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return prevGames.isEmpty ? 0 : numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if section is last 5, get the last 5 games from the data model here
        if section == lastThreePreviousGamesSectionNumber {
            return prevGames.count < previousGamesTableSectionRowQuantity ? prevGames.count : previousGamesTableSectionRowQuantity
        } else {
            return prevGames.isEmpty ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PreviousGameTableViewCell.reusableID, for: indexPath) as! PreviousGameTableViewCell
        if indexPath.section == bestPreviousGameSectionNumber {
            if !prevGames.isEmpty {
                guard let best = bestPrevGame else {
                    fatalError("Tried displaying best previous game saved from previous games but something went wrong")
                }
                let time = best.time
                let taps = best.numOfTaps
                guard let date = best.date else {
                    fatalError("Tried displaying date saved from previous game but something went wrong")
                }
                
                let timeString = setTimeString(time: time)

                cell.timeLabel.text = "Total Time: \(timeString)"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                dateFormatter.locale = Locale(identifier: "en_US")
                let dateString: String = dateFormatter.string(from: date)
               
                cell.dateLabel.text = "Played on \(dateString)."
                cell.tapsLabel.text = "\(taps) Taps"
            }
            
            return cell
            
        } else {
            if !prevGames.isEmpty {
                let time = prevGames[indexPath.row].time
                let taps = prevGames[indexPath.row].numOfTaps
                guard let date = prevGames[indexPath.row].date else {
                    fatalError("Tried displaying date saved from previous game but something went wrong")
                }
                
                let timeString = setTimeString(time: time)

                cell.timeLabel.text = "Total Time: \(timeString)"
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                dateFormatter.locale = Locale(identifier: "en_US")
                let dateString: String = dateFormatter.string(from: date)
               
                cell.dateLabel.text = "Played on \(dateString)."
                cell.tapsLabel.text = "\(taps) Taps"
            }
            
            return cell
        }
            
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        demoCardsCollectionView.deselectItem(at: indexPath, animated: false)
        
        guard let game = self.gameModel else {
            fatalError("The game model wasn't set before the demo game started")
        }
    
        let cardCell = demoCardsCollectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardCell.getCard()
        
        if !card.isMatched {
            
            if game.isFirstSelectionEmpty() {
                
                game.setFirstCardInSelectedPair(cardCell)
                //card.isFlipped = true
                //cardCell.flipCard(withDelay: false)
                game.flipFirstCardSelected(withDelay: false)
                //making the first selected card out of the pair disabled will prevent an
                //event from firing off if the user taps it again. MAKE SURE TO RESET THIS AFTER SECOND SELECTION
//                cardCell.isUserInteractionEnabled = false
                game.disableFirstCardSelection()
                
            } else if game.isSecondSelectionEmpty() {
                
                game.setSecondCardInSelectedPair(cardCell)
                
                //TODO: card is flipped should only be set in the cardCell class since
                //card.isFlipped = true
                game.flipSecondCardSelected(withDelay: false)
                
                if game.checkSelectedPairForMatch() {
                    
                    print("You got a match!")
                    //making the second selected card out of the pair when there is a match disabled
                    //so users can't fire an event if it is tapped again.
//                    self.secondCardCellSelected?.isUserInteractionEnabled = false
                    game.disableSecondCardSelection()
                    game.setCardMatchPropForSelectedCards()
                    game.setCardSelectionToMatchedState()
                    game.resetCardSelection()
                    
                    
                    //check for the end of the game
                    if game.isGameComplete() {
                        
                        //flip all cards
                        //game.resetGame()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                            for cell in self.demoCardsCollectionView.visibleCells as! [CardCollectionViewCell] {
                                cell.resetCard()
                                cell.isUserInteractionEnabled = true
                            }
                            //reset game here
                            game.resetGame()
                            game.shuffleCards()
 
                            game.resetCardSelection()
                        }
                    }
                    
                } else {
                    print("That wasn't a match!")
                    //enable the selected pair since they were not a match
                    game.enableSecondCardSelection()
                    game.enableFirstCardSelection()
                    game.flipSecondCardSelected(withDelay: true)
                    game.flipFirstCardSelected(withDelay: true)
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

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardModel.getNumOfCardsForDemo()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = demoCardsCollectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CardCollectionViewCell
        //this is where we configure the card!
        //first, set the card info (should the cardCollectionViewCell have a reference to a Card object?)
        guard let game = self.gameModel else {
            fatalError("The game model wasn't set before the demo game started")
        }
        
        cell.setCard(card: game.getCards()[indexPath.item])
        
        return cell
    }
}
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 75)
    }

}
