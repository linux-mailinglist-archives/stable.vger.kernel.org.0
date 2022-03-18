Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D254DDED0
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbiCRQY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239128AbiCRQYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:24:47 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1892730CDAA;
        Fri, 18 Mar 2022 09:20:27 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o13so5376427pgc.12;
        Fri, 18 Mar 2022 09:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Za0iurpcwxXfkRS9CbrStLyJ0ExWJl1yK1MlvtVV+lE=;
        b=Vh/FekQyxu5hTaU6FeEKJyV7bKIaALYplD7yclWjvntFThDRDuDLWh/EgIy7vCSrVj
         l4ubS0oE/KL+KlCdW8rOuL8o/pnCDEPnjtfNe/wKlBQlNuk0+DL4ruLkXJRz2qqSqWxe
         asZX8KAQiL+53+Te5ecnsj2WqFMYIqgusGDttetOr2a7zPC3bYQYcsJnmOMWivRmrMda
         c/0ePGqaIDQW+PVtt3B+2x8jNlGVgZEybspP2l8yFfIxkIWk5lr5nDPLCn9TJIR/iC7d
         rh4qnj/jBojkhB1K5UxGEKT6iSkz9zluZZAkGSorCM9aGVK25rvvXLfDtJNj9qQAH7Os
         7kKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Za0iurpcwxXfkRS9CbrStLyJ0ExWJl1yK1MlvtVV+lE=;
        b=Eg2QyNFIGrULuXXhC+Tc5qjSWUA7b4hQaGDBp82+B0pgKs0zmca9yKml9Kc8pWe4qy
         +NxF+vko2KVL2TUHJfWd/tyTDrSwNGwLaQmfjpz8Nh1KuIy7s25CGC3ysuuKyxoTI6d0
         3+7M1bznk4OSx1k1Z4zfomiWyyMqbW7CvOMgvRh2Nq5qRPH6bRX1Ktm2OmRfI9iRhENa
         GKIQnibcPL56CgsIW8qdAQNs8xzECWog69sUTSa5v/ZGERBkfoAjt9Lo4UWs9s+LVU98
         HwMvEzGdx8+rjxOaOpS9l1tKnpJZo1ZBFMmFYPUjqdL+0CCzDuM04NpW3nGYKAAlrdGp
         KamA==
X-Gm-Message-State: AOAM530OTGYUPjZtzk0sIIPjUlQa5RefsNeJRjcwqHj1/tZ6RvLy7flI
        Yt2GGmuURowrcYMO38OWkfw=
X-Google-Smtp-Source: ABdhPJz1/AoM7RAToC5mYwXjq5SvCnazVz3/wyYVVjp9FvCYVD6irn2K3IOTR1xZzT5E0PG8Trfyjw==
X-Received: by 2002:a62:402:0:b0:4f7:81a3:7c47 with SMTP id 2-20020a620402000000b004f781a37c47mr10559177pfe.9.1647620426232;
        Fri, 18 Mar 2022 09:20:26 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:bd26:cec:b459:db6e])
        by smtp.gmail.com with ESMTPSA id d6-20020a056a00244600b004f701135460sm10466207pfj.146.2022.03.18.09.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:20:25 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Fri, 18 Mar 2022 09:20:23 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     Dong Aisheng <dongas86@gmail.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Dong Aisheng <aisheng.dong@nxp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        shawnguo@kernel.org, linux-imx@nxp.com, akpm@linux-foundation.org,
        m.szyprowski@samsung.com, lecopzer.chen@mediatek.com,
        vbabka@suse.cz, stable@vger.kernel.org, shijie.qin@nxp.com
Subject: Re: [PATCH v3 1/2] mm: cma: fix allocation may fail sometimes
Message-ID: <YjSxR9Zyck4YqgEz@google.com>
References: <20220315144521.3810298-1-aisheng.dong@nxp.com>
 <20220315144521.3810298-2-aisheng.dong@nxp.com>
 <93480fb1-6992-b992-4c93-0046f3b92d7a@redhat.com>
 <CAA+hA=QzDJhFnntKK4nk-SMErk9J_mFPv0b7ZWuC8Ubz0BC+sg@mail.gmail.com>
 <YjNr+d2Un7F8c2DZ@google.com>
 <CAA+hA=SBeCT+XkzNL3p07vC+58AZOTtoiLG=jVK0tX4wNFvrHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=SBeCT+XkzNL3p07vC+58AZOTtoiLG=jVK0tX4wNFvrHA@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 18, 2022 at 11:43:41AM +0800, Dong Aisheng wrote:
