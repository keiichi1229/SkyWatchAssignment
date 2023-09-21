//
//  PlayItemListViewModelTests.swift
//  WhoTubeTests
//
//  Created by Raymondting on 2023/9/7.
//

import XCTest
import RxSwift
import RxTest
import SwiftyJSON
import Moya
@testable import WhoTube

class PlayItemListViewModelTests: XCTestCase {
    var viewModel: PlayItemListViewModel!
    var scheduler: TestScheduler!
    let disposeBag = DisposeBag()
    let mockApiProvider = MockApiProvider()

    override func setUp() {
        super.setUp()
        viewModel = PlayItemListViewModel()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testFetchNextPage() {
        // Mock the API response
        mockApiProvider.responseJSON = MockApiProvider.readJSONFromFile(fileName: "playList")
        mockApiProvider.isRequestSuccess = true
        viewModel.apiProvider = mockApiProvider

        // Create an observer to record emitted events
        let observer = scheduler.createObserver([PlayItem].self)

        // Bind the observer
        viewModel.playItemList
            .bind(to: observer)
            .disposed(by: disposeBag)

        // Call the method
        viewModel.fetchNextPage()

        // Check the emitted events
        let emitted = observer.events.compactMap { $0.value.element }
        XCTAssertNotNil(emitted.first)
        XCTAssertEqual(emitted.first?.count, 30)
    }
}








