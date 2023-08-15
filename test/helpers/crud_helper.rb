module CRUDHelper
  def get_list(module_name, token = nil)
    get "/api/v1/#{module_name}/list", 
      xhr: true
  end

  def get_item(module_name, id, token = nil)
    get "/api/v1/#{module_name}/#{id}", 
      xhr: true
  end

  def create_item(module_name, params, token = nil)
    post "/api/v1/#{module_name}", 
      params: params,
      xhr: true,
      headers: { 'Authorization' => "Bearer #{token}" }
  end

  def update_item(module_name, id, params, token = nil)
    patch "/api/v1/#{module_name}/#{id}", 
      params: params,
      xhr: true,
      headers: { 'Authorization' => "Bearer #{token}" }
  end

  def delete_item(module_name, id, token = nil)
    delete "/api/v1/#{module_name}/#{id}",
      xhr: true,
      headers: { 'Authorization' => "Bearer #{token}" }
  end
end