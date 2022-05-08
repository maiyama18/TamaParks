import Entities
import SwiftUI

struct ParkListScreen: View {
    @ObservedObject var viewModel: ParkListViewModel

    var body: some View {
        VStack {
            HStack(spacing: 16) {
                HStack(spacing: 2) {
                    Image(systemName: "line.3.horizontal.decrease")
                        .font(.callout.bold())
                        .foregroundColor(.accentColor)

                    Picker("", selection: $viewModel.parkFilter) {
                        ForEach(ParkFilter.allCases, id: \.self) {
                            Text($0.description)
                                .font(.callout.bold())
                        }
                    }
                }

                HStack(spacing: 2) {
                    Image(systemName: "arrow.down")
                        .font(.callout.bold())
                        .foregroundColor(.accentColor)

                    Picker("", selection: $viewModel.parkSortOrder) {
                        ForEach(ParkSortOrder.allCases, id: \.self) {
                            Text($0.description)
                                .font(.callout.bold())
                        }
                    }
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, -8)
            .padding(.bottom, -4)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.parks) { park in
                        ParkListItemRow(
                            park: park
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.onParkTapped(park)
                        }
                    }
                }
            }
        }
    }
}
