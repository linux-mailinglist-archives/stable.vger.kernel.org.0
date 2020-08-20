Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42FF024C684
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgHTUEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:04:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36154 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgHTUEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:04:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KK1VTB016735;
        Thu, 20 Aug 2020 20:04:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ZlD967fzDvT7h+t6vGSreOe9yRMalJikWvftexey1Tc=;
 b=wKiMSynaPrh1rhus26KTT2tbrNEFI+VIIX8nqy1eX0cTW5JhWmz4moy7+HjTBuXX428W
 9BDWtAmmTB+pf1XHFbhklZygHiHaEmChp8Iu5+SwHYb1GXwFsGOpCWzXs7bPggGfb/Tl
 UeTLFe4JDH4MoQDr2YxZQfnO0yHW0lWG6YU4u6OftjIaK+yDLRv/+KNKh3hURn6R40rf
 rPaXKzV7m+69nNkPG/SvP4MM8vjCacEDX8Smeit+RpFuZExGZHDRnzxIIyKk5FO7xKOA
 KSTrJo3ozHpP/KZ8iDrxow+7yupkZBNIkBtB/5Uz/Pd3KLyovRC/hRtD52XHPLai/G4o 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32x7nmtq34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 20 Aug 2020 20:04:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KK4M7n104292;
        Thu, 20 Aug 2020 20:04:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 32xsfvf5a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Aug 2020 20:04:26 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07KK4PSp012847;
        Thu, 20 Aug 2020 20:04:25 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 13:04:25 -0700
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: fix calculation of" failed to
 apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org, peterx@redhat.com, aarcange@redhat.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
References: <1597839685158224@kroah.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <ca0c6c8e-0d90-9614-d7e4-c5a8c3372352@oracle.com>
Date:   Thu, 20 Aug 2020 13:04:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1597839685158224@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 phishscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200160
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/20 5:21 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

From d43b8a81c7f921aa52d55817390384053cd7be21 Mon Sep 17 00:00:00 2001
From: Peter Xu <peterx@redhat.com>
Date: Thu, 20 Aug 2020 10:38:02 -0700
Subject: [PATCH] mm/hugetlb: fix calculation of
 adjust_range_if_pmd_sharing_possible

commit 75802ca66354a39ab8e35822747cd08b3384a99a upstream

This is found by code observation only.

Firstly, the worst case scenario should assume the whole range was covered
by pmd sharing.  The old algorithm might not work as expected for ranges
like (1g-2m, 1g+2m), where the adjusted range should be (0, 1g+2m) but the
expected range should be (0, 2g).

Since at it, remove the loop since it should not be required.  With that,
the new code should be faster too when the invalidating range is huge.

Mike said:

: With range (1g-2m, 1g+2m) within a vma (0, 2g) the existing code will only
: adjust to (0, 1g+2m) which is incorrect.
:
: We should cc stable.  The original reason for adjusting the range was to
: prevent data corruption (getting wrong page).  Since the range is not
: always adjusted correctly, the potential for corruption still exists.
:
: However, I am fairly confident that adjust_range_if_pmd_sharing_possible
: is only gong to be called in two cases:
:
: 1) for a single page
: 2) for range == entire vma
:
: In those cases, the current code should produce the correct results.
:
: To be safe, let's just cc stable.

Fixes: 017b1660df89 ("mm: migration: fix migration of huge PMD shared pages")
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200730201636.74778-1-peterx@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3a1501e85483..baac9a09ec0a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4257,6 +4257,7 @@ static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
 	return false;
 }
 
+#define ALIGN_DOWN(x, a)	__ALIGN_KERNEL((x) - ((a) - 1), (a))
 /*
  * Determine if start,end range within vma could be mapped by shared pmd.
  * If yes, adjust start and end to cover range associated with possible
@@ -4265,25 +4266,21 @@ static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
 void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 				unsigned long *start, unsigned long *end)
 {
-	unsigned long check_addr = *start;
+	unsigned long a_start, a_end;
 
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return;
 
-	for (check_addr = *start; check_addr < *end; check_addr += PUD_SIZE) {
-		unsigned long a_start = check_addr & PUD_MASK;
-		unsigned long a_end = a_start + PUD_SIZE;
+	/* Extend the range to be PUD aligned for a worst case scenario */
+	a_start = ALIGN_DOWN(*start, PUD_SIZE);
+	a_end = ALIGN(*end, PUD_SIZE);
 
-		/*
-		 * If sharing is possible, adjust start/end if necessary.
-		 */
-		if (range_in_vma(vma, a_start, a_end)) {
-			if (a_start < *start)
-				*start = a_start;
-			if (a_end > *end)
-				*end = a_end;
-		}
-	}
+	/*
+	 * Intersect the range with the vma range, since pmd sharing won't be
+	 * across vma after all
+	 */
+	*start = max(vma->vm_start, a_start);
+	*end = min(vma->vm_end, a_end);
 }
 
 /*
-- 
2.25.4

