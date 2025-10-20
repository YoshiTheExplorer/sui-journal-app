/*
/// Module: journal
module journal::journal;
*/

// For Move coding conventions, see
// https://docs.sui.io/concepts/sui-move-concepts/conventions


module journal::journal {

  use sui::clock::Clock;
  use std::string::String;

  public struct Journal has key, store {
    id: UID,
    owner: address,
    title: String,
    entries: vector<Entry>,
  }
  public struct Entry has store{
    content: String,
    create_at_ms: u64,
  }

  public fun new_journal(title: String, ctx: &mut TxContext): Journal {
    Journal {
      id: object::new(ctx),
      owner: ctx.sender(),
      title,
      entries: vector::empty(),
    }
  }

  public fun add_entry(journal: &mut Journal, content: String, clock: &Clock, ctx: &TxContext) {
    assert!(journal.owner == ctx.sender(), 0);
    let entry = Entry {
      content,
      create_at_ms: clock.timestamp_ms(),
    };
    vector::push_back(&mut journal.entries, entry);
  }
}