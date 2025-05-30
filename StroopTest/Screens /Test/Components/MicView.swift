//
//  MicView.swift
//  StroopTest
//
//  Created by Hari's Mac on 28.05.2025.
//

import SwiftUI

struct MicView: View {
    @State var color:Color
    @Binding var isRecording:Bool
    @Binding var searchText:String
    // default values
    var placeHolder:String
    var placeHolderColor:Color
    var micIconWidth:CGFloat
    var micIconHeight:CGFloat
    var textFieldSize:CGFloat
    public init(color: Color = .gray, isRecording: Binding<Bool>, searchText: Binding<String>, placeHolder: String = "Search", placeHolderColor: Color = Color.gray, micIconWidth: CGFloat = 15, micIconHeight: CGFloat = 25, textFieldSize: CGFloat = 25) {
        self.color = color
        self._isRecording = isRecording
        self._searchText = searchText
        self.placeHolder = placeHolder
        self.placeHolderColor = placeHolderColor
        self.micIconWidth = micIconWidth
        self.micIconHeight = micIconHeight
        self.textFieldSize = textFieldSize
    }
    public var body: some View{
        HStack{
            Spacer()
            TextField("", text: $searchText,prompt: Text(placeHolder).foregroundColor(placeHolderColor))
                .font(.system(size: textFieldSize))
            Image(systemName: "mic.fill")
                .resizable()
                .frame(width: micIconWidth, height: micIconHeight)
                .foregroundStyle( color )
                .onTapGesture {
                    isRecording.toggle()
                }
            Spacer()
        }
        .padding()
        .overlay{
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black, lineWidth: 2.0)
        }
        .padding()
        .sheet(isPresented: $isRecording){
            SwiftUIView(isRecording: self.$isRecording, searchText: self.$searchText, color: self.$color)
                .presentationDetents([.medium, .fraction(0.5)])
                .presentationDragIndicator(.visible)
        }
    }
}

