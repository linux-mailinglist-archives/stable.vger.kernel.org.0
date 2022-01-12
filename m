Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388DF48CB7F
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 20:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343922AbiALTGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 14:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241549AbiALTGn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 14:06:43 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D73E5C061748
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 11:06:42 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id h14so8315883ybe.12
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 11:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1N4+Xk2A1HV9Zz01S+vjdjuhpy9VXBL+0Xdf9UxVggQ=;
        b=Tsv0x4UhaAW7q8o0pJBbbyHs41au6t+Y+O8b2zY5Bq5f4RWLAfruyRblcTzN17ZiUy
         8EbQyjLIf50EdPX6iiu+yTQHVTCyaME4QJnfK/DR0BF0/Hefdez1kbYOGFKAlTUIFvj4
         7XWRYScoAFZzziDppLB2eGR+YxREcjskE7e8JshG3fETc96Pe1G64D5sQSbjCCAyYh1v
         R/9S0aYJyUdsauazoYSbqu+UGuVMhyTIDpd0vEX05cgFNzfMVHa4Ef3I8L2OsgLF7OZb
         75aaGtZIA+8VUGsiPOVMOZdFShrjKZSreG3G21YkBjWdyLeVF8wOeC2Lp5GiWLlI/Eok
         999g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1N4+Xk2A1HV9Zz01S+vjdjuhpy9VXBL+0Xdf9UxVggQ=;
        b=XsdAF1Zd0sEKSnkQuP8m6MofbHXBPRdJZIVVt++4V8bcrDf3SeqAJ+M7sEaV/2kUD7
         W+bPpL00AAbW7kAZumSnEFwtI8NZGy47qm+wWv8IGqYriyhgyJj3uSDb5jJvPLG3NKsY
         XKFQSTriMi04HA7XtI1AibQCfB6wneHSCw7mU2YWRcPit/3H9uwEsyG5jDdV3W6gFHxB
         +sg1FvXqi0r6lxPBAIz5yUMsEqr8sDVqYQSI4CbVAdv/KP6yFX5Mi8UzAb8Bwnk2DT+I
         yt8tWUoZoOxApmEW+wUyFKSJEy7SD9mbzVx2bCMbvPsmX6ECgdOptsqTEukdpclOB2rc
         OsKw==
X-Gm-Message-State: AOAM530W/luJs0CmWUtlhm1fv54otXybj9YECcYwBZtV/cOyNjvFPMZ4
        eZVs6aFdmxBtaBsbBRzi5PeN1Q3Y6VspcJG7Vd0Ung==
X-Google-Smtp-Source: ABdhPJzV8D8NEZA+hx+YEnSJtLVuC2jwO1yJEkjitVKUN8jWSUnfF6+WmaxZnHg54OZdg7cl3lSNBoAHMQJZ5csIrsE=
X-Received: by 2002:a25:c3c4:: with SMTP id t187mr1313832ybf.634.1642014401927;
 Wed, 12 Jan 2022 11:06:41 -0800 (PST)
MIME-Version: 1.0
References: <20220111232309.1786347-1-surenb@google.com> <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
 <Yd8a8TdThrGHsf2o@casper.infradead.org> <CAJuCfpF45VY_7esx7p2yEK+eK-ufSMsBETEdJPF=Mzxj+BTnLA@mail.gmail.com>
 <Yd8hpPwsIT2pbKUN@gmail.com> <CAJuCfpF_aZ7OnDRYr2MNa-x=ctO-daw-U=k+-GCYkJR1_yTHQg@mail.gmail.com>
 <Yd8mIY5IxwOKTK+D@gmail.com>
In-Reply-To: <Yd8mIY5IxwOKTK+D@gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 12 Jan 2022 11:06:30 -0800
Message-ID: <CAJuCfpG9o5Z7x6hvPXy-Tfgom31sm4rjAA=f4KiY9pppGRGSHQ@mail.gmail.com>
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

On Wed, Jan 12, 2022 at 11:04 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, Jan 12, 2022 at 10:53:48AM -0800, Suren Baghdasaryan wrote:
> > On Wed, Jan 12, 2022 at 10:44 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Wed, Jan 12, 2022 at 10:26:08AM -0800, Suren Baghdasaryan wrote:
> > > > On Wed, Jan 12, 2022 at 10:16 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > > >
> > > > > On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > > > > > > This happens with the following config:
> > > > > > >
> > > > > > > CONFIG_CGROUPS=n
> > > > > > > CONFIG_PSI=y
> > > > > > >
> > > > > > > With cgroups disabled these functions are defined as non-static but
> > > > > > > are not defined in the header
> > > > > > > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > > > > > > since the only external user cgroup.c is disabled. The cleanest way to
> > > > > > > fix these I think is by doing smth like this in psi.c:
> > > > >
> > > > > A cleaner way to solve these is simply:
> > > > >
> > > > > #ifndef CONFIG_CGROUPS
> > > > > static struct psi_trigger *psi_trigger_create(...);
> > > > > ...
> > > > > #endif
> > > > >
> > > > > I tested this works:
> > > > >
> > > > > $ cat foo5.c
> > > > > static int psi(void *);
> > > > >
> > > > > int psi(void *x)
> > > > > {
> > > > >         return (int)(long)x;
> > > > > }
> > > > >
> > > > > int bar(void *x)
> > > > > {
> > > > >         return psi(x);
> > > > > }
> > > > > $ gcc -W -Wall -O2 -c -o foo5.o foo5.c
> > > > > $ readelf -s foo5.o
> > > > >
> > > > > Symbol table '.symtab' contains 4 entries:
> > > > >    Num:    Value          Size Type    Bind   Vis      Ndx Name
> > > > >      0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
> > > > >      1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
> > > > >      2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
> > > > >      3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar
> > > > >
> > > >
> > > > Thanks Matthew!
> > > > That looks much cleaner. I'll post a separate patch to fix these. My
> > > > main concern was whether it's worth adding more code to satisfy this
> > > > warning but with this approach the code changes are minimal, so I'll
> > > > go ahead and post it shortly.
> > >
> > > Why not simply move the declarations of psi_trigger_create() and
> > > psi_trigger_destroy() in include/linux/psi.h outside of the
> > > '#ifdef CONFIG_CGROUPS' block, to match the .c file?
> >
> > IIRC this was done to avoid another warning that these functions are
> > not used outside of psi.c when CONFIG_CGROUPS=n
> >
>
> What tool gave that warning?

Let me double-check by building it. It has been a while since I
developed the code and I don't want to mislead by making false claims.

>
> - Eric
