import Foundation
import Security

final class Keychain {
  private let service: String

  init(service: String = "com.plugin.tauri-plugin-vault") {
    self.service = service
  }

  func set(key: String, value: String) throws {
    guard let data = value.data(using: .utf8) else {
      throw KeychainError.invalidString
    }

    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key,
    ]

    let attributes: [CFString: Any] = [
      kSecValueData: data
    ]

    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

    switch status {
    case errSecSuccess:
      return

    case errSecItemNotFound:
      var item = query
      item[kSecValueData] = data

      let addStatus = SecItemAdd(item as CFDictionary, nil)

      guard addStatus == errSecSuccess else {
        throw KeychainError.osStatus(addStatus)
      }

    default:
      throw KeychainError.osStatus(status)
    }
  }

  func get(key: String) throws -> String? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key,
      kSecReturnData: true,
      kSecMatchLimit: kSecMatchLimitOne,
    ]

    var result: CFTypeRef?

    let status = SecItemCopyMatching(query as CFDictionary, &result)

    switch status {
    case errSecSuccess:
      guard
        let data = result as? Data,
        let string = String(data: data, encoding: .utf8)
      else {
        throw KeychainError.invalidData
      }

      return string

    case errSecItemNotFound:
      return nil

    default:
      throw KeychainError.osStatus(status)
    }
  }

  func remove(key: String) throws {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: service,
      kSecAttrAccount: key,
    ]

    let status = SecItemDelete(query as CFDictionary)

    switch status {
    case errSecSuccess, errSecItemNotFound:
      return

    default:
      throw KeychainError.osStatus(status)
    }
  }
}

enum KeychainError: Error {
  case invalidString
  case invalidData
  case osStatus(OSStatus)
}
