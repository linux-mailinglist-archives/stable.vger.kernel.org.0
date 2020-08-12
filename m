Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24737243164
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 01:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgHLXQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 19:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHLXQq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 19:16:46 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A53C061383
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 16:16:45 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id o18so4115497eje.7
        for <stable@vger.kernel.org>; Wed, 12 Aug 2020 16:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mWshXrpax2tozenAEM7ag+s/OzLgpq6fe10P47L+QB4=;
        b=kAHdfjXSH9fGjrP285VeUFnmcVhFQlDCLhVhW88+wvZmKQtM+i7xolXB7vlZ1zwXfn
         sS2WDJZ/NSBnF4lsOoNPb9Y3cx8uqePpSzTOtSvW4YaQIZ2HI/A/2/Ea4TAFr8DCkiR8
         UZ7rWVFuNd1rQn5kOkVMZr71AJSHlQ8U04gSlHf4LYDxyTkrJgFRaMOixqhYsBn+SA2N
         5jAIb46gloTEss4J6/3foZDQ0iO6sBt3pSn/EUB5YierRQ2bu5FfhyzWnhWHNQVTw+KO
         k2ZDBFZRXH0dgki/ZVTBWslUNpo3Jv+kSxJazckDBYE6b6f7CZJFeOrXPD+ZY8ZvLbD5
         OnXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mWshXrpax2tozenAEM7ag+s/OzLgpq6fe10P47L+QB4=;
        b=UOUKgzqt17NGPB4A5iRMKZ3kOpAjHc0cbNQrC5dFEpOvMOxbZNhDlGYUUSFQQ38W6x
         PuDEAoR+DuAPFDzJuEjFnrSWc5wluAtShPsD9+Qx6T2GHJTu6An87qKMns9SuW2i3Mm9
         vazXUycFOkXtYG6MS8sDdfLv+Z8cw/bFSc+c/2X3zVWSQL7bdhKaUN3kxUBh0SyGzUit
         3BQEl0JYUUtXZUkrjTfiT/xH90A77cW+BWiS80/gjkpZ56Q1HROU2cwoQpGln0OD97+1
         HzoXqdaixTv2sbNBs2sovnbYTS3aVwBi42RUldhzoD2StgGzyiG9vZrUVWqMQzombaS1
         IhRg==
X-Gm-Message-State: AOAM530v59rn7xsezI0wNPYeXveMGTVKp4cyUjKsTq+jw5IU6RO+ooj5
        pIie3NVZIx+F4WdKy9IEnTGPz8MKC5MRR5bGTTgdCEhjzBQ=
X-Google-Smtp-Source: ABdhPJwEkt/RRIDV/+KWn70a046tQrtWIXgfNBjzTW8Bhi5VY2n5dPvxlT++WBc9v2vz4VI5uP1nv1bBghdunm+83tE=
X-Received: by 2002:a17:906:95cb:: with SMTP id n11mr2091529ejy.506.1597274204121;
 Wed, 12 Aug 2020 16:16:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200127173453.2089565-1-guro@fb.com> <20200130020626.GA21973@in.ibm.com>
 <20200130024135.GA14994@xps.DHCP.thefacebook.com>
In-Reply-To: <20200130024135.GA14994@xps.DHCP.thefacebook.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Wed, 12 Aug 2020 19:16:08 -0400
Message-ID: <CA+CK2bCQcnTpzq2wGFa3D50PtKwBoWbDBm56S9y8c+j+pD+KSw@mail.gmail.com>
Subject: Re: [PATCH v2 00/28] The new cgroup slab memory controller
To:     Roman Gushchin <guro@fb.com>
Cc:     Bharata B Rao <bharata@linux.ibm.com>,
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

Guys,

There is a convoluted deadlock that I just root caused, and that is
fixed by this work (at least based on my code inspection it appears to
be fixed); but the deadlock exists in older and stable kernels, and I
am not sure whether to create a separate patch for it, or backport
this whole thing.

