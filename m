Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 530B0258E9F
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 14:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgIAMwv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 08:52:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbgIAMwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 08:52:44 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E82C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 05:52:42 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id a12so1301439eds.13
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 05:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pgSXSA4H8mdGNjJZ0yybSD4GOey4TsVcZvKV0kpPvc0=;
        b=S9jFVyxBJ/i/oy9jnxgCDPVeGrb68atuH7IGzBrwTa1sdRxt6qnKaGZLIN2USd8QCc
         2ypezbk2RyBPtf4gmMwKNSh2hHQ9CJnFl2qUamd6Y9NsWHxgLQTwWap1bw3sq1A/1uL0
         y6wJ9gC61lpcdpVYYTrHCQL4abJ+644L85lt8CmuWi7ZpLOwWnxHXn0WWPF4TyV/dd71
         ubb1I+l1a5or3xGHerTD2KpvccOYm9fb32elVTCgvnjoap20OOdUyw5LnEfyJhvcqRkP
         Y+LXFsomhloqu1/z4To1n9OFjQNCE47GjEW1FkHz3+FvTIvBtQQHAd5lDcUdtzwuNiSR
         zjkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pgSXSA4H8mdGNjJZ0yybSD4GOey4TsVcZvKV0kpPvc0=;
        b=WbNhaWp4odXKD54P7CS3YzPUMT0xXI6VT3BKvIo15BHDTs06WvqvDByLEwT0p3J2Pw
         sOjx2GRXdz7yLG18l+XJKqd5WeGUgdP5l72XK7QzX4nqob5vV8Plqqx0Ac3txD7VjvLo
         KRdu4h3iVm5fAqDBAjbPtiCFZ567YJC5SoibZ65cIU/J2zmppcS3pA1Kcl+wPyb5QyHJ
         wdNUanb6fDWEF+OwhfZlRQYX5NwSQMVWxqtYGNYQ4vHkNF7Tx6ktKyr/PexNLG0aNFV0
         YhCk0qzO2i9oJZU9wkZrJ4qtz4ATC8Asy5AvP4xFkm5hxD2D6Bxk3Wro9femkNkmeD3E
         KvOg==
X-Gm-Message-State: AOAM530HoyF7DZGuGIcq+J8dqJeBi1hfFWyvrCKJAHN0ywLXbbI3g8YN
        Yp6ijgtCCMXY1oQ9i6hOHCHA+4ktCQMclS2kOkclLw==
X-Google-Smtp-Source: ABdhPJxvjihOHm/euOwacTzZHy0ImKVveo3O/tXcHUIrkSg877sBO/hUWatDeEEOrtg6umY6mDRWry+Caz0ySzziV5k=
X-Received: by 2002:a50:9355:: with SMTP id n21mr1511489eda.237.1598964761499;
 Tue, 01 Sep 2020 05:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200127173453.2089565-1-guro@fb.com> <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com> <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
 <20200813000416.GA1592467@carbon.dhcp.thefacebook.com> <CA+CK2bDDToW=Q5RgeWkoN3_rUr3pyWGVb9MraTzM+DM3OZ+tdg@mail.gmail.com>
 <CA+CK2bBEHFuLLg79_h6bv4Vey+B0B2YXyBxTBa=Le12OKbNdwA@mail.gmail.com> <20200901052819.GA52094@in.ibm.com>
