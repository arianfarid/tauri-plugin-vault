<script>
  import { set, get, remove } from 'tauri-plugin-vault-api'

  let setKey = $state('')
  let setValue = $state('')
  let setMsg = $state('')

  let getKey = $state('')
  let getValue = $state('')

  let removeKey = $state('')
  let removeMsg = $state('')

  async function onSet() {
    try {
      await set({ key: setKey, value: setValue })
      setMsg = `Stored "${setKey}"`
    } catch (e) {
      setMsg = `Error: ${e}`
    }
  }

  async function onGet() {
    try {
      const v = await get(getKey)
      getValue = v === null ? '(not found)' : v
    } catch (e) {
      getValue = `Error: ${e}`
    }
  }

  async function onRemove() {
    try {
      await remove(removeKey)
      removeMsg = `Removed "${removeKey}"`
    } catch (e) {
      removeMsg = `Error: ${e}`
    }
  }
</script>

<main class="container">
  <h1>Vault</h1>

  <div class="row">
    <input placeholder="key" bind:value={setKey} />
    <input placeholder="value" bind:value={setValue} />
    <button onclick={onSet}>Set</button>
    <span>{setMsg}</span>
  </div>

  <div class="row">
    <input placeholder="key" bind:value={getKey} />
    <button onclick={onGet}>Get</button>
    <span>{getValue}</span>
  </div>

  <div class="row">
    <input placeholder="key" bind:value={removeKey} />
    <button onclick={onRemove}>Remove</button>
    <span>{removeMsg}</span>
  </div>
</main>

<style>
  .container {
    padding: 16px;
    padding-top: 8vh;
    gap: 16px;
    text-align: left;
  }

  .row {
    flex-wrap: wrap;
    justify-content: flex-start;
    align-items: center;
    gap: 8px;
    margin-bottom: 12px;
  }

  .row input {
    flex: 1 1 120px;
    min-width: 0;
  }

  .row button {
    flex: 0 0 auto;
  }

  .row span {
    flex-basis: 100%;
    color: #646cff;
  }
</style>
