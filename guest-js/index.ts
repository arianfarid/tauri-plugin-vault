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
export async function set(vaultRequest: VaultRequest): Promise<void> {
  return await invoke<void>('plugin:vault|set', {
    payload: {
      ...vaultRequest,
    },
  })
}

/**
 * Retrieves value from native keystore.
 *
 * @param key VaultKey a key (string) used to retrieve data.
 */
export async function get(key: VaultKey): Promise<string | null> {
  const { value } = await invoke<{ value: string | null }>('plugin:vault|get', {
    payload: {
      key,
    },
  })
  return value
}

/**
 * Removes value from native keystore.
 *
 * @param key VaultKey a key (string) used to remove data.
 * @returns {Promise<void>}
 */
export async function remove(key: VaultKey): Promise<void> {
  return await invoke<void>('plugin:vault|remove', {
    payload: {
      key,
    },
  })
}