Thread #1: Hot-removes memory
device_offline
  memory_subsys_offline
    offline_pages
      __offline_pages
        mem_hotplug_lock <- write access
      waits for Thread #3 refcnt for pfn 9e5113 to get to 1 so it can
migrate it.

Thread #2: ccs killer kthread
   css_killed_work_fn
     cgroup_mutex  <- Grab this Mutex
     mem_cgroup_css_offline
       memcg_offline_kmem.part
          memcg_deactivate_kmem_caches
            get_online_mems
              mem_hotplug_lock <- waits for Thread#1 to get read access

Thread #3: crashing userland program
do_coredump
  elf_core_dump
      get_dump_page() -> get page with pfn#9e5113, and increment refcnt
      dump_emit
        __kernel_write
          __vfs_write
            new_sync_write
              pipe_write
                pipe_wait   -> waits for Thread #4 systemd-coredump to
read the pipe

Thread #4: systemd-coredump
ksys_read
  vfs_read
    __vfs_read
      seq_read
        proc_single_show
          proc_cgroup_show
            cgroup_mutex -> waits from Thread #2 for this lock.

In Summary:
Thread#1 waits for Thread#3 for refcnt, Thread#3 waits for Thread#4 to
read pipe. Thread#4 waits for Thread#2 for cgroup_mutex lock; Thread#2
waits for Thread#1 for mem_hotplug_lock rwlock.

This work appears to fix this deadlock because cgroup_mutex is not
called anymore before mem_hotplug_lock (unless I am missing it), as it
removes memcg_deactivate_kmem_caches.

Thank you,
Pasha

