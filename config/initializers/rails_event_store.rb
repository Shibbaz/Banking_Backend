Rails.configuration.to_prepare do
    $event_store = RailsEventStore::Client.new
    $event_store.subscribe(Contexts::Users::Commands::Create.new, to: [UserWasCreated])
    $event_store.subscribe(Contexts::Users::Commands::Update.new, to: [UserWasUpdated])
    $event_store.subscribe(Contexts::Users::Commands::Delete.new, to: [UserWasDeleted])
end
