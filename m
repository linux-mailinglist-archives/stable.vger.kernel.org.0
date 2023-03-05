Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3EBD6AAE19
	for <lists+stable@lfdr.de>; Sun,  5 Mar 2023 05:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjCEEDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 23:03:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCEEDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 23:03:36 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E56BBDCC;
        Sat,  4 Mar 2023 20:03:34 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u5so6796223plq.7;
        Sat, 04 Mar 2023 20:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677989014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=St+LXbAwYb6pdrMuptqZn7fDDP6I0sfWlOco0YZvkco=;
        b=WZjsJco8N1ikNVVmqEQ7C/RXdh58a1X6dq3AnmYCZOKAmIGBXM/na2ZGOSIBwAgJ0x
         D0pZGc2D+HBfP731JuhP2f6Xxd3xBJuOijHsGKW0eJZUa/IY8StjCCkpFbcxJWlmTOtA
         TwogSW5BJAOoObhK9rqwKZbS/A7QaIRqfhMmACA+dvkxSDVPu+IcnIQ12eCAgIPc9I9G
         lnOrHlzmCQOUta96rhzUdflwgxJgtjdifecFUuPMianupBEB6CbTjVnogRqHqP7l0suR
         k0/wf7prQ6auGPPOd+YZZpL/9rRx5UbIxgUrJ+uYARg3yN8EvQNdyP9cXd8zdS6ZF3A1
         335Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677989014;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=St+LXbAwYb6pdrMuptqZn7fDDP6I0sfWlOco0YZvkco=;
        b=s8to6cMqu0G2wDNY8ziTmeilP88GJ5O8y54O8gtIrmowYpsel5KFfmWVi2GlYbxkp1
         OZiMTw5ddNtpP022To+G1Lb5JRs6EZa4SFZAofLZDL9jsfDYMwK6G5Ck/r3qRqK0BZLD
         OsYLrCTX0H8gEl/5729B5i4DyS3WuAYfqT8sqdrLV1AXsnuS159OCdQftplGIJYBOt4k
         qDp00LR3stRC4ER5Ga5KcH9aWWRQKfWLecZviluNc+r5QzzUHxFbbWg1ZL7j81RCYURo
         iLrCAO6QM9GjSMB94IyYdkhbj257grSSjy1KCDplFBCjQAnwPJxlnI1fmlmbOqtAKICP
         NpAg==
X-Gm-Message-State: AO0yUKVDda9cpYeBM7A5ULaoARKZkqJNTtJhcJNZRaEzuxyuBWqM3X+6
        TnhTrq28XjzyxGDNKoEPOdgvpDYSqRg=
X-Google-Smtp-Source: AK7set9qHxMhSv6UDvC/imoSB+PoGEl5y1Qe2a3PzFSooQDzANyH7sQmctk76Ui+u45gyKcopHkX7A==
X-Received: by 2002:a05:6a21:6d81:b0:cb:cd6a:2e42 with SMTP id wl1-20020a056a216d8100b000cbcd6a2e42mr9035269pzb.29.1677989013886;
        Sat, 04 Mar 2023 20:03:33 -0800 (PST)
Received: from debian.me (subs02-180-214-232-71.three.co.id. [180.214.232.71])
        by smtp.gmail.com with ESMTPSA id p18-20020a62ab12000000b005825b8e0540sm3867201pff.204.2023.03.04.20.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 20:03:33 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 12594105FA1; Sun,  5 Mar 2023 11:03:29 +0700 (WIB)
