Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CE24751C5
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 05:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbhLOEs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 23:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhLOEs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 23:48:26 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD8AC061574;
        Tue, 14 Dec 2021 20:48:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 36-20020a17090a09a700b001b103e48cfaso731080pjo.0;
        Tue, 14 Dec 2021 20:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QSJFdNHmXZjsmVMjqaJMFUvlmr/IGVuF1VTcRtG/qDI=;
        b=GcMJptJKF9iGYR7c1eI2K+/EVlLYTBekM+m4OlH2NpCAchuSa3sSHzeoShBBxRKmXa
         fKZDmaR4ySaNfZ4xFhXniRCw2lusT9Jz3ALywIc+hmjqozeufWZ8jXnhW4UU/DLJmTrO
         Ojl5Evl/xFfeC91MVsWDqiCdaSFSbQY/otcqVJByotSDcazCG4pWQgmtffRPwlq5AJo5
         L3tTiJk2It9OjCOTVF06J7imCJdfMtbRqVUD5XQZzPynSjSJaR9druF1FBFQYM2E8Pmm
         DOXUViB/pyLOOM6ycTlVwpuY02zr4W3kB2Gmt3BjYqjUBtpBZRQYYS0ZgHsmdsIJ4R6H
         Nb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QSJFdNHmXZjsmVMjqaJMFUvlmr/IGVuF1VTcRtG/qDI=;
        b=2PgLVik+0KWY36i1uiSK3M0NJ67GEGITwC+CKqOM5f0zLuTY3oiYCfKrMdFdM7yP9k
         aJCk7ByaZcGFbny5e+kh/RxghPlcME2kmcAoDRfyNOt8Ge8ud3CAQqF7CCXsDet9xDma
         MtUcElWjGwz1amd6pC6maoS6k3w7Nm3nuhA/zjgJ9bCKl2SxVtffHPLHuEaMwTdDrBMQ
         BhcrVPmAN5nHnXqBcSivemCVmq5X0E2vdtErKCt9MLhLoX2u+lvLJek1rZCJa2SsnqYj
         JPT+yXxP1Qfhq9ZS7JSkU2bfptnmqfTw3Rnp0SpB3Sqbhzjmt0eiWrLNGurew3FBOpEx
         NysQ==
X-Gm-Message-State: AOAM531irn8KqanAFgL0pleBvuGvRxFbNJcFKEsIUO54g6YQ/e1m2fDg
        WEZ9gRa3HMaChZSy6exDb+ujC4UKmNWkiPGF
X-Google-Smtp-Source: ABdhPJyr/jHE/RxZ7IBkI9UTQoUjUj3kMnVy0GJkNOYcipoAxptgoDt+bobYGEB3N1/dB0RyDzmiaA==
X-Received: by 2002:a17:902:7d8b:b0:144:e29b:4f2b with SMTP id a11-20020a1709027d8b00b00144e29b4f2bmr9813215plm.57.1639543705830;
        Tue, 14 Dec 2021 20:48:25 -0800 (PST)
Received: from odroid ([114.29.23.242])
        by smtp.gmail.com with ESMTPSA id d195sm703154pga.41.2021.12.14.20.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 20:48:25 -0800 (PST)
Date:   Wed, 15 Dec 2021 04:48:18 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org, hch@lst.de,
        cl@linux.com, John.p.donnelly@oracle.com,
        kexec@lists.infradead.org, stable@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <20211215044818.GB1097530@odroid>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
 <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5ff82eb-73b6-55b5-53d7-04ab73ce5035@suse.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 11:09:23AM +0100, Vlastimil Babka wrote:
