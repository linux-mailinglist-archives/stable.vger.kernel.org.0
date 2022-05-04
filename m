Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C55F51A486
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 17:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352835AbiEDP4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 11:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352832AbiEDP4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 11:56:20 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559E245AE0;
        Wed,  4 May 2022 08:52:43 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-deb9295679so1585272fac.6;
        Wed, 04 May 2022 08:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhJlKdg5r+X6KS3me6VzL1uciQddx4EvxJlyedThxCA=;
        b=L2cjyvd6bcZcIKxeSLyWAjfBa0cAq/9jEmwrLkHQLnN+adFkTtQSqMglNhQAg4n2HZ
         QjzI8D7WdDOIR4N5xfofxNhAiIEMkCIpI8BIEVH4EBaaLoR9mUbSUdmWKRUuav6Mo1XJ
         qbnwSp9AVxQ2Rp9G4FVpjn+zlszGWh4TWlANNPHdImylfdg0ulIrZn2tHk3brFIEZd6i
         xzdKTdufJ6i0rcDRsw3XXeQVwRS73mp5HZJtnjTFnbcCQJmECoB6nnkG6O4YuJ6Q6SaF
         1Cu/H/vg8/rBZHe8M586HdelGqKK/mDGOgsnsU1W3OWXMNSjQ1lLhxwO/bg7NnyjcHrA
         I2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhJlKdg5r+X6KS3me6VzL1uciQddx4EvxJlyedThxCA=;
        b=bjMFnvxJF7Gfl+cv+LpTE99OaL2Ho9ccEYDzwTdTVzDsDtM1Q9P5fACPy3yxvKVHZ0
         bw3zjb7qb2W6chjhhy4ggFozw+R4mEVBrG59MsO6x2FxWZRbY7qlUkfxLCU5DU8OObQY
         nk8DcPQ55mhN5OLmMBNOQYe/9FWqPO1mVAB50jZniN+/qdMNI818ga2b3lIMo0hx/uJE
         UbYhmeZIvjHuUO1cyp9Pc29hMUjIHp2wNHAyOUcrwZTg8L8qr+ZlzWQEdksypdW0hllN
         lVJ/T7FOuh0OPtMEJhT0CiMlnyhr9TXekzoLqEzuinS7DIe6eqP+VDg/WwXb2mSCzyD7
         c3Mw==
X-Gm-Message-State: AOAM530Nuzq5+1q6J87f7wLJIq3yjtXTpKg60ts6pd9DzVTQDCtvnA5c
        7/sxQYl2rYrbsKYY/PRe0Afe0hTZLNKrTFfpIF8=
X-Google-Smtp-Source: ABdhPJzrprLcYxe0h/fDHoDxhGBbr4CB8kyiXoWpnQc0SGnixGfNWAAjzti9CGUlC/v7anT52YKxCPHf4EZoApoe+fc=
X-Received: by 2002:a05:6870:f619:b0:e9:6d65:4aae with SMTP id
 ek25-20020a056870f61900b000e96d654aaemr59308oab.126.1651679562581; Wed, 04
 May 2022 08:52:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com> <93480fb1-6992-b992-4c93-0046f3b92d7a@redhat.com>
 <CAA+hA=QzDJhFnntKK4nk-SMErk9J_mFPv0b7ZWuC8Ubz0BC+sg@mail.gmail.com>
 <YjNr+d2Un7F8c2DZ@google.com> <CAA+hA=SBeCT+XkzNL3p07vC+58AZOTtoiLG=jVK0tX4wNFvrHA@mail.gmail.com>
 <YjSxR9Zyck4YqgEz@google.com>
In-Reply-To: <YjSxR9Zyck4YqgEz@google.com>
From:   Dong Aisheng <dongas86@gmail.com>
Date:   Wed, 4 May 2022 23:52:30 +0800
Message-ID: <CAA+hA=QT3GH0_ufNRowW0N-KzziiJkaDo5o8W-CqZboD3XDbyg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
To:     Minchan Kim <minchan@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawnguo@kernel.org, linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        vbabka@suse.cz, stable@vger.kernel.org, shijie.qin@nxp.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Minchan & David,

