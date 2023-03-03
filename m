Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3536A9BB8
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 17:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCCQ0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 11:26:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCCQ0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 11:26:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458491ACD7;
        Fri,  3 Mar 2023 08:26:34 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 323FuUF9032250;
        Fri, 3 Mar 2023 16:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=KWWrGu9s6nFo3DaWQ+eqfEBda06NjJvV/h5p3RM6fDI=;
 b=V0FxVx0LF1V8s/M0HUodcG0F02Ev13WgBUVv72zi/CKDVI5iPPEdH73S90ziLuD0LEX0
 Gq+YIHJkr63TvIwkSgukM4R8eElmt1xcykFlt9GOrlVjdk/hHYCXbGLlctycHLd7ZqiN
 rRp1vamPH0JLctdxbNby3YK1Z+MzSF/Sp+0w8ZsTvYKqxCYw3rkP6PmupBftKB88SzfG
 X9BmAKnbGUq0vIxpxVKbAf4if92Sa7SPXTSd6pM0eZ8aAsdFSu1rtiNEmtkiwli5DMta
 BwFptu8piqyXfw92+r499FLZHPkUtLVDo/oEUorv6uJg6YLaGdicxErH7MaUeHFMB/2H tg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb7wxtc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 16:26:21 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 323EbG0G004991;
        Fri, 3 Mar 2023 16:26:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sc0n8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 16:26:19 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 323GM3cj020249;
        Fri, 3 Mar 2023 16:26:19 GMT
Received: from t460.home (dhcp-10-175-62-236.vpn.oracle.com [10.175.62.236])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3ny8sc0n6r-1;
        Fri, 03 Mar 2023 16:26:18 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, backports@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH] docs: add backporting and conflict resolution document
Date:   Fri,  3 Mar 2023 17:25:53 +0100
Message-Id: <20230303162553.17212-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.35.1.46.g38062e73e0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_03,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303030142
X-Proofpoint-GUID: W7vcRf8MNFU0gknmnBrkI1yoN64x5AzV
X-Proofpoint-ORIG-GUID: W7vcRf8MNFU0gknmnBrkI1yoN64x5AzV
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a new document based on my 2022 blog post:

  https://blogs.oracle.com/linux/post/backporting-patches-using-git

Although this is aimed at stable contributors and distro maintainers, it
does also contain useful tips and tricks for anybody who needs to
resolve merge conflicts.

By adding this to the kernel as documentation we can more easily point
to it e.g. from stable emails about failed backports, as well as allow
the community to modify it over time if necessary.

I've added this under process/ since it also has
process/applying-patches.rst. Another interesting document is
maintainer/rebasing-and-merging.rst which maybe should eventually refer
to this one, but I'm leaving that as a future cleanup.

Thanks to Harshit for helping with the original blog post as well as
this updated document.

Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 Documentation/process/backporting.rst | 488 ++++++++++++++++++++++++++
 Documentation/process/index.rst       |   1 +
 2 files changed, 489 insertions(+)
 create mode 100644 Documentation/process/backporting.rst

