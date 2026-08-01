import SwiftRs
import Tauri
import UIKit
import WebKit

class PingArgs: Decodable {
  let value: String?
}

class VaultPlugin: Plugin {
  @objc public func set(_ invoke: Invoke) throws {
    let args = try invoke.parseArgs(PingArgs.self)
    invoke.resolve(["value": args.value ?? ""])
  }
}

@_cdecl("init_plugin_vault")
func initPlugin() -> Plugin {
  return VaultPlugin()
}
