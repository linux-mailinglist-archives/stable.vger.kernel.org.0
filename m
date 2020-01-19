Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4B7142036
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 22:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgASViU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 16:38:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44804 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727556AbgASViU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 16:38:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so27585550wrm.11
        for <stable@vger.kernel.org>; Sun, 19 Jan 2020 13:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xgf6yNAQ5PTiozZwIZP30hPxDsKkPPcwKTnS9SOUa+E=;
        b=Bwo/nlC6IePRsMLaCsNI4WnoGCqOiFcMf9Z/aWWm7jhKjiC2zRp9GTJIUtB0EXYy5t
         jYUaNTaeWjTsOk//Nj5NZer7c+5ZNnckqLLjcCZ/0UgLSAgATV7NrxOtAohm2T3OfY/g
         expUV3tEB52UDsQ3r1nRvrxZdoMMKORAbeLJGZ5zPapc4u5Jr/ABli7/s5pO1gis3dEb
         crucaBJtyLgfn1+gcmX2e8a0c2dUG57MxvG/01a//R8o1zMk3JpOZM3z+eW1FylBhbsH
         Iub3YjRvImehr4PmyivVqjpBxbgLAUiyAfhtiRJYb1JHACKiZld+VT5MRQM+dria9EW/
         N7eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xgf6yNAQ5PTiozZwIZP30hPxDsKkPPcwKTnS9SOUa+E=;
        b=oip/tQKArYqrBl/XG8s2nV4kekvzoT0XpweasxtK6xbar5ur4nA9an6cyFLfK3+ytn
         IRP1wWCwuLgsmPn0o6jDAekgcs2Ju8b1243W+HHPMBRhgzU9GoW5Tt7nzbPsjxeWEWCk
         Lj6RIrIC9v4zMTwA2JJsPxev4K3Y8vnrtRiqOOF+FuP2sZwM+eYuLATA8F2N0c73VId2
         5Oal6UrlITuClreFHJLOlD1RGifcHvqfq1BrZzeHpfOag6pwwdl76THbD/soyrModNXC
         MkZxo+HeiakgaXtbEo33E+mhBbMY/GzAjcUZCocYbL5xbvwl7BsWeayIpGnnoaOp1jhz
         hZyQ==
X-Gm-Message-State: APjAAAX7U1qwIM6jFuclnbLkQIs72I9hE2ILxTuoGP+06d4Pg3+lLK3V
        TmIoPqaeCR1NF5P5ro4qyl9l+/qOHLQCHKKXxEVz5Jw/
X-Google-Smtp-Source: APXvYqwBx6e3f1YLwGvAWWeUW+8QdRQJua2vFvjAYpswZF3xfOneP2hAC5He8pDXAeKULQ/A7QyywCnqTMzIuY+xc+M=
X-Received: by 2002:a5d:494b:: with SMTP id r11mr14595307wrs.184.1579469897756;
 Sun, 19 Jan 2020 13:38:17 -0800 (PST)
MIME-Version: 1.0
References: <4913d030-84c0-0eb9-f8b2-c006a1dd0757@cambridgegreys.com>
 <20191204174346.78dfd358bd15.I19e7eb2601fbdc0270fb1e1b647a75301e9e4503@changeid>
 <6581dcc9-daef-5a14-194c-1b351e3b8f85@cambridgegreys.com>
