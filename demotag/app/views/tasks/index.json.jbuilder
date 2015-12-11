json.array!(@tasks) do |task|
  json.extract! task, :id, :owner, :date, :price, :detail, :location
  json.url task_url(task, format: :json)
end
