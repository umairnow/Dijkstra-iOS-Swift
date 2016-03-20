//
//  ITShortestPath.swift
//  InterviewTest
//
//  Created by Umair Aamir on 3/17/16.
//  Copyright © 2016 MyWorkout AS. All rights reserved.
//

import UIKit

class ITShortestPath: NSObject {
    
    var pointList: [ITPathPoint]
    var cancelled: Bool = false
    
    private var sourcePoint: ITPathPoint
    private var targetPoint: ITPathPoint
    
    init(pointList: [ITPathPoint], fromPoint: ITPathPoint, toPoint: ITPathPoint) {
        self.sourcePoint = fromPoint
        self.targetPoint = toPoint
        self.pointList = pointList
    }
    
    /**
     * Get shortest Path
     **/
    func getShortestPathFromPoint() -> [ITPathPoint]? {
        return self.getPathForPoint(self.sourcePoint, path: [self.sourcePoint])
    }
    
    /**
     * Iterate recursively over all the array of points to find the shortest path
     **/
    private func getPathForPoint(point: ITPathPoint, path: [ITPathPoint]) -> [ITPathPoint]? {
        guard self.cancelled == false else { return [] }
        var paths: [[ITPathPoint]] = []
        // Target point achieved so add it to paths array
        if point == self.targetPoint {
            paths.append(path)
        } else {
            // Path finding algorithm
            // First task is to find the correct path to target point
            for ind in 0..<point.connectionList.count {
                guard self.cancelled == false else { return [] }
                let connection: ITPathConnection = point.connectionList[ind]
                if (path.filter() { return $0.tag == connection.point.tag }).count == 0 {
                    var newPath: [ITPathPoint] = []
                    newPath = newPath + path
                    newPath.append(connection.point)
                    let shortestPath = self.getPathForPoint(connection.point, path: newPath)
                    if shortestPath!.count > 0 {
                        paths.append(shortestPath!)
                    }
                }
            }
        }
        // All possible paths found
        // Now it comes to find the shortest path
        var smallestWeight: Int = 0
        var smallest: [ITPathPoint] = []
        for row in 0..<paths.count {
            let path = paths[row]
            var weight: Int = 0
            for col in 0..<path.count - 1 {
                guard self.cancelled == false else { return [] }
                let pointFrom = path[col]
                let pointTo = path[col + 1]
                if let connection = pointFrom.getConnectionToPointWithTag(pointTo.tag) {
                    weight += connection.weight
                }
            }
            if weight < smallestWeight || smallestWeight == 0 {
                smallest = path
                smallestWeight = weight
            }
        }
        return smallest
    }
}
