# Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change. 

As a contributor, here are the guidelines we would like you to follow:

 - [Code of Conduct](#coc)
 - [Issues and Bugs](#issue)
 - [Feature Requests](#feature)
 - [Submission Guidelines](#submit)
 - [Coding Rules](#rules)
 - [Commit Message Guidelines](#commit)

## <a name="coc"></a> Code of Conduct

Please read and follow our [Code of Conduct][coc].

## <a name="issue"></a> Found a Bug?

If you find a bug in the source code, you can help us by [submitting an issue](#submit-issue) to our [GitHub Repository][github].
Even better, you can [submit a Pull Request](#submit-pr) with a fix.

## <a name="feature"></a> Missing a Feature?
You can *request* a new feature by [submitting an issue](#submit-issue) to our GitHub Repository.
If you would like to *implement* a new feature, please consider the size of the change in order to determine the right steps to proceed:

* For a **Major Feature**, first open an issue and outline your proposal so that it can be discussed.
  This process allows us to better coordinate our efforts, prevent duplication of work, and help you to craft the change so that it is successfully accepted into the project.

  **Note**: Adding a new topic to the documentation, or significantly re-writing a topic, counts as a major feature.

* **Small Features** can be crafted and directly [submitted as a Pull Request](#submit-pr).

## <a name="submit"></a> Submission Guidelines

### <a name="submit-issue"></a> Submitting an Issue

Before you submit an issue, please search the issue tracker. An issue for your problem might already exist and the discussion might inform you of workarounds readily available.

### <a name="submit-pr"></a> Submitting a Pull Request (PR)

Before you submit your Pull Request (PR) consider the following guidelines:

1. Search [GitHub][pull-requests] for an open or closed PR that relates to your submission.
   You don't want to duplicate existing efforts.

2. Be sure that an issue describes the problem you're fixing, or documents the design for the feature you'd like to add.
   Discussing the design upfront helps to ensure that we're ready to accept your work.

3. Make your changes in a new git fork according to our [coding rules](#rules).

4. Run the test suites to ensure tests are passing.

5. Commit your changes using a descriptive commit message that follows our [commit message conventions](#commit).

6. Push your changes to GitHub.

7. In GitHub, send a pull request to `studious-eureka-app:main`.

### Reviewing a Pull Request

The reviewers reserves the right not to accept pull requests from community members who haven't been good citizens of the community. Such behavior includes not following the [Code of Conduct][coc].

#### Addressing review feedback

If we ask for changes via code reviews then:

1. Make the required updates to the code.

2. Re-run the test suites to ensure tests are still passing.

3. Create a fixup commit and push to your GitHub repository (this will update your Pull Request):

    ```shell
    git commit --all --fixup HEAD
    git push
    ```

    For more info on working with fixup commits see [here][fixup-commits].

That's it! Thank you for your contribution!

##### Updating the commit message

A reviewer might often suggest changes to a commit message (for example, to add more context for a change or adhere to our [commit message guidelines](#commit)).
In order to update the commit message of the last commit on your branch:

1. Check out your branch.

2. Amend the last commit and modify the commit message:

    ```shell
    git commit --amend
    ```

3. Push to your GitHub repository:

    ```shell
    git push --force-with-lease
    ```

> NOTE:<br />
> If you need to update the commit message of an earlier commit, you can use `git rebase` in interactive mode.
> See the [git docs][interactive-rebase] for more details.

#### After your pull request is merged

After your pull request is merged, you can fetch the changes from the main (upstream) repository and safely reset your fork:

1. Fetch latest changes from upstream repository:

    ```shell
    git fetch upstream
    ```

2. Check out your main branch:

    ```shell
    git checkout main
    ```

3. Reset your main branch to upstream main branch:

    ```shell
    git reset --hard upstream main
    ```

  > NOTE:<br />
  > Any untracked files or directories will be deleted.

## <a name="rules"></a> Coding Rules
To ensure consistency throughout the source code, keep these rules in mind as you are working:

* All features or bug fixes **must be tested** by one or more specs (unit-tests).
* We follow [Effective Dart: Style][style-guide], but wrap all code at **120 characters**.

## <a name="commit"></a> Commit Message Format

We have very precise rules over how our Git commit messages must be formatted.
This format leads to **easier to read commit history**.
Please read and follow the [Conventional Commits][commit-message-format].

## Attribution

This document is adapted from [Angular's Contributing document](https://github.com/angular/angular/blob/master/CONTRIBUTING.md).

[coc]: CODE_OF_CONDUCT.md
[commit-message-format]: https://www.conventionalcommits.org
[fixup-commits]: https://fle.github.io/git-tip-keep-your-branch-clean-with-fixup-and-autosquash.html
[github]: https://github.com/benedictkhoo/studious-eureka-app
[interactive-rebase]: https://git-scm.com/docs/git-rebase#_interactive_mode
[pull-requests]: https://github.com/benedictkhoo/studious-eureka-app/pulls
[style-guide]: https://dart.dev/guides/language/effective-dart/style