Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712254F6C93
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235575AbiDFVZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235381AbiDFVZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1DA246160
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 13:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649276457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QAx2SSp7zCkgZuknG991vtPMpZJznKxzgffQrgP47FE=;
        b=ZV0/SY/REdQcElZyVCVxSgWfdkhPzFpoYvzGE/IF+oUgvOrZ9mBd6zdH2dXVsKWHgo8kpm
        8+RYjwF25UyWKHTGWNRiEcVUnlHLJmzNmsQwxaS+YgAla9K9gN1afDQksSYn6oghZ7OCM9
        d3nXL+HkFivRsUZtD1/rwx2kN5XwlWw=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-CV3LK8isOAmD-2Iq18sHsQ-1; Wed, 06 Apr 2022 16:20:56 -0400
X-MC-Unique: CV3LK8isOAmD-2Iq18sHsQ-1
Received: by mail-io1-f70.google.com with SMTP id e27-20020a056602045b00b00645bd576184so2339371iov.3
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 13:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QAx2SSp7zCkgZuknG991vtPMpZJznKxzgffQrgP47FE=;
        b=Vo6qr0uOA3BNeleY6vfNet2rvkFg8jqFBdvxA0p86aD96VBKjv/WYtM5vlMDyv2m6f
         k3CyEGoyq0KgEzN81y40RqgZ1QC+Pigutx5vr28yj1ggbgbnI5iKbk1AnEuiFwnCiGi7
         cUPntXZViSxwHoa9PRz3swpRiF8ZwBdSNl3laYFH6jcH9gue7pSRwEE0ufAZ4HTN+5Zb
         faYtxsxioBZ/rgTwChNdp1k134zX69gl6FySS2jeM2phkLi1gx1ZfNyKpIFSb+zYNOxd
         6g5GGlkaPRbh5o9Y/PRTMPOX4jZE76XZ5chaQsWt+Nwjh5CUDbYjpIRdNPi2Q/XGN6I5
         S5vw==
X-Gm-Message-State: AOAM530qFf2tIE80xhGs4X9hd09diDj7jefUJjGfJKghxb0grxddMRsO
        80MyMBZTUZwOvZkvoVjJGzlc+h97yYGwLr3wl7o71vTiybjccrTNvT0GKmGzN2Zu3nqPWqODbVd
        XNWz4DkuNY21OCSp9
X-Received: by 2002:a5e:990b:0:b0:645:e9e5:3a9b with SMTP id t11-20020a5e990b000000b00645e9e53a9bmr4712098ioj.164.1649276456128;
        Wed, 06 Apr 2022 13:20:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx4TB2U6LOk6fyrjf8P6U9S56yKfnuflAwHV2uU3Bmp+4tNe9ZoLnd/Estp52isxYyU7FVlRQ==
X-Received: by 2002:a5e:990b:0:b0:645:e9e5:3a9b with SMTP id t11-20020a5e990b000000b00645e9e53a9bmr4712084ioj.164.1649276455879;
        Wed, 06 Apr 2022 13:20:55 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id t16-20020a92ca90000000b002ca4e87c8besm4888750ilo.19.2022.04.06.13.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:20:55 -0700 (PDT)
Date:   Wed, 6 Apr 2022 16:20:54 -0400
From:   Peter Xu <peterx@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     aarcange@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com,
        david@redhat.com, hughd@google.com, jhubbard@nvidia.com,
        kirill@shutemov.name, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: don't skip swap entry even if
 zap_details specified" failed to apply to 4.9-stable tree
Message-ID: <Yk32JnHEwFzU6+0e@xz-m1.local>
References: <164881751212299@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lg67v2Aa2at1aZiB"
Content-Disposition: inline
In-Reply-To: <164881751212299@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--lg67v2Aa2at1aZiB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline



--lg67v2Aa2at1aZiB
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="patch-4.9.y"

From f4b76680ee69b3147344c9152d10ea7a8e4a89b2 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 22 Mar 2022 14:42:15 -0700
Subject: [PATCH] mm: don't skip swap entry even if zap_details specified

NOTE: this is cherry-picked from 5abfd71d936a8aefd9f9ccd299dea7a164a5d455
but backported explicitly to stable branch.

A few notes:

  - zap_mapping used to be called check_mapping.

  - check_swap_entries existed in 4.9.y, this patch removed its major
    reference in zap_pte_range() then we'll check swap entry with/without
    specifying check_swap_entries=Y.  Logically we can drop the field
    check_swap_entries (which was introduced for oom killer scenario)
    altogether but this patch kept it for simplicity.

  - The patch is simplified too, e.g. we don't add hwpoison or
    WARN_ON_ONCE() but only start to look after all the swap entries.

  - There was no zap_skip_check_mapping() yet in the branch, so it's
    written in the full form to check against zap_details.check_mapping.

