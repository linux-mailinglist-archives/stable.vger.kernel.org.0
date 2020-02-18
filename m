Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D49161ED8
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 03:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgBRCJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 21:09:43 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40099 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgBRCJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 21:09:43 -0500
Received: by mail-io1-f68.google.com with SMTP id x1so9112849iop.7
        for <stable@vger.kernel.org>; Mon, 17 Feb 2020 18:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fM30C4hYe4O7W/0krOqJPNu1c/FGOvvSlzloCbaa9eo=;
        b=RhyLmMMrZpAnw7Zn/q8OV364RGL/Y2BtQcSmXyY3VuyY27YSj77tKY1IiAaM6PJ4iM
         UUlBG0gCLB8R0zxv5JYUK1TiO5veeVi9QEtrmxFvP+5rJk9Vzgz34EmFb+PHAZ4AGIj2
         e4FPU98V8AkcV/yO2bxFAo7os/d+M1r/UNaN8ZOl97R/LqGjeF8O3diM9hItPu8iq8n2
         KfFKtJiMc6Qvhp5xJ08NVeGL4XcMU8vZ1HsuBqWWHKWUvC1HOamPXi8adB5gRNlL2fgm
         OyBoqCKv9zwwBtP1/cp7a7wCEQUowe33y74+pV81Ji4HpcxtVl0NsRWCXlUCZ7RWo1fs
         xtsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fM30C4hYe4O7W/0krOqJPNu1c/FGOvvSlzloCbaa9eo=;
        b=C+jhPGEB6qzQWAVvaRHZVE0d6olAHmsNvaOpEna1bJYyLlAFCQprotva/ysyXonGn/
         q54cYcehbYbbaCh343UKop0xnecIoZgFS+MZ3C8tTYsRPwa+8ORnt0AR78/VFvcS2bns
         JYkNOiHaRkI9hd2A43u3swTO2TWAuIlcg1W6HLVleOJVvvDg6bnsjrC2JzCSDAZWnfTW
         A4w3cVFCpP19W3RMe1tzh50RHSZu1DKrjULk2FhRy7VrQc1lWgwP8DcmUiFnCSz3MOL1
         rzeEWPx95qU1suGAvRr/1n4Ob5mkg+udQvH/Wy/U5t2TGPPaWCWlBL+NF3yPYWvYLxnE
         bTFw==
X-Gm-Message-State: APjAAAV+57fnFhs9Jb8As1TC3dj0ioxWpY7gd4WSVyjogrTaeo4gmz1X
        MMmaCFSPjsYujDbEW3ukH37FSywx0YmSymU5rtw=
X-Google-Smtp-Source: APXvYqyy46ljQyc48W5bmQRGK2iak1CCvCtiIBcH3RGDp7Ap3mW6t41PnBBiOPQwOhvUhsFjaDrtIhyxCnfqqp6fUfg=
X-Received: by 2002:a6b:5503:: with SMTP id j3mr13912448iob.142.1581991782674;
 Mon, 17 Feb 2020 18:09:42 -0800 (PST)
MIME-Version: 1.0
References: <20200216145249.6900-1-laoar.shao@gmail.com> <20200217092459.GG31531@dhcp22.suse.cz>
 <CALOAHbCDVYKQ+WMD+Lke6V-FiUVfBsKCKmRHuGtUUWd1G4LctA@mail.gmail.com>
 <20200217132443.GM31531@dhcp22.suse.cz> <CALOAHbCVMnrtyxT4OzueD4mPKRRyyB-nF0w1nSX3ZGLuXTUUTQ@mail.gmail.com>
 <20200217140430.GO31531@dhcp22.suse.cz> <CALOAHbA0=QAo0KkKf-i_tSamhLQX2mmmP7h-CX2bRz9qcOSGwA@mail.gmail.com>
 <20200217143529.GQ31531@dhcp22.suse.cz> <CALOAHbA=fL4AbLFBE3riuxO7k48OnqtBwa1YNk6KBm+=CA7hPw@mail.gmail.com>
 <20200217151417.GS31531@dhcp22.suse.cz>
