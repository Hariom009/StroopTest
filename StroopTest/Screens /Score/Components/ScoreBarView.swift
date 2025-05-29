

//import SwiftUI
//
//struct ScoreBarView: View {
//    var body: some View {
//        // Score bar visualization
//        ZStack(alignment: .leading) {
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color.gray.opacity(0.3))
//                .frame(height: 8)
//            
//            RoundedRectangle(cornerRadius: 10)
//                .fill(
//                    LinearGradient(
//                        colors: getScoreGradientColors(),
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                )
//                .frame(width: CGFloat(animatedScore) * 2.2, height: 8)
//                .animation(.easeInOut(duration: 2), value: animatedScore)
//        }
//        .frame(maxWidth: 220)
//        .opacity(scoreOpacity)
//    }
//}
//
//#Preview {
//    ScoreBarView()
//}
