#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2024 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See COPYRIGHT and LICENSE files for more details.
#++

require 'spec_helper'

RSpec.describe Queries::WorkPackages::Filter::PriorityFilter do
  let(:priority) { build_stubbed(:priority) }

  it_behaves_like 'basic query filter' do
    let(:type) { :list }
    let(:class_key) { :priority_id }

    describe '#available?' do
      it 'is true if any group exists' do
        allow(IssuePriority)
          .to receive_message_chain(:active, :exists?)
          .and_return true

        expect(instance).to be_available
      end

      it 'is false if no group exists' do
        allow(IssuePriority)
          .to receive_message_chain(:active, :exists?)
          .and_return false

        expect(instance).not_to be_available
      end
    end

    describe '#allowed_values' do
      before do
        allow(IssuePriority)
          .to receive(:active)
          .and_return [priority]
      end

      it 'is an array of group values' do
        expect(instance.allowed_values)
          .to contain_exactly([priority.name, priority.id.to_s])
      end
    end

    describe '#ar_object_filter?' do
      it 'is true' do
        expect(instance)
          .to be_ar_object_filter
      end
    end

    describe '#value_objects' do
      let(:priority2) { build_stubbed(:priority) }

      before do
        allow(IssuePriority)
          .to receive(:active)
          .and_return([priority, priority2])

        instance.values = [priority2.id.to_s]
      end

      it 'returns an array of priorities' do
        expect(instance.value_objects)
          .to contain_exactly(priority2)
      end
    end
  end
end