On Wed, Jan 29, 2020 at 9:42 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Thu, Jan 30, 2020 at 07:36:26AM +0530, Bharata B Rao wrote:
> > On Mon, Jan 27, 2020 at 09:34:25AM -0800, Roman Gushchin wrote:
> > > The existing cgroup slab memory controller is based on the idea of
> > > replicating slab allocator internals for each memory cgroup.
> > > This approach promises a low memory overhead (one pointer per page),
> > > and isn't adding too much code on hot allocation and release paths.
> > > But is has a very serious flaw: it leads to a low slab utilization.
> > >
> > > Using a drgn* script I've got an estimation of slab utilization on
> > > a number of machines running different production workloads. In most
> > > cases it was between 45% and 65%, and the best number I've seen was
> > > around 85%. Turning kmem accounting off brings it to high 90s. Also
> > > it brings back 30-50% of slab memory. It means that the real price
> > > of the existing slab memory controller is way bigger than a pointer
> > > per page.
> > >
> > > The real reason why the existing design leads to a low slab utilization
> > > is simple: slab pages are used exclusively by one memory cgroup.
> > > If there are only few allocations of certain size made by a cgroup,
> > > or if some active objects (e.g. dentries) are left after the cgroup is
> > > deleted, or the cgroup contains a single-threaded application which is
> > > barely allocating any kernel objects, but does it every time on a new CPU:
> > > in all these cases the resulting slab utilization is very low.
> > > If kmem accounting is off, the kernel is able to use free space
> > > on slab pages for other allocations.
> > >
> > > Arguably it wasn't an issue back to days when the kmem controller was
> > > introduced and was an opt-in feature, which had to be turned on
> > > individually for each memory cgroup. But now it's turned on by default
> > > on both cgroup v1 and v2. And modern systemd-based systems tend to
> > > create a large number of cgroups.
> > >
> > > This patchset provides a new implementation of the slab memory controller,
> > > which aims to reach a much better slab utilization by sharing slab pages
> > > between multiple memory cgroups. Below is the short description of the new
> > > design (more details in commit messages).
> > >
> > > Accounting is performed per-object instead of per-page. Slab-related
> > > vmstat counters are converted to bytes. Charging is performed on page-basis,
> > > with rounding up and remembering leftovers.
> > >
> > > Memcg ownership data is stored in a per-slab-page vector: for each slab page
> > > a vector of corresponding size is allocated. To keep slab memory reparenting
> > > working, instead of saving a pointer to the memory cgroup directly an
> > > intermediate object is used. It's simply a pointer to a memcg (which can be
> > > easily changed to the parent) with a built-in reference counter. This scheme
> > > allows to reparent all allocated objects without walking them over and
> > > changing memcg pointer to the parent.
> > >
> > > Instead of creating an individual set of kmem_caches for each memory cgroup,
> > > two global sets are used: the root set for non-accounted and root-cgroup
> > > allocations and the second set for all other allocations. This allows to
> > > simplify the lifetime management of individual kmem_caches: they are
> > > destroyed with root counterparts. It allows to remove a good amount of code
> > > and make things generally simpler.
> > >
> > > The patchset* has been tested on a number of different workloads in our
> > > production. In all cases it saved significant amount of memory, measured
> > > from high hundreds of MBs to single GBs per host. On average, the size
> > > of slab memory has been reduced by 35-45%.
> >
> > Here are some numbers from multiple runs of sysbench and kernel compilation
> > with this patchset on a 10 core POWER8 host:
> >
> > ==========================================================================
> > Peak usage of memory.kmem.usage_in_bytes, memory.usage_in_bytes and
> > meminfo:Slab for Sysbench oltp_read_write with mysqld running as part
> > of a mem cgroup (Sampling every 5s)
> > --------------------------------------------------------------------------
> >                               5.5.0-rc7-mm1   +slab patch     %reduction
> > --------------------------------------------------------------------------
> > memory.kmem.usage_in_bytes    15859712        4456448         72
> > memory.usage_in_bytes         337510400       335806464       .5
> > Slab: (kB)                    814336          607296          25
> >
> > memory.kmem.usage_in_bytes    16187392        4653056         71
> > memory.usage_in_bytes         318832640       300154880       5
> > Slab: (kB)                    789888          559744          29
> > --------------------------------------------------------------------------
> >
> >
> > Peak usage of memory.kmem.usage_in_bytes, memory.usage_in_bytes and
> > meminfo:Slab for kernel compilation (make -s -j64) Compilation was
> > done from bash that is in a memory cgroup. (Sampling every 5s)
> > --------------------------------------------------------------------------
> >                               5.5.0-rc7-mm1   +slab patch     %reduction
> > --------------------------------------------------------------------------
> > memory.kmem.usage_in_bytes    338493440       231931904       31
> > memory.usage_in_bytes         7368015872      6275923968      15
> > Slab: (kB)                    1139072         785408          31
> >
> > memory.kmem.usage_in_bytes    341835776       236453888       30
> > memory.usage_in_bytes         6540427264      6072893440      7
> > Slab: (kB)                    1074304         761280          29
> >
> > memory.kmem.usage_in_bytes    340525056       233570304       31
> > memory.usage_in_bytes         6406209536      6177357824      3
> > Slab: (kB)                    1244288         739712          40
> > --------------------------------------------------------------------------
> >
> > Slab consumption right after boot
> > --------------------------------------------------------------------------
> >                               5.5.0-rc7-mm1   +slab patch     %reduction
> > --------------------------------------------------------------------------
> > Slab: (kB)                    821888          583424          29
> > ==========================================================================
> >
> > Summary:
> >
> > With sysbench and kernel compilation,  memory.kmem.usage_in_bytes shows
> > around 70% and 30% reduction consistently.
> >
> > Didn't see consistent reduction of memory.usage_in_bytes with sysbench and
> > kernel compilation.
> >
> > Slab usage (from /proc/meminfo) shows consistent 30% reduction and the
> > same is seen right after boot too.
>
> That's just perfect!
>
> memory.usage_in_bytes was most likely the same because the freed space
> was taken by pagecache.
>
> Thank you very much for testing!
>
> Roman
