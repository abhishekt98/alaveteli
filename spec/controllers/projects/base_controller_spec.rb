require 'spec_helper'

spec_meta = {
  type: :controller,
  feature: :projects
}

RSpec.describe Projects::BaseController, spec_meta do
  controller(Projects::BaseController) do
    def index
      head :index
    end
  end

  describe 'GET index' do
    context 'when projects are enabled' do
      let(:project) { double(:project, id: 1) }

      before do
        allow(Project).to receive(:find).with(project.id.to_s).
          and_return(project)
      end

      it 'assigns the project' do
        get :index, params: { project_id: project.id }
        expect(assigns[:project]).to eq(project)
      end

      it 'sets in_pro_area' do
        get :index, params: { project_id: project.id }
        expect(assigns(:in_pro_area)).to eq(true)
      end
    end

    context 'when project cannot be found' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          get :index, params: { project_id: 'invalid' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when projects are disabled' do
      it 'raises an ActiveRecord::RecordNotFound error' do
        expect {
          with_feature_disabled(:projects) do
            get :index
          end
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
