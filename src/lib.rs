#![cfg(mobile)]

use tauri::{
  plugin::{Builder, TauriPlugin},
  Manager, Runtime,
};

pub use models::*;

#[cfg(mobile)]
mod commands;
mod error;
#[cfg(mobile)]
mod mobile;
mod models;

pub use error::{Error, Result};

use mobile::Vault;

/// Extensions to [`tauri::App`], [`tauri::AppHandle`] and [`tauri::Window`] to access the vault APIs.
pub trait VaultExt<R: Runtime> {
  fn vault(&self) -> &Vault<R>;
}

impl<R: Runtime, T: Manager<R>> crate::VaultExt<R> for T {
  fn vault(&self) -> &Vault<R> {
    self.state::<Vault<R>>().inner()
  }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
  Builder::new("vault")
    .invoke_handler(tauri::generate_handler![
      commands::set,
      commands::get,
      commands::remove
    ])
    .setup(|app, api| {
      #[cfg(mobile)]
      {
        let vault = mobile::init(app, api)?;
        app.manage(vault);
      }
      Ok(())
    })
    .build()
}
