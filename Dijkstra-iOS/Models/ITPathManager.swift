//
//  ITPathManager.swift
//  InterviewTest
//
//  Created by Umair Aamir on 3/17/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit

class ITPathManager: NSOperation {
    
    var shortestPath: ITShortestPath?
    var totalColumns: Int
    
    var shortestPathIndices: [Int]?
    
    private var arrWords: [String]
    
    init(columns: Int, arrWords: [String]) {
        self.totalColumns = columns
        self.arrWords = arrWords
        super.init()
    }
    
    override func main() {
        guard self.cancelled == false else { return }
        self.createGridAndFindPath()
    }
    
    override func cancel() {
        self.shortestPath?.cancelled = true
        super.cancel()
    }
    
    // Create Grid/Table to Find the Shortest Path
    private func createGridAndFindPath() -> Void {
        guard self.arrWords.count != 0 else { return }
        var pointList: [ITPathPoint] = []
        
        let totalRows = utility.posibleRows(self.arrWords.count, columns: self.totalColumns)
        
        // Create matrix indices
        for row in 0..<totalRows {
            for col in 0..<self.totalColumns {
                let tag: ITCoordinate = ITCoordinate(row: row, column: col, itemIndex: pointList.count)
                if tag.itemIndex < self.arrWords.count {
                    pointList.append(ITPathPoint(label: self.arrWords[tag.itemIndex], tag: tag))
                }
            }
        }
        
        // Add Connections to each point
        for point in pointList {
            point.connectionList = self.getConnectionListForSource(point, pointList: pointList)
        }
        
        // Cancel any previous calculations
        self.shortestPath?.cancelled = true
        
        // Start new Calculation
        self.shortestPath = ITShortestPath(pointList: pointList, fromPoint: pointList.first!, toPoint: pointList.last!)
        
        let arrShortestPath = self.shortestPath?.getShortestPathFromPoint()
        self.shortestPathIndices = []
        for point in arrShortestPath! {
            self.shortestPathIndices!.append(point.tag.itemIndex)
        }
    }
    
    /**
     * Search and return the connection list for given source point
     */
    private func getConnectionListForSource(source: ITPathPoint, pointList: [ITPathPoint]) -> [ITPathConnection] {
        let indices = utility.getConnectionIndicesForTag(source.tag, totalColumns: self.totalColumns, totalRows: pointList.last!.tag.row)
        var connections: [ITPathConnection] = []
        
        for i in indices {
            if let _ = pointList.indexOf({$0.tag == i}) {
                connections.append(ITPathConnection(sourceCost: source.cost, point: pointList[i.indexByCoordinates(self.totalColumns)]))
            }
        }
        return connections
    }
}
