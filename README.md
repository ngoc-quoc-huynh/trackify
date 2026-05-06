# trackify

Source code for the Trackify Flutter app.

## Prerequisites

### Flutter setup

We are using [mise](https://mise.jdx.dev/) to manage the dependencies. Make sure you have it
installed and then run the following command to install the required versions:

```bash
mise install
```

If you don't have mise installed or prefer not to use it, you can
install [Flutter](https://docs.flutter.dev/install) directly by following the official installation
guide.

Make sure to use the version specified in the [mise.toml](mise.toml) file to avoid compatibility
issues.

### Android setup

- Install the [Android SDK](https://developer.android.com/studio)
- Set environment variable `ANDROID_HOME` to the location of the SDK

### iOS setup

- Be a Mac OS user
- Install XCode
    - You'll need to be logged in with an Apple Developer account to download XCode
- Start XCode once and follow the instructions

## Code style

We use a consistent code style to keep the codebase readable and maintainable.

To format and analyze the codebase, you can run the following command:

```sh
make style
```

## Tests

To execute the tests, run the following command in your terminal:

```sh
make test
```

This will run the test in random order.
If you want to specify a seed for randomizing the test order, you can use the following command:

```sh
make test seed=1
```
