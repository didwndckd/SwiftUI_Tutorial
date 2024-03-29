//
//  CategoryHomeView.swift
//  Landmarks
//
//  Created by 양중창 on 2022/09/20.
//

import SwiftUI

struct CategoryHomeView: View {
    @ObservedObject
    private var viewModel: CategoryHomeViewModel
    
    init(viewModel: CategoryHomeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            List {
                self.featuredView
                
                ForEach(self.viewModel.state.categories.keys.sorted(), id: \.self) { key in
                    self.categoryRow(key: key)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Featured")
            .toolbar {
                Button {
                    self.viewModel.action(.profile)
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: self.$viewModel.state.showProfile,
                   onDismiss: { print("Profile dismiss")},
                   content: {
                let viewModel = ProfileHostViewModel()
                ProfileHostView(viewModel: viewModel)
            })
        }
    }
}

extension CategoryHomeView {
    @ViewBuilder
    private var featuredView: some View {
        PageView(pages: self.viewModel.featuredLandmark.map { FeatureCard(landmark: $0) })
            .aspectRatio(3 / 2, contentMode: .fit)
            .listRowInsets(EdgeInsets())
    }
    
    @ViewBuilder
    private func categoryRow(key: String) -> some View {
        let landmarkItems = self.viewModel.landmarkItems(key: key)
        CategoryRow(categoryName: key, items: landmarkItems)
    }
}

struct CategoryHomeView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CategoryHomeViewModel()
        CategoryHomeView(viewModel: viewModel)
    }
}
