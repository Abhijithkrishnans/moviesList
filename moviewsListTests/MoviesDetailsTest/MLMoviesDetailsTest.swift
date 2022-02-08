//
//  MLMoviesDetailsTest.swift
//  moviewsListTests
//
//  Created by Abhijithkrishnan on 08/02/22.
//

import XCTest
@testable import moviewsList

class MLMoviesDetailsTest: XCTestCase {
    func bootstrapMoviesDetailsViewMock(_ movieList:[MLMoviesListModel]) -> MLMoviewDetailsSceneViewMock {
        //MARK: Initialise components.
        let view = MLMoviewDetailsSceneViewMock()
        
        let viewModel = MLMovieDetailsMock(movieList)
        
        //MARK: link VM components.
        view.viewModel = viewModel
        view.exp =  self.expectation(description: "Completion of view didFetch/didFailed")
        return view
    }
    var SUT:MLMoviewDetailsSceneViewMock!
    
    //MARK: Data Source Testing
    func testsuccessCaseForDataSoruceLoading()  {
        guard let list = MLUtilities.getDecodedBundleData(WithName: "MoviesListMock", ext: "json", type: [MLMoviesListModel].self)?.first else {
            return
        }
        SUT = bootstrapMoviesDetailsViewMock([list])
        SUT.initiate()
        waitForExpectations(timeout: 1)
       
        ///Ensure initiate method called once
        XCTAssertTrue(SUT.calledMethod(.initiate))
        XCTAssertFalse(SUT.numberOfTimesCalled(.initiate) > 1)

        
        ///Movies and Favorite datasource should be loaded
        XCTAssertTrue((SUT.moviesList != nil), "Movies Fetched")
       
    }
}
