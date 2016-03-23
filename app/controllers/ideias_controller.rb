# encoding: utf-8

class Prodam::Idealize::IdeiasController < Prodam::Idealize::ApplicationController
  helpers Prodam::Idealize::IdeiasHelper

  before do
    @page = controllers[:ideias_controller]
  end

  get '/nova', authenticate: true do
    @ideia = Prodam::Idealize::Ideia.new
    @categorias = Prodam::Idealize::Categoria.all
    view 'ideias/form'
  end

  post '/' do
    params[:ideia].to_s
  end

  get '/' do
    @ideias = Prodam::Idealize::Ideia.latest(5)
    @ideia = Prodam::Idealize::Ideia.new
    view 'ideias/index'
  end
  
  get '/:id' do |id|
    @ideia = Prodam::Idealize::Ideia[id.to_i]
    view 'ideias/page'
  end

  get '/autor/:autor_id' do |autor_id|
    @ideias = Prodam::Idealize::Ideia.all_by_autor(autor_id.to_i)
    @ideias.to_s
  end
end
