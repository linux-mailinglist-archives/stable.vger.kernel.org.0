Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B30A2EE9A0
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 00:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbhAGXNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 18:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbhAGXNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 18:13:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACF80235FF;
        Thu,  7 Jan 2021 23:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610061163;
        bh=fxdOrGr7022fZaL8Cgn6KM85rCDVSEPeNYGywHviD1I=;
        h=Date:From:To:Subject:From;
        b=mOtR+gE+5SFDMvrmL2pWIK/JzzAYIH071e7KQ+R7RNYqnBLx/QO5ZZGp8HJ1oJglx
         hEMirW23Y4d9QBAxB9RHQ/SyVpUVwukDnQLArJoltSJTAxpLJBfVx8weQODVy4SEx4
         UvMDC91j6BQur+t4M3R7xLq9114eTt83tcyU275Q=
Date:   Thu, 07 Jan 2021 15:12:43 -0800
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org
Subject:  +
 mm-hugetlb-fix-potential-missing-huge-page-size-info.patch added to -mm
 tree
Message-ID: <20210107231243.zNctvhgUa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix potential missing huge page size info
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-potential-missing-huge-page-size-info.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-potential-missing-huge-page-size-info.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-potential-missing-huge-page-size-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential missing huge page size info

The huge page size is encoded for VM_FAULT_HWPOISON errors only.  So if we
return VM_FAULT_HWPOISON, huge page size would just be ignored.

Link: https://lkml.kernel.org/r/20210107123449.38481-1-linmiaohe@huawei.com
Fixes: aa50d3a7aa81 ("Encode huge page size for VM_FAULT_HWPOISON errors")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-missing-huge-page-size-info
+++ a/mm/hugetlb.c
@@ -4371,7 +4371,7 @@ retry:
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
 		if (unlikely(PageHWPoison(page))) {
-			ret = VM_FAULT_HWPOISON |
+			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
 		}
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmallocc-fix-potential-memory-leak.patch
mm-hugetlb-fix-potential-missing-huge-page-size-info.patch