> On 12/14/21 06:32, Baoquan He wrote:
> > On 12/13/21 at 01:43pm, Hyeonggon Yoo wrote:
> >> Hello Baoquan. I have a question on your code.
> >> 
> >> On Mon, Dec 13, 2021 at 08:27:12PM +0800, Baoquan He wrote:
> >> > Dma-kmalloc will be created as long as CONFIG_ZONE_DMA is enabled.
> >> > However, it will fail if DMA zone has no managed pages. The failure
> >> > can be seen in kdump kernel of x86_64 as below:
> >> > 
> 
> Could have included the warning headline too.
> 
> >> >  CPU: 0 PID: 65 Comm: kworker/u2:1 Not tainted 5.14.0-rc2+ #9
> >> >  Hardware name: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS RMLSDP.86I.R2.28.D690.1306271008 06/27/2013
> >> >  Workqueue: events_unbound async_run_entry_fn
> >> >  Call Trace:
> >> >   dump_stack_lvl+0x57/0x72
> >> >   warn_alloc.cold+0x72/0xd6
> >> >   __alloc_pages_slowpath.constprop.0+0xf56/0xf70
> >> >   __alloc_pages+0x23b/0x2b0
> >> >   allocate_slab+0x406/0x630
> >> >   ___slab_alloc+0x4b1/0x7e0
> >> >   ? sr_probe+0x200/0x600
> >> >   ? lock_acquire+0xc4/0x2e0
> >> >   ? fs_reclaim_acquire+0x4d/0xe0
> >> >   ? lock_is_held_type+0xa7/0x120
> >> >   ? sr_probe+0x200/0x600
> >> >   ? __slab_alloc+0x67/0x90
> >> >   __slab_alloc+0x67/0x90
> >> >   ? sr_probe+0x200/0x600
> >> >   ? sr_probe+0x200/0x600
> >> >   kmem_cache_alloc_trace+0x259/0x270
> >> >   sr_probe+0x200/0x600
> >> >   ......
> >> >   bus_probe_device+0x9f/0xb0
> >> >   device_add+0x3d2/0x970
> >> >   ......
> >> >   __scsi_add_device+0xea/0x100
> >> >   ata_scsi_scan_host+0x97/0x1d0
> >> >   async_run_entry_fn+0x30/0x130
> >> >   process_one_work+0x2b0/0x5c0
> >> >   worker_thread+0x55/0x3c0
> >> >   ? process_one_work+0x5c0/0x5c0
> >> >   kthread+0x149/0x170
> >> >   ? set_kthread_struct+0x40/0x40
> >> >   ret_from_fork+0x22/0x30
> >> >  Mem-Info:
> >> >  ......
> >> > 
> >> > The above failure happened when calling kmalloc() to allocate buffer with
> >> > GFP_DMA. It requests to allocate slab page from DMA zone while no managed
> >> > pages in there.
> >> >  sr_probe()
> >> >  --> get_capabilities()
> >> >      --> buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> >> > 
> >> > The DMA zone should be checked if it has managed pages, then try to create
> >> > dma-kmalloc.
> >> >
> >> 
> >> What is problem here?
> >> 
> >> The slab allocator requested buddy allocator with GFP_DMA,
> >> and then buddy allocator failed to allocate page in DMA zone because
> >> there was no page in DMA zone. and then the buddy allocator called warn_alloc
> >> because it failed at allocating page.
> >> 
> >> Looking at warn, I don't understand what the problem is.
> > 
> > The problem is this is a generic issue on x86_64, and will be warned out
> > always on all x86_64 systems, but not on a certain machine or a certain
> > type of machine. If not fixed, we can always see it in kdump kernel. The
> > way things are, it doesn't casue system or device collapse even if
> > dma-kmalloc can't provide buffer or provide buffer from zone NORMAL.
> > 
> > 
> > I have got bug reports several times from different people, and we have
> > several bugs tracking this inside Redhat. I think nobody want to see
> > this appearing in customers' monitor w or w/o a note. If we have to
> > leave it with that, it's a little embrassing.
> >

Okay Then,
Do you care if it just fails (without warning)
or is allocated from ZONE_DMA32?

