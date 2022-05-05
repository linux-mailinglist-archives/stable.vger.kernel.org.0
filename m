Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADFF51C56F
	for <lists+stable@lfdr.de>; Thu,  5 May 2022 18:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346945AbiEEQ4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 May 2022 12:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiEEQ4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 May 2022 12:56:37 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776E057B14
        for <stable@vger.kernel.org>; Thu,  5 May 2022 09:52:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id r9so4703279pjo.5
        for <stable@vger.kernel.org>; Thu, 05 May 2022 09:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ysBakyAO0cQmKS96vClynaYLEdLsuydxq/3dx/fhoSo=;
        b=HdAleN4Tk5VuhTMZlCacDQ76aGW7ZAD1tbTNriMjLTs49KiAbLHv7/uPxLWcEcRj6G
         RZH6g+ULVFFEYOrtplpS/SGPM17c7G2+cE/gvRrpqIStUSUI6Z9RKUD8OHdPce2Lzful
         BlL4g8qLOe6uZ47xpv0BUPSEFJ5Wx9dSjnL7L7cDCLICnBnJUB0iOZQC8Vu2Q8z1S3Fk
         yeXaCUWcfgSdNp9xYAMbilLbgUiwSuWXEQ7QZWrgbaqg707gu66tDSGEjoI3A2MNB5yZ
         V/j5q4sheTz15dd7SuACc9CwXWPkAk+k2zcbla9LNWKKgK7C5dE7a0OjsAkx6uNGbpaT
         C0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ysBakyAO0cQmKS96vClynaYLEdLsuydxq/3dx/fhoSo=;
        b=mIgvQyYVM9x/GYGpD3wDJxGddaTDqa5UTgUYfbxwyKym3WZKQeoxy9cEWer55ZEvpo
         kyvFQyFCQ171lELQazNAneCjmDk1wrJDyRKQUCm5wQoeNE5VeGQTnl70tcIvLBHMAWr8
         WZW5kSq948yjvGXXG2GeaQshsPoeZhWoLrwmrbuG69hn3c33mIDuGdc11+ymXnWPQ3+M
         NDcFbhjBHJ+X0wqYrN6DC0MFITdFUo/TWIwEP1E9ZkmExUqaPr9pGEjG1gcPiLc2ScJF
         9zlX1yqJCZqc4GdaC80KPjURfHggNvOv5d/oLBcKH5y4m4LFKozmFimJ81e3jX95c1Pt
         LnHg==
X-Gm-Message-State: AOAM530Ef+YivqUSjjSkbB5iAyuWCYZBMSf33b/7upu41c4cXOBvVZGd
        vnJCj7G+IaUuvanWaH4Km9k=
X-Google-Smtp-Source: ABdhPJy2q+GQfVlGnfYaS9OcmMSJeIeSyfOK+NKOyQX+hIZX8qA8E0qxOKQ3RaTRi8YsUnnQurD3Yw==
X-Received: by 2002:a17:902:ce87:b0:15e:a619:4294 with SMTP id f7-20020a170902ce8700b0015ea6194294mr21445450plg.157.1651769576947;
        Thu, 05 May 2022 09:52:56 -0700 (PDT)
Received: from google.com ([2620:15c:211:201:1c0c:8050:e4d3:12f5])
        by smtp.gmail.com with ESMTPSA id mu6-20020a17090b388600b001d960eaed66sm1757256pjb.42.2022.05.05.09.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 09:52:56 -0700 (PDT)
Sender: Minchan Kim <minchan.kim@gmail.com>
Date:   Thu, 5 May 2022 09:52:54 -0700
From:   Minchan Kim <minchan@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, axboe@kernel.dk, david@redhat.com,
        ivan@cloudflare.com, ngupta@vflare.org, senozhatsky@chromium.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: fix unexpected zeroed page mapping
 with zram swap" failed to apply to 4.19-stable tree
Message-ID: <YnQA5hBrVI1dzAG1@google.com>
References: <16502691166558@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16502691166558@kroah.com>
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

On Mon, Apr 18, 2022 at 10:05:16AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

< snip >

This is backport for 4.19-stable.

From c1e0210179e39d3f51d10f20e8031e5af0ce06f8 Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Thu, 5 May 2022 09:49:49 -0700
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
 mm/page_io.c | 55 ----------------------------------------------------
 1 file changed, 55 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 9b646f07f47f..929e7829e02d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -71,55 +71,6 @@ void end_swap_bio_write(struct bio *bio)
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
-	if (disk->fops->swap_slot_free_notify &&
-			__swap_count(sis, entry) == 1) {
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
@@ -135,7 +86,6 @@ static void end_swap_bio_read(struct bio *bio)
 	}
 
 	SetPageUptodate(page);
-	swap_slot_free_notify(page);
 out:
 	unlock_page(page);
 	WRITE_ONCE(bio->bi_private, NULL);
@@ -373,11 +323,6 @@ int swap_readpage(struct page *page, bool synchronous)
 
 	ret = bdev_read_page(sis->bdev, map_swap_page(page, &sis->bdev), page);
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

