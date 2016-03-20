//
//  VCDijkstra.swift
//  InterviewTest
//
//  Created by Umair Aamir on 3/15/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit

class VCDijkstra: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private var arrWords: [String] = []
    private var numberOfColumns: Int = 2 {
        didSet {
            self.reloadCollectionToFindPath()
        }
    }
    
    private var selectedIndices: [Int] = []
    private let horizontalInset: CGFloat = 10
    private let textCellHeight: CGFloat = 230
    private let staticFontSize: CGFloat = 16
    
    private var findPathQueue: NSOperationQueue?
    private var manager: ITPathManager?
    
    private var timer: NSTimer?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupQueue()
//        s self.reloadCollectionToFindPath()
    }
    
    // MARK: - Helping Methods
    
    /**
    * Setting up background queue
    **/
    private func setupQueue() -> Void {
        self.findPathQueue = NSOperationQueue()
        self.findPathQueue?.qualityOfService = .Background
        self.findPathQueue?.maxConcurrentOperationCount = 1
    }
    
    /**
     * Register blocks from top cell
     **/
    private func registerHeaderBlocks(headerView: CollectionTextCell) -> Void {
        headerView.textDidChanged = { (text) in
            self.arrWords = text.componentsSeparatedByString(" ")
            self.reloadCollectionToFindPath()
        }
        
        headerView.sliderValueDidChange = { (value) in
            if value == self.numberOfColumns {return}
            self.numberOfColumns = value
        }
        
        headerView.textViewEmpty = {
            self.arrWords.removeAll()
            self.reloadCollectionAsynchronously()
        }
    }
    
    /**
     * Reload the collection and find path
     **/
    private func reloadCollectionToFindPath() -> Void {
        self.reloadCollectionAsynchronously()
        self.startFindingShortestPath()
    }
    
    /**
     * Start the operation on background queue
     **/
    private func startFindingShortestPath() -> Void {
        self.manager?.cancel()
        self.startTimer()
        self.selectedIndices.removeAll()
        self.manager = ITPathManager(columns: self.numberOfColumns, arrWords: self.arrWords)
        self.manager!.completionBlock = {
            self.killTimer()
            if self.manager!.cancelled == false && self.manager!.shortestPathIndices != nil {
                self.hideNotifyingMessage(true)
                self.selectedIndices = [] + self.manager!.shortestPathIndices!
                self.reloadCollectionAsynchronously()
            }
        }
        self.findPathQueue?.addOperation(self.manager!)
    }
    
    /**
     * Reload the collection asynchronously
     **/
    private func reloadCollectionAsynchronously() -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.collectionView?.reloadSections(NSIndexSet(index: 1))
        }
    }
    
    /**
     * Start timer for notifying user
     **/
    private func startTimer() -> Void {
        self.killTimer()
        self.hideNotifyingMessage(false)
        if self.timer == nil {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "showNotifyingAlert", userInfo: nil, repeats: true)
        }
    }
    
    private func killTimer() -> Void {
        if self.manager?.finished == true {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    func showNotifyingAlert() -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if self.presentedViewController == nil {
                utility.showCancelTypeAlert(title: utility.titleOperationDelay, message: utility.messageOperationDelay, buttonTitle: "OK")
            }
        }
    }
    
    private func hideNotifyingMessage(hide: Bool) -> Void {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if let cell = self.collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) {
                (cell as! CollectionTextCell).hideNotifyingMessages(hide)
            }
        }
    }
    
    // MARK: - UICollectionViewFlowLayout Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        guard indexPath.section != 0 else { return CGSizeMake(utility.SCREEN_WIDTH - self.horizontalInset, self.textCellHeight) }
        let width = CGRectGetWidth(collectionView.bounds) / CGFloat(self.numberOfColumns) - self.horizontalInset
        let text = self.arrWords[indexPath.item]
        let height = text.heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(self.staticFontSize)) + self.horizontalInset
        return CGSizeMake(width, height)
    }
    
    // MARK: - UICollectionView Datasource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section != 0 else { return 1}
        return self.arrWords.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard indexPath.section != 0 else {
            let headerView: CollectionTextCell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionTextCell.nameOfClass, forIndexPath: indexPath) as! CollectionTextCell
            self.registerHeaderBlocks(headerView)
            return headerView
        }
        let cell: CollectionLabelCell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionLabelCell.nameOfClass, forIndexPath: indexPath) as! CollectionLabelCell
        if let _ = self.selectedIndices.indexOf({$0 == indexPath.item}) {
            cell.backgroundColor = UIColor.blueColor()
            cell.lblTitle.textColor = UIColor.whiteColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.lblTitle.textColor = UIColor.blackColor()
        }
        cell.lblTitle.text = self.arrWords[indexPath.item]
        return cell
    }
    
}
