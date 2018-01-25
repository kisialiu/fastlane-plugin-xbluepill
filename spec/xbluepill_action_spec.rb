describe Fastlane::Actions::XbluepillAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The xbluepill plugin is working!")

      Fastlane::Actions::XbluepillAction.run(nil)
    end
  end
end
