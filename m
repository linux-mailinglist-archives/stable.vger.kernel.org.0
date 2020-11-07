Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5652AA3E8
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 09:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgKGIjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 03:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgKGIjm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 03:39:42 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93D9C0613CF;
        Sat,  7 Nov 2020 00:39:42 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id f38so3021307pgm.2;
        Sat, 07 Nov 2020 00:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zIMBOiLbdItdg+48kpCIygPkMR3TPO8xi/V7tkVxarw=;
        b=Q1MJkrA4DDlLPKPOVjja9yqaL48rkY8+AopbUnmYjeAss/uW93GnGdXvXW3h5EMoBm
         sfMQCDL5zqMgXISj6HDKWUtH4d9KXEXx3EvLv4znlsAYVo5X08pjm0cRvHyArXPlzw+K
         YPfoIV125OzqVs96lNgPM+OwwoSVRLPCvYlkcEUmVDjsxxV76aZU424wstERnbjJ2yk7
         /6R+GXytHmojMhfet00peordD/giAsVhFiU3lKxzNEGPpwabRkdYkTw2ok23h+U5Vnqe
         eHcSCwaro8jCgtq30U5M3AFm6Re433c8TbJjv90iq9OWR84Jnx+27y/OHXtW499aMRMb
         pYSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zIMBOiLbdItdg+48kpCIygPkMR3TPO8xi/V7tkVxarw=;
        b=DYsrom5xfNtsLjVxhHT+usNGtkB11AQrAOFxdTNgheKUxjIOkUll7USFQmt2syw9J6
         4hz+hoaCDMMAVB+Xcdh5wJ1ekvZpYKsJ31hJBeRCG46Z1mp7wEiNx6etv8Dsge/j7hlS
         xo3ivBYPCZmTc16q7mSiQ0w0sod+AbCbrsSFbeTbbxLHC9OB91urxFra6sQZszBqWlry
         WYMTHT80Hd5LAcDH5c6h6q5fTrfMEG1CFLo/H9pbgImO+UEGg7Eq3vl8Xg6x9hISpkxt
         +jIKjsxw7g/4DnAlltbpGcyLWVLpr/lHtcvH73GRI8+Wy1O/igsiaOHdF/ToMiBKmMWe
         PMxg==
X-Gm-Message-State: AOAM530LzGUVVZXdgoa5MJ/2lfSnrjfCdJKI0cRqweAI5WbgoMOLglNI
        K/Tc+jbndhqJz9QqbDyOSHk=
X-Google-Smtp-Source: ABdhPJwzEwyc5AdMfUtIacIn/a2s5UjdZjDOgwLBm0t/39XVoeu+PD1k4dsPebw6nJrCBXcZcn7ulQ==
X-Received: by 2002:a63:fb50:: with SMTP id w16mr4760055pgj.202.1604738382137;
        Sat, 07 Nov 2020 00:39:42 -0800 (PST)
Received: from google.com ([2620:15c:211:201:7220:84ff:fe09:5e58])
        by smtp.gmail.com with ESMTPSA id v23sm4694682pfn.141.2020.11.07.00.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 00:39:41 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Sat, 7 Nov 2020 00:39:39 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Harish Sriram <harish@linux.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "mm/vunmap: add cond_resched() in
 vunmap_pmd_range"
Message-ID: <20201107083939.GA1633068@google.com>
References: <20201105170249.387069-1-minchan@kernel.org>
 <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106175933.90e4c8851010c9ce4dd732b6@linux-foundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andrew,

On Fri, Nov 06, 2020 at 05:59:33PM -0800, Andrew Morton wrote:
> On Thu,  5 Nov 2020 09:02:49 -0800 Minchan Kim <minchan@kernel.org> wrote:
> 
> > This reverts commit e47110e90584a22e9980510b00d0dfad3a83354e.
> > 
> > While I was doing zram testing, I found sometimes decompression failed
> > since the compression buffer was corrupted. With investigation,
> > I found below commit calls cond_resched unconditionally so it could
> > make a problem in atomic context if the task is reschedule.
> > 
> > Revert the original commit for now.
> > 
> > [   55.109012] BUG: sleeping function called from invalid context at mm/vmalloc.c:108
> > [   55.110774] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 946, name: memhog
> > [   55.111973] 3 locks held by memhog/946:
> > [   55.112807]  #0: ffff9d01d4b193e8 (&mm->mmap_lock#2){++++}-{4:4}, at: __mm_populate+0x103/0x160
> > [   55.114151]  #1: ffffffffa3d53de0 (fs_reclaim){+.+.}-{0:0}, at: __alloc_pages_slowpath.constprop.0+0xa98/0x1160
> > [   55.115848]  #2: ffff9d01d56b8110 (&zspage->lock){.+.+}-{3:3}, at: zs_map_object+0x8e/0x1f0
> > [   55.118947] CPU: 0 PID: 946 Comm: memhog Not tainted 5.9.3-00011-gc5bfc0287345-dirty #316
> > [   55.121265] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1 04/01/2014
> > [   55.122540] Call Trace:
> > [   55.122974]  dump_stack+0x8b/0xb8
> > [   55.123588]  ___might_sleep.cold+0xb6/0xc6
> > [   55.124328]  unmap_kernel_range_noflush+0x2eb/0x350
> > [   55.125198]  unmap_kernel_range+0x14/0x30
> > [   55.125920]  zs_unmap_object+0xd5/0xe0
> > [   55.126604]  zram_bvec_rw.isra.0+0x38c/0x8e0
> > [   55.127462]  zram_rw_page+0x90/0x101
> > [   55.128199]  bdev_write_page+0x92/0xe0
> > [   55.128957]  ? swap_slot_free_notify+0xb0/0xb0
> > [   55.129841]  __swap_writepage+0x94/0x4a0
> > [   55.130636]  ? do_raw_spin_unlock+0x4b/0xa0
> > [   55.131462]  ? _raw_spin_unlock+0x1f/0x30
> > [   55.132261]  ? page_swapcount+0x6c/0x90
> > [   55.133038]  pageout+0xe3/0x3a0
> > [   55.133702]  shrink_page_list+0xb94/0xd60
> > [   55.134626]  shrink_inactive_list+0x158/0x460
> >
> > ...
> >
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -102,8 +102,6 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
> >  		if (pmd_none_or_clear_bad(pmd))
> >  			continue;
> >  		vunmap_pte_range(pmd, addr, next, mask);
> > -
> > -		cond_resched();
> >  	} while (pmd++, addr = next, addr != end);
> >  }
> 
> If this is triggering a warning then why isn't the might_sleep() in
> remove_vm_area() also triggering?

I don't understand what specific callpath you are talking but if
it's clearly called in atomic context, the reason would be config
combination I met.
    
    CONFIG_PREEMPT_VOLUNTARY + no CONFIG_DEBUG_ATOMIC_SLEEP

It makes preempt_count logic void so might_sleep warning will not work.

> 
> Sigh.  I also cannot remember why these vfree() functions have to be so
> awkward.  The mutex_trylock(&vmap_purge_lock) isn't permitted in
> interrupt context because mutex_trylock() is stupid, but what was the
> issue with non-interrupt atomic code?
> 

Seems like a latency issue.

commit f9e09977671b
Author: Christoph Hellwig <hch@lst.de>
Date:   Mon Dec 12 16:44:23 2016 -0800

    mm: turn vmap_purge_lock into a mutex

The purge_lock spinlock causes high latencies with non RT kernel,

