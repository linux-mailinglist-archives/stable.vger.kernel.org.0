Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5BB1A706D
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 03:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgDNBIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 21:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgDNBH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 21:07:59 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5EFC0A3BDC
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 18:07:59 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id q19so10674852ljp.9
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 18:07:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pjKjWwmtlCHlQBhC2Wm4xBBadnDi4o65zOBIN4PLMlI=;
        b=ijQBsp2+A2t90IUsKbF/GaLT+GPF7+lql0FGFbEUrJ9SWZYDx/SsdOg0TknLwYsG++
         md25Z6qZ5FQhnITWu3VWSOYbzCZtz4WS6DDCoY/hCZqCUFTw7FS47iyp910Q79XAN2AK
         TArmllJSsQDty1euXIT+Km8uCQehaWHzZMhaLh4yG972F/QLPWfkOZHfXaQ9OqDhz1DO
         iTt5CNwY5/7MFFmUXN4srPuJs8TX8JCz8TCQDc1jWTeZ4AYTabmge4n1PXmd2licupHx
         G0gm1+3t5+t4PCCJNOrXr3xLpcEuBdMLcXHTNnnZc+RBUtAwEsHWHWu4YjUwFjivA9/l
         2/rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pjKjWwmtlCHlQBhC2Wm4xBBadnDi4o65zOBIN4PLMlI=;
        b=ae1MOmzxe/3TOMySB3e8ZH131kE7a2pU4IHtgEa1RuGu/MXiJsUzHlccfJoE4Cp73p
         f8L3z4SCT30iGUwJDY6+ja2nYKzrE0m/KnGINPbpn7F0ExCY1oGXX8XjQtXs8tLreWcu
         yHg40WyHio2N7dAJB6NTRBEbb+IgUZZTnU8V7iD5NIfECJq2PNDRKprwn4hkW/sZgkQB
         95Uu0V3kWZydiF4EWD8nh8qcDMwpIFP/wkDe1+2H7/DaTMr1FlJd3m2RN74TBb3m/44f
         PgHV24d9yrxt8unOD5wFzm++DJzzGj6ll9+5fy3F3auX9rBdP2lCdQVY+++Io9tLMhSZ
         B/zg==
X-Gm-Message-State: AGi0PuZaM62o+5+Ie69fMDlp/hwmxmIo7kYBcT4/nfe2WTfbRwywuHZI
        d0U6exiojaIeuDjUTzal8/aqEyW9NgBhDgMND1ouaQ==
X-Google-Smtp-Source: APiQypLjbWUm/qK6itzRjVlSBbeT6SHfeSxUeQT28VOQXCHBkPSPfWn1D1k+/ku3wX3dn+ykLz2TxY0WXsaw4RouFTk=
X-Received: by 2002:a2e:9a4a:: with SMTP id k10mr2168225ljj.115.1586826477624;
 Mon, 13 Apr 2020 18:07:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200412140427.6732-1-laoar.shao@gmail.com> <CALvZod56skzRJNAmtXo=VxtoVAgkamZekEh0K0SBV=D96BA7Yg@mail.gmail.com>
 <CALOAHbDa4BO2btFoMpqqPg6GQF47RSii=f+ZH6ONAqhQA=Z8KA@mail.gmail.com>
 <CALvZod5Jc6u4XGjSwfNi2teoVrSJjRGB304Vf2u41dS71buULg@mail.gmail.com> <CALOAHbAdOeYMR3DcLtf8S-tBXyb8xUjLfUYB1CxSFyKAAYFABg@mail.gmail.com>
In-Reply-To: <CALOAHbAdOeYMR3DcLtf8S-tBXyb8xUjLfUYB1CxSFyKAAYFABg@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 13 Apr 2020 18:07:46 -0700
Message-ID: <CALvZod7NCMCEkXKP0ue7XoHi8m2L-C2bnjuEdgwPhwn82eNdUg@mail.gmail.com>
Subject: Re: [PATCH] mm, memcg: fix inconsistent oom event behavior
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Chris Down <chris@chrisdown.name>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 5:58 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Tue, Apr 14, 2020 at 8:53 AM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > On Mon, Apr 13, 2020 at 5:36 PM Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > On Tue, Apr 14, 2020 at 1:06 AM Shakeel Butt <shakeelb@google.com> wrote:
> > > >
> > > > On Sun, Apr 12, 2020 at 7:04 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> > > > >
> > > > > A recent commit 9852ae3fe529 ("mm, memcg: consider subtrees in
> > > > > memory.events") changes the behavior of memcg events, which will
> > > > > consider subtrees in memory.events. But oom_kill event is a special one
> > > > > as it is used in both cgroup1 and cgroup2. In cgroup1, it is displayed
> > > > > in memory.oom_control. The file memory.oom_control is in both root memcg
> > > > > and non root memcg, that is different with memory.event as it only in
> > > > > non-root memcg. That commit is okay for cgroup2, but it is not okay for
> > > > > cgroup1 as it will cause inconsistent behavior between root memcg and
> > > > > non-root memcg.
> > > >
> > > > I still couldn't understand the cgroup v1's root vs non_root behavior
> > > > change. The behavior change I see is the hierarchical one i.e.
> > > > MEMCG_OOM_KILL event in the descendant will cause the notification and
> > > > count increment in the ancestors even in the cgroup v1.
> > >
> > > For the non-root memcg, its memory.oom_control(oom_kill) includes its
> > > descendants' oom_kill, but for root memcg, it doesn't include its
> > > descendants' oom_kill. That means, memory.oom_control(oom_kill) has
> > > different meanings in different memcgs. That is inconsistent.
> > >
> > > [snip]
> > > > I suppose we
> > > > don't want that behavior change in v1.
> > > >
> > >
> > > That is another topic. I think this feature is welcomed to cgroup1, if
> > > we can fully support it, for example by adding memory.events.local
> > > into cgroup1 as well, but as far as I know the cgroup1 is frozen.
> > >
> >
> > Please note that after your patch the non-root memcg's
> > memory.oom_control(oom_kill) will not include the descendant's
> > oom_kill anymore. The non-root and root memcg's
> > memory.oom_control(oom_kill) will not be hierarchical anymore but
> > consistent. I think that was the intention of the patch, right?
> >
>
> Right. If we can't fully support it in cgroup1, then let's don't touch
> its original behavior.
>

Agreed.

> > > > > Let's recover the original behavior for cgroup1.
> > > > >
> > > > > Fixes: 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events")
> > > > > Cc: Chris Down <chris@chrisdown.name>
> > > > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > > > Cc: Shakeel Butt <shakeelb@google.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

> > > > > ---
> > > > >  include/linux/memcontrol.h | 3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > > > index 8c340e6b347f..a0ae080a67d1 100644
> > > > > --- a/include/linux/memcontrol.h
> > > > > +++ b/include/linux/memcontrol.h
> > > > > @@ -798,7 +798,8 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
> > > > >                 atomic_long_inc(&memcg->memory_events[event]);
> > > > >                 cgroup_file_notify(&memcg->events_file);
> > > > >
> > > > > -               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
> > > > > +               if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS ||
> > > > > +                   !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > > >                         break;
> > > > >         } while ((memcg = parent_mem_cgroup(memcg)) &&
> > > > >                  !mem_cgroup_is_root(memcg));
> > > > > --
> > > > > 2.18.2
> > > > >
> > >
> > >
>
>
> Thanks
> Yafang
