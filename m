Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3D951C51B
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 18:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380430AbiEEQbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 12:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233421AbiEEQbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 12:31:31 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2F426579
        for <stable@vger.kernel.org>; Thu,  5 May 2022 09:27:52 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d17so4911135plg.0
        for <stable@vger.kernel.org>; Thu, 05 May 2022 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IrANl9UNlmb6YfpELlZ5NcH8fF+psOChpCTrK7l3qSQ=;
        b=g9R3QqDGoZlBJ16Sl1Vr6BxU1HXBFjXu8jhhYlVowS+0UntdTm/bcVZ2a9HC3gwHh1
         HSRp+lVjMhy0uXVex8Ub0ImzONXu8laGComNZI9jWME3NKCDL7BExVBQAR0htFY7avGE
         caAay4jSi0GSzmUeo9d43+lUthj5Ey2d0bje/VnoZdXpUWKmoN5LLPdrjbSOKUz89mv0
         RmbSlJlp0ItNYs2Ej9rZXuRpMdOT98CzxRwtffzk1l8IHaIP5eEfj7GsnVpjvyOdGsFA
         YPkZ6s4NV2rUA+vTakhVLNTO7kGuUTaDyk/I6RBQEe/5L7n/AQ0icHVjwkvL0B/YCcJd
         rd0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=IrANl9UNlmb6YfpELlZ5NcH8fF+psOChpCTrK7l3qSQ=;
        b=51OKvm9x8PfpOQu3Hh/VN9i3grwkvXxBVTJ7TXgWjFk1qw9REz0dn68oL3ADA8MZO1
         1ICsTVpx8dO9Kz6HKDZ7vIv0XJX54aMRQW8mJhciOMtzEX21nnWJcO9ypk/y6z3KVi6L
         DkIRB9WMpHHTqCL1MR7iOHE0DCZgpSeu2jK2t1N5Fxmi4KY1RrqpXmo4xLMcCW1KSEH9
         tZ5SeS/gegNd+DhNIsGWGb6r9AwE8MAuGoDd7+O06y2SAyhQyEsimld1BhSXQ6dS6qzd
         dSvu2XZ8wVPzIRE3q6SVs5QIvaW47xVS1EIvbM16uiOOYznkX3teXLGgrT6glUZSU9zn
         /U9g==
X-Gm-Message-State: AOAM5309OCVAunUzJrnizxsQx2ahFuf4lC2VFubM2KBTooMZx9FZ9b93
        Wd/ztFdDTO2YHDodxBzHuhw=
X-Google-Smtp-Source: ABdhPJzEt/DGBav+JK2WDsksZar/YFuETgp8nP8+OkIb/qOrAEZGhbZb81mO3A6BAnq74fxFGqMnag==
X-Received: by 2002:a17:90b:1642:b0:1dc:6419:43ff with SMTP id il2-20020a17090b164200b001dc641943ffmr7096634pjb.229.1651768071349;
        Thu, 05 May 2022 09:27:51 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:1c0c:8050:e4d3:12f5])
        by smtp.gmail.com with ESMTPSA id f4-20020a17090ac28400b001dbc620a5adsm5533495pjt.41.2022.05.05.09.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 09:27:50 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 5 May 2022 09:27:49 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, axboe@kernel.dk, david@redhat.com,
        ivan@cloudflare.com, ngupta@vflare.org, senozhatsky@chromium.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: fix unexpected zeroed page mapping
 with zram swap" failed to apply to 5.4-stable tree
Message-ID: <YnP7BQVW3q43wDg8@google.com>
References: <16502691151480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16502691151480@kroah.com>
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

On Mon, Apr 18, 2022 at 10:05:15AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

< snip >

This is backport for 5.4-stable.

From 587a2b370d803766fd57778cdd1f05511658a246 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Thu, 14 Apr 2022 19:13:46 -0700
Subject: [PATCH] mm: fix unexpected zeroed page mapping with zram swap

e914d8f00391520ecc4495dd0ca0124538ab7119 upstream.

Two processes under CLONE_VM cloning, user process can be corrupted by
seeing zeroed page unexpectedly.

      CPU A                        CPU B

  do_swap_page                do_swap_page
  SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
  swap_readpage valid data
    swap_slot_free_notify
      delete zram entry
                              swap_readpage zeroed(invalid) data
                              pte_lock
                              map the *zero data* to userspace
                              pte_unlock
  pte_lock
  if (!pte_same)
    goto out_nomap;
  pte_unlock
  return and next refault will
  read zeroed data

