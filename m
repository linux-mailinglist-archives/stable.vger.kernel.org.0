Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D2D32AEA4
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 03:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhCBX6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 18:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241058AbhCBCFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 21:05:47 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F7CC061788;
        Mon,  1 Mar 2021 18:04:50 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id d9so2959847qvo.3;
        Mon, 01 Mar 2021 18:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bD3uuoTgMfMoLwFrqSoqyX1P/FmDSNKRPvIeTsj/tgc=;
        b=bvTUu89Qd5+bPUeuND1meoG3DQq0dfCRAg9+tj8/egxx7jHxnAc6Dr9dczUoR8xsS6
         QpcQPnJzuYuMis+w/jsLfOzZ3ipW1zlsfho4tTFnlPLhNkGST+6H0TQ9upLn3ANB7hLz
         74SQVUmfcimCG2BUipO2bfI80M/oPBQRdbyZ3uKDTkqqGGO5zvKVc257ldQ3HQmAFcgG
         keFuQsJZy/JpAmhyWlRBig5XrEZ8wCbPDZ6fIgHQYXTM9sKE4RLm7nDyaGUEeu3ReUwF
         uxpPS2zv54ddLn3YJ8vFV7faEJznmCs+fjQKhNKeBqBulgdAi+7JaBFHkc3GHJSNbSvc
         IE3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bD3uuoTgMfMoLwFrqSoqyX1P/FmDSNKRPvIeTsj/tgc=;
        b=LpeKPk/XeLvfGWKZ9T/mvzMmq2jo/B18L/GwDRZecqV++SGNoTmAFCdWLYxRId1dK9
         9fEHi+6ERbao4FsJIo4QcTGVdj2c4egDQzFwssZiyw4q/5/IvvGZsmOPZualidUjGqAq
         Jx+Ed3ooSxBdWI92kIS7d67R0+2zBFsfsFehxFp7On8xyuLkB6lAujtTtwi8/egVqSse
         dC5URAjxTxZO5Pxk8UP/BYLy4byD9GOgjWTfi7BC6aIJGfoK+tKESNbM7iw2jmhdE/XG
         7BMiSjVCY7LKX2gnCk0U3e+L9WSgxN86xZihtnc5aQg/QfJ/5R7Im8m+aDX4Dv+5WNyu
         igFw==
X-Gm-Message-State: AOAM531gA9gLzJQZNV2c4XNBXZwfiLLKoThMZ6DIfWmKilS4K0SNHz7E
        tmkYm440+5k59WASelFL5eLesWJuJCUDxwBte14+pwtSmLc=
X-Google-Smtp-Source: ABdhPJzwyNfeP7JHoWu4pP7lZM69M9InzadAzcGn67y8vebjJmJjvmPYlRjv5KeRRbjKRP/pKzyildV8m4fGjvgz8Ug=
X-Received: by 2002:a0c:e2cd:: with SMTP id t13mr1582582qvl.44.1614650689307;
 Mon, 01 Mar 2021 18:04:49 -0800 (PST)
MIME-Version: 1.0
References: <20210222034342.13136-1-yunqiang.su@cipunited.com>
 <CAKcpw6UgEUUCG2=9E9KFpTYF23fWshdcFtmB_O+YT0xEoS3swA@mail.gmail.com>
 <alpine.DEB.2.21.2102280217220.44210@angie.orcam.me.uk> <000501d70da5$0ffd6a70$2ff83f50$@cipunited.com>
 <alpine.DEB.2.21.2102281407590.44210@angie.orcam.me.uk>
In-Reply-To: <alpine.DEB.2.21.2102281407590.44210@angie.orcam.me.uk>
From:   YunQiang Su <wzssyqa@gmail.com>
Date:   Tue, 2 Mar 2021 10:04:37 +0800
Message-ID: <CAKcpw6W30Bxo_rArG1p8O7H+d=vXw=AebQgZa-gpTNQLWT2ZiQ@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E5=9B=9E=E5=A4=8D=3A_=5BPATCH_v4=5D_MIPS=3A_introduce_config_option?=
        =?UTF-8?Q?_to_force_use_FR=3D0_for_FPXX_binary?=
To:     "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc:     YunQiang Su <yunqiang.su@cipunited.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips <linux-mips@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Maciej W. Rozycki <macro@orcam.me.uk> =E4=BA=8E2021=E5=B9=B42=E6=9C=8828=E6=
=97=A5=E5=91=A8=E6=97=A5 =E4=B8=8B=E5=8D=889:39=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, 28 Feb 2021, yunqiang.su@cipunited.com wrote:
>
> > >  This is also the correct interpretation for objects produced by Gola=
ng, which I
> > > have concluded are actually just fine according to the traditional ps=
ABI
> > > definition.  It looks to me like the bug is solely in the linker, due=
 to this weird
> > > interpretation quoted above and unforeseen consequences for FPXX link=
s
> > > invented much later.
> > >
> >
> > Yes. This a bug of linker, and we should fix it.
> > While for pre-existing binaries, we need a solution to make it workable=
, especially for the
> > generic Linux distributions, just like Debian.
> >
> > https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D962485
>
>  Thanks for the pointer.
>
>  After a bit of thinking and having fully understood what the issue
> actually is I conclude a change like your original one (with no
> configuration option; we've got too many of them already) will be OK so
> long as it keeps the current arrangement for R6, which has the FR mode
> hardwired, because, as you say, for genuine FPXX binaries the actual FR
> setting does not matter, so the change in the fixed form won't break what
> hasn't been broken already.
>
>  Please keep the history of changes in the comment section rather that th=
e
> change description though.  Also I think the change description needs to
> be more elaborate on the motivation, so that someone who looks at it say
> 10 years from now can figure out what is going on here.  You can reuse
> bits of our discussion for that purpose.
>
>  Sadly I can see many changes going in where the description hardly says
> anything, and while the matter may seem obvious right now, it surely won'=
t
> be for someone trying to unbreak things years from now while keeping the
> intent of the original change where it did the right thing.  Especially a=
s
> secondary sources of information may not be easily available (anymore) an=
d
> the test environment may not be easily reproducible.  Notice how often I
> need to refer to changes that were made many years ago and were not alway=
s
> correct.
>
>  NB the real problem are not programs included with the distribution
> (which as I say can and ought to be fixed up with a script automatically;
> a distribution needs to have provisions for such workarounds as problems
> with the toolchain inevitably do happen from time to time), but programs
> built by users of the distribution who we cannot reasonably expect to be
> aware of every single quirk out there.
>

The "stable" branch of distribution is in the same situation as the user.
Normally, we cannot modify the binary in the "stable" branch.

>  Observe however that this does not solve the issue of a link-time or
> load-time incompatibility between FP32 modules incorrectly marked FPXX an=
d
> FP64 or FP64A modules.  These will be let through and depending on usage
> likely eventually fail.
>

Yes, that's a problem. the patch of golang has been merged now.
https://go-review.googlesource.com/c/go/+/239217
https://go-review.googlesource.com/c/go/+/237058
And we will continue to try to fix binutils/llvm etc.

>  You might be able to come up with a wrapper script in place of whatever
> the Golang invocation command is to postprocess modules produced in user
> compilations as well, and have it distributed until the linker issue has
> been fixed upstream and the changes propagated back to the distribution.
>

We fixed the golang itself, and the packages has been in Debian bullseye no=
w.

>   Maciej



--=20
YunQiang Su
