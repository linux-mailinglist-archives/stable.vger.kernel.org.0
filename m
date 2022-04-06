Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 944284F6C91
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235759AbiDFVZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbiDFVZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D637131C08E
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 13:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649276423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sv60+PGbSp/SPLVmA/zuo2UTIM2Cw2/zPS3rJaatU2w=;
        b=RNsKXe4hM7IlodZF8fsEe1fFJLGF1ER/ow9yPwoRKC/PGYHoIIgLGklkwIZWRvmRKFEb+/
        YmhiD2TRCUFNdMVbz3j9G9TP1E3Z8/+y48FePUacIoom0DfNNIILkfj6kruowup5KUXvxW
        Vl9+38TA+r36LPi84aSZnbUeHCugPT4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-diia657NMhapEbIZ-gwL9w-1; Wed, 06 Apr 2022 16:20:20 -0400
X-MC-Unique: diia657NMhapEbIZ-gwL9w-1
Received: by mail-io1-f71.google.com with SMTP id d19-20020a0566022bf300b00645eba5c992so2334861ioy.4
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 13:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Sv60+PGbSp/SPLVmA/zuo2UTIM2Cw2/zPS3rJaatU2w=;
        b=Kqa5NX2jzUyzu18QERO0wos4XOM4N7AA/4k2QwiMHEj1A/mVG8Jics6SmtZzABdtjY
         2QtLab8836pQS9nynBPspCW8b3LyBgBvGcGUTJuNMUGU5JDiYnvwkikAmfK9AqCioe5j
         pkCJHw6vtoKDD2P/8tK8wYAJJj+aTYuWUwg/c0vji0bA3a4CFKqwk+7PUa1TB0J+Uyf6
         Ohu7f2MYr6MVRtJbH3bIaPNGeaGZw8Or///mT3IUNpmK3iunwEW5huHMirs41qlIe0Fx
         WARD/qU/ZWyhwHkOfcIu/kslAGtqQ7bdTiywfSqOsjB8IZ/47BcLuT9yeCrlp6dKagGS
         Zd4A==
X-Gm-Message-State: AOAM5314tANZBDy4qrtHPbLDq831LlYk4f2H3weVbHjXj2d4Xi1EM6x+
        UQh61jc9LPSW7r72Ww0qycoxS5nTDngUVULiH+Y/C8ok09itXGMzhBOWdLebU4CPia2Dl8tMi7Z
        oVeMCoIc4n5E4Bgoa
X-Received: by 2002:a6b:ce01:0:b0:64c:ad0b:9a65 with SMTP id p1-20020a6bce01000000b0064cad0b9a65mr4717674iob.147.1649276419241;
        Wed, 06 Apr 2022 13:20:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9TRreIMwiwE1CXjQQzHtMkx1du68gsYWCEv1F1gQZYl14RnEfZwMBARG/XySWZEZhfgr+tA==
X-Received: by 2002:a6b:ce01:0:b0:64c:ad0b:9a65 with SMTP id p1-20020a6bce01000000b0064cad0b9a65mr4717660iob.147.1649276418992;
        Wed, 06 Apr 2022 13:20:18 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id d16-20020a056e020bf000b002ca51236f60sm4634553ilu.9.2022.04.06.13.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 13:20:18 -0700 (PDT)
Date:   Wed, 6 Apr 2022 16:20:17 -0400
From:   Peter Xu <peterx@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     aarcange@redhat.com, akpm@linux-foundation.org, apopple@nvidia.com,
        david@redhat.com, hughd@google.com, jhubbard@nvidia.com,
        kirill@shutemov.name, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz, willy@infradead.org
Subject: Re: FAILED: patch "[PATCH] mm: don't skip swap entry even if
 zap_details specified" failed to apply to 5.10-stable tree
Message-ID: <Yk32AeVVb/HTUuDG@xz-m1.local>
References: <164881750615344@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7S6gKgx5tKO6ib37"
Content-Disposition: inline
In-Reply-To: <164881750615344@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7S6gKgx5tKO6ib37
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline



--7S6gKgx5tKO6ib37
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="patch-5.10.y"

From 9ca74e2ae81740c41d8a736de1cc17c44135b516 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Tue, 22 Mar 2022 14:42:15 -0700
Subject: [PATCH] mm: don't skip swap entry even if zap_details specified

NOTE: this is cherry-picked from 5abfd71d936a8aefd9f9ccd299dea7a164a5d455
but backported explicitly to stable branch.

A few notes:

  - zap_mapping used to be called check_mapping.

  - The patch is simplified, e.g. we don't add hwpoison handling or
    explicit WARN_ON_ONCE() but only start to look after all swap entries.

  - There was no zap_skip_check_mapping() yet in the branch, so it's
    written in the full form to check against zap_details.check_mapping for
    the migration entry checks.

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
 mm/memory.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 4fe24cd865a7..b26314549a04 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1204,6 +1204,17 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
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
@@ -1295,16 +1306,18 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 			continue;
 		}
 
-		/* If details->check_mapping, we leave swap entries. */
-		if (unlikely(details))
-			continue;
-
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


--7S6gKgx5tKO6ib37--