The swap_slot_free_notify is bogus for CLONE_VM case since it doesn't
increase the refcount of swap slot at copy_mm so it couldn't catch up
whether it's safe or not to discard data from backing device.  In the
case, only the lock it could rely on to synchronize swap slot freeing is
page table lock.  Thus, this patch gets rid of the swap_slot_free_notify
function.  With this patch, CPU A will see correct data.

      CPU A                        CPU B

  do_swap_page                do_swap_page
  SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
                              swap_readpage original data
                              pte_lock
                              map the original data
                              swap_free
                                swap_range_free
                                  bd_disk->fops->swap_slot_free_notify
  swap_readpage read zeroed data
                              pte_unlock
  pte_lock
  if (!pte_same)
    goto out_nomap;
  pte_unlock
  return
  on next refault will see mapped data by CPU B

The concern of the patch would increase memory consumption since it
could keep wasted memory with compressed form in zram as well as
uncompressed form in address space.  However, most of cases of zram uses
no readahead and do_swap_page is followed by swap_free so it will free
the compressed form from in zram quickly.

Link: https://lkml.kernel.org/r/YjTVVxIAsnKAXjTd@google.com
Fixes: 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous device")
Reported-by: Ivan Babrou <ivan@cloudflare.com>
Tested-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>	[4.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/page_io.c | 54 ----------------------------------------------------
 1 file changed, 54 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index bcf27d057253..f0e3f2be7b44 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -69,54 +69,6 @@ void end_swap_bio_write(struct bio *bio)
 	bio_put(bio);
 }
 
-static void swap_slot_free_notify(struct page *page)
-{
-	struct swap_info_struct *sis;
-	struct gendisk *disk;
-	swp_entry_t entry;
-
-	/*
-	 * There is no guarantee that the page is in swap cache - the software
-	 * suspend code (at least) uses end_swap_bio_read() against a non-
-	 * swapcache page.  So we must check PG_swapcache before proceeding with
-	 * this optimization.
-	 */
-	if (unlikely(!PageSwapCache(page)))
-		return;
-
-	sis = page_swap_info(page);
-	if (!(sis->flags & SWP_BLKDEV))
-		return;
-
-	/*
-	 * The swap subsystem performs lazy swap slot freeing,
-	 * expecting that the page will be swapped out again.
-	 * So we can avoid an unnecessary write if the page
-	 * isn't redirtied.
-	 * This is good for real swap storage because we can
-	 * reduce unnecessary I/O and enhance wear-leveling
-	 * if an SSD is used as the as swap device.
-	 * But if in-memory swap device (eg zram) is used,
-	 * this causes a duplicated copy between uncompressed
-	 * data in VM-owned memory and compressed data in
-	 * zram-owned memory.  So let's free zram-owned memory
-	 * and make the VM-owned decompressed page *dirty*,
-	 * so the page should be swapped out somewhere again if
-	 * we again wish to reclaim it.
-	 */
-	disk = sis->bdev->bd_disk;
-	entry.val = page_private(page);
-	if (disk->fops->swap_slot_free_notify && __swap_count(entry) == 1) {
-		unsigned long offset;
-
-		offset = swp_offset(entry);
-
-		SetPageDirty(page);
-		disk->fops->swap_slot_free_notify(sis->bdev,
-				offset);
-	}
-}
-
 static void end_swap_bio_read(struct bio *bio)
 {
 	struct page *page = bio_first_page_all(bio);
@@ -132,7 +84,6 @@ static void end_swap_bio_read(struct bio *bio)
 	}
 
 	SetPageUptodate(page);
-	swap_slot_free_notify(page);
 out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
@@ -371,11 +322,6 @@ int swap_readpage(struct page *page, bool synchronous)
 
 	ret = bdev_read_page(sis->bdev, swap_page_sector(page), page);
 	if (!ret) {
-		if (trylock_page(page)) {
-			swap_slot_free_notify(page);
-			unlock_page(page);
-		}
-
 		count_vm_event(PSWPIN);
 		return 0;
 	}
-- 
2.36.0.512.ge40c2bad7a-goog

