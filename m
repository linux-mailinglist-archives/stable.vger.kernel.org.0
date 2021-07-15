Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA623CAD88
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 22:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346800AbhGOUGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 16:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346726AbhGOUGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 16:06:31 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B647C073375
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 12:54:46 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id go30so11262908ejc.8
        for <stable@vger.kernel.org>; Thu, 15 Jul 2021 12:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zHNlh//dIwbzoiIIHbeKHWQJjCegMg2CTrBRgzPNJi0=;
        b=KxL0yf4DoApKlyNR8guw3jw8sfJ2+Mr0AOeFWAMuKrA/qsr+j9mzgB/NzLfH5o9Ykm
         +CjipMtv53dz1Ol/FkykvdM6ttw1sp0UBAc4Qx2B9nbGjBdkAYJFq+zpyI0Ryse3pHSa
         jX3zy0U3EZOnPUPh4q8HJW3ADHgRwB6jgjfK4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zHNlh//dIwbzoiIIHbeKHWQJjCegMg2CTrBRgzPNJi0=;
        b=HvPONSEe8z7S5WPJ2ZvJO02gHyPqAyAxpdhQRavmHt9LmAZ3Y2ZeLxrfZNajzUSTv3
         9owKrWeEMD0hApTDq2PgI4ffOpQZZ37Eo/rpvET6+1ORS9zpdDGgd5YIAv9ONsfwb3li
         fIV/V0GD/NkF3rfPZRSCB447/43LtOm1s6+kwgFqCa4szNvcpz4f/buJpkpv6cYhqKLl
         zjsPN+5gLgF0WlOTO6x9QcAuMLmGE0Jk2Hw40Fopa1e3lfoaxdiQVTKF6TcQYIX0NqSN
         K1OeQFt7cr+wAVce+zWpdqqOIs8MkEFHYre+FtQ8zlh+OUgYUARGWH3R0CgOenvKM+dW
         OIOA==
X-Gm-Message-State: AOAM5339zoEPMWJBqDQJaynNk58qZKwGmtGAGa3jtWzqpRRzqQ3hXt48
        HB/qEInOvcJeLNoMsqXhxOO+3Mf0P7UM8HROT2WYRA==
X-Google-Smtp-Source: ABdhPJyZvG8QvcLXRpWrfKQxGiLLxrEAfzg8l9T8pYEsV1q8+354HrSwq7qaIsPwFcVCv7UNSyj4+liFnvY0nYuwnc8=
X-Received: by 2002:a17:906:28c4:: with SMTP id p4mr7369633ejd.302.1626378884738;
 Thu, 15 Jul 2021 12:54:44 -0700 (PDT)
MIME-Version: 1.0
References: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com> <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
 <YPBw8SQ/oQQXfguv@kroah.com> <CA+tGwnk3N6mGY+0HqKuhtraCx9Dyj9DU89dOt1tKNZ_Rg0jgeg@mail.gmail.com>
In-Reply-To: <CA+tGwnk3N6mGY+0HqKuhtraCx9Dyj9DU89dOt1tKNZ_Rg0jgeg@mail.gmail.com>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 15 Jul 2021 14:54:33 -0500
Message-ID: <CAFxkdArW4BUhip_6xbwBNorEcCHOBx+GNd7i6PaV-sToZr1iWg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E2=9D=8C_FAIL=3A_Test_report_for_kernel_5=2E13=2E2_=28stable=2D?=
        =?UTF-8?Q?queue=2C_ee00910f=29?=
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     Greg KH <greg@kroah.com>, CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 2:38 PM Veronika Kabatova <vkabatov@redhat.com> wro=
te:
>
> On Thu, Jul 15, 2021 at 7:32 PM Greg KH <greg@kroah.com> wrote:
> >
> > On Thu, Jul 15, 2021 at 02:51:15PM +0200, Veronika Kabatova wrote:
> > > On Thu, Jul 15, 2021 at 2:50 PM CKI Project <cki-project@redhat.com> =
wrote:
> > > >
> > > >
> > > > Hello,
> > > >
> > > > We ran automated tests on a recent commit from this kernel tree:
> > > >
> > > >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git=
/stable/linux-stable-rc.git
> > > >             Commit: ee00910f75ff - powerpc/powernv/vas: Release ref=
erence to tgid during window close
> > > >
> > > > The results of these automated tests are provided below.
> > > >
> > > >     Overall result: FAILED (see details below)
> > > >              Merge: OK
> > > >            Compile: FAILED
> > > >
> > > > All kernel binaries, config files, and logs are available for downl=
oad here:
> > > >
> > > >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.=
html?prefix=3Ddatawarehouse-public/2021/07/15/337656806
> > > >
> > > > We attempted to compile the kernel for multiple architectures, but =
the compile
> > > > failed on one or more architectures:
> > > >
> > > >            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> > > >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> > > >
> > >
> > > Hi, looks to be introduced by
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-r=
c.git/commit/?h=3Dqueue/5.13&id=3D07d407cc1259634b3334dd47519ecd64e6818617
> >
> > Are you sure?  I fixed a different build bug in that area a few hours
> > ago, if you rebuild the tree it should be resolved.
> >
>
> Yes. All runs of the queue hit the problem, including the latest
> b438694730fd. I also ran a test of the second latest completed
> run with a patch revert and the issue disappeared.
>
> That said, the c139bde0fdca rebase (second latest) introduced
> an s390x compilation problem that did not happen before. It
> is also visible with the latest head. I don't know what commit
> introduced it yet as the run barely finished:
>

