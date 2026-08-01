use tauri::{command, AppHandle, Runtime};

use crate::models::*;
use crate::Result;
use crate::VaultExt;

#[command]
pub(crate) async fn store<R: Runtime>(app: AppHandle<R>, payload: StoreRequest) -> Result<()> {
  app.vault().store(payload)
}

#[command]
pub(crate) async fn retrieve<R: Runtime>(
  app: AppHandle<R>,
  payload: RetrieveRequest,
) -> Result<RetrieveResponse> {
  app.vault().retrieve(payload)
}

#[command]
pub(crate) async fn remove<R: Runtime>(app: AppHandle<R>, payload: RemoveRequest) -> Result<()> {
  app.vault().remove(payload)
}
