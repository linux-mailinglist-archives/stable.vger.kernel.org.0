Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7D024C690
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgHTUGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:06:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57452 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbgHTUGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:06:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KK2Im0078038;
        Thu, 20 Aug 2020 20:06:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=v/n4Tj6y62Es8Le2e22X2kiTOiS1wY7jQtGVwyLjfdo=;
 b=w8EGeBIGwSjpK5zluXKnnCB1F6p6XYkRV4mqGsimQFGnJPXzoJuALPXciEeNdapfG444
 8MwnULdF2aY9bG6LM2t/SrPTWrO9BOOmke/YoPnF35f8/OaCELeBOBBOriXUOePv8lMV
 pED4VbLu9bDC8eVvBy0OmEcKISGTlYPfWc0rUFNHxnBydcOjFGKMcb1hb38Vi7U4yOsb
 YIg+tjpQXM4Tr+ajQNA5kFvfWFehdB/qaFTfGas3Mo1p7KpAYcWh4O1SAdiNxdqGLRWf
 //mKIjOazZSsR6n9xLLcFswo/6ZZ5vh5WEsj7IDo+qbTSrgGNOgWZsuk6ZI/I6rG19F2 yQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32x74rjsw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 20 Aug 2020 20:06:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07KK33hn116314;
        Thu, 20 Aug 2020 20:06:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 32xsn1t9s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Aug 2020 20:06:10 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07KK69MC014641;
        Thu, 20 Aug 2020 20:06:09 GMT
Received: from [192.168.2.112] (/50.38.35.18)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 20 Aug 2020 13:06:08 -0700
Subject: Re: FAILED: patch "[PATCH] mm/hugetlb: fix calculation of" failed to
 apply to 4.9-stable tree
To:     gregkh@linuxfoundation.org, peterx@redhat.com, aarcange@redhat.com,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
References: <159783968356185@kroah.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <e1fc5fe9-1438-bc53-869d-9e7a4fd0d7bd@oracle.com>
Date:   Thu, 20 Aug 2020 13:06:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159783968356185@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9718 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008200160
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/19/20 5:21 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

From fe0d63dd32343cab510846ada110079ec3ebafbb Mon Sep 17 00:00:00 2001
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
 mm/hugetlb.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9914da93069e..2c22ea7a2013 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4380,25 +4380,21 @@ static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
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

