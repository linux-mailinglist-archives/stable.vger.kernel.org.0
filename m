Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D774F6B57E1
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 03:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjCKCmq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 21:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjCKCmo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 21:42:44 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6802134822;
        Fri, 10 Mar 2023 18:42:42 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id nn12so7045452pjb.5;
        Fri, 10 Mar 2023 18:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678502562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=umqzK/hOBtRu3pNuRypQQc9h+Uu3og0K8NY7WJV+iZA=;
        b=kuu45IXEDEo/OxCiuuLWr+cOhNq7nvTvneMFTdgJQRJK9aRyg9jc4+yzEk6cD2lVGY
         iWVqcKOzY9Iv8SzXRhy4XrY+NAlWESOMNUv4uHJI1WXyb8AixJK/zlpatlBAr+NHrFQk
         ITQR4TvI9KEIoMD8TH/+G/M/d4NA3nNL18VEG4Dho0j65fjhx7C1oyr57KvjghB5q1+n
         BrNdea2Z924MKhIDwdu7cX2I6fw6i5p/EUPX6l/wqJtHgCOen53t+1KkmUTAXrF1WEME
         mElV3JADqK/VnUdZn5wxA4sRPgaY/Oj4tOut/CJHGYrEUb2kl93tbIDSxarn372OGKCM
         Rf0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678502562;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umqzK/hOBtRu3pNuRypQQc9h+Uu3og0K8NY7WJV+iZA=;
        b=MGuLOK7SYWNg1K6sJmn2KNfzgYTPi41mBlXqkwpWQK0k457j84ajb6ERYHfZV8pkCy
         7kL/4ogVFhoE2E94l3CVW09e9AskrR9iHCW72o9t15MhCQiR0KB/5etxu5TcgiV/AWxG
         nGC+ZZEnS/3fTQ0qfT7O/GMkfvgYfs2rsSukuCzV8O2ZfoBDlL6J0ED6g/Vrcja4tIve
         nBk74Z5LqNT9JAtaKp9VbuhO5+bocE93cuGH3yL/mXOEBBGGwVeCGshCBW5GkMz7qJLj
         2kB1Gp7cyo//TEM2dtmUxThpupo9C444idodIT1cy+xCRgRANMUuTVomrPUtfD94NLgc
         PGBw==
X-Gm-Message-State: AO0yUKXt9PAGmBMCUjXIc/MLqogaIler283vn+GyfFTXikPUpSAChgaA
        bB40ntxunJojz80lRwiqvRWWu6vy9To=
X-Google-Smtp-Source: AK7set+bw2PZKBjOfEpcK/SQBdkFCXFqFMTtZP42+Q9HLXf5vggFG+C38LdqWm3xo4+ebIC7X/Silw==
X-Received: by 2002:a17:902:eecc:b0:199:2ee:6238 with SMTP id h12-20020a170902eecc00b0019902ee6238mr25679291plb.16.1678502562106;
        Fri, 10 Mar 2023 18:42:42 -0800 (PST)
Received: from debian.me (subs28-116-206-12-51.three.co.id. [116.206.12.51])
        by smtp.gmail.com with ESMTPSA id kt7-20020a170903088700b001963bc7bdb8sm573404plb.274.2023.03.10.18.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 18:42:41 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
        id 767891065A6; Sat, 11 Mar 2023 09:42:36 +0700 (WIB)
Date:   Sat, 11 Mar 2023 09:42:35 +0700
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
Message-ID: <ZAvqm9EqGq/kJpkT@debian.me>
References: <20230303162553.17212-1-vegard.nossum@oracle.com>
 <ZAQUkbxQxCanh+9c@debian.me>
 <e70bf38e-af6a-dc63-3249-adbf168a1233@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5SlrIDA6gKdGPE62"
Content-Disposition: inline
In-Reply-To: <e70bf38e-af6a-dc63-3249-adbf168a1233@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5SlrIDA6gKdGPE62
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 07, 2023 at 12:43:42PM +0100, Vegard Nossum wrote:
> This whole document is meant for the developer doing the backport.
>=20
> git-format-patch --base=3D is already covered here:
>=20
> https://docs.kernel.org/process/submitting-patches.html#providing-base-tr=
ee-information
>=20
> I don't think we need to repeat it in this document.

OK.

> >=20
> > "In most cases, you will likely want to cherry-pick with ``-x`` option
> > to record upstream commit in the resulting backport commit description,
> > which looks like::
> >=20
> >      (cherry picked from commit <upstream commit>)
> >=20
> > However, for backporting to stable, you need to edit the description
> > above to either::
> >=20
> >      commit <upstream commit> upstream
> >=20
> > or
> >      [ Upstream commit <upstream commit> ]
> >=20
> > "
>=20
> Good point -- the original blog post where this came from was meant to
> be more general than just stable backports, but this document in
> particular is partly also meant to aid stable contributors we might as
> well include it.

Nice.

>=20
> > > +For backports, what likely happened was that your older branch is
> > > +missing a patch compared to the branch you are backporting from --
> > > +however, it is also possible that your older branch has some commit =
that
> > > +doesn't exist in the newer branch. In any case, the result is a conf=
lict
> > > +that needs to be resolved.
> >=20
> > Another conflict culprit that there are non-prerequisite commits that
> > change the context line.
>=20
> I think that's already covered by "missing a patch", or at least that
> was my intention. I guess we can change it to something like:
>=20
> +For backports, what likely happened was that the branch you are
> +backporting from contains patches not in the branch you are backporting
> +to. However, it is also possible that your older branch has some commit
> +that doesn't exist in the newer branch. In any case, the result is a
> +conflict that needs to be resolved.