> > 
> >> 
> >> > ---
> >> >  mm/slab_common.c | 9 +++++++++
> >> >  1 file changed, 9 insertions(+)
> >> > 
> >> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> >> > index e5d080a93009..ae4ef0f8903a 100644
> >> > --- a/mm/slab_common.c
> >> > +++ b/mm/slab_common.c
> >> > @@ -878,6 +878,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
> >> >  {
> >> >  	int i;
> >> >  	enum kmalloc_cache_type type;
> >> > +#ifdef CONFIG_ZONE_DMA
> >> > +	bool managed_dma;
> >> > +#endif
> >> >  
> >> >  	/*
> >> >  	 * Including KMALLOC_CGROUP if CONFIG_MEMCG_KMEM defined
> >> > @@ -905,10 +908,16 @@ void __init create_kmalloc_caches(slab_flags_t flags)
> >> >  	slab_state = UP;
> >> >  
> >> >  #ifdef CONFIG_ZONE_DMA
> >> > +	managed_dma = has_managed_dma();
> >> > +
> >> >  	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
> >> >  		struct kmem_cache *s = kmalloc_caches[KMALLOC_NORMAL][i];
> >> >  
> >> >  		if (s) {
> >> > +			if (!managed_dma) {
> >> > +				kmalloc_caches[KMALLOC_DMA][i] = kmalloc_caches[KMALLOC_NORMAL][i];
> 
> The right side could be just 's'?
> 
> >> > +				continue;
> >> > +			}
> >> 
> >> This code is copying normal kmalloc caches to DMA kmalloc caches.
> >> With this code, the kmalloc() with GFP_DMA will succeed even if allocated
> >> memory is not actually from DMA zone. Is that really what you want?
> > 
> > This is a great question. Honestly, no,
> > 
> > On the surface, it's obviously not what we want, We should never give
> > user a zone NORMAL memory when they ask for zone DMA memory. If going to
> > this specific x86_64 ARCH where this problem is observed, I prefer to give
> > it zone DMA32 memory if zone DMA allocation failed. Because we rarely
> > have ISA device deployed which requires low 16M DMA buffer. The zone DMA
> > is just in case. Thus, for kdump kernel, we have been trying to make sure
> > zone DMA32 has enough memory to satisfy PCIe device DMA buffer allocation,
> > I don't remember we made any effort to do that for zone DMA.
> > 
> > Now the thing is that the nothing serious happened even if sr_probe()
> > doesn't get DMA buffer from zone DMA. And it works well when I feed it
> > with zone NORMAL memory instead with this patch applied.
> 
> If doesn't feel right to me to fix (or rather workaround) this on the level
> of kmalloc caches just because the current reports come from there. If we
> decide it's acceptable for kdump kernel to return !ZONE_DMA memory for
> GFP_DMA requests, then it should apply at the page allocator level for all
> allocations, not just kmalloc().

I think that will make it much easier to manage the code.

> Also you mention above you'd prefer ZONE_DMA32 memory, while chances are
> this approach of using KMALLOC_NORMAL caches will end up giving you
> ZONE_NORMAL. On the page allocator level it would be much easier to
> implement a fallback from non-populated ZONE_DMA to ZONE_DMA32 specifically.
>

Hello Baoquan and Vlastimil.

I'm not sure allowing ZONE_DMA32 for kdump kernel is nice way to solve
this problem. Devices that requires ZONE_DMA is rare but we still
support them.

If we allow ZONE_DMA32 for ZONE_DMA in kdump kernels,
the problem will be hard to find.

What about one of those?:

    1) Do not call warn_alloc in page allocator if will always fail
    to allocate ZONE_DMA pages.


    2) let's check all callers of kmalloc with GFP_DMA
    if they really need GFP_DMA flag and replace those by DMA API or
    just remove GFP_DMA from kmalloc()

    3) Drop support for allocating DMA memory from slab allocator
    (as Christoph Hellwig said) and convert them to use DMA32
    and see what happens

Thanks,
Hyeonggon.

> >> 
> >> Maybe the function get_capabilities() want to allocate memory
> >> even if it's not from DMA zone, but other callers will not expect that.
> > 
> > Yeah, I have the same guess too for get_capabilities(), not sure about other
> > callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> > the right way to call people when the first name is the same. Correct me if
> > it's wrong), any buffer requested from kmalloc can be used by device driver.
> > Means device enforces getting memory inside addressing limit for those
> > DMA transferring buffer which is usually large, Megabytes level with
> > vmalloc() or alloc_pages(), but doesn't care about this kind of small
> > piece buffer memory allocated with kmalloc()? Just a guess, please tell
> > a counter example if anyone happens to know, it could be easy.
> > 
> > 
> >> 
> >> >  			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
> >> >  				kmalloc_info[i].name[KMALLOC_DMA],
> >> >  				kmalloc_info[i].size,
> >> > -- 
> >> > 2.17.2
> >> > 
> >> > 
> >> 
> > 
> 