Original commit message below.

=============================

Patch series "mm: Rework zap ptes on swap entries", v5.

Patch 1 should fix a long standing bug for zap_pte_range() on
zap_details usage.  The risk is we could have some swap entries skipped
while we should have zapped them.

Migration entries are not the major concern because file backed memory
always zap in the pattern that "first time without page lock, then
re-zap with page lock" hence the 2nd zap will always make sure all
migration entries are already recovered.

However there can be issues with real swap entries got skipped
errornoously.  There's a reproducer provided in commit message of patch
1 for that.

Patch 2-4 are cleanups that are based on patch 1.  After the whole
patchset applied, we should have a very clean view of zap_pte_range().

Only patch 1 needs to be backported to stable if necessary.

This patch (of 4):

The "details" pointer shouldn't be the token to decide whether we should
skip swap entries.

For example, when the callers specified details->zap_mapping==NULL, it
means the user wants to zap all the pages (including COWed pages), then
we need to look into swap entries because there can be private COWed
pages that was swapped out.

Skipping some swap entries when details is non-NULL may lead to wrongly
leaving some of the swap entries while we should have zapped them.

A reproducer of the problem:

===8<===
        #define _GNU_SOURCE         /* See feature_test_macros(7) */
        #include <stdio.h>
        #include <assert.h>
        #include <unistd.h>
        #include <sys/mman.h>
        #include <sys/types.h>

        int page_size;
        int shmem_fd;
        char *buffer;

        void main(void)
        {
                int ret;
                char val;

                page_size = getpagesize();
                shmem_fd = memfd_create("test", 0);
                assert(shmem_fd >= 0);

                ret = ftruncate(shmem_fd, page_size * 2);
                assert(ret == 0);

                buffer = mmap(NULL, page_size * 2, PROT_READ | PROT_WRITE,
                                MAP_PRIVATE, shmem_fd, 0);
                assert(buffer != MAP_FAILED);

                /* Write private page, swap it out */
                buffer[page_size] = 1;
                madvise(buffer, page_size * 2, MADV_PAGEOUT);

                /* This should drop private buffer[page_size] already */
                ret = ftruncate(shmem_fd, page_size);
                assert(ret == 0);
                /* Recover the size */
                ret = ftruncate(shmem_fd, page_size * 2);
                assert(ret == 0);

                /* Re-read the data, it should be all zero */
                val = buffer[page_size];
                if (val == 0)
                        printf("Good\n");
                else
                        printf("BUG\n");
        }
===8<===

We don't need to touch up the pmd path, because pmd never had a issue with
swap entries.  For example, shmem pmd migration will always be split into
pte level, and same to swapping on anonymous.

Add another helper should_zap_cows() so that we can also check whether we
should zap private mappings when there's no page pointer specified.

This patch drops that trick, so we handle swap ptes coherently.  Meanwhile
we should do the same check upon migration entry, hwpoison entry and
genuine swap entries too.

To be explicit, we should still remember to keep the private entries if
even_cows==false, and always zap them when even_cows==true.

The issue seems to exist starting from the initial commit of git.

[peterx@redhat.com: comment tweaks]
  Link: https://lkml.kernel.org/r/20220217060746.71256-2-peterx@redhat.com

Link: https://lkml.kernel.org/r/20220217060746.71256-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220216094810.60572-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20220216094810.60572-2-peterx@redhat.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 5abfd71d936a8aefd9f9ccd299dea7a164a5d455)
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/memory.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2b2cc69ddcce..1b31cdce936e 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1113,6 +1113,17 @@ int copy_page_range(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	return ret;
 }
 
+/* Whether we should zap all COWed (private) pages too */
+static inline bool should_zap_cows(struct zap_details *details)
+{
+	/* By default, zap all pages */
+	if (!details)
+		return true;
+
+	/* Or, we zap COWed pages only if the caller wants to */
+	return !details->check_mapping;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1186,17 +1197,20 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 			}
 			continue;
 		}
-		/* only check swap_entries if explicitly asked for in details */
-		if (unlikely(details && !details->check_swap_entries))
-			continue;
 
 		entry = pte_to_swp_entry(ptent);
-		if (!non_swap_entry(entry))
+		if (!non_swap_entry(entry)) {
+			/* Genuine swap entry, hence a private anon page */
+			if (!should_zap_cows(details))
+				continue;
 			rss[MM_SWAPENTS]--;
-		else if (is_migration_entry(entry)) {
+		} else if (is_migration_entry(entry)) {
 			struct page *page;
 
 			page = migration_entry_to_page(entry);
+			if (details && details->check_mapping &&
+			    details->check_mapping != page_rmapping(page))
+				continue;
 			rss[mm_counter(page)]--;
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
-- 
2.32.0


--lg67v2Aa2at1aZiB--