Date:   Sun, 5 Mar 2023 11:03:29 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Vegard Nossum <vegard.nossum@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, backports@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH] docs: add backporting and conflict resolution document
Message-ID: <ZAQUkbxQxCanh+9c@debian.me>
References: <20230303162553.17212-1-vegard.nossum@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yxswqAePtvTOIAX3"
Content-Disposition: inline
In-Reply-To: <20230303162553.17212-1-vegard.nossum@oracle.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_PDS_SHORTFWD_URISHRT_QP autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yxswqAePtvTOIAX3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 03, 2023 at 05:25:53PM +0100, Vegard Nossum wrote:
> +It is strongly recommended to instead find an appropriate base version
> +where the patch applies cleanly and *then* cherry-pick it over to your
> +destination tree, as this will make git output conflict markers and let
> +you resolve conflicts with the help of git and any other conflict
> +resolution tools you might prefer to use.
> +
> +It's generally better to use the exact same base as the one the patch
> +was generated from, but it doesn't really matter that much as long as it
> +applies cleanly and isn't too far from the original base. The only
> +problem with applying the patch to the "wrong" base is that it may pull
> +in more unrelated changes in the context of the diff when cherry-picking
> +it to the older branch.
> +
> +If you are using
> +`b4 <https://people.kernel.org/monsieuricon/introducing-b4-and-patch-att=
estation>`__
> +and you are applying the patch directly from an email, you can use
> +``b4 am`` with the options ``-g``/``--guess-base`` and
> +``-3``/``--prep-3way`` to do some of this automatically (see `this
> +presentation <https://youtu.be/mF10hgVIx9o?t=3D2996>`__ for more
> +information). However, the rest of this article will assume that you are
> +doing a plain ``git cherry-pick``.

Above are from applier's perspective (maintainers and/or developers
doing the backport). For patch submitter, don't forget to pass
--base=3D<base-commit> to git-format-patch(1) so that the applier can know
the base commit of the patch to be applied. For patches intended for
mainline submission, the applier could create a temporary branch based on
specified base commit (as described above), apply the patch, and rebase
to latest appropriate subsystem tree (and resolve conflicts if any).
Others could instead directly apply the patch on top of subsystem tree.

> +
> +Once you have the patch in git, you can go ahead and cherry-pick it into
> +your source tree. Don't forget to cherry-pick with ``-x`` if you want a
> +written record of where the patch came from!

"In most cases, you will likely want to cherry-pick with ``-x`` option
to record upstream commit in the resulting backport commit description,
which looks like::

    (cherry picked from commit <upstream commit>)

However, for backporting to stable, you need to edit the description
above to either::

    commit <upstream commit> upstream

or
    [ Upstream commit <upstream commit> ]

"

> +For backports, what likely happened was that your older branch is
> +missing a patch compared to the branch you are backporting from --
> +however, it is also possible that your older branch has some commit that
> +doesn't exist in the newer branch. In any case, the result is a conflict
> +that needs to be resolved.

Another conflict culprit that there are non-prerequisite commits that
change the context line.

> +git log
> +^^^^^^^
> +
> +A good first step is to look at ``git log`` for the file that has the
> +conflict -- this is usually sufficient when there aren't a lot of
> +patches to the file, but may get confusing if the file is big and
> +frequently patched. You should run ``git log`` on the range of commits
> +between your currently checked-out branch (``HEAD``) and the parent of
> +the patch you are picking (``COMMIT``), i.e.::
> +
> +    git log HEAD..COMMIT^ -- PATH

HEAD and <commit> swapped, giving empty log. The correct way is:

```
git log <commit>^..HEAD -- <path>
```

Note that for placeholder arguments, I'd like to write the
placeholder name inside chevrons, like above (git manpage style).

