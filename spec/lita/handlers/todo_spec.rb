require "spec_helper"

describe Lita::Handlers::Todo, lita_handler: true do
  it { routes("todo list").to(:list) }
  it { routes("todo add test").to(:add) }
  it { routes("todo delete 1").to(:delete) }

  it "adds tasks" do
    send_message("todo add test")
    expect(replies.last).to eq "task 0 added"
  end

  it "shows tasks" do
    send_message("todo add test")
    send_message("todo")
    expect(replies.last).to eq "[0] test"
  end

  it "deletes tasks" do
    send_message("todo add test")
    send_message("todo delete 0")
    send_message("todo")
    expect(replies.last).to eq "[0] test"
  end
end