In-Reply-To: <20200901052819.GA52094@in.ibm.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Tue, 1 Sep 2020 08:52:05 -0400
Message-ID: <CA+CK2bDZW4F-Y7PDiVZ_Jdbw8F5GCa26JRSXyxFbdu-Q6dEpRg@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
To:     Bharata B Rao <bharata@linux.ibm.com>
Cc:     Roman Gushchin <guro@fb.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 1, 2020 at 1:28 AM Bharata B Rao <bharata@linux.ibm.com> wrote:
>
> On Fri, Aug 28, 2020 at 12:47:03PM -0400, Pavel Tatashin wrote:
> > There appears to be another problem that is related to the
> > cgroup_mutex -> mem_hotplug_lock deadlock described above.
> >
> > In the original deadlock that I described, the workaround is to
> > replace crash dump from piping to Linux traditional save to files
> > method. However, after trying this workaround, I still observed
> > hardware watchdog resets during machine  shutdown.
> >
> > The new problem occurs for the following reason: upon shutdown systemd
> > calls a service that hot-removes memory, and if hot-removing fails for
> > some reason systemd kills that service after timeout. However, systemd
> > is never able to kill the service, and we get hardware reset caused by
> > watchdog or a hang during shutdown:
> >
> > Thread #1: memory hot-remove systemd service
> > Loops indefinitely, because if there is something still to be migrated
> > this loop never terminates. However, this loop can be terminated via
> > signal from systemd after timeout.
> > __offline_pages()
> >       do {
> >           pfn = scan_movable_pages(pfn, end_pfn);
> >                   # Returns 0, meaning there is nothing available to
> >                   # migrate, no page is PageLRU(page)
> >           ...
> >           ret = walk_system_ram_range(start_pfn, end_pfn - start_pfn,
> >                                             NULL, check_pages_isolated_cb);
> >                   # Returns -EBUSY, meaning there is at least one PFN that
> >                   # still has to be migrated.
> >       } while (ret);
> >
> > Thread #2: ccs killer kthread
> >    css_killed_work_fn
> >      cgroup_mutex  <- Grab this Mutex
> >      mem_cgroup_css_offline
> >        memcg_offline_kmem.part
> >           memcg_deactivate_kmem_caches
> >             get_online_mems
> >               mem_hotplug_lock <- waits for Thread#1 to get read access
> >
> > Thread #3: systemd
> > ksys_read
> >  vfs_read
> >    __vfs_read
> >      seq_read
> >        proc_single_show
> >          proc_cgroup_show
> >            mutex_lock -> wait for cgroup_mutex that is owned by Thread #2
> >
> > Thus, thread #3 systemd stuck, and unable to deliver timeout interrupt
> > to thread #1.
> >
> > The proper fix for both of the problems is to avoid cgroup_mutex ->
> > mem_hotplug_lock ordering that was recently fixed in the mainline but
> > still present in all stable branches. Unfortunately, I do not see a
> > simple fix in how to remove mem_hotplug_lock from
> > memcg_deactivate_kmem_caches without using Roman's series that is too
> > big for stable.
>
> We too are seeing this on Power systems when stress-testing memory
> hotplug, but with the following call trace (from hung task timer)
> instead of Thread #2 above:
>
> __switch_to
> __schedule
> schedule
> percpu_rwsem_wait
> __percpu_down_read
> get_online_mems
> memcg_create_kmem_cache
> memcg_kmem_cache_create_func
> process_one_work
> worker_thread
> kthread
> ret_from_kernel_thread
>
> While I understand that Roman's new slab controller patchset will fix
> this, I also wonder if infinitely looping in the memory unplug path
> with mem_hotplug_lock held is the right thing to do? Earlier we had
> a few other exit possibilities in this path (like max retries etc)
> but those were removed by commits:
>
> 72b39cfc4d75: mm, memory_hotplug: do not fail offlining too early
> ecde0f3e7f9e: mm, memory_hotplug: remove timeout from __offline_memory
>
> Or, is the user-space test is expected to induce a signal back-off when
> unplug doesn't complete within a reasonable amount of time?

Hi Bharata,

Thank you for your input, it looks like you are experiencing the same
problems that I observed.

What I found is that the reason why our machines did not complete
hot-remove within the given time is because of this bug:
https://lore.kernel.org/linux-mm/20200901124615.137200-1-pasha.tatashin@soleen.com

Could you please try it and see if that helps for your case?

Thank you,
Pasha
