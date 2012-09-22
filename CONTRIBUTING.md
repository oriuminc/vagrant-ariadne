Contributing to Ariadne
=======================

Ariadne is being developed using the [git-flow tool][gitflow] and
methodology. The take-home message is that pull requests should be
submitted to the `develop` branch.

Here's the gist of how we're applying it:

  - New features happen on `develop` branch, not `master`.
  - Release branches are created in preparation for a tagged release,
    and only bugfixes happen on release branches.
  - When it seems all bugs are fixed on release branch, it's merged into
    `master`, tagged, and the release branch is removed.
  - When developing new features on `develop`, feature branches are
    recommended.

