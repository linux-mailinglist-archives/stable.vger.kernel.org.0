Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1F1095366
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 03:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfHTB3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 21:29:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:45323 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbfHTB3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 21:29:51 -0400
Received: by mail-io1-f65.google.com with SMTP id t3so8597369ioj.12;
        Mon, 19 Aug 2019 18:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KKjD5A8NaZUrH/M43uDXv8CAljNHrPrsN4OaxgcIFWU=;
        b=gVYZIY8BzCrk1VyB29fczZF2tKYtOEIigjrlogTwEIWHsU6+681mGRuSKV1Yaa1DNx
         YhD+oeBQZiyRrYCmRexgUUhbubEWfdOpvKgJJTU1Si+vT/BfbUOMZZ1+sM0D5wVH0Pvf
         TRQVXvTaXNLees07ZAko50w9Qd+1sQCFYvXI5hIcWyfDLuYYlrOq0JwiUCgLfalasdcz
         H9jCvAyI2ZjVEoZYsi4yXrHqUkKwX6TxQQ06ulagsxGTDdljwqBD170Rbf2dR2Pr8jr4
         pH4p6MM/NdLPN3alOV3IGTvm4PIl9GE0G2VU083yyM5LNAyJW/UBSLBgxjyoZZdLzo9b
         wKYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KKjD5A8NaZUrH/M43uDXv8CAljNHrPrsN4OaxgcIFWU=;
        b=PYPLq24H6i7nobHunbjFP0OMRk7W/GCCXEIGvyRYDdaBZemd6BOP8tzaydyRadNkpn
         1S4yHgVjtayrlY/T+iNDbtKdWN+eDQotJmMNT75Vk2F6hauONviHjl6YD7Qj5nJ+DAOT
         dO9m2THkRwwGknQ9Q6riXVvrp6YDmTrZOX+HO4F3+AU+F7naYsp5x1iFXAfUDOuIzlFC
         yBBvxq/6yCR6sn7K+SHHBDl6ZW/go5oz3ogPWUeq8cDAEDqKoCS7ey07I1NvxX7+QasQ
         AO+qEeKvXN9xsqvjx0N+4lyR9MfNlNeggrOc1F9Ovss5m8fq3oL2jAEjyPaHgwrVX4uY
         8cmg==
X-Gm-Message-State: APjAAAXCxk/2yBJOvQM/BBR6iHeeU1qWl/WQ/oqTflVlXdguSRMngGQe
        EmhFl6X/eucP574MmaUHCAZdnZXac/YSas37z18=
X-Google-Smtp-Source: APXvYqwsPm5MLF4aYGeG/QAtbB9h+kk5pi4C2nkEC0lE+bqaQGppmxMlXeVXIRPxp9/vOiGE3ZAhisVxV57qTI1WnWM=
X-Received: by 2002:a6b:e511:: with SMTP id y17mr547859ioc.228.1566264590034;
 Mon, 19 Aug 2019 18:29:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190817004726.2530670-1-guro@fb.com> <CALOAHbBsMNLN6jZn83zx6EWM_092s87zvDQ7p-MZpY+HStk-1Q@mail.gmail.com>
 <20190817191419.GA11125@castle> <CALOAHbA-Z-1QDSgQ6H6QhPaPwAGyqfpd3Gbq-KLnoO=ZZxWnrw@mail.gmail.com>
 <20190819212034.GB24956@tower.dhcp.thefacebook.com>
In-Reply-To: <20190819212034.GB24956@tower.dhcp.thefacebook.com>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Tue, 20 Aug 2019 09:29:14 +0800
Message-ID: <CALOAHbCwWHirJjmByeAVZdDoHpCMabq20tzMdhr_25Ddic9TYw@mail.gmail.com>
Subject: Re: [PATCH] Partially revert "mm/memcontrol.c: keep local VM counters
 in sync with the hierarchical ones"
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 5:20 AM Roman Gushchin <guro@fb.com> wrote:
>
> On Sun, Aug 18, 2019 at 08:30:15AM +0800, Yafang Shao wrote:
> > On Sun, Aug 18, 2019 at 3:14 AM Roman Gushchin <guro@fb.com> wrote:
> > >
> > > On Sat, Aug 17, 2019 at 11:33:57AM +0800, Yafang Shao wrote:
> > > > On Sat, Aug 17, 2019 at 8:47 AM Roman Gushchin <guro@fb.com> wrote:
> > > > >
> > > > > Commit 766a4c19d880 ("mm/memcontrol.c: keep local VM counters in sync
> > > > > with the hierarchical ones") effectively decreased the precision of
> > > > > per-memcg vmstats_local and per-memcg-per-node lruvec percpu counters.
> > > > >
> > > > > That's good for displaying in memory.stat, but brings a serious regression
> > > > > into the reclaim process.
> > > > >
> > > > > One issue I've discovered and debugged is the following:
> > > > > lruvec_lru_size() can return 0 instead of the actual number of pages
> > > > > in the lru list, preventing the kernel to reclaim last remaining
> > > > > pages. Result is yet another dying memory cgroups flooding.
> > > > > The opposite is also happening: scanning an empty lru list
> > > > > is the waste of cpu time.
> > > > >
> > > > > Also, inactive_list_is_low() can return incorrect values, preventing
> > > > > the active lru from being scanned and freed. It can fail both because
> > > > > the size of active and inactive lists are inaccurate, and because
> > > > > the number of workingset refaults isn't precise. In other words,
> > > > > the result is pretty random.
> > > > >
> > > > > I'm not sure, if using the approximate number of slab pages in
> > > > > count_shadow_number() is acceptable, but issues described above
> > > > > are enough to partially revert the patch.
> > > > >
> > > > > Let's keep per-memcg vmstat_local batched (they are only used for
> > > > > displaying stats to the userspace), but keep lruvec stats precise.
> > > > > This change fixes the dead memcg flooding on my setup.
> > > > >
> > > >
> > > > That will make some misunderstanding if the local counters are not in
> > > > sync with the hierarchical ones
> > > > (someone may doubt whether there're something leaked.).
> > >
> > > Sure, but the actual leakage is a much more serious issue.
> > >
> > > > If we have to do it like this, I think we should better document this behavior.
> > >
> > > Lru size calculations can be done using per-zone counters, which is
> > > actually cheaper, because the number of zones is usually smaller than
> > > the number of cpus. I'll send a corresponding patch on Monday.
> > >
> >
> > Looks like a good idea.
> >
> > > Maybe other use cases can also be converted?
> >
> > We'd better keep the behavior the same across counters. I think you
> > can have a try.
>
> As I said, consistency of counters is important, but not nearly as important
> as the real behavior of the system. Especially because we talk about
> per-node memcg statistics, which I believe is mostly used for debugging.
>
> So for now I think the right thing to do is to revert the change to fix
> the memory reclaim process. And then we can discuss how to get counters
> right.
>

Sure.

Thanks
Yafang