> On Fri, Mar 18, 2022 at 1:12 AM Minchan Kim <minchan@kernel.org> wrote:
> >
> > On Thu, Mar 17, 2022 at 10:26:42PM +0800, Dong Aisheng wrote:
> > > On Thu, Mar 17, 2022 at 6:55 PM David Hildenbrand <david@redhat.com> wrote:
> > > >
> > > > On 15.03.22 15:45, Dong Aisheng wrote:
> > > > > When there're multiple process allocing dma memory in parallel
> > > >
> > > > s/allocing/allocating/
> > > >
> > > > > by calling dma_alloc_coherent(), it may fail sometimes as follows:
> > > > >
> > > > > Error log:
> > > > > cma: cma_alloc: linux,cma: alloc failed, req-size: 148 pages, ret: -16
> > > > > cma: number of available pages:
> > > > > 3@125+20@172+12@236+4@380+32@736+17@2287+23@2473+20@36076+99@40477+108@40852+44@41108+20@41196+108@41364+108@41620+
> > > > > 108@42900+108@43156+483@44061+1763@45341+1440@47712+20@49324+20@49388+5076@49452+2304@55040+35@58141+20@58220+20@58284+
> > > > > 7188@58348+84@66220+7276@66452+227@74525+6371@75549=> 33161 free of 81920 total pages
> > > > >
> > > > > When issue happened, we saw there were still 33161 pages (129M) free CMA
> > > > > memory and a lot available free slots for 148 pages in CMA bitmap that we
> > > > > want to allocate.
> >
> > Yes, I also have met the problem especially when the multiple threads
> > compete cma allocation. Thanks for bringing up the issue.
> >
> > > > >
> > > > > If dumping memory info, we found that there was also ~342M normal memory,
> > > > > but only 1352K CMA memory left in buddy system while a lot of pageblocks
> > > > > were isolated.
> > > >
> > > > s/If/When/
> > > >
> > >
> > > Will fix them all, thanks.
> > >
> > > > >
> > > > > Memory info log:
> > > > > Normal free:351096kB min:30000kB low:37500kB high:45000kB reserved_highatomic:0KB
> > > > >           active_anon:98060kB inactive_anon:98948kB active_file:60864kB inactive_file:31776kB
> > > > >           unevictable:0kB writepending:0kB present:1048576kB managed:1018328kB mlocked:0kB
> > > > >           bounce:0kB free_pcp:220kB local_pcp:192kB free_cma:1352kB lowmem_reserve[]: 0 0 0
> > > > > Normal: 78*4kB (UECI) 1772*8kB (UMECI) 1335*16kB (UMECI) 360*32kB (UMECI) 65*64kB (UMCI)
> > > > >       36*128kB (UMECI) 16*256kB (UMCI) 6*512kB (EI) 8*1024kB (UEI) 4*2048kB (MI) 8*4096kB (EI)
> > > > >       8*8192kB (UI) 3*16384kB (EI) 8*32768kB (M) = 489288kB
> > > > >
> > > > > The root cause of this issue is that since commit a4efc174b382
> > > > > ("mm/cma.c: remove redundant cma_mutex lock"), CMA supports concurrent
> > > > > memory allocation. It's possible that the memory range process A trying
> > > > > to alloc has already been isolated by the allocation of process B during
> > > > > memory migration.
> > > > >
> > > > > The problem here is that the memory range isolated during one allocation
> > > > > by start_isolate_page_range() could be much bigger than the real size we
> > > > > want to alloc due to the range is aligned to MAX_ORDER_NR_PAGES.
> > > > >
> > > > > Taking an ARMv7 platform with 1G memory as an example, when MAX_ORDER_NR_PAGES
> > > > > is big (e.g. 32M with max_order 14) and CMA memory is relatively small
> > > > > (e.g. 128M), there're only 4 MAX_ORDER slot, then it's very easy that
> > > > > all CMA memory may have already been isolated by other processes when
> > > > > one trying to allocate memory using dma_alloc_coherent().
> > > > > Since current CMA code will only scan one time of whole available CMA
> > > > > memory, then dma_alloc_coherent() may easy fail due to contention with
> > > > > other processes.
> > > > >
> > > > > This patch introduces a retry mechanism to rescan CMA bitmap for -EBUSY
> > > > > error in case the target memory range may has been temporarily isolated
> > > > > by others and released later.
> > > >
> > > > But you patch doesn't check for -EBUSY and instead might retry forever,
> > > > on any allocation error, no?
> > > >
> > >
> > > My patch seems not need check it because there's no chance to retry the loop
> > > in case an non -EBUS error happened earlier.
> > >
> > > for (;;) {
> > >         if (bitmap_no >= bitmap_maxno) {
> > >                 retry_the_whole_loop;
> > >         }
> > >
> > >         pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
> > >         ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
> > >                              GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
> > >
> > >         if (ret != -EBUSY)
> > >                 break;
> > > }
> > >
> > > > I'd really suggest letting alloc_contig_range() return -EAGAIN in case
> > > > the isolation failed and handling -EAGAIN only in a special way instead.
> > > >
> > >
> > > Yes, i guess that's another improvement and is applicable.
> > >
> > > > In addition, we might want to stop once we looped to often I assume.
> > > >
> > >
> > > I wonder if really retried un-reasonably too often, we probably may
> > > need figure out
> > > what's going on inside alloc_contig_range() and fix it rather than
> > > return EBUSY error to
> > > users in case there're still a lot of avaiable memories.
> > > So currently i didn't add a maximum retry loop outside.
> > >
> > > Additionaly, for a small CMA system (128M with 32M max_order pages),
> > > the retry would
> > > be frequently when multiple process allocating memory, it also depends
> > > on system running
> > > state, so it's hard to define a reasonable and stable maxinum retry count.
> >
> > IMO, when the CMA see the -EAGAIN, it should put the task into
> > cma->wait_queue and then be woken up by other thread which finish
> > work of the cma. So it's similar with cma_mutex but we don't need to
> > synchronize for !EAGAIN cases and make the cma allocatoin fair.
> 
> Okay, that's another approach which is completely different from the
> existing one.
> Instead of blocking on the CMA memory range which we want to allocate,
> the existing code will try the next available memory ranges.
> The question is whether we need to change this behavior?

