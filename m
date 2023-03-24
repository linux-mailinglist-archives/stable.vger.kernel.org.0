Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D0D6C7FD5
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 15:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCXO1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjCXO1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 10:27:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC78F96D
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 07:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679667984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=njAUDap1YoiePqX1ep0d+XCPs1LaFXcKfsvd98HpMnw=;
        b=NmgknZlics75s94oz1fxQhfphw+BPv9J+UtwQ7wPBo4FkEdJu+d36IuXAaiosaQIij0TeU
        DUhmmLcqaXAAyTmXnL+Jz7s7fZ+/S8ffosos0bOy7SJj2sUnOLtWSZBgzDdQ1xWQIfLKpc
        pgM2zORZic8saXkZNUq7pwr+wxJYzNI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-600-ls_Co3WyNkCL_4l0GglGjg-1; Fri, 24 Mar 2023 10:26:23 -0400
X-MC-Unique: ls_Co3WyNkCL_4l0GglGjg-1
Received: by mail-qt1-f200.google.com with SMTP id v7-20020a05622a188700b003e0e27bbc2eso1132183qtc.8
        for <stable@vger.kernel.org>; Fri, 24 Mar 2023 07:26:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679667982; x=1682259982;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njAUDap1YoiePqX1ep0d+XCPs1LaFXcKfsvd98HpMnw=;
        b=7zrcu+NbiMlf6r8SAWzICA/dLw0troBQHpncxwlv4B138/r4LEqX7UP1aQYnxLYzkF
         eoMt+PLDCOsb9Zs2vOg2zwWYafD6waLML20VL+hrApsnYcl0djY8eHhvpWl5PANZuSJg
         +gnEqxK43HWqmnbHfAZvH5s8v+ToLv9sGlN3V8xGJJXhPxhR6rJ6ocSjMZohR/UrMh71
         Ew7TCNheyw5U+VRA0aGhtjiwJPAUSb3gMgPKpXEOcveA7Q0eni7F56pOO67tFE8sg3gj
         joN1uQ1WHWFQaqvNAmG1qiRFonpRVRs1BqX7oyiitjiIGsr+eBi6Uso7O7gZ+N5Sw/fi
         y/Ww==
X-Gm-Message-State: AO0yUKXvhBA2J1xeR8mbsbbVtWcO6ypeLoyLKoYc+lJLEcnA42vgIoQI
        UKGLl0MboTp3hLwFr1MUc9I/NPkcPPmoVJepnXeCgKWk66B6YHLAj/plKe+FcZQu87limaXtRgL
        cFLa5qI4ydrgMV2cV
X-Received: by 2002:a05:622a:1a18:b0:3bf:a60d:43b9 with SMTP id f24-20020a05622a1a1800b003bfa60d43b9mr3348945qtb.4.1679667982613;
        Fri, 24 Mar 2023 07:26:22 -0700 (PDT)
X-Google-Smtp-Source: AK7set9wCBN9QmO2rC/Ob5zXNxNLGPTDDrI6pt6+Z4sTLoNtnwJCOM1zLtDSVeejcWRSe7w/LcEIWg==
X-Received: by 2002:a05:622a:1a18:b0:3bf:a60d:43b9 with SMTP id f24-20020a05622a1a1800b003bfa60d43b9mr3348920qtb.4.1679667982337;
        Fri, 24 Mar 2023 07:26:22 -0700 (PDT)
Received: from x1n.. (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id 141-20020a370793000000b0074672975d5csm10024794qkh.91.2023.03.24.07.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 07:26:21 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>, peterx@redhat.com,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: [PATCH v3] mm/hugetlb: Fix uffd wr-protection for CoW optimization path
Date:   Fri, 24 Mar 2023 10:26:20 -0400
Message-Id: <20230324142620.2344140-1-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
writable even with uffd-wp bit set.  It only happens with hugetlb private
mappings, when someone firstly wr-protects a missing pte (which will
install a pte marker), then a write to the same page without any prior
access to the page.

Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
reaching hugetlb_wp() to avoid taking more locks that userfault won't need.
However there's one CoW optimization path that can trigger hugetlb_wp()
inside hugetlb_no_page(), which will bypass the trap.

This patch skips hugetlb_wp() for CoW and retries the fault if uffd-wp bit
is detected.  The new path will only trigger in the CoW optimization path
because generic hugetlb_fault() (e.g. when a present pte was wr-protected)
will resolve the uffd-wp bit already.  Also make sure anonymous UNSHARE
won't be affected and can still be resolved, IOW only skip CoW not CoR.

This patch will be needed for v5.19+ hence copy stable.

Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-stable <stable@vger.kernel.org>
Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
Signed-off-by: Peter Xu <peterx@redhat.com>
---

Notes:

v2 is not on the list but in an attachment in the reply; this v3 is mostly
to make sure it's not the same as the patch used to be attached.  Sorry
Andrew, we need to drop the queued one as I rewrote the commit message.

Muhammad, I didn't attach your T-b because of the slight functional change.
Please feel free to re-attach if it still works for you (which I believe
should).

thanks,
---
 mm/hugetlb.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8bfd07f4c143..a58b3739ed4b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		       struct folio *pagecache_folio, spinlock_t *ptl)
 {
 	const bool unshare = flags & FAULT_FLAG_UNSHARE;
-	pte_t pte;
+	pte_t pte = huge_ptep_get(ptep);
 	struct hstate *h = hstate_vma(vma);
 	struct page *old_page;
 	struct folio *new_folio;
@@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 	unsigned long haddr = address & huge_page_mask(h);
 	struct mmu_notifier_range range;
 
+	/*
+	 * Never handle CoW for uffd-wp protected pages.  It should be only
+	 * handled when the uffd-wp protection is removed.
+	 *
+	 * Note that only the CoW optimization path (in hugetlb_no_page())
+	 * can trigger this, because hugetlb_fault() will always resolve
+	 * uffd-wp bit first.
+	 */
+	if (!unshare && huge_pte_uffd_wp(pte))
+		return 0;
+
 	/*
 	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
 	 * PTE mapped R/O such as maybe_mkwrite() would do.
@@ -5500,7 +5511,6 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
 		return 0;
 	}
 
-	pte = huge_ptep_get(ptep);
 	old_page = pte_page(pte);
 
 	delayacct_wpcopy_start();
-- 
2.39.1