In-Reply-To: <6581dcc9-daef-5a14-194c-1b351e3b8f85@cambridgegreys.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Sun, 19 Jan 2020 22:38:06 +0100
Message-ID: <CAFLxGvyEwz93JryMDH+e9-ObyUj_jLhQBKSHNJ7nLZ_0LyfRiQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "um: Enable CONFIG_CONSTRUCTORS"
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-um <linux-um@lists.infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Johannes Berg <johannes.berg@intel.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 4, 2019 at 7:35 PM Anton Ivanov
<anton.ivanov@cambridgegreys.com> wrote:
>
>
>
> On 04/12/2019 16:43, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > This reverts commit 786b2384bf1c ("um: Enable CONFIG_CONSTRUCTORS").
> >
> > There are two issues with this commit, uncovered by Anton in tests
> > on some (Debian) systems:
> >
> > 1) I completely forgot to call any constructors if CONFIG_CONSTRUCTORS
> >     isn't set. Don't recall now if it just wasn't needed on my system, or
> >     if I never tested this case.
> >
> > 2) With that fixed, it works - with CONFIG_CONSTRUCTORS *unset*. If I
> >     set CONFIG_CONSTRUCTORS, it fails again, which isn't totally
> >     unexpected since whatever wanted to run is likely to have to run
> >     before the kernel init etc. that calls the constructors in this case.
> >
> > Basically, some constructors that gcc emits (libc has?) need to run
> > very early during init; the failure mode otherwise was that the ptrace
> > fork test already failed:
> >
> > ----------------------
> > $ ./linux mem=512M
> > Core dump limits :
> >       soft - 0
> >       hard - NONE
> > Checking that ptrace can change system call numbers...check_ptrace : child exited with exitcode 6, while expecting 0; status 0x67f
> > Aborted
> > ----------------------
> >
> > Thinking more about this, it's clear that we simply cannot support
> > CONFIG_CONSTRUCTORS in UML. All the cases we need now (gcov, kasan)
> > involve not use of the __attribute__((constructor)), but instead
> > some constructor code/entry generated by gcc. Therefore, we cannot
> > distinguish between kernel constructors and system constructors.
> >
> > Thus, revert this commit.
> >
> > Cc: stable@vger.kernel.org [5.4+]
> > Fixes: 786b2384bf1c ("um: Enable CONFIG_CONSTRUCTORS")
> > Reported-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >   arch/um/include/asm/common.lds.S | 2 +-
> >   arch/um/kernel/dyn.lds.S         | 1 +
> >   init/Kconfig                     | 1 +
> >   kernel/gcov/Kconfig              | 2 +-
> >   4 files changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/um/include/asm/common.lds.S b/arch/um/include/asm/common.lds.S
> > index d7086b985f27..4049f2c46387 100644
> > --- a/arch/um/include/asm/common.lds.S
> > +++ b/arch/um/include/asm/common.lds.S
> > @@ -83,8 +83,8 @@
> >       __preinit_array_end = .;
> >     }
> >     .init_array : {
> > -        /* dummy - we call this ourselves */
> >       __init_array_start = .;
> > +     *(.init_array)
> >       __init_array_end = .;
> >     }
> >     .fini_array : {
> > diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
> > index c69d69ee96be..f5001481010c 100644
> > --- a/arch/um/kernel/dyn.lds.S
> > +++ b/arch/um/kernel/dyn.lds.S
> > @@ -103,6 +103,7 @@ SECTIONS
> >        be empty, which isn't pretty.  */
> >     . = ALIGN(32 / 8);
> >     .preinit_array     : { *(.preinit_array) }
> > +  .init_array     : { *(.init_array) }
> >     .fini_array     : { *(.fini_array) }
> >     .data           : {
> >       INIT_TASK_DATA(KERNEL_STACK_SIZE)
> > diff --git a/init/Kconfig b/init/Kconfig
> > index b4daad2bac23..0328b53d09ad 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -54,6 +54,7 @@ config CC_DISABLE_WARN_MAYBE_UNINITIALIZED
> >
> >   config CONSTRUCTORS
> >       bool
> > +     depends on !UML
> >
> >   config IRQ_WORK
> >       bool
> > diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
> > index 060e8e726755..3941a9c48f83 100644
> > --- a/kernel/gcov/Kconfig
> > +++ b/kernel/gcov/Kconfig
> > @@ -4,7 +4,7 @@ menu "GCOV-based kernel profiling"
> >   config GCOV_KERNEL
> >       bool "Enable gcov-based kernel profiling"
> >       depends on DEBUG_FS
> > -     select CONSTRUCTORS
> > +     select CONSTRUCTORS if !UML
> >       default n
> >       ---help---
> >       This option enables gcov-based code profiling (e.g. for code coverage
> >
>
> Acked-by: Anton Ivanov <anton.ivanov@cambridgegreys.co.uk>

Applied. Thanks!

-- 
Thanks,
//richard
