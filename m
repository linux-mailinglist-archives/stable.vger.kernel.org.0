Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F365148CC4D
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 20:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343667AbiALTuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 14:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357749AbiALTuK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 14:50:10 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862C7C06173F
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 11:50:10 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id p187so8839425ybc.0
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 11:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jRJqEvb6RaoXDTGIGvfe6D9l0JWX3IBGy+0XrscHKFk=;
        b=A05wtVt0YhyBSdDPVxnMOaffKavmT2bc7mtYBlQvpXZuCcKdvBu2pQnaPFx3DGatS3
         dletqWECy0d2sgn8vA9vLAVgNohXHyzj9Cgqbl79LKWXgG+hE4wDbGAhWFykD9TScLom
         RAoovIZCddTCKuxzFHyAQtyUFKl1Zj9Pah7k/alWN5AMM8RaorUkk56uf1K/F+4vbrJ1
         tVX2xsXqH3CMuhvO/jQ0GHItrhwrslksLTTyVuEJKA47jbtOoEt6Dy2V8InbwuqJee6U
         RtN4mRaJgakGvKhskjQGCe4cEY3Rn9j04AANjfnBq6vDTcY1WWI2cp4TB0GwIncWQef6
         qjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jRJqEvb6RaoXDTGIGvfe6D9l0JWX3IBGy+0XrscHKFk=;
        b=2FRx28ep+e6SJPoRQFxbJJUEP1/MDa0crQw9+qZc4YZQ370gFS8ehsQabPXE4fvWUd
         tzjsU4/cT71PbUHyN1sUlv4NxZMjmO2Us/J4G34wavVCMDzW6NKJAZKIvqiso4xJoac3
         eFo/BrVPXG8jDkqvBMRo3wzc6jxsf6tmyh9A78xuHyiHuPMeABNrXdAIhmkawqte6zVZ
         6GoWCg3NMfVFWv25mcp/aeePz5E/ujqqWwQ73bOCU/Xj0dMarDX4R3Qcmp3PVCeVJ7za
         xZld239xmOVDrqj3YJ5xRj8kJy5wvA4ALyIYcEVF5/dPuvN+z6YzmJ8DP1HTBzbBLuoW
         LuEA==
X-Gm-Message-State: AOAM533Jfwm/8UoXmQgaXcMR5MEd5bqBs5eaqfCagQirc39rMYBSWuOn
        u66rF8oaFfpNqVyA3hh2NKaNBcJWrSPsqDGl9slo1ZO0egXiaw==
X-Google-Smtp-Source: ABdhPJx6W0X7kISJhEYdoiY21aNG29fuGIZW3ogzIBP7+xBMxjmD0lYfSi3qgeEmYg4Q7LUKrKFZmmy6/h0/7WJ3H6o=
X-Received: by 2002:a25:c245:: with SMTP id s66mr1871016ybf.243.1642017009537;
 Wed, 12 Jan 2022 11:50:09 -0800 (PST)
MIME-Version: 1.0
References: <20220111232309.1786347-1-surenb@google.com> <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
 <Yd8a8TdThrGHsf2o@casper.infradead.org> <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA@mail.gmail.com>
 <Yd8hpPwsIT2pbKUN@gmail.com> <CAJuCfpF_aZ7OnDRYr2MNa-x=ctO-daw-U=k+-GCYkJR1_yTHQg@mail.gmail.com>
 <Yd8mIY5IxwOKTK+D@gmail.com> <CAJuCfpG9o5Z7x6hvPXy-Tfgom31sm4rjAA=f4KiY9pppGRGSHQ@mail.gmail.com>
In-Reply-To: <CAJuCfpG9o5Z7x6hvPXy-Tfgom31sm4rjAA=f4KiY9pppGRGSHQ@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 12 Jan 2022 11:49:58 -0800
Message-ID: <CAJuCfpHeg9mb4oq71P6xcC9fQipWBaAy9WJZg=jM+cUnR+ouMg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 12, 2022 at 11:06 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> On Wed, Jan 12, 2022 at 11:04 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Wed, Jan 12, 2022 at 10:53:48AM -0800, Suren Baghdasaryan wrote:
> > > On Wed, Jan 12, 2022 at 10:44 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > >
> > > > On Wed, Jan 12, 2022 at 10:26:08AM -0800, Suren Baghdasaryan wrote:
> > > > > On Wed, Jan 12, 2022 at 10:16 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > > > >
> > > > > > On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > > > > > > > This happens with the following config:
> > > > > > > >
> > > > > > > > CONFIG_CGROUPS=n
> > > > > > > > CONFIG_PSI=y
> > > > > > > >
> > > > > > > > With cgroups disabled these functions are defined as non-static but
> > > > > > > > are not defined in the header
> > > > > > > > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > > > > > > > since the only external user cgroup.c is disabled. The cleanest way to
> > > > > > > > fix these I think is by doing smth like this in psi.c:
> > > > > >
> > > > > > A cleaner way to solve these is simply:
> > > > > >
> > > > > > #ifndef CONFIG_CGROUPS
> > > > > > static struct psi_trigger *psi_trigger_create(...);
> > > > > > ...
> > > > > > #endif
> > > > > >
> > > > > > I tested this works:
> > > > > >
> > > > > > $ cat foo5.c
> > > > > > static int psi(void *);
> > > > > >
> > > > > > int psi(void *x)
> > > > > > {
> > > > > >         return (int)(long)x;
> > > > > > }
> > > > > >
> > > > > > int bar(void *x)
> > > > > > {
> > > > > >         return psi(x);
> > > > > > }
> > > > > > $ gcc -W -Wall -O2 -c -o foo5.o foo5.c
> > > > > > $ readelf -s foo5.o
> > > > > >
> > > > > > Symbol table '.symtab' contains 4 entries:
> > > > > >    Num:    Value          Size Type    Bind   Vis      Ndx Name
> > > > > >      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
> > > > > >      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
> > > > > >      2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
> > > > > >      3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar
> > > > > >
> > > > >
> > > > > Thanks Matthew!
> > > > > That looks much cleaner. I'll post a separate patch to fix these. My
> > > > > main concern was whether it's worth adding more code to satisfy this
> > > > > warning but with this approach the code changes are minimal, so I'll
> > > > > go ahead and post it shortly.
> > > >
> > > > Why not simply move the declarations of psi_trigger_create() and
> > > > psi_trigger_destroy() in include/linux/psi.h outside of the
> > > > '#ifdef CONFIG_CGROUPS' block, to match the .c file?
> > >
> > > IIRC this was done to avoid another warning that these functions are
> > > not used outside of psi.c when CONFIG_CGROUPS=n
> > >
> >
> > What tool gave that warning?
>
> Let me double-check by building it. It has been a while since I
> developed the code and I don't want to mislead by making false claims.
>

No warnings, so it was probably done to keep the scope of these
functions as local as possible.
I agree that moving them out of #ifdef CONFIG_CGROUPS in the header
file makes sense here. The scope unnecessarily expands when
CONFIG_CGROUPS=n but the code is simpler. Will do that then.

I noticed there is another warning about psi_cpu_proc_ops and similar
structures being unused when CONFIG_PROC_FS=n. Looks like I'll need
some more ifdefs to fix all these warnings.

> >
> > - Eric
