Rails.configuration.to_prepare do
  $event_store = RailsEventStore::Client.new
  $event_store.subscribe(Contexts::Users::Commands::Create.new, to: [UserWasCreated])
  $event_store.subscribe(Contexts::Transactions::Commands::Create.new, to: [TransactionWasCreated])
  $event_store.subscribe(Contexts::Transactions::Commands::SendSalary.new, to: [SalaryWasSentToUser])
end