On Sat, Mar 19, 2022 at 12:20 AM Minchan Kim <minchan@kernel.org> wrote:
>
> On Fri, Mar 18, 2022 at 11:43:41AM +0800, Dong Aisheng wrote:
> > On Fri, Mar 18, 2022 at 1:12 AM Minchan Kim <minchan@kernel.org> wrote:
> > >
> > > On Thu, Mar 17, 2022 at 10:26:42PM +0800, Dong Aisheng wrote:
> > > > On Thu, Mar 17, 2022 at 6:55 PM David Hildenbrand <david@redhat.com> wrote:
> > > > >
> > > > > On 15.03.22 15:45, Dong Aisheng wrote:
> > > > > > When there're multiple process allocing dma memory in parallel
> > > > >
> > > > > s/allocing/allocating/
> > > > >
> > > > > > by calling dma_alloc_coherent(), it may fail sometimes as follows:
> > > > > >
> > > > > > Error log:
> > > > > > cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
> > > > > > cma: number of available pages:
> > > > > > 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
> > > > > > 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
> > > > > > 7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages
> > > > > >
> > > > > > When issue happened, we saw there were still 33161 pages (129M) free CMA
> > > > > > memory and a lot available free slots for 148 pages in CMA bitmap that we
> > > > > > want to allocate.
> > >
> > > Yes, I also have met the problem especially when the multiple threads
> > > compete cma allocation. Thanks for bringing up the issue.
> > >
> > > > > >
> > > > > > If dumping memory info, we found that there was also ~342M normal memory,
> > > > > > but only 1352K CMA memory left in buddy system while a lot of pageblocks
> > > > > > were isolated.
> > > > >
> > > > > s/If/When/
> > > > >
> > > >
> > > > Will fix them all, thanks.
> > > >
> > > > > >
> > > > > > Memory info log:
> > > > > > Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
> > > > > >           active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
> > > > > >           unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
> > > > > >           bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
> > > > > > Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
> > > > > >       36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
> > > > > >       8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
> > > > > >
> > > > > > The root cause of this issue is that since commit a4efc174b382
> > > > > > ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
> > > > > > memory allocation. It's possible that the memory range process A trying
> > > > > > to alloc has already been isolated by the allocation of process B during
> > > > > > memory migration.
> > > > > >
> > > > > > The problem here is that the memory range isolated during one allocation
> > > > > > by start_isolate_page_range() could be much bigger than the real size we
> > > > > > want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.
> > > > > >
> > > > > > Taking an ARMv7 platform with 1G memory as an example, when MAX_ORDER_NR_PAGES
> > > > > > is big (e.g. 32M with max_order 14) and CMA memory is relatively small
> > > > > > (e.g. 128M), there're only 4 MAX_ORDER slot, then it's very easy that
> > > > > > all CMA memory may have already been isolated by other processes when
> > > > > > one trying to allocate memory using dma_alloc_coherent().
> > > > > > Since current CMA code will only scan one time of whole available CMA
> > > > > > memory, then dma_alloc_coherent() may easy fail due to contention with
> > > > > > other processes.
> > > > > >
> > > > > > This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
> > > > > > error in case the target memory range may has been temporarily isolated
> > > > > > by others and released later.
> > > > >
> > > > > But you patch doesn't check for -EBUSY and instead might retry forever,
> > > > > on any allocation error, no?
> > > > >
> > > >
> > > > My patch seems not need check it because there's no chance to retry the loop
> > > > in case an non -EBUS error happened earlier.
> > > >
> > > > for (;;) {
> > > >         if (bitmap_no >= bitmap_maxno) {
> > > >                 retry_the_whole_loop;
> > > >         }
> > > >
> > > >         pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
> > > >         ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
> > > >                              GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
> > > >
> > > >         if (ret != -EBUSY)
> > > >                 break;
> > > > }
> > > >
> > > > > I'd really suggest letting alloc_contig_range() return -EAGAIN in case
> > > > > the isolation failed and handling -EAGAIN only in a special way instead.
> > > > >
> > > >
> > > > Yes, i guess that's another improvement and is applicable.
> > > >
> > > > > In addition, we might want to stop once we looped to often I assume.
> > > > >
> > > >
> > > > I wonder if really retried un-reasonably too often, we probably may
> > > > need figure out
> > > > what's going on inside alloc_contig_range() and fix it rather than
> > > > return EBUSY error to
> > > > users in case there're still a lot of avaiable memories.
> > > > So currently i didn't add a maximum retry loop outside.
> > > >
> > > > Additionaly, for a small CMA system (128M with 32M max_order pages),
> > > > the retry would
> > > > be frequently when multiple process allocating memory, it also depends
> > > > on system running
> > > > state, so it's hard to define a reasonable and stable maxinum retry count.
> > >
> > > IMO, when the CMA see the -EAGAIN, it should put the task into
> > > cma->wait_queue and then be woken up by other thread which finish
> > > work of the cma. So it's similar with cma_mutex but we don't need to
> > > synchronize for !EAGAIN cases and make the cma allocatoin fair.
> >
> > Okay, that's another approach which is completely different from the
> > existing one.
> > Instead of blocking on the CMA memory range which we want to allocate,
> > the existing code will try the next available memory ranges.
> > The question is whether we need to change this behavior?
>
> It could wait only if it scan the whole range but everyblock were
> taken and then one more trial after woken up. If the cma_alloc return
> -EAGAIN in the end, user could decide the policy.
>
> > It looks to me both ways have pros and cons.
> >
> > And for sleeping on -EAGAIN case, do we need an accurate wakeup?
> > IOW only wakes the sleeper when the exact memory range is released
> > which means we need create some more complicated code logic
> > to track different CMA memory range usage.
> > Otherwise, there will be possible false positive wakeups and the requester may
> > quickly sleep again.
>
> I even didn't consider such complicated model since we would have
> the race anyway.(Never tested but wanted to show the intention)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index bc9ca8f3c487..cccf684da587 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -449,6 +449,7 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>         offset = cma_bitmap_aligned_offset(cma, align);
>         bitmap_maxno = cma_bitmap_maxno(cma);
>         bitmap_count = cma_bitmap_pages_to_bits(cma, count);
> +       bool retried = false;
>
>         if (bitmap_count > bitmap_maxno)
>                 goto out;
> @@ -460,6 +461,12 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>                                 offset);
>                 if (bitmap_no >= bitmap_maxno) {
>                         spin_unlock_irq(&cma->lock);
> +                       if (ret == -EAGAIN && !retried) {
> +                               wait_event_killable(cma->wq);

I spent a few days reading the code carefully and implementing your suggestions.
But I think the problem was still when to wake up multiple callers
properly who were sleeping
on isolation contention error.  The issue I observed was that there's
a synchronization problem
between the sleeper and waker in current code logic due to:
1) we only need to wake up the caller when detecting users sleeping on
the isolation contention.
A flag needs to be introduced to check dynamically.
2) wakeup code may be finished before the flag was set which means the
last sleeper
may be missed to wake up. So a timeout mechanism needs to be introduced.
3) the code can't avoid the wait_for_completion() and complete() run in parallel
without introducing extra complexity to do proper synchronization.
(during my test, &cma->pending can be < 0 sometimes)