It could wait only if it scan the whole range but everyblock were
taken and then one more trial after woken up. If the cma_alloc return
-EAGAIN in the end, user could decide the policy.

> It looks to me both ways have pros and cons.
> 
> And for sleeping on -EAGAIN case, do we need an accurate wakeup?
> IOW only wakes the sleeper when the exact memory range is released
> which means we need create some more complicated code logic
> to track different CMA memory range usage.
> Otherwise, there will be possible false positive wakeups and the requester may
> quickly sleep again.

I even didn't consider such complicated model since we would have
the race anyway.(Never tested but wanted to show the intention)

diff --git a/mm/cma.c b/mm/cma.c
index bc9ca8f3c487..cccf684da587 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -449,6 +449,7 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 	offset = cma_bitmap_aligned_offset(cma, align);
 	bitmap_maxno = cma_bitmap_maxno(cma);
 	bitmap_count = cma_bitmap_pages_to_bits(cma, count);
+	bool retried = false;
 
 	if (bitmap_count > bitmap_maxno)
 		goto out;
@@ -460,6 +461,12 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 				offset);
 		if (bitmap_no >= bitmap_maxno) {
 			spin_unlock_irq(&cma->lock);
+			if (ret == -EAGAIN && !retried) {
+				wait_event_killable(cma->wq);
+				retried = true;
+				start = 0;
+				continue;
+			}
 			break;
 		}
 		bitmap_set(cma->bitmap, bitmap_no, bitmap_count);
@@ -471,6 +478,10 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 		spin_unlock_irq(&cma->lock);
 
 		pfn = cma->base_pfn + (bitmap_no << cma->order_per_bit);
+		if (is_migrate_isolate_page(pfn_to_page(pfn))) {
+			ret = -EAGAIN;
+			goto next;
+		}
 		ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA,
 				     GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
 
@@ -478,9 +489,9 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 			page = pfn_to_page(pfn);
 			break;
 		}
-
+next:
 		cma_clear_bitmap(cma, pfn, count);
-		if (ret != -EBUSY)
+		if (ret != -EBUSY && ret != -EAGAIN)
 			break;
 
 		pr_debug("%s(): memory range at %p is busy, retrying\n",
@@ -489,7 +500,10 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
 		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
 					   count, align);
 		/* try again with a bit different memory target */
-		start = bitmap_no + mask + 1;
+		if (ret == -EAGAIN)
+			start = (pfn_max_align_up(pfn + 1) - cma->base_pfn) >> cma->order_per_bit;
+		else
+			start = bitmap_no + mask + 1;
 	}
 
 	trace_cma_alloc_finish(cma->name, pfn, page, count, align);
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index f67c4c70f17f..f5a16a82552a 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -182,7 +182,7 @@ __first_valid_page(unsigned long pfn, unsigned long nr_pages)
  * might be used to flush and disable pcplist before isolation and enable after
  * unisolation.
  *
- * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
+ * Return: 0 on success and -EAGAIN if any part of range cannot be isolated.
  */
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 			     unsigned migratetype, int flags)
@@ -199,7 +199,7 @@ int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (page && set_migratetype_isolate(page, migratetype, flags)) {
 			undo_isolate_page_range(start_pfn, pfn, migratetype);
-			return -EBUSY;
+			return -EAGAIN
 		}
 	}
 	return 0;