In-Reply-To: <20200217151417.GS31531@dhcp22.suse.cz>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 18 Feb 2020 10:09:06 +0800
Message-ID: <CALOAHbD-K_BFjw-mLGWY-PWRe4J9BaMc0w7YmU9yp-t4iV4F_A@mail.gmail.com>
Subject: Re: [PATCH resend] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Down <chris@chrisdown.name>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 17, 2020 at 11:14 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 17-02-20 22:40:22, Yafang Shao wrote:
> > On Mon, Feb 17, 2020 at 10:35 PM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Mon 17-02-20 22:28:38, Yafang Shao wrote:
> > > > On Mon, Feb 17, 2020 at 10:04 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > >
> > > > > On Mon 17-02-20 21:51:23, Yafang Shao wrote:
> > > > > > On Mon, Feb 17, 2020 at 9:24 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > >
> > > > > > > On Mon 17-02-20 21:08:12, Yafang Shao wrote:
> > > > > > > > On Mon, Feb 17, 2020 at 5:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> > > > > > > > >
> > > > > > > > > On Sun 16-02-20 09:52:49, Yafang Shao wrote:
> > > > > > > > > > memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> > > > > > > > > > them won't be changed until next recalculation in this function. After
> > > > > > > > > > either or both of them are set, the next reclaimer to relcaim this memcg
> > > > > > > > > > may be a different reclaimer, e.g. this memcg is also the root memcg of
> > > > > > > > > > the new reclaimer, and then in mem_cgroup_protection() in get_scan_count()
> > > > > > > > > > the old values of them will be used to calculate scan count, that is not
> > > > > > > > > > proper. We should reset them to zero in this case.
> > > > > > > > > >
> > > > > > > > > > Here's an example of this issue.
> > > > > > > > > >
> > > > > > > > > >     root_mem_cgroup
> > > > > > > > > >          /
> > > > > > > > > >         A   memory.max=1024M memory.min=512M memory.current=800M
> > > > > > > > > >
> > > > > > > > > > Once kswapd is waked up, it will try to scan all MEMCGs, including
> > > > > > > > > > this A, and it will assign memory.emin of A with 512M.
> > > > > > > > > > After that, A may reach its hard limit(memory.max), and then it will
> > > > > > > > > > do memcg reclaim. Because A is the root of this reclaimer, so it will
> > > > > > > > > > not calculate its memory.emin. So the memory.emin is the old value
> > > > > > > > > > 512M, and then this old value will be used in
> > > > > > > > > > mem_cgroup_protection() in get_scan_count() to get the scan count.
> > > > > > > > > > That is not proper.
> > > > > > > > >
> > > > > > > > > Please document user visible effects of this patch. What does it mean
> > > > > > > > > that this is not proper behavior?
> > > > > > > >
> > > > > > > > In the memcg reclaim, if the target memcg is the root of the reclaimer,
> > > > > > > > the reclaimer should scan this memcg's all page cache pages in the LRU,
> > > > > > > > but now as the old memcg.{emin, elow} value are still there, it will get
> > > > > > > > a wrong protection value,
> > > > > > > > and the reclaimer can't reclaim the page cache pages protected by this
> > > > > > > > wrong protection.
> > > > > > >
> > > > > > > Could you be more specific please. Your example above says that emin is
> > > > > > > not going to be recalculated and stays at 512M even for a potential max
> > > > > > > limit reclaim. The min limit is still 512M so why is this value wrong?
> > > > > > >
> > > > > >
> > > > > > Because the relcaimers are changed or the root the relcaimer is changed.
> > > > > >
> > > > > > Kswapd begins to relcaim memcg-A.
> > > > > > kswapd
> > > > > >   |
> > > > > > calculate the {emin, elow} for memcg-A
> > > > > >  |
> > > > > > stores {emin, elow} in memory.{emin, elow} of memcg-A
> > > > > > |
> > > > > > This memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > > (See get_scan_count->mem_cgroup_protection)
> > > > > > |
> > > > > > exit
> > > > > > (And it won't relcaim memcg-A for a long time)
> > > > > >
> > > > > >
> > > > > > Then memcg relcaimer is woke up (reached the hard limit of memcg-A),
> > > > > > and the root of this new reclaimer is memcg-A.
> > > > > >
> > > > > > This memcg relcaimer begins to reclaim memcg-A.
> > > > > > memcg relcaimer
> > > > > >       |
> > > > > > As the root of the relcaimer is memcg-A, it won't calculate emin, elow
> > > > > > for memcg-A.
> > > > > > (See if (memcg == root) in mem_cgroup_protected())
> > > > > >      |
> > > > > > The old memory.{emin, elow} will protect the page cache pages in memcg-A
> > > > > > (SO WE SHOULD CLEAR THE OLD VALUE)
> > > > >
> > > > > I am sorry but I still do not follow. Could you focus on _why_ the old
> > > > > value is no longer valid?
> > > >
> > > > Because for the new reclaimer the memory.{emin, elow} should be 0.
> > > > The old value may be not 0, but it was thought as 0 in the if
> > > > statement (if (memcg == root)).
> > >
> > > Why should it be 0 when the A.min is still 512MB?
> >
> > Because A's hard limit is reached and A is the root of memcg relcaimer.
>
> Confused. But your examples suggests that memory.max > memory.min so
> having an effective emin 0 or not doesn't make any difference.
>

Why is it having an effective emin 0 if memory.max > memory.min ?
Note that effective emin is only set in function
mem_cgroup_protected(), so if we don't set it explicitly to 0 then it
can't be 0.

Besides mem_cgroup_protected(), the effective emin also take effect in
the function mem_cgroup_protection(), but in this function it only use
the existed memory.emin rather than verifying memory.max > memory.min.

So the real issue is in mem_cgroup_protection(), because the value it
is using may be an old value.

> > If A is the root of the memcg reclaimer, then the memcg protection
> > should not prevent it from relcaiming the page cache pages of itself.
> > That is why the if statement if (memcg == root) exists.
>
> I suspect you misinterpret the code or your example is incomplete.
> Please have a look at the patch I have referred to earlier. Johannes
> explicitly sets effective values to their native ones
>         if (parent == root) {
>                 memcg->memory.emin = memcg->memory.min;
>                 memcg->memory.elow = memcg->memory.low;
>                 goto out;
>         }
>
> and this matches my understanding.

I haven't read Johannes's patch carefully, but take a first glance I
don't think it can fix this issue.


-- 
Yafang Shao
DiDi