I hit this same failure building in koji.  All of the s390 patches are
related, and appear to be an incomplete set:


s390-signal-switch-to-using-vdso-for-sigreturn-and-syscall-restart.patch
s390-vdso64-add-sigreturn-rt_sigreturn-and-restart_syscall.patch
s390-vdso-add-minimal-compat-vdso.patch
s390-vdso-always-enable-vdso.patch
s390-vdso-rename-vdso64_lbase-to-vdso_lbase.patch

Justin

>
> 00:00:12 In file included from arch/s390/kernel/signal.c:35:
> 00:00:12 arch/s390/kernel/signal.c: In function =E2=80=98setup_frame=E2=
=80=99:
> 00:00:12 ./arch/s390/include/asm/vdso.h:14:67: error:
> =E2=80=98vdso64_offset_sigreturn=E2=80=99 undeclared (first use in this f=
unction)
> 00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
> ((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
> 00:00:12       |
>             ^~~~~~~~~~~~~~
> 00:00:12 arch/s390/kernel/signal.c:340:14: note: in expansion of macro
> =E2=80=98VDSO64_SYMBOL=E2=80=99
> 00:00:12   340 |   restorer =3D VDSO64_SYMBOL(current, sigreturn);
> 00:00:12       |              ^~~~~~~~~~~~~
> 00:00:12 ./arch/s390/include/asm/vdso.h:14:67: note: each undeclared
> identifier is reported only once for each function it appears in
> 00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
> ((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
> 00:00:12       |
>             ^~~~~~~~~~~~~~
> 00:00:12 arch/s390/kernel/signal.c:340:14: note: in expansion of macro
> =E2=80=98VDSO64_SYMBOL=E2=80=99
> 00:00:12   340 |   restorer =3D VDSO64_SYMBOL(current, sigreturn);
> 00:00:12       |              ^~~~~~~~~~~~~
> 00:00:12 arch/s390/kernel/signal.c: In function =E2=80=98setup_rt_frame=
=E2=80=99:
> 00:00:12 ./arch/s390/include/asm/vdso.h:14:67: error:
> =E2=80=98vdso64_offset_rt_sigreturn=E2=80=99 undeclared (first use in thi=
s function)
> 00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
> ((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
> 00:00:12       |
>             ^~~~~~~~~~~~~~
> 00:00:12 arch/s390/kernel/signal.c:398:14: note: in expansion of macro
> =E2=80=98VDSO64_SYMBOL=E2=80=99
> 00:00:12   398 |   restorer =3D VDSO64_SYMBOL(current, rt_sigreturn);
> 00:00:12       |              ^~~~~~~~~~~~~
> 00:00:12 arch/s390/kernel/signal.c: In function =E2=80=98arch_do_signal_o=
r_restart=E2=80=99:
> 00:00:12 ./arch/s390/include/asm/vdso.h:16:67: error:
> =E2=80=98vdso32_offset_restart_syscall=E2=80=99 undeclared (first use in =
this
> function); did you mean =E2=80=98do_no_restart_syscall=E2=80=99?
> 00:00:12    16 | #define VDSO32_SYMBOL(tsk, name)
> ((tsk)->mm->context.vdso_base + (vdso32_offset_##name))
> 00:00:12       |
>             ^~~~~~~~~~~~~~
> 00:00:12 arch/s390/kernel/signal.c:514:22: note: in expansion of macro
> =E2=80=98VDSO32_SYMBOL=E2=80=99
> 00:00:12   514 |     regs->psw.addr =3D VDSO32_SYMBOL(current, restart_sy=
scall);
> 00:00:12       |                      ^~~~~~~~~~~~~
> 00:00:12 ./arch/s390/include/asm/vdso.h:14:67: error:
> =E2=80=98vdso64_offset_restart_syscall=E2=80=99 undeclared (first use in =
this
> function); did you mean =E2=80=98do_no_restart_syscall=E2=80=99?
> 00:00:12    14 | #define VDSO64_SYMBOL(tsk, name)
> ((tsk)->mm->context.vdso_base + (vdso64_offset_##name))
> 00:00:12       |
>             ^~~~~~~~~~~~~~
> 00:00:12 arch/s390/kernel/signal.c:516:22: note: in expansion of macro
> =E2=80=98VDSO64_SYMBOL=E2=80=99
> 00:00:12   516 |     regs->psw.addr =3D VDSO64_SYMBOL(current, restart_sy=
scall);
> 00:00:12       |                      ^~~~~~~~~~~~~
> 00:00:12 make[4]: *** [scripts/Makefile.build:273:
> arch/s390/kernel/signal.o] Error 1
>
> Veronika
>
> > If not, please let me know.
> >
> > thanks,
> >
> > greg k-h
> >
>
