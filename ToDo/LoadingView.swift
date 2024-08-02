import SwiftUI

struct LoadingCustomView: View {
	@State var show = false
	
    var body: some View {
		ZStack {
			Button(action: {
				show.toggle()
			}, label: {
				/*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
			})
			
			if show {
				GeometryReader { geo in
					VStack {
						Loader()
					}
					.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
				}
				.background(.pink)
				.opacity(0.45)
			}
		}
    }
}

#Preview {
    LoadingCustomView()
}

struct Loader: View {
	@State var animate = false
	
	var body: some View {
		VStack {
			ZStack {
				RoundedRectangle(cornerRadius: 15)
					.foregroundStyle(.white)
					.frame(width: 200, height: 150)
				VStack {
					Circle()
						.trim(from: 0.0, to: 0.8)
						.stroke(AngularGradient(gradient: Gradient(colors: [.gray, .white]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/), style: StrokeStyle(lineWidth: 8, lineCap: .round))
						.frame(width: 45, height: 45)
						.rotationEffect(.init(degrees: animate ? 360 : 0))
					Text("Loading...")
						.foregroundStyle(.gray)
						.offset(x: 0, y: 30)
				}
			}
		}
		.onAppear {
			withAnimation(.linear(duration: 0.7).repeatForever(autoreverses: false)) {
				animate.toggle()
			}
		}
	}
}
