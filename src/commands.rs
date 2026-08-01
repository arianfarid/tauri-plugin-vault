use tauri::{command, AppHandle, Runtime};

use crate::models::*;
use crate::Result;
use crate::VaultExt;

#[command]
pub(crate) async fn set<R: Runtime>(app: AppHandle<R>, payload: SetReqest) -> Result<()> {
  app.vault().set(payload)
}

#[command]
pub(crate) async fn get<R: Runtime>(app: AppHandle<R>, payload: GetRequest) -> Result<GetResponse> {
  app.vault().get(payload)
}

#[command]
pub(crate) async fn remove<R: Runtime>(app: AppHandle<R>, payload: RemoveRequest) -> Result<()> {
  app.vault().remove(payload)
}
