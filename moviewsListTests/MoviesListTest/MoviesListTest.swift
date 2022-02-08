//
//  MoviesListTest.swift
//  moviewsListTests
//
//  Created by Abhijithkrishnan on 08/02/22.
//

import XCTest
@testable import moviewsList

class MoviesListTest: XCTestCase {
    func bootstrapMoviesListViewMock() -> MLMoviesListSceneViewMock {
        //MARK: Initialise components.
        let view = MLMoviesListSceneViewMock()
        
        let networking = MLNetworking()
        let apiWorker = MoviesWorkerMock(networking)
        let viewModel = MLMoviesListViewModelMock(apiWorker)

        //MARK: link VM components.
        view.viewModel = viewModel
        view.exp =  self.expectation(description: "Completion of view didFetch/didFailed")
        return view
    }
    var SUT:MLMoviesListSceneViewMock!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        SUT = nil
    }
    
    //MARK: Data Source Testing
    func testsuccessCaseForDataSoruceLoading()  {
        SUT = bootstrapMoviesListViewMock()
        SUT.initiate(endpoint: .fetchMoviesList) ///Inititate flow with expected endpoint
        waitForExpectations(timeout: 1)
        
        ///** Ensure initiate method called once
        XCTAssertTrue(SUT.calledMethod(.initiate))
        XCTAssertFalse(SUT.numberOfTimesCalled(.initiate) > 1)
        
        ///Ensure databinding method called once
        ///View failed interface should be called once
        XCTAssertTrue(SUT.calledMethod(.bindDataSource))
        XCTAssertFalse(SUT.numberOfTimesCalled(.initiate) > 1)
        
        ///Ensure fetching favorite method called once
        XCTAssertTrue(SUT.calledMethod(.getFavorite))
        XCTAssertFalse(SUT.numberOfTimesCalled(.getFavorite) > 1)
        
        ///Movies and Favorite datasource should be loaded
        XCTAssertTrue((SUT.moviesAll != nil), "Movies Fetched")
        XCTAssertTrue((SUT.moviesFavorite != nil), "Favorite Fetched")
        
       
    }
    func testFailureCaseForDataSoruceLoading()  {
        SUT = bootstrapMoviesListViewMock()
        SUT?.initiate(endpoint: .fetchImage("")) ///Inititate flow with unexpected endpoint
        waitForExpectations(timeout: 1)
        
        ///Movies and Favorite datasource shouldn't be loaded
        XCTAssertTrue((SUT.moviesAll?.count == 0), "Movies not Fetched")
        XCTAssertTrue((SUT.moviesFavorite?.count == 0), "Favorite not Fetched")
    }
    
    //MARK: Cell Selection Testing
    func testselection() {
        SUT = bootstrapMoviesListViewMock()
        SUT.initiate(endpoint: .fetchMoviesList) ///Inititate flow with expected endpoint
        ///Waiting for setting datasource successfully
        waitForExpectations(timeout: 1)
        
        ///Set New expectetion for fulfilling selection
        SUT?.selectionExp = self.expectation(description: "Completion of view didFetch/didFailed")
        guard let exp = SUT.selectionExp else {return}
        SUT.viewModel?.setSelection(SUT.moviesAll?.first,isFavorite: true)
        wait(for: [exp], timeout: 1)
        /// Selected Movie Array should not be empty and it should only contain 1 object
        XCTAssertTrue((SUT.selectedList?.count == 1), "Movie Selected")
    }
    
    
    //MARK: Data Source Sort Testing
    func testSuccessCaseForSort()  {
        SUT = bootstrapMoviesListViewMock()
        SUT?.initiate(endpoint: .fetchMoviesList) ///Inititate flow with unexpected endpoint
        waitForExpectations(timeout: 1)
        
        
        let moviesAllRat = SUT.moviesAll?.compactMap{$0.rating!}
        let favoritesRat = SUT.moviesFavorite?.compactMap{$0.rating!}
        XCTAssertTrue((moviesAllRat!.isSorted(by: >)), "Movies list sorted based on rating")
        XCTAssertTrue((favoritesRat!.isSorted(by: >)), "Favorite list sorted based on rating")
    }
}
