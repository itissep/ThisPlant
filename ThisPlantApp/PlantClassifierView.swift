import SwiftUI
import PhotosUI

struct PlantClassifierView: View {
    @StateObject var viewModel = PlantClassifierService()
    
    @State var showSelection = false
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var prediction: String?
    @State private var isLoaderAnimating: Bool = false
    
    init() { }
    
    var body: some View {
        VStack {
            Text("This Plant")
                .monospaced()
                .foregroundStyle(.accent)
                .font(.title)
                .padding(.bottom, Style.greatSpacing)
            
            Group {
                if viewModel.selectedImage != nil {
                    Image(uiImage: viewModel.selectedImage!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .clipShape(.rect(cornerRadius: Style.cornerRadius))
                        .overlay {
                            if viewModel.isLoading { loader }
                        }
                } else {
                    RoundedRectangle(cornerRadius: Style.cornerRadius)
                        .foregroundStyle(.accent)
                        .frame(width: 300, height: 300)
                        .overlay {
                            if viewModel.isLoading {
                                loader
                            } else {
                                Text("image")
                                    .monospaced()
                                    .foregroundStyle(.background)
                            }
                        }
                }
            }
            .padding(.bottom, Style.greatSpacing)
            
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) { Text("pick new image") }
                .baseButtonStyle()
                .onChange(of: selectedItem) { _, newItem in
                    viewModel.isLoading = true
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            viewModel.selectedImage = UIImage(data: data)
                            viewModel.isLoading = false
                        }
                    }
                }
            Button("which plant it is?") { viewModel.tryImage() }
                .baseButtonStyle()
                .disabled(viewModel.selectedImage == nil)
                .padding(.bottom, Style.greatSpacing)
            
            Group {
                if !viewModel.predictionsTop3.isEmpty {
                    ForEach(viewModel.predictionsTop3, id: \.name) { item in
                        HStack() {
                            Image(systemName: "\(item.place + 1).square.fill")
                                .font(.system(size: 42))
                            Text(item.name)
                            Spacer()
                            Text("\(item.confidence)")
                                .bold()
                        }
                    }
                } else {
                    HStack {
                        Image(systemName: "circle.square.fill")
                            .font(.system(size: 42))
                        Spacer()
                        Text("your plant prediction is going to be here")
                            .monospaced()
                            .foregroundStyle(.accent)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            .frame(width: 300)
            .foregroundStyle(.accent)
            .monospaced()
        }
    }
    
    private var loader: some View {
        RoundedRectangle(cornerRadius: Style.cornerRadius)
            .foregroundStyle(.accent)
            .frame(width: 300, height: 300)
            .overlay {
                Image(systemName: "circle.square.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.background)
                    .rotationEffect(.degrees(isLoaderAnimating ? 360 : 0))
                    .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isLoaderAnimating)
                    .onAppear { isLoaderAnimating = true }
                    .onDisappear { isLoaderAnimating = false }
            }
    }
}
