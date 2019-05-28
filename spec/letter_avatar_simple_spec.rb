require "spec_helper"

def image_compare(path1, path2)
  Imatcher::Matcher.new.compare(path1, path2)
end

describe "LetterAvatarSimple" do
  context "#generate" do
    context "with the default options" do
      context "given 'foobar'" do
        let(:image) { LetterAvatarSimple.generate("foobar") }
        let(:fixture_path) { image_fixture_path("foobar.png") }

        it "generates the correct image" do
          expect(image_compare(stringio_to_file(image).path, fixture_path)).to be_match
        end
      end

      context "given 'Dallas Smith'" do
        let(:image) { LetterAvatarSimple.generate("Dallas Smith") }
        let(:fixture_path) { image_fixture_path("Dallas Smith.png") }

        it "generates the correct image" do
          expect(image_compare(stringio_to_file(image).path, fixture_path)).to be_match
        end
      end
    end

    context "with a bunch of options provided" do
      let(:image) {
        LetterAvatarSimple.generate(
          "foobar",
          size: 256,
          palette: :i_want_hue,
          pointsize: 50,
          weight: 100,
          fill_color: "rgba(0, 255, 255, 1)",
          annotate_position: "-20+20",
        )
      }
      let(:fixture_path) { image_fixture_path("integration.png") }

      it "generates the correct image" do
        expect(image_compare(stringio_to_file(image).path, fixture_path)).to be_match
      end
    end
  end
end
