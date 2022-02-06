//
//  SFDIContainer.swift
//  moviewsList
//
//  Created by Abhijithkrishnan on 02/02/22.
//

import Foundation
struct DIContainer {

    static func bootstrapMoviesListView() -> MLMoviewListSceneView {
        //MARK: Initialise components.
        let view = MLMoviewListSceneView()
        
        let networking = MLNetworking()
        let apiWorker = MLWorker(networking)
        let viewModel = MLMoviesListViewModel(apiWorker)

        //MARK: link VM components.
        view.viewModel = viewModel
        return view
    }
    static func bootstrapMoviesDetailsView() -> MLMoviesDetailsViewSceneView {
        //MARK: Initialise components.
        let view = MLMoviesDetailsViewSceneView()
        let viewModel = MLDetailsViewModel()

        //MARK: link VM components.
//        view.viewModel = viewModel
        return view
    }
}
