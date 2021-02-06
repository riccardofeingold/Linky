//
//  InformationView.swift
//  Linky
//
//  Created by Riccardo Feingold on 06.01.21.
//

import SwiftUI

struct InformationView: View {
    let linkName: String
    let link: String
    let linkText: String
    
    @State var showingShareSheet = false
    @State var startEaseOut: Bool = false
    @State var offset = CGSize.zero
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack (alignment: .leading){
            Color.white
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        
                        Text(linkName)
                            .font(Font.custom("Helvetica Neue", fixedSize: 30).weight(.bold))
                            .foregroundColor(.blue)
                            .padding(.bottom)
                        
                        Text(link)
                            .foregroundColor(.blue)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.informationViewImageSize, height: UIScreen.informationViewImageSize)
                        .padding(.trailing)
                }
                                
                Text(linkText)
                    .foregroundColor(.gray)
                    .padding()
                
                Spacer()
                
                HStack {
                    Button(action: {
                        print("Editing")
                    }, label: {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize)
                    })
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        if let url = URL(string: "https://\(link)") {
                            UIApplication.shared.open(url)
                        }
                    }, label: {
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize)
                    })
                    .padding(.trailing)
                    
                    Button(action: {
                        self.showingShareSheet = true
                    }, label: {
                        Image(systemName: "square.and.arrow.up.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize)
                    })
                    .padding(.trailing)
                    .sheet(isPresented: $showingShareSheet, content: {
                        ShareView(activityItems: [NSURL(string: "https://\(link)")!] as [Any], applicationActivities: [])
                    })
                }
            }
        }
        .frame(width: UIScreen.informationViewWidth, height: UIScreen.informationViewHeight)
        .cornerRadius(20)
        .shadow(radius: 20)
        .offset(x: 0, y: offset.height)
        .gesture(DragGesture().onChanged({ gesture in
            self.offset = gesture.translation
        })
        .onEnded({ _ in
            model.showInformation = false
            self.startEaseOut = true
        }))
        .animation(startEaseOut ? .easeOut : .none)
        .animation(.spring())
    }
}

struct ShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView(linkName: "Google", link: "www.google.com", linkText: "aölsdkfaölsdjfa alsdkjfa öal dlakj söda sö alsj").previewLayout(.sizeThatFits)
            .environmentObject(Model())
    }
}
