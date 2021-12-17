import Foundation
import QuickLook
import SwiftUI

/// SwiftUI обертка для QLPreviewController
/// ```
/// // Пример вызова
///     .fullScreenCover(isPresented: $viewModel.isShowPreview) {
///          GXQuickLookView(url: $viewModel.fileURL, isPresented: $viewModel.isShowPreview)
///             .ignoresSafeArea()
///             .preferredColorScheme(.light)
///       }
/// ```
public struct GXQuickLookView: UIViewControllerRepresentable {
    @Binding var url: URL?
    @Binding var isPresented: Bool
    
    /// Инит для показа QLPreviewController
    /// - Parameters:
    ///   - url: URL файла для показа
    ///   - isPresented: флаг для скрытия/показа шторки
    public init(url: Binding<URL?>, isPresented: Binding<Bool>) {
        _url = url
        _isPresented = isPresented
    }

    public func makeUIViewController(context: Context) -> UINavigationController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.dismiss)
        )

        let navigationController = UINavigationController(rootViewController: controller)
        return navigationController
    }

    public func updateUIViewController(_: UINavigationController, context _: Context) {}

    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    public class Coordinator: QLPreviewControllerDataSource {
        let parent: GXQuickLookView

        public  init(parent: GXQuickLookView) {
            self.parent = parent
        }

        public func numberOfPreviewItems(in _: QLPreviewController) -> Int {
            return 1
        }

        public func previewController(_: QLPreviewController, previewItemAt _: Int) -> QLPreviewItem {
            return parent.url! as QLPreviewItem
        }

        @objc func dismiss() {
            parent.isPresented = false
        }
    }
}
