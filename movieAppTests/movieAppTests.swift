//
//  movieAppTests.swift
//  movieAppTests
//
//  Created by Amit Mathur on 9/4/18.
//  Copyright © 2018 Amit Mathur. All rights reserved.
//

import XCTest
@testable import movieApp

class movieAppTests: XCTestCase {
    
    var sessionUnderTest: URLSession!

    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAPIStatus()  {
        self.CheckValidAPI(searchText: "s", page: 1)
        self.CheckValidAPI(searchText: "sm", page: 1)
        self.CheckValidAPI(searchText: "sm", page: 1)
        self.CheckValidAPI(searchText: "sm", page: 1)
    }
    
    func testAPIStatusFaster()  {
        self.testValidAPI_faster(searchText: "s")
        self.testValidAPI_faster(searchText: "sm")
        self.testValidAPI_faster(searchText: "sm")
        self.testValidAPI_faster(searchText: "sm")
    }
    
    
    func testDateConversation()  {
        self.CheckValidDateConversation(string: "2018-01-10")
        self.CheckValidDateConversation(string: "2018-11-10")
        self.CheckValidDateConversation(string: "2018-09-10")
        self.CheckValidDateConversation(string: "2018-01-10")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


//MARK: - Implemented functiona.
extension movieAppTests {
 // Asynchronous: success fast, failure slow
    fileprivate func CheckValidAPI(searchText: String, page : Int) {
        let service = APIService()
        let urlString = "\(service.endPoint)&query=\(searchText)&page=\(page)"
        let url = URL(string: urlString)
        weak var promise = expectation(description: "Exception fire")
        if let urlpath = url {
            let dataTask = sessionUnderTest.dataTask(with: urlpath) { data, response, error in
                if let error = error {
                    XCTFail("Error: \(error.localizedDescription)")
                    return
                } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as? [String: AnyObject] {
                                guard (json["results"] as? [[String: AnyObject]]) != nil else {
                                    return XCTFail("There are no new Items to show")
                                }
                                promise?.fulfill()
                            }
                        } catch let error {
                            XCTFail("Data not valid: \(error.localizedDescription)error")
                        }
                        
                    } else {
                        XCTFail("Error Status code: \(statusCode)")
                    }
                }
            }
            dataTask.resume()
           waitForExpectations(timeout: 50, handler: nil)
        }
        
    }
    
    // Asynchronous test: failure fast
    func testValidAPI_faster(searchText: String) {
         let service = APIService()
        let urlString = "\(service.endPoint)&query=\(searchText)&page=\(1)"
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
         let url = URL(string: urlString)
         if let urlpath = url {
            let dataTask = sessionUnderTest.dataTask(with: urlpath) { data, response, error in
                statusCode = (response as? HTTPURLResponse)?.statusCode
                responseError = error
                promise.fulfill()
            }
            dataTask.resume()
        }
       
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
   fileprivate func CheckValidDateConversation(string : String)  {
        let securecontext = secureContext()
        let date = securecontext.strToDate(releaseStr: string)
        XCTAssertNil(date, "date not created")
    }
}

