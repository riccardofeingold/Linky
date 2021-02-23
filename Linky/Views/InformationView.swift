//
//  InformationView.swift
//  Linky
//
//  Created by Riccardo Feingold on 06.01.21.
//

import SwiftUI

struct InformationView: View {
    let link: String
    
    @State var linkName: String
    @State var disableEditing: Bool = true
    @State var linkText: String
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
                        
                        TextEditor(text: $linkName)
                            .font(Font.custom("Helvetica Neue", fixedSize: 30).weight(.bold))
                            .foregroundColor(.blue)
                            .padding(.bottom)
                            .lineLimit(1)
                            .disabled(disableEditing == true)
                        
                        Text(link)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.informationViewImageSize, height: UIScreen.informationViewImageSize)
                        .padding(.trailing)
                }
                                
                TextEditor(text: $linkText)
                    .foregroundColor(.gray)
                    .padding()
                    .disabled(disableEditing == true)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        disableEditing.toggle()
                    }, label: {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize)
                    })
                    .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        if let url = URL(string: link) {
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
                        ShareView(activityItems: [NSURL(string: link)!] as [Any], applicationActivities: nil)
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
            if abs(self.offset.height) > 200 {
                withAnimation(.easeOut){
                    self.offset = CGSize(width: CGFloat(0), height: CGFloat(-UIScreen.screenHeight))
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    model.showInformation = false
    
                }
            }else {
                withAnimation(.spring()){
                    self.offset = .zero
                }
            }
        }))
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
        InformationView(link: "www.google.com", linkName: "Google", linkText: "aölsdkfaölsdjfa")
            .environmentObject(Model())
    }
}