diff --git a/Documentation/process/backporting.rst b/Documentation/process/backporting.rst
new file mode 100644
index 000000000000..1b03df759905
--- /dev/null
+++ b/Documentation/process/backporting.rst
@@ -0,0 +1,488 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===================================
+Backporting and conflict resolution
+===================================
+
+:Author: Vegard Nossum <vegard.nossum@oracle.com>
+
+.. contents::
+    :local:
+    :depth: 3
+    :backlinks: none
+
+Introduction
+============
+
+Some developers may never really have to deal with backporting patches,
+merging branches, or resolving conflicts in their day-to-day work, so
+when a merge conflict does pop up, it can be daunting. Luckily,
+resolving conflicts is a skill like any other, and there are many useful
+techniques you can use to make the process smoother and increase your
+confidence in the result.
+
+This document aims to be a comprehensive, step-by-step guide to
+backporting and conflict resolution.
+
+Applying the patch to a tree
+============================
+
+Sometimes the patch you are backporting already exists as a git commit,
+in which case you just cherry-pick it directly using
+``git cherry-pick``. However, if the patch comes from an email, as it
+often does for the Linux kernel, you will need to apply it to a tree
+using ``git am``.
+
+If you've ever used ``git am``, you probably already know that it is
+quite picky about the patch applying perfectly to your source tree. In
+fact, you've probably had nightmares about ``.rej`` files and trying to
+edit the patch to make it apply.
+
+It is strongly recommended to instead find an appropriate base version
+where the patch applies cleanly and *then* cherry-pick it over to your
+destination tree, as this will make git output conflict markers and let
+you resolve conflicts with the help of git and any other conflict
+resolution tools you might prefer to use.
+
+It's generally better to use the exact same base as the one the patch
+was generated from, but it doesn't really matter that much as long as it
+applies cleanly and isn't too far from the original base. The only
+problem with applying the patch to the "wrong" base is that it may pull
+in more unrelated changes in the context of the diff when cherry-picking
+it to the older branch.
+
+If you are using
+`b4 <https://people.kernel.org/monsieuricon/introducing-b4-and-patch-attestation>`__
+and you are applying the patch directly from an email, you can use
+``b4 am`` with the options ``-g``/``--guess-base`` and
+``-3``/``--prep-3way`` to do some of this automatically (see `this
+presentation <https://youtu.be/mF10hgVIx9o?t=2996>`__ for more
+information). However, the rest of this article will assume that you are
+doing a plain ``git cherry-pick``.
+
+Once you have the patch in git, you can go ahead and cherry-pick it into
+your source tree. Don't forget to cherry-pick with ``-x`` if you want a
+written record of where the patch came from!
+
+Resolving conflicts
+===================
+
+Uh-oh; the cherry-pick failed with a vaguely threatening message::
+
+    CONFLICT (content): Merge conflict
+
+What to do now?
+
+In general, conflicts appear when the context of the patch (i.e., the
+lines being changed and/or the lines surrounding the changes) doesn't
+match what's in the tree you are trying to apply the patch *to*.
+
+For backports, what likely happened was that your older branch is
+missing a patch compared to the branch you are backporting from --
+however, it is also possible that your older branch has some commit that
+doesn't exist in the newer branch. In any case, the result is a conflict
+that needs to be resolved.
+
+If your attempted cherry-pick fails with a conflict, git automatically
+edits the files to include so-called conflict markers showing you where
+the conflict is and how the two branches have diverged. Resolving the
+conflict typically means editing the end result in such a way that it
+takes into account these other commits.
+
+Resolving the conflict can be done either by hand in a regular text
+editor or using a dedicated conflict resolution tool.
+
+Many people prefer to use their regular text editor and edit the
+conflict directly, as it may be easier to understand what you're doing
+and to control the final result. There are definitely pros and cons to
+each method, and sometimes there's value in using both.
+
+We will not cover using dedicated merge tools here beyond providing some
+pointers to various tools that you could use:
+
+-  `vimdiff/gvimdiff <https://linux.die.net/man/1/vimdiff>`__
+-  `KDiff3 <http://kdiff3.sourceforge.net/>`__
+-  `TortoiseMerge <https://tortoisesvn.net/TortoiseMerge.html>`__
+-  `Meld <https://meldmerge.org/help/>`__
+-  `P4Merge <https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge>`__
+-  `Beyond Compare <https://www.scootersoftware.com/>`__
+-  `IntelliJ <https://www.jetbrains.com/help/idea/resolve-conflicts.html>`__
+-  `VSCode <https://code.visualstudio.com/docs/editor/versioncontrol>`__
+
+To configure git to work with these, see ``git mergetool --help`` or
+`the official git documentation <https://git-scm.com/docs/git-mergetool>`__.
+
+Prerequisite patches
+~~~~~~~~~~~~~~~~~~~~
+
+Most conflicts happen because the branch you are backporting to is
+missing some patches compared to the branch you are backporting *from*.
+In the more general case (such as merging two independent branches),
+development could have happened on either branch, or the branches have
+simply diverged -- perhaps your older branch had some other backports
+applied to it that themselves needed conflict resolutions, causing a
+divergence.
+
+It's important to always identify the commit or commits that caused the
+conflict, as otherwise you cannot be confident in the correctness of
+your resolution. As an added bonus, especially if the patch is in an
+area you're not that famliar with, the changelogs of these commits will
+often give you the context to understand the code and potential problems
+or pitfalls with your conflict resolution.
+
+git log
+^^^^^^^
+
+A good first step is to look at ``git log`` for the file that has the
+conflict -- this is usually sufficient when there aren't a lot of
+patches to the file, but may get confusing if the file is big and
+frequently patched. You should run ``git log`` on the range of commits
+between your currently checked-out branch (``HEAD``) and the parent of
+the patch you are picking (``COMMIT``), i.e.::
+
+    git log HEAD..COMMIT^ -- PATH
+
+Even better, if you want to restrict this output to a single function
+(because that's where the conflict appears), you can use the following
+syntax::
+
+    git log -L:'\<function\>':PATH HEAD..COMMIT^
+
+.. note::
+     The ``\<`` and ``\>`` around the function name ensure that the
+     matches are anchored on a word boundary. This is important, as this
+     part is actually a regex and git only follows the first match, so
+     if you use ``-L:thread_stack:kernel/fork.c`` it may only give you
+     results for the function ``try_release_thread_stack_to_cache`` even
+     though there are many other functions in that file containing the
+     string ``thread_stack`` in their names.
+
+Another useful option for ``git log`` is ``-G``, which allows you to
+filter on certain strings appearing in the diffs of the commits you are
+listing::
+
+    git log -G'regex' HEAD..COMMIT^ -- PATH
+
+This can also be a handy way to quickly find when something (e.g. a
+function call or a variable) was changed, added, or removed. The search
+string is a regular expression, which means you can potentially search
+for more specific things like assignments to a specific struct member::
+
+    git log -G'\->index\>.*='
+
+git blame
+^^^^^^^^^
+
+Another way to find prerequisite commits (albeit only the most recent
+one for a given conflict) is to run ``git blame``. In this case, you
+need to run it against the parent commit of the patch you are
+cherry-picking and the file where the conflict appared, i.e.::
+
+    git blame COMMIT^ -- PATH
+
+This command also accepts the ``-L`` argument (for restricting the
+output to a single function), but in this case you specify the filename
+at the end of the command as usual::
+
+    git blame -L:'\<function\>' COMMIT^ -- PATH
+
+Navigate to the place where the conflict occurred. The first column of
+the blame output is the commit ID of the patch that added a given line
+of code.
+
+It might be a good idea to ``git show`` these commits and see if they
+look like they might be the source of the conflict. Sometimes there will
+be more than one of these commits, either because multiple commits
+changed different lines of the same conflict area *or* because multiple
+subsequent patches changed the same line (or lines) multiple times. In
+the latter case, you may have to run ``git blame`` again and specify the
+older version of the file to look at in order to dig further back in
+the history of the file.
+
+Prerequisite vs. incidental patches
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+Having found the patch that caused the conflict, you need to determine
+whether it is a prerequisite for the patch you are backporting or
+whether it is just incidental and can be skipped. An incidental patch
+would be one that touches the same code as the patch you are
+backporting, but does not change the semantics of the code in any
+material way. For example, a whitespace cleanup patch is completely
+incidental -- likewise, a patch that simply renames a function or a
+variable would be incidental as well. On the other hand, if the function
+being changed does not even exist in your current branch then this would
+not be incidental at all and you need to carefully consider whether the
+patch adding the function should be cherry-picked first.
+
+If you find that there is a necessary prerequisite patch, then you need
+to stop and cherry-pick that instead. If you've already resolved some
+conflicts in a different file and don't want to do it again, you can
+create a temporary copy of that file.
+
+To abort the current cherry-pick, go ahead and run
+``git cherry-pick --abort``, then restart the cherry-picking process
+with the commit ID of the prerequisite patch instead.
+
+Understanding conflict markers
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+Combined diffs
+^^^^^^^^^^^^^^
+
+Let's say you've decided against picking (or reverting) additional
+patches and you just want to resolve the conflict. Git will have
+inserted conflict markers into your file. Out of the box, this will look
+something like::
+
+    <<<<<<< HEAD
+    this is what's in your current tree before cherry-picking
+    =======
+    this is what the patch wants it to be after cherry-picking
+    >>>>>>> COMMIT... title
+
+This is what you would see if you opened the file in your editor.
+However, if you were to run run ``git diff`` without any arguments, the
+output would look something like this::
+
+    $ git diff
+    [...]
+    ++<<<<<<<< HEAD
+     +this is what's in your current tree before cherry-picking
+    ++========
+    + this is what the patch wants it to be after cherry-picking
+    ++>>>>>>>> COMMIT... title
+
+When you are resolving a conflict, the behavior of ``git diff`` differs
+from its normal behavior. Notice the two columns of diff markers
+instead of the usual one; this is a so-called "`combined diff
+<https://git-scm.com/docs/diff-format#_combined_diff_format>`__", here
+showing the 3-way diff (or diff-of-diffs) between
+
+#. the current branch (before cherry-picking) and the current working
+   directory, and
+#. the current branch (before cherry-picking) and the file as it looks
+   after the original patch has been applied.
+
+Better diffs
+^^^^^^^^^^^^
+
+3-way combined diffs include all the other changes that happened to the
+file between your current branch and the branch you are cherry-picking
+from. While this is useful for spotting other changes that you need to
+take into account, this also makes the output of ``git diff`` somewhat
+intimidating and difficult to read. You may instead prefer to run
+``git diff HEAD`` (or ``git diff --ours``) which shows only the diff
+between the current branch before cherry-picking and the current working
+directory. It looks like this::
+
+    $ git diff HEAD
+    [...]
+    +<<<<<<<< HEAD
+     this is what's in your current tree before cherry-picking
+    +========
+    +this is what the patch wants it to be after cherry-picking
+    +>>>>>>>> COMMIT... title
+
+As you can see, this reads just like any other diff and makes it clear
+which lines are in the current branch and which lines are being added
+because they are part of the merge conflict or the patch being
+cherry-picked.
+
+Merge styles and diff3
+^^^^^^^^^^^^^^^^^^^^^^
+
+The default conflict marker style shown above is known as the ``merge``
+style. There is also another style available, known as the ``diff3``
+style, which looks like this::
+
+    <<<<<<< HEAD
+    this is what is in your current tree before cherry-picking
+    ||||||| parent of COMMIT (title)
+    this is what the patch expected to find there
+    =======
+    this is what the patch wants it to be after being applied
+    >>>>>>> COMMIT (title)
+
+As you can see, this has 3 parts instead of 2, and includes what git
+expected to find there but didn't. Some people vastly prefer this style
+as it makes it much clearer what the patch actually changed; i.e., it
+allows you to compare the before-and-after versions of the file for the
+commit you are cherry-picking. This allows you to make better decisions
+about how to resolve the conflict.
+
+To change conflict marker styles, you can use the following command::
+
+    git config merge.conflictStyle diff3
+
+There is a third option, ``zdiff3``, introduced in `Git
+2.35 <https://github.blog/2022-01-24-highlights-from-git-2-35/>`__,
+which has the same 3 sections as ``diff3``, but where common lines have
+been trimmed off, making the conflict area smaller in some cases.
+
+Iterating on conflict resolutions
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The first step in any conflict resolution process is to understand the
+patch you are backporting. For the Linux kernel this is especially
+important, since an incorrect change can lead to the whole system
+crashing -- or worse, an undetected security vulnerability.
+
+Understanding the patch can be easy or difficult depending on the patch
+itself, the changelog, and your familiarity with the code being changed.
+However, a good question for every change (or every hunk of the patch)
+might be: "Why is this hunk in the patch?" The answers to these
+questions will inform your conflict resolution.
+
+Resolution process
+^^^^^^^^^^^^^^^^^^
+
+Sometimes the easiest thing to do is to just remove all but the first
+part of the conflict, leaving the file essentially unchanged, and apply
+the changes by hand. Perhaps the patch is changing a function call
+argument from ``0`` to ``1`` while a conflicting change added an
+entirely new (and insignificant) parameter to the end of the parameter
+list; in that case, it's easy enough to change the argument from ``0``
+to ``1`` by hand and leave the rest of the arguments alone. This
+technique of manually applying changes is mostly useful if the conflict
+pulled in a lot of unrelated context that you don't really need to care
+about.
+
+For particularly nasty conflicts with many conflict markers, you can use
+``git add`` or ``git add -i`` to selectively stage your resolutions to
+get them out of the way; this also lets you use ``git diff HEAD`` to
+always see what remains to be resolved or ``git diff --cached`` to see
+what your patch looks like so far.
+
+Function arguments
+^^^^^^^^^^^^^^^^^^
+
+Pay attention to changing function arguments! It's easy to gloss over
+details and think that two lines are the same but actually they differ
+in some small detail like which variable was passed as an argument
+(especially if the two variables are both a single character that look
+the same, like i and j).
+
+Error handling
+^^^^^^^^^^^^^^
+
+If you cherry-pick a patch that includes a ``goto`` statement (typically
+for error handling), it is absolutely imperative to double check that
+the target label is still correct in the branch you are backporting to.
+Error handling is typically located at the bottom of the function, so it
+may not be part of the conflict even though could have been changed by
+other patches.
+
+A good way to ensure that you review the error paths is to always use
+``git diff -W`` and ``git show -W`` (AKA ``--function-context``) when
+inspecting your changes.  For C code, this will show you the whole
+function that's being changed in a patch. One of the things that often
+go wrong during backports is that something else in the function changed
+on either of the branches that you're backporting from or to. By
+including the whole function in the diff you get more context and can
+more easily spot problems that might otherwise go unnoticed.
+
+Dealing with file renames
+^^^^^^^^^^^^^^^^^^^^^^^^^
+
+One of the most annoying things that can happen while backporting a
+patch is discovering that one of the files being patched has been
+renamed, as that typically means git won't even put in conflict markers,
+but will just throw up its hands and say (paraphrased): "Unmerged path!
+You do the work..."
+
+There are generally a few ways to deal with this. If the patch to the
+renamed file is small, like a one-line change, the easiest thing is to
+just go ahead and apply the change by hand and be done with it. On the
+other hand, if the change is big or complicated, you definitely don't
+want to do it by hand.
+
+Sometimes the right thing to do will be to also backport the patch that
+did the rename, but that's definitely not the most common case. Instead,
+what you can do is to temporarily rename the file in the branch you're
+backporting to (using ``git mv`` and committing the result), restart the
+attempt to cherry-pick the patch, rename the file back (``git mv`` and
+committing again), and finally squash the result using ``git rebase -i``
+(`tutorial <https://medium.com/@slamflipstrom/a-beginners-guide-to-squashing-commits-with-git-rebase-8185cf6e62ec>`__)
+so it appears as a single commit when you are done.
+
+Verifying the result
+====================
+
+colordiff
+~~~~~~~~~
+
+Having committed a conflict-free new patch, you can now compare your
+patch to the original patch. It is highly recommended that you use a
+tool such as `colordiff <https://www.colordiff.org/>`__ that can show
+two files side by side and color them according to the changes between
+them::
+
+    colordiff -yw -W 200 <(git diff -W UPSTREAM_COMMIT^-) <(git diff -W HEAD^-) | less -SR
+
+Here, ``-y`` means to do a side-by-side comparison; ``-w`` ignores
+whitespace, and ``-W 200`` sets the width of the output (as otherwise it
+will use 130 by default, which is often a bit too little).
+
+The ``rev^-`` syntax is a handy shorthand for ``rev^..rev``, essentially
+giving you just the diff for that single commit; also see
+`the official git documentation <https://git-scm.com/docs/git-rev-parse#_other_rev_parent_shorthand_notations>`__.
+
+Again, note the inclusion of ``-W`` for ``git diff``; this ensures that
+you will see the full function for any function that has changed.
+
+One incredibly important thing that colordiff does is to highlight lines
+that are different. For example, if an error-handling ``goto`` has
+changed labels between the original and backported patch, colordiff will
+show these side-by-side but highlighted in a different color.  Thus, it
+is easy to see that the two ``goto`` statements are jumping to different
+labels. Likewise, lines that were not modified by either patch but
+differ in the context will also be highlighted and thus stand out during
+a manual inspection.
+
+Of course, this is just a visual inspection; the real test is building
+and running the patched kernel (or program).
+
+Build testing
+~~~~~~~~~~~~~
+
+We won't cover runtime testing here, but it can be a good idea to build
+just the files touched by the patch as a quick sanity check. For the
+Linux kernel you can build single files like this, assuming you have the
+``.config`` and build environment set up correctly::
+
+    make path/to/file.o
+
+Note that this won't discover linker errors, so you should still do a
+full build after verifying that the single file compiles. By compiling
+the single file first you can avoid having to wait for a full build *in
+case* there are compiler errors in any of the files you've changed.
+
+Runtime testing
+~~~~~~~~~~~~~~~
+
+Even a successful build or boot test is not necessarily enough to rule
+out a missing dependency somewhere. Even though the chances are small,
+there could be code changes where two independent changes to the same
+file result in no conflicts, no compile-time errors, and runtime errors
+only in exceptional cases.
+
+One concrete example of this was where a patch to the system call entry
+code saved/restored a register and a later patch made use of the saved
+register somewhere in the middle -- since there was no conflict, one
+could backport the second patch and believe that everything was fine,
+but in fact the code was now scribbling over an unsaved register.
+
+Although the vast majority of errors will be caught during compilation
+or by superficially exercising the code, the only way to *really* verify
+a backport is to review the final patch with the same level of scrutiny
+as you would (or should) give to any other patch. Having unit tests and
+regression tests or other types of automatic testing can help increase
+the confidence in the correctness of a backport.
+
+Examples
+========
+
+The above shows roughly the idealized process of backporting a patch.
+For a more concrete example, see this video tutorial where two patches
+are backported from mainline to stable:
+`Backporting Linux Kernel patches <https://youtu.be/sBR7R1V2FeA>`__
diff --git a/Documentation/process/index.rst b/Documentation/process/index.rst
index d4b6217472b0..6eb6dcf9545e 100644
--- a/Documentation/process/index.rst
+++ b/Documentation/process/index.rst
@@ -58,6 +58,7 @@ lack of a better place.
    :maxdepth: 1
 
    applying-patches
+   backporting
    adding-syscalls
    magic-number
    volatile-considered-harmful
-- 
2.35.1.46.g38062e73e0

