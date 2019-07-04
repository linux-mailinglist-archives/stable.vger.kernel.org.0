Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D6F5FE18
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 23:23:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfGDVXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 17:23:23 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:33655 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbfGDVXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 17:23:23 -0400
Received: by mail-yb1-f195.google.com with SMTP id x4so1667383ybk.0
        for <stable@vger.kernel.org>; Thu, 04 Jul 2019 14:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODcLKS4fA6Fts+ALAb5EoA1LXRf5LsQW3r2QMmBZkZg=;
        b=T454SotmdTpjOVqHBHQ4SE8pCSsTMij4gNDh/mfnD0X1Ut6R4I84quAVAYwkDBnMrk
         kuPgtCRGf3re38URtW6c55quE9g6OLy3hUOrIYaMkXRHGfENtv1TFBUA+8noXdqvQVTm
         hIibw5m3KZYMz0w7OChJTqwq9yiDFOEeI3jF0kG0ZzDNOTPEgemSVklS/G3dNF9YeHOy
         KKHvYnAUN5eIJ6jwPEGj1SZ84DhrGRN7PLwXyVpdCWozJK3r1YZ3Ik0rKHMjL5kw874u
         Gsnv3kPCmezz2PS7hCocfIrtAIgiVBgM/ADMToWpFs2XuiUpkTm0fLwSMJSbD7e9m3U1
         WLxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODcLKS4fA6Fts+ALAb5EoA1LXRf5LsQW3r2QMmBZkZg=;
        b=aGch27Fus7N9ffONJbdRSv3ghCYqajCPDY6ylkrrOfj4V5Rv602V3WShj4qFvRV3sE
         9Q1WMMP7pykgK3OxR9439HSPazI0ZZ9S+59NhIezAYFGD7pRSP65MHXzXBzC2t7q4j80
         //rslHvpKIadC6gQY1PELqKAjn7/tqfBpJUbqi6XWHiS27RFnfWov2w/52QJTJ9YtO48
         thqscRpyFH5A5473e78PqzkfQcVIKPoj8mwTCHSQyFvzj5gr1emsq8Tlyre+5cjZJD/n
         pK0a2eBCcJQ55occrCuf00PbJb3GFgLD9PGFgjzbC9ckTAYfNIImNLISU+H7Xz2ZGI3N
         /9Yw==
X-Gm-Message-State: APjAAAX3qXvACCEAwliEs7hdgoaoxyhgPk0EhISzaWYlgou3gddX6ygi
        nBs+3C8GoKTrjercgwX5x/pPsRFBgI2D7FPRBxgIag==
X-Google-Smtp-Source: APXvYqwVMVqw9/e7Du+/z1RCV15VKc57umt9D+M0HKHWMNebwwH17Gud3tvPZrktcNIaaLBpyA5iWjrRShGJNs6cGg4=
X-Received: by 2002:a25:9903:: with SMTP id z3mr239063ybn.293.1562275402132;
 Thu, 04 Jul 2019 14:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190704210222.D8psCcsKb%akpm@linux-foundation.org>
In-Reply-To: <20190704210222.D8psCcsKb%akpm@linux-foundation.org>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 4 Jul 2019 14:23:11 -0700
Message-ID: <CALvZod5a1hNeD_nMsE92dpp7geVJYRa2KdtUdCBQBZze+oXixQ@mail.gmail.com>
Subject: Re: + mm-memcontrol-fix-wrong-statistics-in-memorystat.patch added to
 -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Yafang Shao <laoar.shao@gmail.com>,
        Michal Hocko <mhocko@suse.com>, mm-commits@vger.kernel.org,
        Yafang Shao <shaoyafang@didiglobal.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 4, 2019 at 2:02 PM <akpm@linux-foundation.org> wrote:
>
>
> The patch titled
>      Subject: mm/memcontrol: fix wrong statistics in memory.stat
> has been added to the -mm tree.  Its filename is
>      mm-memcontrol-fix-wrong-statistics-in-memorystat.patch
>
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-fix-wrong-statistics-in-memorystat.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-fix-wrong-statistics-in-memorystat.patch
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
>
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
>
> ------------------------------------------------------
> From: Yafang Shao <laoar.shao@gmail.com>
> Subject: mm/memcontrol: fix wrong statistics in memory.stat
>
> When we calculate total statistics for memcg1_stats and memcg1_events, we
> use the the index 'i' in the for loop as the events index.  Actually we
> should use memcg1_stats[i] and memcg1_events[i] as the events index.
>
> Link: http://lkml.kernel.org/r/1562116978-19539-1-git-send-email-laoar.shao@gmail.com
> Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty").

Missing Yafang's signoff and my reviewed-by.

> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Yafang Shao <shaoyafang@didiglobal.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/memcontrol.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> --- a/mm/memcontrol.c~mm-memcontrol-fix-wrong-statistics-in-memorystat
> +++ a/mm/memcontrol.c
> @@ -3530,12 +3530,13 @@ static int memcg_stat_show(struct seq_fi
>                 if (memcg1_stats[i] == MEMCG_SWAP && !do_memsw_account())
>                         continue;
>                 seq_printf(m, "total_%s %llu\n", memcg1_stat_names[i],
> -                          (u64)memcg_page_state(memcg, i) * PAGE_SIZE);
> +                          (u64)memcg_page_state(memcg, memcg1_stats[i]) *
> +                          PAGE_SIZE);
>         }
>
>         for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
>                 seq_printf(m, "total_%s %llu\n", memcg1_event_names[i],
> -                          (u64)memcg_events(memcg, i));
> +                          (u64)memcg_events(memcg, memcg1_events[i]));
>
>         for (i = 0; i < NR_LRU_LISTS; i++)
>                 seq_printf(m, "total_%s %llu\n", mem_cgroup_lru_names[i],
> _
>
> Patches currently in -mm which might be from laoar.shao@gmail.com are
>
> mm-memcontrol-fix-wrong-statistics-in-memorystat.patch
> mm-vmscan-expose-cgroup_ino-for-memcg-reclaim-tracepoints.patch
> mm-vmscan-add-a-new-member-reclaim_state-in-struct-shrink_control.patch
> mm-vmscan-add-a-new-member-reclaim_state-in-struct-shrink_control-fix.patch
> mm-vmscan-calculate-reclaimed-slab-caches-in-all-reclaim-paths.patch
>
