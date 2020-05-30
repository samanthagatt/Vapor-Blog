<p align="center">
    <img src="https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png" width="320" alt="API Template">
    <br>
    <br>
    <a href="http://docs.vapor.codes/3.0/">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor">
        <img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/api-template">
        <img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-5-brightgreen.svg" alt="Swift 5">
    </a>
</p>

# Vapor Blog

## Initial Setup (Using Xcode 11.4.1)
* Fork and clone repository
* Open `Package.swift` in Xcode
* Wait until all dependencies are cloned/installed
* Edit `Run` scheme
    * Select `Run` (Debug) from the left side panel
    * Select `Options` on the top panel
    * Select `Use custom working directory:` so Xcode doesn't use `DerivedData/`
        * Choose the folder containing Package.swift
* Duplicate `Run` scheme
* Name the duplicate `Migrate`
* Edit `Migrate` scheme
    * Select `Run` (Debug) from the left side panel
    * Make sure correct folder is selected for `Use custom working directory:` in `Options` (same as `Run` scheme)
    * Select `Arguments` on the top panel
    * Add an the argument `migrate` to `Arguments Passed On Launch`
* Run `Migrate` scheme
    * Should be prompted with the following
        ```
        The following migration(s) will be prepared:
        + _Migration on default
        + BlogMigration_v1_0_0 on default
        + UserMigration_v1_0_0 on default
        Would you like to continue?
        y/n> 
        ```
    * Type `y` and then enter
* Run `Run` scheme
    * Server will run on port 8080, so make sure it's available before running
* Now you should be set!
