use serde::de::DeserializeOwned;
use tauri::{
  plugin::{PluginApi, PluginHandle},
  AppHandle, Runtime,
};

use crate::models::*;

#[cfg(target_os = "ios")]
tauri::ios_plugin_binding!(init_plugin_vault);

// initializes the Kotlin or Swift plugin classes
pub fn init<R: Runtime, C: DeserializeOwned>(
  _app: &AppHandle<R>,
  api: PluginApi<R, C>,
) -> crate::Result<Vault<R>> {
  #[cfg(target_os = "android")]
  let handle = api.register_android_plugin("com.plugin.tauri-plugin-vault", "ExamplePlugin")?;
  #[cfg(target_os = "ios")]
  let handle = api.register_ios_plugin(init_plugin_vault)?;
  Ok(Vault(handle))
}

/// Access to the vault APIs.
pub struct Vault<R: Runtime>(PluginHandle<R>);

impl<R: Runtime> Vault<R> {
  pub fn set(&self, payload: SetRequest) -> crate::Result<()> {
    self.0.run_mobile_plugin("set", payload).map_err(Into::into)
  }
  pub fn get(&self, payload: GetRequest) -> crate::Result<GetResponse> {
    self.0.run_mobile_plugin("get", payload).map_err(Into::into)
  }
  pub fn remove(&self, payload: RemoveRequest) -> crate::Result<()> {
    self
      .0
      .run_mobile_plugin("remove", payload)
      .map_err(Into::into)
  }
}
