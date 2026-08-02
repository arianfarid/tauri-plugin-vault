import XCTest

@testable import tauri_plugin_vault

final class KeychainTests: XCTestCase {
  private var keychain: Keychain!
  private var service: String!

  override func setUp() {
    super.setUp()
    service = "com.plugin.tauri-plugin-vault.tests.\(UUID().uuidString)"
    keychain = Keychain(service: service)
  }

  override func tearDown() {
    keychain = nil
    service = nil
    super.tearDown()
  }

  func testSetThenGetReturnsValue() throws {
    try keychain.set(key: "token", value: "secret")

    XCTAssertEqual(try keychain.get(key: "token"), "secret")
  }

  func testGetMissingKeyReturnsNil() throws {
    XCTAssertNil(try keychain.get(key: "does-not-exist"))
  }

  func testSetOverwritesExistingValue() throws {
    try keychain.set(key: "token", value: "first")
    try keychain.set(key: "token", value: "second")

    XCTAssertEqual(try keychain.get(key: "token"), "second")
  }

  func testRemoveDeletesValue() throws {
    try keychain.set(key: "token", value: "secret")

    try keychain.remove(key: "token")

    XCTAssertNil(try keychain.get(key: "token"))
  }

  func testRemoveMissingKeyDoesNotThrow() throws {
    XCTAssertNoThrow(try keychain.remove(key: "does-not-exist"))
  }

  func testKeysAreScopedIndependently() throws {
    try keychain.set(key: "a", value: "1")
    try keychain.set(key: "b", value: "2")

    XCTAssertEqual(try keychain.get(key: "a"), "1")
    XCTAssertEqual(try keychain.get(key: "b"), "2")

    try keychain.remove(key: "a")

    XCTAssertNil(try keychain.get(key: "a"))
    XCTAssertEqual(try keychain.get(key: "b"), "2")
  }

  func testValueRoundTripsUnicode() throws {
    let value = "pä$$wörd 🔐 日本語"
    try keychain.set(key: "unicode", value: value)

    XCTAssertEqual(try keychain.get(key: "unicode"), value)
  }
}
