require 'test_helper'

class RoleTypePresenterTest < ActiveSupport::TestCase
  test "should generate options for select" do
    expected = [
      ["cabinet_minister", "Cabinet minister"],
      ["other_minister", "Other minister"],
      ["permanent_secretary", "Permanent secretary"],
      ["other_board_member", "Other board member"],
      ["chief_of_the_defence_staff", "Chief of the defence staff"],
      ["chief_of_staff", "Chief of staff"]
    ]
    assert_equal expected, RoleTypePresenter.options
  end

  test "should select cabinet minister" do
    role = build(:role, type: "MinisterialRole", cabinet_member: true)
    assert_equal "cabinet_minister", RoleTypePresenter.option_value_for(role)
  end

  test "should select other minister" do
    role = build(:role, type: "MinisterialRole", cabinet_member: false)
    assert_equal "other_minister", RoleTypePresenter.option_value_for(role)
  end

  test "should select permanent secretary" do
    role = build(:role, type: "BoardMemberRole", permanent_secretary: true)
    assert_equal "permanent_secretary", RoleTypePresenter.option_value_for(role)
  end

  test "should select other board member" do
    role = build(:role, type: "BoardMemberRole", permanent_secretary: false)
    assert_equal "other_board_member", RoleTypePresenter.option_value_for(role)
  end

  test "should select chief of the defence staff" do
    role = build(:role, type: "MilitaryRole", chief_of_the_defence_staff: true)
    assert_equal "chief_of_the_defence_staff", RoleTypePresenter.option_value_for(role)
  end

  test "should select chief of staff" do
    role = build(:role, type: "MilitaryRole", chief_of_the_defence_staff: false)
    assert_equal "chief_of_staff", RoleTypePresenter.option_value_for(role)
  end

  test "should select cabinet minister by default" do
    role = build(:role, type: nil)
    assert_equal "cabinet_minister", RoleTypePresenter.option_value_for(role)
  end

  test "should generate attributes for cabinet minister" do
    expected = {type: "MinisterialRole", cabinet_member: true, permanent_secretary: false, chief_of_the_defence_staff: false}
    assert_equal expected, RoleTypePresenter.role_attributes_from(type: "cabinet_minister")
  end

  test "should generate attributes for other minister" do
    expected = {type: "MinisterialRole", cabinet_member: false, permanent_secretary: false, chief_of_the_defence_staff: false}
    assert_equal expected, RoleTypePresenter.role_attributes_from(type: "other_minister")
  end

  test "should generate attributes for permanent secretary" do
    expected = {type: "BoardMemberRole", cabinet_member: false, permanent_secretary: true, chief_of_the_defence_staff: false}
    assert_equal expected, RoleTypePresenter.role_attributes_from(type: "permanent_secretary")
  end

  test "should generate attributes for other board member" do
    expected = {type: "BoardMemberRole", cabinet_member: false, permanent_secretary: false, chief_of_the_defence_staff: false}
    assert_equal expected, RoleTypePresenter.role_attributes_from(type: "other_board_member")
  end

  test "should generate attributes for chief of the defence staff" do
    expected = {type: "MilitaryRole", cabinet_member: false, permanent_secretary: false, chief_of_the_defence_staff: true}
    assert_equal expected, RoleTypePresenter.role_attributes_from(type: "chief_of_the_defence_staff")
  end

  test "should generate attributes for chief of staff" do
    expected = {type: "MilitaryRole", cabinet_member: false, permanent_secretary: false, chief_of_the_defence_staff: false}
    assert_equal expected, RoleTypePresenter.role_attributes_from(type: "chief_of_staff")
  end

  test "should generate attributes for cabinet minister by default" do
    expected = {type: "MinisterialRole", cabinet_member: true, permanent_secretary: false, chief_of_the_defence_staff: false}
    assert_equal expected, RoleTypePresenter.role_attributes_from(type: nil)
  end
end
