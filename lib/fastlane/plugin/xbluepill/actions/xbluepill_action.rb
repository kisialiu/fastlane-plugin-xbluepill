require 'fastlane/action'
require 'fastlane/actions/scan'
require_relative '../helper/xbluepill_helper'

module Fastlane
  module Actions
    class XbluepillAction < Action
      def self.run(params)
        UI.message("The xbluepill plugin is working!")

        sh("rm -rf ./xbluepill")
        sh("rm -rf ./xbluepill_output")

        scan_options = {}
        scan_options[:workspace] = params[:workspace]
        scan_options[:scheme] = params[:scheme]
        scan_options[:build_for_testing] = true
        scan_options[:derived_data_path] = "./xbluepill"
        scan_options[:buildlog_path] = "./xbluepill/logs/"
        config = FastlaneCore::Configuration.create(Fastlane::Actions::ScanAction.available_options, scan_options)
        Fastlane::Actions::ScanAction.run(config)

        xctestrun_path = Dir.glob("./xbluepill/Build/Products/*.xctestrun")[0].to_s
        app = Dir.glob("./xbluepill/Build/Products/Debug-*/*.app")[0].to_s

        cmd = get_bp_binary.to_s

        add_required_param(cmd, "--xctestrun-path", xctestrun_path)
        add_required_param(cmd, "-o", params[:output_dir])

        add_optional_param(cmd, "-a", app)
        add_optional_param(cmd, "-c", params[:config])
        add_optional_param(cmd, "-d", params[:device])
        add_optional_param_array(cmd, "-x", params[:exclude])
        add_optional_param_array(cmd, "-i", params[:include])
        add_optional_param_not_string(cmd, "--headless", params[:headless])
        add_optional_param(cmd, "-X", params[:xcode_path])
        add_optional_param_not_string(cmd, "-J", params[:json_output])
        add_optional_param_not_string(cmd, "-j", params[:junit_output])
        add_optional_param_not_string(cmd, "-l", params[:list_tests])
        add_optional_param_not_string(cmd, "-n", params[:num_sims])
        add_optional_param_not_string(cmd, "-p", params[:plain_output])
        add_optional_param(cmd, "-P", params[:printf_config])
        add_optional_param_not_string(cmd, "-R", params[:error_retries])
        add_optional_param_not_string(cmd, "-f", params[:failure_tolerance])
        add_optional_param_not_string(cmd, "-F", params[:only_retry_failed])
        add_optional_param(cmd, "-r", params[:runtime])
        add_optional_param(cmd, "-S", params[:stuck_timeout])
        add_optional_param(cmd, "-T", params[:test_timeout])
        add_optional_param(cmd, "-t", params[:test_bundle_path])
        add_optional_param_not_string(cmd, "--additional-unit-xctests", params[:additional_unit_xctests])
        add_optional_param_not_string(cmd, "--additional-ui-xctests", params[:additional_ui_xctests])
        add_optional_param_not_string(cmd, "-C", params[:repeat_count])
        add_optional_param(cmd, "-N", params[:no_split])
        add_optional_param_not_string(cmd, "-q", params[:quiet])
        add_optional_param_not_string(cmd, "--reuse-simulator", params[:reuse_simulator])
        add_optional_param_not_string(cmd, "--diagnostics", params[:diagnostics])
        add_optional_param(cmd, "-h", params[:help])
        add_optional_param(cmd, "-u", params[:runner_app_path])
        add_optional_param(cmd, "--screenshots-directory", params[:screenshots_directory])
        add_optional_param_not_string(cmd, "-V", params[:video_paths])
        add_optional_param_not_string(cmd, "-I", params[:image_paths])

        sh(cmd)

        reset = params[:reset_simulators].to_s.empty? ? false : params[:reset_simulators]
        sh("xcrun simctl shutdown all ; export SNAPSHOT_FORCE_DELETE=true ; fastlane snapshot reset_simulators --force") if reset
      end

      def self.add_required_param(cmd, param_name, param_value)
        cmd << " #{param_name} '#{param_value}'"
      end

      def self.add_optional_param(cmd, param_name, param_value)
        cmd << " #{param_name} '#{param_value}'" unless param_value.to_s.empty?
      end

      def self.add_optional_param_not_string(cmd, param_name, param_value)
        cmd << " #{param_name} #{param_value}" unless param_value.to_s.empty?
      end

      def self.add_optional_param_array(cmd, param_name, param_value)
        cmd << " #{param_name} #{param_value.join(' -i ')}" unless param_value.to_s.empty?
      end

      def self.get_bp_binary
        File.expand_path('../../../../../../bin/bluepill', __FILE__)
      end

      def self.description
        "Fastlane plugin that allows to use bluepill (linkedin library) as a fastlane command"
      end

      def self.authors
        ["Vova"]
      end

      # Nothing to return here
      def self.return_value; end

      def self.details
        "Bluepill is powered by LinkedIn: https://github.com/linkedin/bluepill"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :scheme,
                                       env_name: "XBLUEPILL_scheme".upcase,
                                       description: "XCode scheme",
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :workspace,
                                       env_name: "XBLUEPILL_workspace".upcase,
                                       description: "XCode workspace",
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :reset_simulators,
                                       env_name: "XBLUEPILL_reset_simulators".upcase,
                                       description: "Delete and re-create all iOS and tvOS simulators",
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :output_dir,
                                       env_name: "XBLUEPILL_output_dir".upcase,
                                       description: "Directory where to put output log files (bluepill only)",
                                       optional: false,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :config,
                                       env_name: "XBLUEPILL_config".upcase,
                                       description: "Read options from the specified configuration file instead of the command line",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :device,
                                       env_name: "XBLUEPILL_device".upcase,
                                       description: "On which device to run the app",
                                       # default_value: "iPhone 6",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :exclude,
                                       env_name: "XBLUEPILL_exclude".upcase,
                                       description: "Exclude a testcase in the set of tests to run (takes priority over include)",
                                       # default_value: [],
                                       optional: true,
                                       type: Array),

          FastlaneCore::ConfigItem.new(key: :include,
                                       env_name: "XBLUEPILL_include".upcase,
                                       description: "Include a testcase in the set of tests to run (unless specified in exclude)",
                                       # default_value: [],
                                       optional: true,
                                       type: Array),

          FastlaneCore::ConfigItem.new(key: :headless,
                                       env_name: "XBLUEPILL_headless".upcase,
                                       description: "Run in headless mode (no GUI)",
                                       # default_value: false,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :xcode_path,
                                       env_name: "XBLUEPILL_xcode_path".upcase,
                                       description: "Path to xcode",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :json_output,
                                       env_name: "XBLUEPILL_json_output".upcase,
                                       description: "Print test timing information in JSON format",
                                       # default_value: false,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :junit_output,
                                       env_name: "XBLUEPILL_junit_output".upcase,
                                       description: "Print results in JUnit format",
                                       # default_value: true,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :list_tests,
                                       env_name: "XBLUEPILL_list_tests".upcase,
                                       description: "Only list tests in bundle",
                                       # default_value: true,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :num_sims,
                                       env_name: "XBLUEPILL_num_sims".upcase,
                                       description: "Number of simulators to run in parallel. (bluepill only)",
                                       # default_value: 4,
                                       optional: true,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :plain_output,
                                       env_name: "XBLUEPILL_plain_output".upcase,
                                       description: "Print results in plain text",
                                       # default_value: true,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :printf_config,
                                       env_name: "XBLUEPILL_printf_config".upcase,
                                       description: "Print a configuration file suitable for passing back using the -c option",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :error_retries,
                                       env_name: "XBLUEPILL_error_retries".upcase,
                                       description: "Number of times to recover from simulator/app crashing/hanging and continue running",
                                       # default_value: 5,
                                       optional: true,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :failure_tolerance,
                                       env_name: "XBLUEPILL_failure_tolerance".upcase,
                                       description: "Number of times to retry on test failures",
                                       # default_value: 0,
                                       optional: true,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :only_retry_failed,
                                       env_name: "XBLUEPILL_only_retry_failed".upcase,
                                       description: "When failure-tolerance > 0, only retry tests that failed",
                                       # default_value: false,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :runtime,
                                       env_name: "XBLUEPILL_runtime".upcase,
                                       description: "What runtime to use",
                                       # default_value: "iOS 11.1",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :stuck_timeout,
                                       env_name: "XBLUEPILL_stuck_timeout".upcase,
                                       description: "Timeout in seconds for a test that seems stuck (no output)",
                                       # default_value: "300s",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :test_timeout,
                                       env_name: "XBLUEPILL_test_timeout".upcase,
                                       description: "Timeout in seconds for a test that is producing output",
                                       # default_value: "300s",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :test_bundle_path,
                                       env_name: "XBLUEPILL_test_bundle_path".upcase,
                                       description: "The path to the test bundle to execute (single .xctest)",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :additional_unit_xctests,
                                       env_name: "XBLUEPILL_additional_unit_xctests".upcase,
                                       description: "Additional XCTest bundles that is not Plugin folder",
                                       optional: true,
                                       type: Array),

          FastlaneCore::ConfigItem.new(key: :additional_ui_xctests,
                                       env_name: "XBLUEPILL_additional_ui_xctests".upcase,
                                       description: "Additional XCTUITest bundles that is not Plugin folder",
                                       optional: true,
                                       type: Array),

          FastlaneCore::ConfigItem.new(key: :repeat_count,
                                       env_name: "XBLUEPILL_repeat_count".upcase,
                                       description: "Number of times we'll run the entire test suite (used for load testing)",
                                       # default_value: 1,
                                       optional: true,
                                       type: Integer),

          FastlaneCore::ConfigItem.new(key: :no_split,
                                       env_name: "XBLUEPILL_no_split".upcase,
                                       description: "Test bundles you don't want to be packed into different groups to run in parallel",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :quiet,
                                       env_name: "XBLUEPILL_quiet".upcase,
                                       description: "Turn off all output except fatal errors",
                                       # default_value: true,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :reuse_simulator,
                                       env_name: "XBLUEPILL_reuse_simulator".upcase,
                                       description: "Enable reusing simulators between test bundles",
                                       # default_value: false,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :diagnostics,
                                       env_name: "XBLUEPILL_diagnostics".upcase,
                                       description: "Enable collection of diagnostics in outputDir in case of test failures",
                                       # default_value: false,
                                       optional: true,
                                       type: TrueClass),

          FastlaneCore::ConfigItem.new(key: :help,
                                       env_name: "XBLUEPILL_help".upcase,
                                       description: "Help",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :runner_app_path,
                                       env_name: "XBLUEPILL_runner_app_path".upcase,
                                       description: "The test runner for UI tests",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :screenshots_directory,
                                       env_name: "XBLUEPILL_screenshots_directory".upcase,
                                       description: "Directory where simulator screenshots for failed ui tests will be stored",
                                       optional: true,
                                       type: String),

          FastlaneCore::ConfigItem.new(key: :video_paths,
                                       env_name: "XBLUEPILL_video_paths".upcase,
                                       description: "A list of videos that will be saved in the simulators",
                                       optional: true,
                                       type: Array),

          FastlaneCore::ConfigItem.new(key: :image_paths,
                                       env_name: "XBLUEPILL_image_paths".upcase,
                                       description: "A list of images that will be saved in the simulators",
                                       optional: true,
                                       type: Array)
        ]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
