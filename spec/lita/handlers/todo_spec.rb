require "spec_helper"

describe Lita::Handlers::Todo, lita_handler: true do
  it { routes("todo").to(:list) }
  it { routes("todo add test").to(:add) }
  it { routes("todo delete 1").to(:delete) }
  
  it 'handles empty todo' do
    send_message("todo")
    expect(replies.last).to eq "todo list is empty"
  end

  it "adds tasks" do
    send_message("todo add test")
    expect(replies.last).to eq "task 0 added"
  end

  it "shows tasks" do
    send_message("todo add test")
    expect(replies.last).to eq "task 0 added"
    send_message("todo")
    expect(replies.last).to eq "[0] test"
  end

  it "deletes tasks" do
    send_message("todo add test")
    expect(replies.last).to eq "task 0 added"
    send_message("todo delete 0")
    expect(replies.last).to eq "task 0 (test) deleted"
    send_message("todo")
    expect(replies.last).to eq "todo list is empty"
  end
end
