Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07E530FB35
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 19:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238113AbhBDSVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 13:21:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28964 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238992AbhBDSU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 13:20:27 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 114ICsIj124397;
        Thu, 4 Feb 2021 13:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=kQfU3QWUFgdV5VCb63TNbGI67L1sxm2m7bMRS1tTKLk=;
 b=nYiz+F8jPJ6wJFObQblwfVKzrhKM9R9trZiUHsLM73iRHsxeGQ8Q/XLxZaJ2KrnaM3Ex
 HNYRWJSiyrksjASUz+M5FemgGAh8CZCUr5ZsjM4FU657rDuobZRXUDf1jsTWCMLrDasG
 Z5VRXX0PXQ3Vgqf6WYmUh1t6B/nUnd8zRW3Qy2Sm4bglZVdaVv4NCzqhw9BzKXN3IIDd
 XCm99KOb3puv1TrLaZ/a8Kpz+3XMf2QL09IGaWYftiqmr73wJCAsb6R+Tg2HapNAO23w
 fKd13F5Cz4iYaq0eRkzZxJPon0yk4sUwp1NXTZAtoD4BqUbSwmbxNNKHIwFhQS7TGKv5 hg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36gp0m8625-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 13:19:34 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 114I8u1i027937;
        Thu, 4 Feb 2021 18:19:31 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 36cy382qab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Feb 2021 18:19:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 114IJTEW48759170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 4 Feb 2021 18:19:29 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D26D5204E;
        Thu,  4 Feb 2021 18:19:29 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.145.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 4764B52051;
        Thu,  4 Feb 2021 18:19:28 +0000 (GMT)
Date:   Thu, 4 Feb 2021 20:19:25 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Linux 5.11-rc5
Message-ID: <20210204181925.GL299309@linux.ibm.com>
References: <CAHk-=wgmJ0q1URHrOb-2iCOdZ8gYybiH6LY2Gq7cosXu6kxAnA@mail.gmail.com>
 <161160687463.28991.354987542182281928@build.alporthouse.com>
 <CAHk-=wh23BXwBwBgPmt9h2EJztnzKKf=qr5r=B0Hr6BGgZ-QDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh23BXwBwBgPmt9h2EJztnzKKf=qr5r=B0Hr6BGgZ-QDA@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-04_09:2021-02-04,2021-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 clxscore=1011 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102040107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 12:49:39PM -0800, Linus Torvalds wrote:
> On Mon, Jan 25, 2021 at 12:35 PM Chris Wilson <chris@chris-wilson.co.uk> wrote:
> 
> Mike: should we perhaps revert the first patch too (commit
> bde9cfa3afe4: "x86/setup: don't remove E820_TYPE_RAM for pfn 0")?

Unfortunately, I was too optimistic and didn't take into account that this
commit changes the way /dev/mem sees the first page of memory.

There were reports of slackware users about issues with lilo after upgrade
from 5.10.11 to 5.10.12

https://www.linuxquestions.org/questions/slackware-14/slackware-current-lilo-vesa-warnings-after-recent-updates-4175689617/#post6214439 

The root cause is that lilo is no longer able to access the first memory
page via /dev/mem because its type was changed from E820_TYPE_RESERVED to
E820_TYPE_RAM, so this became a part of the "System RAM" resource and
devmem_is_allowed() considers it disallowed area.

So here's the revert of bde9cfa3afe4 as well.

From a7fdc4117010d393dd77b99da5b573a5c98453ce Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@linux.ibm.com>
Date: Thu, 4 Feb 2021 20:12:37 +0200
Subject: [PATCH] Revert "x86/setup: don't remove E820_TYPE_RAM for pfn 0"

This reverts commit bde9cfa3afe4324ec251e4af80ebf9b7afaf7afe.

Changing the first memory page type from E820_TYPE_RESERVED to
E820_TYPE_RAM makes it a part of "System RAM" resource rather than a
reserved resource and this in turn causes devmem_is_allowed() to treat is
as area that can be accessed but it is filled with zeroes instead of the
actual data as previously.

The change in /dev/mem output causes lilo to fail as was reported at
slakware users forum [1], and probably other legacy applications will
experience similar problems.

[1] https://www.linuxquestions.org/questions/slackware-14/slackware-current-lilo-vesa-warnings-after-recent-updates-4175689617/#post6214439

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/x86/kernel/setup.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 3412c4595efd..740f3bdb3f61 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -660,6 +660,17 @@ static void __init trim_platform_memory_ranges(void)
 
 static void __init trim_bios_range(void)
 {
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 *
+	 * This typically reserves additional memory (64KiB by default)
+	 * since some BIOSes are known to corrupt low memory.  See the
+	 * Kconfig help text for X86_RESERVE_LOW.
+	 */
+	e820__range_update(0, PAGE_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);
+
 	/*
 	 * special case: Some BIOSes report the PC BIOS
 	 * area (640Kb -> 1Mb) as RAM even though it is not.
@@ -717,15 +728,6 @@ early_param("reservelow", parse_reservelow);
 
 static void __init trim_low_memory_range(void)
 {
-	/*
-	 * A special case is the first 4Kb of memory;
-	 * This is a BIOS owned area, not kernel ram, but generally
-	 * not listed as such in the E820 table.
-	 *
-	 * This typically reserves additional memory (64KiB by default)
-	 * since some BIOSes are known to corrupt low memory.  See the
-	 * Kconfig help text for X86_RESERVE_LOW.
-	 */
 	memblock_reserve(0, ALIGN(reserve_low, PAGE_SIZE));
 }
 	
-- 
2.29.2





>                 Linus

-- 
Sincerely yours,
Mike.
