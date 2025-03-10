{ lib
, buildPythonPackage
, fetchPypi
, grpc-google-iam-v1
, google-cloud-core
, google-cloud-testutils
, libcst
, mock
, proto-plus
, pytestCheckHook
, pytest-asyncio
, sqlparse
, pythonOlder
}:

buildPythonPackage rec {
  pname = "google-cloud-spanner";
  version = "3.22.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lJn1x77C1oiYFZqTRQGCop/1DQ8OsrqRH42bnxJ7Xio=";
  };

  propagatedBuildInputs = [
    google-cloud-core
    grpc-google-iam-v1
    libcst
    proto-plus
    sqlparse
  ];

  checkInputs = [
    google-cloud-testutils
    mock
    pytestCheckHook
    pytest-asyncio
  ];

  preCheck = ''
    # prevent google directory from shadowing google imports
    rm -r google
  '';

  disabledTestPaths = [
    # Requires credentials
    "tests/system/test_backup_api.py"
    "tests/system/test_database_api.py"
    "tests/system/test_dbapi.py"
    "tests/system/test_instance_api.py"
    "tests/system/test_session_api.py"
    "tests/system/test_streaming_chunking.py"
    "tests/system/test_table_api.py"
    "tests/unit/spanner_dbapi/test_connect.py"
    "tests/unit/spanner_dbapi/test_connection.py"
    "tests/unit/spanner_dbapi/test_cursor.py"
  ];

  pythonImportsCheck = [
    "google.cloud.spanner_admin_database_v1"
    "google.cloud.spanner_admin_instance_v1"
    "google.cloud.spanner_dbapi"
    "google.cloud.spanner_v1"
  ];

  meta = with lib; {
    description = "Cloud Spanner API client library";
    homepage = "https://github.com/googleapis/python-spanner";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
