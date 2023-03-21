Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A746C3A49
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCUTUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjCUTUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:20:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232F44DBCA
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679426324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bnoAyuqHmnvQnMwtwv+VIx5eISsKZ1h4nkzuYDMbGjQ=;
        b=Cax03dqm9izhiDZ8242DUnV+IR0BU7ST6f16oO+EEuRPYta8t15UxpzzCKQD7aebUQdsDH
        dEENcm2O/5rrWzjJGiMhv+4Z+yyDoyhLNKyXRu/1Kv+3LzsUV1l3/BYi/S/NaGMa89EXD3
        Aln1kCQUP+kC3vlhpyb7WvABYwkmqDc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-0jAGEsLAM7mBmWe5148-OA-1; Tue, 21 Mar 2023 15:18:43 -0400
X-MC-Unique: 0jAGEsLAM7mBmWe5148-OA-1
Received: by mail-qt1-f198.google.com with SMTP id j4-20020ac85f84000000b003d864ebfc20so9182117qta.14
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426323; x=1682018323;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bnoAyuqHmnvQnMwtwv+VIx5eISsKZ1h4nkzuYDMbGjQ=;
        b=AkUqGbwhQQRH1v0p2zt/imD9wsP5LTuX4OdU5a0uGMBq1wAszYO5j19n/vzYp/uvtw
         qY3rVfvkz79QDIyFk+1eui65qsV0sj82V04bhQcaVz7Y8VQ27uQAzD/CjbHsVbcK0/cR
         i4qFX9lyjM2jG24TvUBAqKKCG7lVf64pSEtwxj+z8lnuHUAh3wI6ztL8MiNu89c6mvHZ
         hfm6CpexSAfAyaw+Gtgra9owqZGhyGbdQmvuvtr6fTTQc4FxZhwHk5+R2qdfg1mdSx/r
         3bNZnrEOLCAfsa03iHAiyU2KygHMB0oYBQV+jAcJmmFkLfmutt8WJr3DvizAZD52odYw
         6ghA==
X-Gm-Message-State: AO0yUKXN8yaAteepiWN3G+BTPqO5AuEQvcGjnxCMe+jVu5cOUAk87XMr
        y5kBC+AyVaxn69orRI8Q37NiB78vORLbY1YvVZg935XI6HLlzCK2aO1u+x8OPw21ZMRd53PxGeI
        BcM4Ot9cqQqPsvJg8
X-Received: by 2002:a05:6214:410f:b0:572:8e20:bd7 with SMTP id kc15-20020a056214410f00b005728e200bd7mr5688230qvb.4.1679426322992;
        Tue, 21 Mar 2023 12:18:42 -0700 (PDT)
X-Google-Smtp-Source: AK7set/+s4wSObnTOQwfeOPgJviuZsqBrAJhYmpM7TaTuPviS0MCZ/yLdpIQWMFbDykMZU+Vyluu9Q==
X-Received: by 2002:a05:6214:410f:b0:572:8e20:bd7 with SMTP id kc15-20020a056214410f00b005728e200bd7mr5688193qvb.4.1679426322669;
        Tue, 21 Mar 2023 12:18:42 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id s10-20020a05620a16aa00b0074341cb30d0sm9756419qkj.62.2023.03.21.12.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:18:42 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization path
Date:   Tue, 21 Mar 2023 15:18:40 -0400
Message-Id: <20230321191840.1897940-1-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
writable even with uffd-wp bit set.  It only happens with all these
conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
write to the page to trigger.

Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
even reaching hugetlb_wp() to avoid taking more locks that userfault won't
need.  However there's one CoW optimization path for missing hugetlb page
that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
userfaultfd-wp traps.

A few ways to resolve this:

  (1) Skip the CoW optimization for hugetlb private mapping, considering
  that private mappings for hugetlb should be very rare, so it may not
  really be helpful to major workloads.  The worst case is we only skip the
  optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
  fault anyway.

  (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
  into hugetlb_wp().  The major cons is there're a bunch of locks taken
  when calling hugetlb_wp(), and that will make the changeset unnecessarily
  complicated due to the lock operations.

  (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
  for uffd-wp privately mapped pages.

This patch chose option (3) which contains the minimum changeset (simplest
for backport) and also make sure hugetlb_wp() itself will start to be
always safe with uffd-wp ptes even if called elsewhere in the future.

This patch will be needed for v5.19+ hence copy stable.

Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-stable <stable@vger.kernel.org>
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/hugetlb.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8bfd07f4c143..22337b191eae 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		       struct folio *pagecache_folio, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
-	pte_t pte;
+	pte_t pte, newpte;
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page;
 	struct folio *new_folio;
@@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		mmu_notifier_invalidate_range(mm, range.start, range.end);
 		page_remove_rmap(old_page, vma, true);
 		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
-		set_huge_pte_at(mm, haddr, ptep,
-				make_huge_pte(vma, &new_folio->page, !unshare));
+		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
+		if (huge_pte_uffd_wp(pte))
+			newpte = huge_pte_mkuffd_wp(newpte);
+		set_huge_pte_at(mm, haddr, ptep, newpte);
 		folio_set_hugetlb_migratable(new_folio);
 		/* Make the old page be freed below */
 		new_folio = page_folio(old_page);
-- 
2.39.1

