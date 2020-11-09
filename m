Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA5D2AB725
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 12:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgKILeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 06:34:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729954AbgKILeG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 06:34:06 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD46C0613CF;
        Mon,  9 Nov 2020 03:34:04 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y16so9870417ljk.1;
        Mon, 09 Nov 2020 03:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JPw2Po3K5j1KcfJ68+mIpcS7q1fw1SYnoLWr5LV7uxE=;
        b=dq3aUSf99CRTkXSToJ1pqxR5JNG/JS2MMvBEU6YU0hSvgbQNcoeXBF2o5MqBlho7HT
         oBZcM+0wqN7wpasKU+Jng8i1uX3C6L15DK1aduROulVcO0KOWEpHREIWvUPziyMnR6Ue
         K7OI3Mijoi0NG4ks77xtY+yh6AE7BYWXiAoJmh0uBSArVRTNFBZF46dmtyGzxGAdXrvA
         uvIHNoL7M3hOUpInB7NNj8cmoPzpg0YjHxvvgab7SOG5MDCY850dCXHUE0hqOYH+7j1P
         WC5TqoPwa9WoRRFn5FqlOVkTq9AXPh3brqRUhbw+7EltuTAWt1duDWeIgagqi2PJlvIu
         sKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JPw2Po3K5j1KcfJ68+mIpcS7q1fw1SYnoLWr5LV7uxE=;
        b=sD5XnDKTx664nulnc0IDE6NtzJ2mw0T7Fo41xRkZBaQt/hep90AfsaxiXRwi1uA3iE
         qd2+LNH5KAupIwjVC/Sp8smxryUgWuyT7wbEjlIAuTaBJLA/VOeByHhv+BGxTjdfjw9y
         I5hEGPbVjj9yxfW0pKSDP4xJUbVz/YNNNNK6cPPzxwf41PCiMs0JbL72Rhof3N6otU71
         e8cj9lgJ8D5pX6qj0qEvFkOnHQbCX7yI/bZIARUcmWYHAE6B3oZJrnMNbfMh5pjnG9pF
         QNWZfrrhbjVUt8GDibrfbXzpc8iUYvsOhcLUC0eypkkQr60krgcWMZ3z8mPBVhvbmuAh
         3CKw==
X-Gm-Message-State: AOAM533v1ZyG6aKpfpfXZX04uNSEWoo2vFbxZ2FvjHvS47Rtu3GOcTAk
        d2pw6NTzFp7ocHog7R8vcUFQCKEjBfkG/w==
X-Google-Smtp-Source: ABdhPJy+nhBeOlyRoHtHZnhZhE2p3nN8WimgTvnQAQtJM8Sx2zbd7uU8TqqSz4rSSFuuWUR7rgG7BA==
X-Received: by 2002:a05:651c:2005:: with SMTP id s5mr649745ljo.36.1604921642882;
        Mon, 09 Nov 2020 03:34:02 -0800 (PST)
Received: from pc636 (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id y1sm1735911lfh.149.2020.11.09.03.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 03:34:02 -0800 (PST)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date:   Mon, 9 Nov 2020 12:33:59 +0100
To:     Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201109113359.GA32670@pc636>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201107083939.GA1633068@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07, 2020 at 12:39:39AM -0800, Minchan Kim wrote:
> Hi Andrew,
> 
> On Fri, Nov 06, 2020 at 05:59:33PM -0800, Andrew Morton wrote:
> > On Thu,  5 Nov 2020 09:02:49 -0800 Minchan Kim <minchan@kernel.org> wrote:
> > 
> > > This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> > > 
> > > While I was doing zram testing, I found sometimes decompression failed
> > > since the compression buffer was corrupted. With investigation,
> > > I found below commit calls cond_resched unconditionally so it could
> > > make a problem in atomic context if the task is reschedule.
> > > 
> > > Revert the original commit for now.
> > > 
> > > [   55.109012] BUG: sleeping function called from invalid context at mm/vmalloc.c:108
> > > [   55.110774] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
> > > [   55.111973] 3 locks held by memhog/946:
> > > [   55.112807]  #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
> > > [   55.114151]  #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
> > > [   55.115848]  #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
> > > [   55.118947] CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
> > > [   55.121265] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
> > > [   55.122540] Call Trace:
> > > [   55.122974]  dump_stack+0x8b/0xb8
> > > [   55.123588]  ___might_sleep.cold+0xb6/0xc6
> > > [   55.124328]  unmap_kernel_range_noflush+0x2eb/0x350
> > > [   55.125198]  unmap_kernel_range+0x14/0x30
> > > [   55.125920]  zs_unmap_object+0xd5/0xe0
> > > [   55.126604]  zram_bvec_rw.isra.0+0x38c/0x8e0
> > > [   55.127462]  zram_rw_page+0x90/0x101
> > > [   55.128199]  bdev_write_page+0x92/0xe0
> > > [   55.128957]  ? swap_slot_free_notify+0xb0/0xb0
> > > [   55.129841]  __swap_writepage+0x94/0x4a0
> > > [   55.130636]  ? do_raw_spin_unlock+0x4b/0xa0
> > > [   55.131462]  ? _raw_spin_unlock+0x1f/0x30
> > > [   55.132261]  ? page_swapcount+0x6c/0x90
> > > [   55.133038]  pageout+0xe3/0x3a0
> > > [   55.133702]  shrink_page_list+0xb94/0xd60
> > > [   55.134626]  shrink_inactive_list+0x158/0x460
> > >
> > > ...
> > >
> > > --- a/mm/vmalloc.c
> > > +++ b/mm/vmalloc.c
> > > @@ -102,8 +102,6 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> > >  		if (pmd_none_or_clear_bad(pmd))
> > >  			continue;
> > >  		vunmap_pte_range(pmd, addr, next, mask);
> > > -
> > > -		cond_resched();
> > >  	} while (pmd++, addr = next, addr != end);
> > >  }
> > 
> > If this is triggering a warning then why isn't the might_sleep() in
> > remove_vm_area() also triggering?
> 
> I don't understand what specific callpath you are talking but if
> it's clearly called in atomic context, the reason would be config
> combination I met.
>     
>     CONFIG_PREEMPT_VOLUNTARY + no CONFIG_DEBUG_ATOMIC_SLEEP
> 
> It makes preempt_count logic void so might_sleep warning will not work.
> 
> > 
> > Sigh.  I also cannot remember why these vfree() functions have to be so
> > awkward.  The mutex_trylock(&vmap_purge_lock) isn't permitted in
> > interrupt context because mutex_trylock() is stupid, but what was the
> > issue with non-interrupt atomic code?
> > 
> 
> Seems like a latency issue.
> 
> commit f9e09977671b
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Mon Dec 12 16:44:23 2016 -0800
> 
>     mm: turn vmap_purge_lock into a mutex
> 
> The purge_lock spinlock causes high latencies with non RT kernel,
> 
__purge_vmap_area_lazy() is our bottleneck. The list of areas to be
drained can be quite big, so the process itself is time consuming.
That is why it is protected by the mutex instead of spinlock. Latency
issues.

I proposed to optimize it here: https://lkml.org/lkml/2020/9/7/815
I will send out the patch soon, but it is another topic not related
to this issue.

--
Vlad Rezki
