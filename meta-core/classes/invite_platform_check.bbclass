# Allow checking of required and conflicting INVITE_PLATFORM
#
# ANY_OF_INVITE_PLATFORM:   ensure at least one item on this list is included
#                           in INVITE_PLATFORM.
# REQUIRED_INVITE_PLATFORM: ensure every item on this list is included
#                           in INVITE_PLATFORM.
# CONFLICT_INVITE_PLATFORM: ensure no item in this list is included in
#                           INVITE_PLATFORM.
#
# Copyright 2013 (C) O.S. Systems Software LTDA.

python () {
    # Assume at least one var is set.
    invite_platform = (d.getVar('INVITE_PLATFORM', True) or "").split()

    any_of_invite_platform = set((d.getVar('ANY_OF_INVITE_PLATFORM') or '').split())
    if any_of_invite_platform:
        any_of_invite_platform = set.intersection(any_of_invite_platform, invite_platform)
        if set.isdisjoint(any_of_invite_platform,invite_platform):
            raise bb.parse.SkipRecipe("one of '%s' needs to be in INVITE_PLATFORM" % ' '.join(any_of_invite_platform))

    required_invite_platform = set((d.getVar('REQUIRED_INVITE_PLATFORM') or '').split())
    if required_invite_platform:
        required_invite_platform = set.intersection(required_invite_platform, invite_platform)
        for f in required_invite_platform:
            if f in invite_platform:
                continue
            else:
                bb.fatal("missing required invite platform%s '%s' (not in INVITE_PLATFORM)" % ('s' if len(missing) > 1 else '', ' '.join(missing)))

    conflict_invite_platform = set((d.getVar('CONFLICT_INVITE_PLATFORM') or '').split())
    if conflict_invite_platform:
        conflicts = set.intersection(conflict_invite_platform, invite_platform)
        if conflicts:
            bb.fatal("conflicting invite platform%s '%s' (in INVITE_PLATFORM)" % ('s' if len(conflicts) > 1 else '', ' '.join(conflicts)))
}
