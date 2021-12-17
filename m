Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DFA478A22
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 12:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhLQLie (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 06:38:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhLQLid (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 06:38:33 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7465CC061574;
        Fri, 17 Dec 2021 03:38:33 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso3784512pjc.4;
        Fri, 17 Dec 2021 03:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+VzCpz2F1GVoeLExPia6PldmklhZ9FrugF0MvQltIMg=;
        b=GM8BvOzGxMzq3qDwprZzeyoQLcPQoqmLOH3DWFPnnHcPX9DOmNxhELHPeLxk+Wuz2F
         rNbbHGlrDmcASnKhX6YkM7/uayMa+cSTfFo9ZFuaPaE9ROscyqC3wKfDLrI6wAASqByK
         rXgQOpMv5W8elb7Fli43FcTIeQDWEPL/FJPaIjVSRwsyu3FwlK11plADQWAvgN5YN2L+
         4UNiCTySfyH/Vk/f5n09rbZoOhjvcyKsnLYdPFO7yH+7ucrXCKxykhTPUWANKKrHdZLp
         1+z9GDn7vC+CHerz/hvsv3WzCaIP9+NYl0sjT9kk4a8BvMeCYQKXPv6FlZ2AHNeRnCJ3
         4szQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+VzCpz2F1GVoeLExPia6PldmklhZ9FrugF0MvQltIMg=;
        b=5QygYELJYB+c9mcqUNayvqa8l/+q9FP+Mbu55rRbY4zPyinXl+iO3Lt0jXL1lPyKbO
         YIFUgqxnHFYe5oP1A3ipWfSPU4cimvlmUjCRxNIoAnX9QP7WvPi1xbyMLMRLwbL4wCtA
         1W7IDrT6GeVUsRd1jPFvE6HPsm3UKE/Gt22bs/N0G05e2DsUO6sLNweEW6LQ9D2SAhmm
         BpKWIs7TCxMu0zqnkU7ek7ZuItxEveYUc35j8UEuTLk8ngwfY7efwYW8IXvBM+eajaU6
         LOzOI1N8LvyrYp6L+7ngP9Nhjyxa7r0KhiIHaSVXDujReS4j7t+invyAkPeB9c20PD5n
         pJdA==
X-Gm-Message-State: AOAM5307EFaVvcyvo0Yne6V6ZXo7A3pvrwGZBIP3+Zz+I+/Fer5XlL6V
        BM2HZ/JY45167DBJ9I1tg7Q=
X-Google-Smtp-Source: ABdhPJwDDw6apEAqMLd3yFtbe3ZWKweE3lIa/k54uBVcB1bFyADiOoe2ypz6l9MLp/QsBVoZZmWbEw==
X-Received: by 2002:a17:902:f54e:b0:148:e76e:a5 with SMTP id h14-20020a170902f54e00b00148e76e00a5mr232292plf.135.1639741112823;
        Fri, 17 Dec 2021 03:38:32 -0800 (PST)
Received: from ip-172-31-30-232.ap-northeast-1.compute.internal (ec2-18-181-137-102.ap-northeast-1.compute.amazonaws.com. [18.181.137.102])
        by smtp.gmail.com with ESMTPSA id g13sm8171488pjc.39.2021.12.17.03.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 03:38:32 -0800 (PST)
Date:   Fri, 17 Dec 2021 11:38:27 +0000
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
To:     Baoquan He <bhe@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hch@lst.de, cl@linux.com,
        John.p.donnelly@oracle.com, kexec@lists.infradead.org,
        stable@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v3 5/5] mm/slub: do not create dma-kmalloc if no managed
 pages in DMA zone
Message-ID: <Ybx2szXEgl1tN4MD@ip-172-31-30-232.ap-northeast-1.compute.internal>
References: <20211213122712.23805-1-bhe@redhat.com>
 <20211213122712.23805-6-bhe@redhat.com>
 <20211213134319.GA997240@odroid>
 <20211214053253.GB2216@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214053253.GB2216@MiWiFi-R3L-srv>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 14, 2021 at 01:32:53PM +0800, Baoquan He wrote:
> On 12/13/21 at 01:43pm, Hyeonggon Yoo wrote:
> > Hello Baoquan. I have a question on your code.
> > 
> > On Mon, Dec 13, 2021 at 08:27:12PM +0800, Baoquan He wrote:
> > > Dma-kmalloc will be created as long as CONFIG_ZONE_DMA is enabled.
> > > However, it will fail if DMA zone has no managed pages. The failure
> > > can be seen in kdump kernel of x86_64 as below:
> > > 
> > >  CPU: 0 PID: 65 Comm: kworker/u2:1 Not tainted 5.14.0-rc2+ #9
> > >  Hardware name: Intel Corporation SandyBridge Platform/To be filled by O.E.M., BIOS RMLSDP.86I.R2.28.D690.1306271008 06/27/2013
> > >  Workqueue: events_unbound async_run_entry_fn
> > >  Call Trace:
> > >   dump_stack_lvl+0x57/0x72
> > >   warn_alloc.cold+0x72/0xd6
> > >   __alloc_pages_slowpath.constprop.0+0xf56/0xf70
> > >   __alloc_pages+0x23b/0x2b0
> > >   allocate_slab+0x406/0x630
> > >   ___slab_alloc+0x4b1/0x7e0
> > >   ? sr_probe+0x200/0x600
> > >   ? lock_acquire+0xc4/0x2e0
> > >   ? fs_reclaim_acquire+0x4d/0xe0
> > >   ? lock_is_held_type+0xa7/0x120
> > >   ? sr_probe+0x200/0x600
> > >   ? __slab_alloc+0x67/0x90
> > >   __slab_alloc+0x67/0x90
> > >   ? sr_probe+0x200/0x600
> > >   ? sr_probe+0x200/0x600
> > >   kmem_cache_alloc_trace+0x259/0x270
> > >   sr_probe+0x200/0x600
> > >   ......
> > >   bus_probe_device+0x9f/0xb0
> > >   device_add+0x3d2/0x970
> > >   ......
> > >   __scsi_add_device+0xea/0x100
> > >   ata_scsi_scan_host+0x97/0x1d0
> > >   async_run_entry_fn+0x30/0x130
> > >   process_one_work+0x2b0/0x5c0
> > >   worker_thread+0x55/0x3c0
> > >   ? process_one_work+0x5c0/0x5c0
> > >   kthread+0x149/0x170
> > >   ? set_kthread_struct+0x40/0x40
> > >   ret_from_fork+0x22/0x30
> > >  Mem-Info:
> > >  ......
> > > 
> > > The above failure happened when calling kmalloc() to allocate buffer with
> > > GFP_DMA. It requests to allocate slab page from DMA zone while no managed
> > > pages in there.
> > >  sr_probe()
> > >  --> get_capabilities()
> > >      --> buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
> > > 
> > > The DMA zone should be checked if it has managed pages, then try to create
> > > dma-kmalloc.
> > >
> > 
> > What is problem here?
> > 
> > The slab allocator requested buddy allocator with GFP_DMA,
> > and then buddy allocator failed to allocate page in DMA zone because
> > there was no page in DMA zone. and then the buddy allocator called warn_alloc
> > because it failed at allocating page.
> > 
> > Looking at warn, I don't understand what the problem is.
> 
> The problem is this is a generic issue on x86_64, and will be warned out
> always on all x86_64 systems, but not on a certain machine or a certain
> type of machine. If not fixed, we can always see it in kdump kernel. The
> way things are, it doesn't casue system or device collapse even if
> dma-kmalloc can't provide buffer or provide buffer from zone NORMAL.
> 
> 
> I have got bug reports several times from different people, and we have
> several bugs tracking this inside Redhat. I think nobody want to see
> this appearing in customers' monitor w or w/o a note. If we have to
> leave it with that, it's a little embrassing.
> 
> 
> > 
> > > ---
> > >  mm/slab_common.c | 9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > > 
> > > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > > index e5d080a93009..ae4ef0f8903a 100644
> > > --- a/mm/slab_common.c
> > > +++ b/mm/slab_common.c
> > > @@ -878,6 +878,9 @@ void __init create_kmalloc_caches(slab_flags_t flags)
> > >  {
> > >  	int i;
> > >  	enum kmalloc_cache_type type;
> > > +#ifdef CONFIG_ZONE_DMA
> > > +	bool managed_dma;
> > > +#endif
> > >  
> > >  	/*
> > >  	 * Including KMALLOC_CGROUP if CONFIG_MEMCG_KMEM defined
> > > @@ -905,10 +908,16 @@ void __init create_kmalloc_caches(slab_flags_t flags)
> > >  	slab_state = UP;
> > >  
> > >  #ifdef CONFIG_ZONE_DMA
> > > +	managed_dma = has_managed_dma();
> > > +
> > >  	for (i = 0; i <= KMALLOC_SHIFT_HIGH; i++) {
> > >  		struct kmem_cache *s = kmalloc_caches[KMALLOC_NORMAL][i];
> > >  
> > >  		if (s) {
> > > +			if (!managed_dma) {
> > > +				kmalloc_caches[KMALLOC_DMA][i] = kmalloc_caches[KMALLOC_NORMAL][i];
> > > +				continue;
> > > +			}
> > 
> > This code is copying normal kmalloc caches to DMA kmalloc caches.
> > With this code, the kmalloc() with GFP_DMA will succeed even if allocated
> > memory is not actually from DMA zone. Is that really what you want?
> 
> This is a great question. Honestly, no,
> 
> On the surface, it's obviously not what we want, We should never give
> user a zone NORMAL memory when they ask for zone DMA memory. If going to
> this specific x86_64 ARCH where this problem is observed, I prefer to give
> it zone DMA32 memory if zone DMA allocation failed. Because we rarely
> have ISA device deployed which requires low 16M DMA buffer. The zone DMA
> is just in case. Thus, for kdump kernel, we have been trying to make sure
> zone DMA32 has enough memory to satisfy PCIe device DMA buffer allocation,
> I don't remember we made any effort to do that for zone DMA.
> 
> Now the thing is that the nothing serious happened even if sr_probe()
> doesn't get DMA buffer from zone DMA. And it works well when I feed it
> with zone NORMAL memory instead with this patch applied.
> > 
> > Maybe the function get_capabilities() want to allocate memory
> > even if it's not from DMA zone, but other callers will not expect that.
> 
> Yeah, I have the same guess too for get_capabilities(), not sure about other
> callers. Or, as ChristophL and ChristophH said(Sorry, not sure if this is
> the right way to call people when the first name is the same. Correct me if
> it's wrong), any buffer requested from kmalloc can be used by device driver.
> Means device enforces getting memory inside addressing limit for those
> DMA transferring buffer which is usually large, Megabytes level with
> vmalloc() or alloc_pages(), but doesn't care about this kind of small
> piece buffer memory allocated with kmalloc()? Just a guess, please tell
> a counter example if anyone happens to know, it could be easy.
>

My understanding is any buffer requested from kmalloc (without
GFP_DMA/DMA32) can be used by device driver because it allocates
continuous physical memory. It doesn't mean that buffer allocated
with kmalloc is free of addressing limitation.

the addressing limitation comes from the capability of device, not
allocation size. if you allocate memory using alloc_pages() or kmalloc(),
the device has same limitation. and vmalloc can't be used for
devices because they have no MMU.

But we can map memory outside DMA zone into bounce buffer (which resides
in DMA zone) using DMA API.

Thanks,
Hyeonggon.

> 
> > 
> > >  			kmalloc_caches[KMALLOC_DMA][i] = create_kmalloc_cache(
> > >  				kmalloc_info[i].name[KMALLOC_DMA],
> > >  				kmalloc_info[i].size,
> > > -- 
> > > 2.17.2
> > > 
> > > 
> > 
> 
