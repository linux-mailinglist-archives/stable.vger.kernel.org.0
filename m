Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838612B0EA4
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 21:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgKLUBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 15:01:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgKLUBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Nov 2020 15:01:05 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA74C0613D1;
        Thu, 12 Nov 2020 12:01:05 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id x15so4216555pfm.9;
        Thu, 12 Nov 2020 12:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R2BNJDwXzv8M8C0Eyq8UgKrkxHVHY2hGkyMgoh70ozU=;
        b=bP0C57H1fGFgL6VKco3kBy8D0joD/MKbu+NiH/ZkcrcFtGohm5BT4EMwCVyo/t688A
         GEEdlcQyDbU2cyTMV49ZVDa4szJaPRKx6gKo2UFXxjxFksSQKuZJJzqenmE4OXBW4aYP
         +YtEygo8BKbi3lZUYRjUs2eVt3r7/MMxmXQMBqWx7ajNpZpCIJgnzP+/Sbv+4hlO8ib8
         U0jtqY4Cnxj3FvcwOjM4J6uFCqu/pTp6q9Id1Y/JeViYpzR7yFOmstU0/vYAq1tFPACj
         I8FIrMEfd+MFFixhgnAEpvFmxTmtJkLypbBcIL5b28l+2acEVHINOJ6gsbTf6Ck/jHEr
         x/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=R2BNJDwXzv8M8C0Eyq8UgKrkxHVHY2hGkyMgoh70ozU=;
        b=Km40Uct2owjXyNZfCU4H76YZUxMsuX9xFX5GtRo0QGboxtXrSsoRSS4z8Ou3ft8Wyx
         pheISxa0JXb9i9YcM3Bbmi1kYNjOtFhwT5kdKijEUMJqKz9FMxpo7P39bwPkCa3kgUGg
         KkwuGIQXMfyPG4LAmaA0AfcrGAJUF3U7gD7EtpWpPQHdMFWLKce6vEeJqF1s58dh+y69
         7DmnZT9n3PAqy2tqDUBT4fFx9T0OH9laHYoKthtf3LIa8109Zswpez939PopI3Jl3nPm
         /pFll12/27SHD01NgIgUgXDxcUYqh5qWtOkqPpgeeSsF1gBAXhmn52mHKJ0V8GJqMTkW
         zOFQ==
X-Gm-Message-State: AOAM532SmTEYnvpssgI737uHvtx/GF/W4jujlsOoedtgzw+U1qxx9tbm
        OLbBvej5x3sv5YuEePB4FPU=
X-Google-Smtp-Source: ABdhPJwPKTlDvsq79aILWrcBKyZuupQNl07PvW/5SA2XFZ9MCByABvk627pjG8OVMVhhKrOchzMDQw==
X-Received: by 2002:a17:90a:67c5:: with SMTP id g5mr895932pjm.13.1605211264705;
        Thu, 12 Nov 2020 12:01:04 -0800 (PST)
Received: from google.com (c-67-188-94-199.hsd1.ca.comcast.net. [67.188.94.199])
        by smtp.gmail.com with ESMTPSA id r205sm7464075pfr.25.2020.11.12.12.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 12:01:03 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 12 Nov 2020 12:01:01 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201112200101.GC123036@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
 <20201107083939.GA1633068@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201107083939.GA1633068@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

How should we proceed this problem?

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
