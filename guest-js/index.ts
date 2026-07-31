import { invoke } from "@tauri-apps/api/core";

export type VaultKey = string;

export interface VaultRequest {
  key: VaultKey;
  value: string;
}

export async function store(payload: VaultRequest) {}
export async function retrieve(key: VaultKey) {}
export async function remove(key: VaultKey) {}
