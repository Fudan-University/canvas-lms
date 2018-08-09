#
# Copyright (C) 2017 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under the
# terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../helpers/graphql_type_tester')

describe Types::AssignmentGroupType do

  context "AssignmentGroup" do

    before(:once) do
      course_with_student(active_all: true)
      @group = @course.assignment_groups.create!(name: 'a group')
      @assignment = @course.assignments.create!(name: 'a assignment')

      @other_group = @course.assignment_groups.create!(name: "other group")
      @other_assignment = @course.assignments.create!(
        name: "other",
        assignment_group: @other_group,
      )
    end

    before do
      @group_type = GraphQLTypeTester.new(Types::AssignmentGroupType, @group)
    end

    it "returns information about the group" do
      expect(@group_type.name).to eq("a group")
    end

    it "returns assignments from the assignment group" do
      expect(@group_type.assignmentsConnection).to eq [@assignment]
    end
  end
end
