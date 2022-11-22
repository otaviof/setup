#!/usr/bin/env bash
#
# Based on the major version informed, this script prints out the git commands needed to update the
# current major version tag, and also, release a minor subsequent tag.
#

set -eu

# major project version and git tag name, based on it
VERSION="${VERSION:-1}"
readonly MAJOR_TAG="v${VERSION}"

# making sure the local git tags are updated
git fetch --tags

echo "# Preparing release for '${MAJOR_TAG}' (major)..."

# checking if there are mnior release tags, based on the major release
LAST_TAG="$(git tag --list --sort=v:refname |grep \"${MAJOR_TAG}.\" |tail -n 1)"

if [ "${LAST_TAG}" == "" ]; then
	NEXT_TAG="${MAJOR_TAG}.0"
else
	echo "# Last tag '${LAST_TAG}'"

	LAST_TAG_MINOR="${LAST_TAG/${MAJOR_TAG}./}"
	NEXT_TAG_MINOR=$((LAST_TAG_MINOR + 1))
	NEXT_TAG="${MAJOR_TAG}.${NEXT_TAG_MINOR}"
fi

echo "# Updating major '${MAJOR_TAG}' and tagging '${NEXT_TAG}'..."
cat <<EOS
git tag --force "v${VERSION}"
git push --force origin "v${VERSION}"

git tag "${NEXT_TAG}"
git push origin "${NEXT_TAG}"
EOS
