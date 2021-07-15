Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA23CACB0
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243766AbhGOTlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:41:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53123 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343511AbhGOTjg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 15:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626377801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DHUMoXl2SdNr27oQJPt4qs9BIRssDeHx1wpg8aTfpbk=;
        b=LNs6UHsMGnY7daj5/qAvaXr0etL6wVCwghAzizPa4FSFvh6e+UCxQLdzNsqeWW38W58AmY
        8tlm1ZO9iJOAprLA377+Zb30+/AZ3BNYZsvmKNto+pyKBUV7Q45KRRv7B/MfqsO7wXKz4Z
        GZep8QX9YgXvaWHk1MtBtrP66U5f2uE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-5YY1Ggr4MJOqfFJXMCx-JA-1; Thu, 15 Jul 2021 15:36:40 -0400
X-MC-Unique: 5YY1Ggr4MJOqfFJXMCx-JA-1
Received: by mail-lf1-f71.google.com with SMTP id br13-20020a056512400db02903874b023039so1786306lfb.9
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 12:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DHUMoXl2SdNr27oQJPt4qs9BIRssDeHx1wpg8aTfpbk=;
        b=d6yci0CryCjRW2hDQ5d/TrQ1wCaMfPwDuzL9FApxep63bLx4IJgyf3tHG3FWPsp5pB
         wBH0ijIoRXE8MSECU1oH6U8lhuxwWAdy0VXvZa3tEddpsgx2HW0BQgOy17Cm3r+EtTT4
         QqNCZ1JnpnhXS165Z75XZj3TBl0fJVk7TfNTWDMCOJEgI/762nwNU9IP409o60htAN1o
         TAgtG4BcfjbEXYjGT/zVDMvC3z1Qnc47SKvph9rNrpxujlDTBXW6/v4+uDKPqTL4ZE8n
         yPet0HqWR5Y7rBBw1GEGps71PYAXvGwE76ZoMeh0wiHSFujkvtfr0jAmtBuw9237j6BY
         4eJA==
X-Gm-Message-State: AOAM531efzP7YNIGAbo3D5vVw3NfvhsOswQFdMsOBPAbFfknz54m6s7R
        8E1+z1yhGAcWJgL98pVImfV/RTivwWwl/oMbAN8Bis2JOtQWczR/l7wZGY7L9YrZ4S6Fe+C3VZY
        PURu8SGYTFvXyp3x89VpmVU8V7Tc5Fbpm
X-Received: by 2002:a05:651c:1253:: with SMTP id h19mr5308180ljh.303.1626377799027;
        Thu, 15 Jul 2021 12:36:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZoQZq5npX5MSMn7dGuvbEIE34ot/m96eIjcf1bK8IW1NowX7IXyV1PJecd3FlLeDhXCKIN7yiWTN5oKwvAU0=
X-Received: by 2002:a05:651c:1253:: with SMTP id h19mr5308164ljh.303.1626377798800;
 Thu, 15 Jul 2021 12:36:38 -0700 (PDT)
MIME-Version: 1.0
References: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com> <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
 <YPBw8SQ/oQQXfguv@kroah.com>
In-Reply-To: <YPBw8SQ/oQQXfguv@kroah.com>
From:   Veronika Kabatova <vkabatov@redhat.com>
Date:   Thu, 15 Jul 2021 21:36:02 +0200
Message-ID: <CA+tGwnk3N6mGY+0HqKuhtraCx9Dyj9DU89dOt1tKNZ_Rg0jgeg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E13=2E2_=28stable=2D?=
        =?UTF-8?Q?queue=2C_ee00910f=29?=
To:     Greg KH <greg@kroah.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 7:32 PM Greg KH <greg@kroah.com> wrote:
>
> On Thu, Jul 15, 2021 at 02:51:15PM +0200, Veronika Kabatova wrote:
> > On Thu, Jul 15, 2021 at 2:50 PM CKI Project <cki-project@redhat.com> wr=
ote:
> > >
> > >
> > > Hello,
> > >
> > > We ran automated tests on a recent commit from this kernel tree:
> > >
> > >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/s=
table/linux-stable-rc.git
> > >             Commit: ee00910f75ff - powerpc/powernv/vas: Release refer=
ence to tgid during window close
> > >
> > > The results of these automated tests are provided below.
> > >
> > >     Overall result: FAILED (see details below)
> > >              Merge: OK
> > >            Compile: FAILED
> > >
> > > All kernel binaries, config files, and logs are available for downloa=
d here:
> > >
> > >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.ht=
ml?prefix=3Ddatawarehouse-public/2021/07/15/337656806
> > >
> > > We attempted to compile the kernel for multiple architectures, but th=
e compile
> > > failed on one or more architectures:
> > >
> > >            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> > >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> > >
> >
> > Hi, looks to be introduced by
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.=
git/commit/?h=3Dqueue/5.13&id=3D07d407cc1259634b3334dd47519ecd64e6818617
>
> Are you sure?  I fixed a different build bug in that area a few hours
> ago, if you rebuild the tree it should be resolved.
>