> +
> +Even better, if you want to restrict this output to a single function
> +(because that's where the conflict appears), you can use the following
> +syntax::
> +
> +    git log -L:'\<function\>':PATH HEAD..COMMIT^

Similar reply as above.

> +Another useful option for ``git log`` is ``-G``, which allows you to
> +filter on certain strings appearing in the diffs of the commits you are
> +listing::
> +
> +    git log -G'regex' HEAD..COMMIT^ -- PATH

Similar reply.

> +It might be a good idea to ``git show`` these commits and see if they
=2E.. to show these commits with ``git show <commit>`` ...

> +Prerequisite vs. incidental patches
> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> +
> +Having found the patch that caused the conflict, you need to determine
> +whether it is a prerequisite for the patch you are backporting or
> +whether it is just incidental and can be skipped. An incidental patch
> +would be one that touches the same code as the patch you are
> +backporting, but does not change the semantics of the code in any
> +material way. For example, a whitespace cleanup patch is completely
> +incidental -- likewise, a patch that simply renames a function or a
> +variable would be incidental as well. On the other hand, if the function
> +being changed does not even exist in your current branch then this would
> +not be incidental at all and you need to carefully consider whether the
> +patch adding the function should be cherry-picked first.
> +
> +If you find that there is a necessary prerequisite patch, then you need
> +to stop and cherry-pick that instead. If you've already resolved some
> +conflicts in a different file and don't want to do it again, you can
> +create a temporary copy of that file.
> +
> +To abort the current cherry-pick, go ahead and run
> +``git cherry-pick --abort``, then restart the cherry-picking process
> +with the commit ID of the prerequisite patch instead.

IMO, finding prerequisite commits can be done without attempting to
cherry-pick the desired commit first.

> +Sometimes the right thing to do will be to also backport the patch that
> +did the rename, but that's definitely not the most common case. Instead,
> +what you can do is to temporarily rename the file in the branch you're
> +backporting to (using ``git mv`` and committing the result), restart the
> +attempt to cherry-pick the patch, rename the file back (``git mv`` and
> +committing again), and finally squash the result using ``git rebase -i``
> +(`tutorial <https://medium.com/@slamflipstrom/a-beginners-guide-to-squas=
hing-commits-with-git-rebase-8185cf6e62ec>`__)
> +so it appears as a single commit when you are done.

I'm kinda confused with above. Did you mean that after renaming file, I
have to abort cherry-picking (``git cherry-pick --abort``) first and
then redo cherry-picking?

> +Build testing
> +~~~~~~~~~~~~~
> +
> +We won't cover runtime testing here, but it can be a good idea to build
Runtime testing is described in the next section.
> +just the files touched by the patch as a quick sanity check. For the
> +Linux kernel you can build single files like this, assuming you have the
> +``.config`` and build environment set up correctly::
> +
> +    make path/to/file.o
> +
> +Note that this won't discover linker errors, so you should still do a
> +full build after verifying that the single file compiles. By compiling
> +the single file first you can avoid having to wait for a full build *in
> +case* there are compiler errors in any of the files you've changed.
> +

plain ``make``?

> +One concrete example of this was where a patch to the system call entry
> +code saved/restored a register and a later patch made use of the saved
> +register somewhere in the middle -- since there was no conflict, one
> +could backport the second patch and believe that everything was fine,
> +but in fact the code was now scribbling over an unsaved register.

Did you mean the later patch is the backported syscall patch?

> +
> +Although the vast majority of errors will be caught during compilation
> +or by superficially exercising the code, the only way to *really* verify
> +a backport is to review the final patch with the same level of scrutiny
> +as you would (or should) give to any other patch. Having unit tests and
"... patches intended for mainline."

> +The above shows roughly the idealized process of backporting a patch.
> +For a more concrete example, see this video tutorial where two patches
> +are backported from mainline to stable:
> +`Backporting Linux Kernel patches <https://youtu.be/sBR7R1V2FeA>`__

For the external link targets, I'd like to separate them from
corresponding link texts (see
https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#ext=
ernal-links
for details).

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--yxswqAePtvTOIAX3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAQUiwAKCRD2uYlJVVFO
o/nkAP9HAoOxmJf20hmzYd1d7cNXTgEElPbqD9if4LZlq42gZwD/Tw/wra8mCG2H
1XBywHdzs4o154/N+50FaksJWIPzPQE=
=Mtfy
-----END PGP SIGNATURE-----

--yxswqAePtvTOIAX3--
