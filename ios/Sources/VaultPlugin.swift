import SwiftRs
import Tauri
import UIKit
import WebKit

class SetArgs: Decodable {
  let key: String
  let value: String
}

class GetArgs: Decodable {
  let key: String
}

class RemoveArgs: Decodable {
  let key: String
}

class VaultPlugin: Plugin {
  private let keychain = Keychain()

  @objc public func set(_ invoke: Invoke) throws {
    let args = try invoke.parseArgs(SetArgs.self)

    try keychain.set(
      key: args.key,
      value: args.value
    )
    invoke.resolve()
  }

  @objc public func get(_ invoke: Invoke) throws {
    let args = try invoke.parseArgs(GetArgs.self)

    let value = try keychain.get(key: args.key)

    invoke.resolve([
      "value": value
    ])
  }

  @objc public func remove(_ invoke: Invoke) throws {
    let args = try invoke.parseArgs(RemoveArgs.self)

    try keychain.remove(key: args.key)

    invoke.resolve()
  }
}

@_cdecl("init_plugin_vault")
func initPlugin() -> Plugin {
  return VaultPlugin()
}
