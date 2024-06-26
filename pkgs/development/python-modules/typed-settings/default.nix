{ lib
, attrs
, buildPythonPackage
, cattrs
, click
, click-option-group
, fetchPypi
, hatchling
, pytestCheckHook
, pythonOlder
, tomli
, typing-extensions
}:

buildPythonPackage rec {
  pname = "typed-settings";
  version = "24.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "typed_settings";
    inherit version;
    hash = "sha256-luUfVsN6uNYZkXfcAUc5P6Y+WYpfAdU6D01kgQMNniw=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    click-option-group
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies = {
    click = [
      click
    ];
  };

  checkInputs = [
    pytestCheckHook
    typing-extensions
  ] ++ passthru.optional-dependencies.click;

  pytestFlagsArray = [
    "tests"
  ];

  disabledTests = [
    # AssertionError: assert [OptionInfo(p...
    "test_deep_options"
  ];

  pythonImportsCheck = [
    "typed_settings"
  ];

  meta = {
    description = "Typed settings based on attrs classes";
    homepage = "https://gitlab.com/sscherfke/typed-settings";
    changelog = "https://gitlab.com/sscherfke/typed-settings/-/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
