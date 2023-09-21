//
//  PlayVideoViewModelTests.swift
//  WhoTubeTests
//
//  Created by Raymondting on 2023/9/7.
//

import XCTest
import RxSwift
import RxTest
import SwiftyJSON
@testable import WhoTube

class PlayVideoViewModelTests: XCTestCase {
    var viewModel: PlayVideoViewModel!
    var scheduler: TestScheduler!
    let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        viewModel = PlayVideoViewModel(withPlayVideoItem: PlayItem(JSON()))
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testGetVideoInfo() {
        let videoDescriptionExpectation = expectation(description: "Video description should be updated")
        let observer = scheduler.createObserver(String.self)
        let mockApiProvider = MockApiProvider()
        mockApiProvider.responseJSON = MockApiProvider.readJSONFromFile(fileName: "video")
        mockApiProvider.isRequestSuccess = true
        viewModel.apiProvider = mockApiProvider
        
        viewModel.videoDescription.skip(1)
            .subscribe(onNext: { element in
                observer.onNext(element)
                videoDescriptionExpectation.fulfill()
            }).disposed(by: disposeBag)
        
        viewModel.getVideoInfo(videoId: "k3PvszZ55Ok")
        
        waitForExpectations(timeout: 1) { _ in
            let emitted = observer.events.compactMap { $0.value.element }
            print("emitted = \(emitted)")
            XCTAssertTrue(emitted[0].contains("王のお触れ。\n骸の王「登録者10人につき1パック開けたら、骸の王効果で年内7万達成出来るアル。」"))
        }
    }
}