I wonder if it's worth introducing such complexity to support sleeping
on isolation contention.
Maybe the simple way was just as Andrew said that  let's revert that
broken patch first.

Do you have any suggestions?

Below is the demo code I ran against next-20220420.

diff --git a/mm/cma.c b/mm/cma.c
index eaa4b5c920a2..682fb8a90572 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -119,6 +119,7 @@ static void __init cma_activate_area(struct cma *cma)
                init_cma_reserved_pageblock(pfn_to_page(pfn));

        spin_lock_init(&cma->lock);
+       init_completion(&cma->completion);

 #ifdef CONFIG_CMA_DEBUGFS
        INIT_HLIST_HEAD(&cma->mem_head);
@@ -429,7 +430,9 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
        unsigned long bitmap_maxno, bitmap_no, bitmap_count;
        unsigned long i;
        struct page *page = NULL;
+       bool rescan = false;
        int ret = -ENOMEM;
+       int loop = 0;

        if (!cma || !cma->count || !cma->bitmap)
                goto out;
@@ -456,6 +459,23 @@ struct page *cma_alloc(struct cma *cma, unsigned
long count,
                                bitmap_maxno, start, bitmap_count, mask,
                                offset);
                if (bitmap_no >= bitmap_maxno) {
+                       pr_debug("%s(): alloc fail, rescan %d\n", __func__,
+                                loop++);
+                       /*
+                        * rescan CMA as the previous isolated memory range we
+                        * wanted to use may have been release by others now.
+                       */
+                       if (rescan) {
+                               rescan = false;
+                               start = 0;
+                               atomic_add(1, &cma->pending);
+                               spin_unlock_irq(&cma->lock);
+                               ret =
wait_for_completion_timeout(&cma->completion, HZ / 2);
+                               if (!ret) {
+                                       atomic_sub(1, &cma->pending);
+                               }
+                               continue;
+                       }
                        spin_unlock_irq(&cma->lock);
                        break;
                }
