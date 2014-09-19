# == Schema Information
#
# Table name: public_body_headings
#
#  id            :integer        not null, primary key
#  locale        :string
#  name          :text           not null
#  display_order :integer
#

require 'spec_helper'

describe PublicBodyHeading, 'when loading the data' do

    before do
        load_test_categories
    end

    it 'should use the display_order field to preserve the original data order' do
        headings = PublicBodyHeading.all
        headings[0].name.should eq 'Local and regional'
        headings[0].display_order.should eq 1
        headings[1].name.should eq 'Miscellaneous'
        headings[1].display_order.should eq 2
    end

end

describe PublicBodyHeading, 'when validating' do

    it 'should require a name' do
        heading = PublicBodyHeading.new
        heading.should_not be_valid
        heading.errors[:name].should == ["Name can't be blank"]
    end

    it 'should require a unique name' do
        heading = FactoryGirl.create(:silly_heading)
        new_heading = PublicBodyHeading.new(:name => heading.name)
        new_heading.should_not be_valid
        new_heading.errors[:name].should == ["Name is already taken"]
    end

    it 'should set a default display order based on the next available display order' do
        heading = PublicBodyHeading.new
        heading.valid?
        heading.display_order.should == PublicBodyHeading.next_display_order
    end

end

describe PublicBodyHeading, 'when setting a display order' do

    it 'should return 0 if there are no public body headings' do
        PublicBodyHeading.next_display_order.should == 0
    end

    it 'should return one more than the highest display order if there are public body headings' do
        heading = FactoryGirl.create(:popular_heading)
        PublicBodyHeading.next_display_order.should == 2
    end

end