What I mean is "hey, we have changes that make context lines
conflicted". By "patches not in the branch", I interpret that as "we
have possible non-prereqs that cause this (messy) conflict".

>=20
> I'll fiddle a bit more with the exact phrasing.
>=20
> > > +git log
> > > +^^^^^^^
> > > +
> > > +A good first step is to look at ``git log`` for the file that has the
> > > +conflict -- this is usually sufficient when there aren't a lot of
> > > +patches to the file, but may get confusing if the file is big and
> > > +frequently patched. You should run ``git log`` on the range of commi=
ts
> > > +between your currently checked-out branch (``HEAD``) and the parent =
of
> > > +the patch you are picking (``COMMIT``), i.e.::
> > > +
> > > +    git log HEAD..COMMIT^ -- PATH
> >=20
> > HEAD and <commit> swapped, giving empty log. The correct way is:
> >=20
> > ```
> > git log <commit>^..HEAD -- <path>
> > ```
>=20
> Hrrm, I've double checked this and I think the original text is correct.
>=20
> HEAD..<commit>^ gives you commits reachable from <commit>^ (parent of
> the commit we are backporting), excluding all commits that are reachable
> from HEAD (the branch we are backporting to).
>=20
> <commit>^..HEAD, on the other hand, would give you commits reachable
> from HEAD excluding all commits that are reachable from the parent of
> the commit we are backporting.
>=20
> With a diagram like this:
>=20
> o--o--x--y--<commit>
>     \
>      \--u--v--HEAD
>=20
> HEAD..<commit>^ would give you x and y while
> <commit>^..HEAD would give you u and v.

In any case, the HEAD you mentioned is at target branch (linux-x.y),
right?

> > > +Sometimes the right thing to do will be to also backport the patch t=
hat
> > > +did the rename, but that's definitely not the most common case. Inst=
ead,
> > > +what you can do is to temporarily rename the file in the branch you'=
re
> > > +backporting to (using ``git mv`` and committing the result), restart=
 the
> > > +attempt to cherry-pick the patch, rename the file back (``git mv`` a=
nd
> > > +committing again), and finally squash the result using ``git rebase =
-i``
> > > +(`tutorial <https://medium.com/@slamflipstrom/a-beginners-guide-to-s=
quashing-commits-with-git-rebase-8185cf6e62ec>`__)
> > > +so it appears as a single commit when you are done.
> >=20
> > I'm kinda confused with above. Did you mean that after renaming file, I
> > have to abort cherry-picking (``git cherry-pick --abort``) first and
> > then redo cherry-picking?
>=20
> Yes, the idea is that instead of trying to resolve it as a conflict, you
> rename the file first, do a (clean) cherry-pick, and then rename it back.
>=20
> What caused the confusion, specifically?

I thought that the sequence was:

```
$ git checkout -b my-backport linux-x.y
$ git cherry-pick <upstream commit>
# we get mv/modified content conflict
$ git mv <original path> <intended path> && git commit
$ git cherry-pick --abort
$ git cherry-pick <upstream commit>
# resolve content conflicts
$ git add <conflicted path>... && git commit
$ git rebase -i linux-x.y
```

>=20
> > > +Build testing
> > > +~~~~~~~~~~~~~
> > > +
> > > +We won't cover runtime testing here, but it can be a good idea to bu=
ild
> > Runtime testing is described in the next section.
> > > +just the files touched by the patch as a quick sanity check. For the
> > > +Linux kernel you can build single files like this, assuming you have=
 the
> > > +``.config`` and build environment set up correctly::
> > > +
> > > +    make path/to/file.o
> > > +
> > > +Note that this won't discover linker errors, so you should still do a
> > > +full build after verifying that the single file compiles. By compili=
ng
> > > +the single file first you can avoid having to wait for a full build =
*in
> > > +case* there are compiler errors in any of the files you've changed.
> > > +
> >=20
> > plain ``make``?
>=20
> Yes, but I don't think we need to spell that out as it's the common case
> (in other words, it is presupposed that you know this).
>=20
> > > +One concrete example of this was where a patch to the system call en=
try
> > > +code saved/restored a register and a later patch made use of the sav=
ed
> > > +register somewhere in the middle -- since there was no conflict, one
> > > +could backport the second patch and believe that everything was fine,
> > > +but in fact the code was now scribbling over an unsaved register.
> >=20
> > Did you mean the later patch is the backported syscall patch?
>=20
> Yes. I'll fiddle a bit with this paragraph to make it clearer.

So, in that case, what would the correct resoultion be regarding to
registers?

> > For the external link targets, I'd like to separate them from
> > corresponding link texts (see
> > https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html=
#external-links
> > for details).
>=20
> We can probably do that, but it doesn't seem to be used much in existing
> kernel documentation, I find no existing instances of it:
>=20
> $ git grep '\.\._.*: http' Documentation/
> $

I recently worked on Documentation/bpf/bpf_devel_QA.rst, where I mention
this linking syntax.

>=20
> I know that lots of people really prefer to minimize the amount of
> markup in these files (as they consume them in source form), so I'd
> really like an ack from others before doing this.
>=20

OK. For now I'm OK with either separating targets or including them.

Thanks for reply!

--=20
An old man doll... just what I always wanted! - Clara

--5SlrIDA6gKdGPE62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZAvqkwAKCRD2uYlJVVFO
o2MZAQCAq3m2XTlWIsKk4U6tgN+qvnbn7x48TuxMzTC83PN22QEA3zYHSclsym9s
B/SoMSlJDwi63VCsTGslZfsPe4mb/w8=
=o/ds
-----END PGP SIGNATURE-----

--5SlrIDA6gKdGPE62--
