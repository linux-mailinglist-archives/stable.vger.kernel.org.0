Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E36483CFE9E
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbhGTPZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 11:25:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242668AbhGTPL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 11:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626796320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7D01Sf7WyFpDy5iBOSB8keAwNmDOKVpIqWY7HiG+shw=;
        b=C6a/310s97+82dKUivh9JgPDxEy6rbvJaSY8T7IxsCxnURsi5eBxkvvCzdGkxcBSitwHlZ
        DCZz8A2CqDSSGNPYfEVE5L1l9rDkrajWZyc658t5o+zcI8w19cZ/wbZVFdJkNav+cqqDcF
        zBy/vnl0/w4u1Nqeny846NL42zxCWjA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-qaFhCR9zO9G7FZhzUVXWWg-1; Tue, 20 Jul 2021 11:51:57 -0400
X-MC-Unique: qaFhCR9zO9G7FZhzUVXWWg-1
Received: by mail-qt1-f198.google.com with SMTP id 44-20020aed30af0000b029024e8ccfcd07so12740348qtf.11
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 08:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7D01Sf7WyFpDy5iBOSB8keAwNmDOKVpIqWY7HiG+shw=;
        b=q28aWs2VvsC2QZwIjjVAGAkEYvRGF7yuxjUf6qb82C2o/zXxsolGBpwGulvrwD8Cs3
         N0NravXpYAQ83lS65hEzgvv3Lbdb1tOCniAX9c4UMP48nPpB4hjLWWn9Hg1Vg0LQRBym
         856m/soeeQq3AMjzSNeG+OXhQs1pGDbtuuAxsKPpfi/4vHNwy+17xgP+oIEvVLerjyl+
         g4eNXhIsDddWZEajyv/o74U5JGTPKuREz1uItG99U+ZLuskPBwXS/QVzno0mYLXx66la
         kHBReBNDLbkKBFDoW0yg0onh3IFlOIStG+1dsOkSJEDk2AA7RxZ5lO/FXH8oUrWqv9U6
         cOsw==
X-Gm-Message-State: AOAM533+m8vZxdkgxw/va20d1f2g7o2FIq+q/CepI1Gf7fM+wE15ozqf
        Y/QOdBxI12Z8+wrxiQEOPkhz21uSNyLAajakqSfS8JnRDhYYt/A6x2qQXkCeyjeMvO/Q1ReF1I9
        v+dlLnx7/Z0D5TuTGtcPDWMN5FulU+AOLvDepFD190cxyd4SqrmfQY07COJ9toHDnmQ==
X-Received: by 2002:a37:dcc2:: with SMTP id v185mr29847468qki.167.1626796316499;
        Tue, 20 Jul 2021 08:51:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9NUWZkskDEWU7mGn9bqckF/hMB20JHvsawHIkAgaxaveiacbm2PLft2c6YquFp8IjnR6I+Q==
X-Received: by 2002:a37:dcc2:: with SMTP id v185mr29847443qki.167.1626796316237;
        Tue, 20 Jul 2021 08:51:56 -0700 (PDT)
Received: from localhost.localdomain (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id c15sm5467012qtc.37.2021.07.20.08.51.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 08:51:55 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc:     Hugh Dickins <hughd@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, peterx@redhat.com,
        Hillf Danton <hdanton@sina.com>, Igor Raits <igor@gooddata.com>
Subject: [PATCH stable 5.13.y/5.12.y 1/2] mm/thp: simplify copying of huge zero page pmd when fork
Date:   Tue, 20 Jul 2021 11:51:49 -0400
Message-Id: <20210720155150.497148-2-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210720155150.497148-1-peterx@redhat.com>
References: <796cbb7-5a1c-1ba0-dde5-479aba8224f2@google.com>
 <20210720155150.497148-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch series "mm/uffd: Misc fix for uffd-wp and one more test".

This series tries to fix some corner case bugs for uffd-wp on either thp
or fork().  Then it introduced a new test with pagemap/pageout.

Patch layout:

Patch 1:    cleanup for THP, it'll slightly simplify the follow up patches
Patch 2-4:  misc fixes for uffd-wp here and there; please refer to each patch
Patch 5:    add pagemap support for uffd-wp
Patch 6:    add pagemap/pageout test for uffd-wp

The last test introduced can also verify some of the fixes in previous
patches, as the test will fail without the fixes.  However it's not easy
to verify all the changes in patch 2-4, but hopefully they can still be
properly reviewed.

Note that if considering the ongoing uffd-wp shmem & hugetlbfs work, patch
5 will be incomplete as it's missing e.g.  hugetlbfs part or the special
swap pte detection.  However that's not needed in this series, and since
that series is still during review, this series does not depend on that
one (the last test only runs with anonymous memory, not file-backed).  So
this series can be merged even before that series.

This patch (of 6):

Huge zero page is handled in a special path in copy_huge_pmd(), however it
should share most codes with a normal thp page.  Trying to share more code
with it by removing the special path.  The only leftover so far is the
huge zero page refcounting (mm_get_huge_zero_page()), because that's
separately done with a global counter.

This prepares for a future patch to modify the huge pmd to be installed,
so that we don't need to duplicate it explicitly into huge zero page case
too.

Link: https://lkml.kernel.org/r/20210428225030.9708-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20210428225030.9708-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, peterx@redhat.com
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brian Geffon <bgeffon@google.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Wang Qing <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 5fc7a5f6fd04bc18f309d9f979b32ef7d1d0a997)
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 mm/huge_memory.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8857ef1543eb..4cea1e218b48 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1088,17 +1088,13 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	 * a page table.
 	 */
 	if (is_huge_zero_pmd(pmd)) {
-		struct page *zero_page;
 		/*
 		 * get_huge_zero_page() will never allocate a new page here,
 		 * since we already have a zero page to copy. It just takes a
 		 * reference.
 		 */
-		zero_page = mm_get_huge_zero_page(dst_mm);
-		set_huge_zero_page(pgtable, dst_mm, vma, addr, dst_pmd,
-				zero_page);
-		ret = 0;
-		goto out_unlock;
+		mm_get_huge_zero_page(dst_mm);
+		goto out_zero_page;
 	}
 
 	src_page = pmd_page(pmd);
@@ -1122,6 +1118,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	get_page(src_page);
 	page_dup_rmap(src_page, true);
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 
-- 
2.31.1