Yes. All runs of the queue hit the problem, including the latest
b438694730fd. I also ran a test of the second latest completed
run with a patch revert and the issue disappeared.

That said, the c139bde0fdca rebase (second latest) introduced
an s390x compilation problem that did not happen before. It
is also visible with the latest head. I don't know what commit
introduced it yet as the run barely finished:


00:00:12 In file included from arch/s390/kernel/signal.c:35:
00:00:12 arch/s390/kernel/signal.c: In function =E2=80=98setup_frame=E2=80=
=99:
00:00:12 ./arch/s390/include/asm/vdso.h:14:67: error:
=E2=80=98vdso64_offset_sigreturn=E2=80=99 undeclared (first use in this fun=
ction)
00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
00:00:12       |
            ^~~~~~~~~~~~~~
00:00:12 arch/s390/kernel/signal.c:340:14: note: in expansion of macro
=E2=80=98VDSO64_SYMBOL=E2=80=99
00:00:12   340 |   restorer =3D VDSO64_SYMBOL(current, sigreturn);
00:00:12       |              ^~~~~~~~~~~~~
00:00:12 ./arch/s390/include/asm/vdso.h:14:67: note: each undeclared
identifier is reported only once for each function it appears in
00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
00:00:12       |
            ^~~~~~~~~~~~~~
00:00:12 arch/s390/kernel/signal.c:340:14: note: in expansion of macro
=E2=80=98VDSO64_SYMBOL=E2=80=99
00:00:12   340 |   restorer =3D VDSO64_SYMBOL(current, sigreturn);
00:00:12       |              ^~~~~~~~~~~~~
00:00:12 arch/s390/kernel/signal.c: In function =E2=80=98setup_rt_frame=E2=
=80=99:
00:00:12 ./arch/s390/include/asm/vdso.h:14:67: error:
=E2=80=98vdso64_offset_rt_sigreturn=E2=80=99 undeclared (first use in this =
function)
00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
00:00:12       |
            ^~~~~~~~~~~~~~
00:00:12 arch/s390/kernel/signal.c:398:14: note: in expansion of macro
=E2=80=98VDSO64_SYMBOL=E2=80=99
00:00:12   398 |   restorer =3D VDSO64_SYMBOL(current, rt_sigreturn);
00:00:12       |              ^~~~~~~~~~~~~
00:00:12 arch/s390/kernel/signal.c: In function =E2=80=98arch_do_signal_or_=
restart=E2=80=99:
00:00:12 ./arch/s390/include/asm/vdso.h:16:67: error:
=E2=80=98vdso32_offset_restart_syscall=E2=80=99 undeclared (first use in th=
is
function); did you mean =E2=80=98do_no_restart_syscall=E2=80=99?
00:00:12    16 | #define VDSO32_SYMBOL(tsk, name)
((tsk)->mm->context.vdso_base + (vdso32_offset_##name))
00:00:12       |
            ^~~~~~~~~~~~~~
00:00:12 arch/s390/kernel/signal.c:514:22: note: in expansion of macro
=E2=80=98VDSO32_SYMBOL=E2=80=99
00:00:12   514 |     regs->psw.addr =3D VDSO32_SYMBOL(current, restart_sysc=
all);
00:00:12       |                      ^~~~~~~~~~~~~
00:00:12 ./arch/s390/include/asm/vdso.h:14:67: error:
=E2=80=98vdso64_offset_restart_syscall=E2=80=99 undeclared (first use in th=
is
function); did you mean =E2=80=98do_no_restart_syscall=E2=80=99?
00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
00:00:12       |
            ^~~~~~~~~~~~~~
00:00:12 arch/s390/kernel/signal.c:516:22: note: in expansion of macro
=E2=80=98VDSO64_SYMBOL=E2=80=99
00:00:12   516 |     regs->psw.addr =3D VDSO64_SYMBOL(current, restart_sysc=
all);
00:00:12       |                      ^~~~~~~~~~~~~
00:00:12 make[4]: *** [scripts/Makefile.build:273:
arch/s390/kernel/signal.o] Error 1

Veronika

> If not, please let me know.
>
> thanks,
>
> greg k-h
>

