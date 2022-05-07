// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
public enum L10n {

  public enum Alert {
    public enum CameraPermissionPrompt {
      /// カメラを利用する権限がありません。「設定」アプリから許可してください。
      public static let message = L10n.tr("Localizable", "alert.camera_permission_prompt.message")
    }
    public enum CameraUnavailable {
      /// カメラが利用できない端末です。
      public static let message = L10n.tr("Localizable", "alert.camera_unavailable.message")
    }
    public enum DeletePhoto {
      /// この写真を削除してもよろしいですか？
      public static let message = L10n.tr("Localizable", "alert.delete_photo.message")
    }
    public enum LocationPermissionDenied {
      /// 位置情報を取得する権限がありません。「設定」アプリから許可してください。
      public static let message = L10n.tr("Localizable", "alert.location_permission_denied.message")
    }
    public enum UnVisit {
      /// 「%@」に訪れた記録を削除してもよろしいですか？
      public static func message(_ p1: Any) -> String {
        return L10n.tr("Localizable", "alert.un_visit.message", String(describing: p1))
      }
    }
  }

  public enum Common {
    /// キャンセル
    public static let cancel = L10n.tr("Localizable", "common.cancel")
    /// 削除
    public static let delete = L10n.tr("Localizable", "common.delete")
    /// エラー
    public static let error = L10n.tr("Localizable", "common.error")
    /// OK
    public static let ok = L10n.tr("Localizable", "common.ok")
  }

  public enum ParkDetail {
    public enum Photo {
      /// 完了
      public static let complete = L10n.tr("Localizable", "park_detail.photo.complete")
      /// 編集
      public static let edit = L10n.tr("Localizable", "park_detail.photo.edit")
      /// 写真
      public static let title = L10n.tr("Localizable", "park_detail.photo.title")
    }
    public enum Stamp {
      /// 訪れた証にタップしてみましょう
      public static let prompt = L10n.tr("Localizable", "park_detail.stamp.prompt")
    }
  }

  public enum ParkList {
    /// 検索
    public static let searchPlaceholder = L10n.tr("Localizable", "park_list.search_placeholder")
    /// 多摩公園ラリー (%@)
    public static func title(_ p1: Any) -> String {
      return L10n.tr("Localizable", "park_list.title", String(describing: p1))
    }
    /// 未訪問
    public static let unvisited = L10n.tr("Localizable", "park_list.unvisited")
  }

  public enum TabTitle {
    /// 一覧
    public static let list = L10n.tr("Localizable", "tab_title.list")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