@@ -468,16 +488,29 @@ struct page *cma_alloc(struct cma *cma, unsigned
long count,
                spin_unlock_irq(&cma->lock);

                pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
+
+               /*
+                * Memory range may be temporarily isolated by others.
+                * Recording it once met and giving another chance to rescan
+                * the whole CMA range in case we failed to find a suitable
+                * memory finally during the initial scan and assuming the
+                * isolated range may be released sometime later.
+                */
                ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
                                     GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));

                if (ret == 0) {
                        page = pfn_to_page(pfn);
+                       if (atomic_read(&cma->pending)) {
+                               complete(&cma->completion);
+                               atomic_sub(1, &cma->pending);
+                       }
                        break;
+               } else if ( ret == -EAGAIN) {
+                       rescan = true;
                }

                cma_clear_bitmap(cma, pfn, count);
-               if (ret != -EBUSY)
+               if (ret != -EBUSY && ret != -EAGAIN)
                        break;

                pr_debug("%s(): memory range at %p is busy, retrying\n",
@@ -486,7 +519,8 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
                trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
                                           count, align);
                /* try again with a bit different memory target */
-               start = bitmap_no + mask + 1;
+               start = ALIGN(bitmap_no + mask + 1,
+                             MAX_ORDER_NR_PAGES >> cma->order_per_bit);
        }

        trace_cma_alloc_finish(cma->name, pfn, page, count, align);
diff --git a/mm/cma.h b/mm/cma.h
index 88a0595670b7..35b4d33d12e4 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -31,6 +31,8 @@ struct cma {
        struct cma_kobject *cma_kobj;
 #endif
        bool reserve_pages_on_error;
+       struct completion completion;
+       atomic_t pending;
 };

 extern struct cma cma_areas[MAX_CMA_AREAS];
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index ff0ea6308299..a2a46eebb0bc 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -30,7 +30,7 @@ static int set_migratetype_isolate(struct page
*page, int migratetype, int isol_
         */
        if (is_migrate_isolate_page(page)) {
                spin_unlock_irqrestore(&zone->lock, flags);
-               return -EBUSY;
+               return -EAGAIN;
        }

        /*
@@ -179,13 +179,15 @@ __first_valid_page(unsigned long pfn, unsigned
long nr_pages)
  * might be used to flush and disable pcplist before isolation and enable after
  * unisolation.
  *
- * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
+ * Return: 0 on success and -EAGAIN or -EBUSY if any part of range cannot be
+ * isolated.
  */
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
                             unsigned migratetype, int flags)
 {
        unsigned long pfn;
        struct page *page;
+       int ret;

        BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
        BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
@@ -194,9 +196,13 @@ int start_isolate_page_range(unsigned long
start_pfn, unsigned long end_pfn,
             pfn < end_pfn;
             pfn += pageblock_nr_pages) {
                page = __first_valid_page(pfn, pageblock_nr_pages);
-               if (page && set_migratetype_isolate(page, migratetype, flags)) {
+               if (!page)
+                       continue;
+
+               ret = set_migratetype_isolate(page, migratetype, flags);
+               if (ret) {
                        undo_isolate_page_range(start_pfn, pfn, migratetype);
-                       return -EBUSY;
+                       return ret;
                }
        }
        return 0;

Regards
Aisheng
