import { invoke } from '@tauri-apps/api/core'

export type VaultKey = string

export interface VaultRequest {
  key: VaultKey
  value: string
}

/**
 * Stores value in native keystore.
 *
 * @param vaultRequest VaultRequest
 * @returns
 */
export async function store(vaultRequest: VaultRequest): Promise<void> {
  return await invoke<void>('plugin:vault|store', {
    payload: {
      ...vaultRequest,
    },
  })
}

/**
 * Retrieves value from native keystore.
 */
export async function retrieve(key: VaultKey): Promise<string | null> {
  return await invoke<string | null>('plugin:vault|retrieve', {
    payload: {
      key,
    },
  })
}

/**
 * Retrieves value from native keystore.
 *
 * @param key VaultKey a key (string) used to retreive data.
 * @returns {Promise<void>}
 */
export async function remove(key: VaultKey): Promise<void> {
  return await invoke<void>('plugin:vault|remove', {
    payload: {
      key,
    },
  })
}
