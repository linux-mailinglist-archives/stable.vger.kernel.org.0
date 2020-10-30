Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423642A103E
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 22:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgJ3VcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 17:32:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727727AbgJ3VcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 17:32:17 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09ULVxMO045243;
        Fri, 30 Oct 2020 17:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=t/Ayp5kcFJCu9kbie7CBaetV7Ow8xMQcbD2R/cFgOqw=;
 b=i+7HZuTs11h5kjzZNnkK38BZC0QkJ0//UBKPKkAIESQRQRNUttXYmZAZbEhoZoLMtYtP
 vP5VrGR4P39RJNZoptvIhpYlfLwBTVfMe2SI9saQo1oVNlHGtJDEeqFGwCwh91TdUt0n
 8W4L5eP87JHStecYr3IrDoTVVtX9AI4Qa2GRUPGAluPPYKTp9cGZDr1PFEPO1AsJoyM8
 n1OZhtg1P52SiD8Ebj/ucFRQLLPYOfrIGsGKDuT1OrD1hEGtwN1sC4S4G4sNYMK7XGJO
 BpKKqW1Wy9X3pADcSQtS2bWU9OOJorFBJIBfHCc+K+gOHgExs999COJdAfhjQXLayCKJ 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gtr304pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:32:08 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09ULW7KD045624;
        Fri, 30 Oct 2020 17:32:07 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34gtr304np-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:32:07 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09ULW5NR028701;
        Fri, 30 Oct 2020 21:32:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 34f7s3sbc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 21:32:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09ULW2t528705130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 21:32:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A6A14C046;
        Fri, 30 Oct 2020 21:32:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFEB04C040;
        Fri, 30 Oct 2020 21:32:01 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.56.109])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 30 Oct 2020 21:32:01 +0000 (GMT)
Date:   Fri, 30 Oct 2020 23:31:59 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: highmem: avoid clobbering non-page aligned memory
 reservations
Message-ID: <20201030213159.GA14584@linux.ibm.com>
References: <20201029110334.4118-1-ardb@kernel.org>
 <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
 <013f82d6-d20f-1242-2cdd-9ea9c2ab9f9c@gmail.com>
 <CAMj1kXEQveNVAbH=uZzqz4-KVFK+bbafGQ2-U7fCnD530PPq_g@mail.gmail.com>
 <20201030151822.GA16907@linux.ibm.com>
 <CAMj1kXEOnSPvkjY7Wd3gpOj+JfpU6bNNtoZ68cEhTK8rin3dTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEOnSPvkjY7Wd3gpOj+JfpU6bNNtoZ68cEhTK8rin3dTw@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_10:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 suspectscore=5 impostorscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300157
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 04:22:37PM +0100, Ard Biesheuvel wrote:
> On Fri, 30 Oct 2020 at 16:18, Mike Rapoport <rppt@linux.ibm.com> wrote:
> >
> > Hi Ard,
> >
> > > > On 10/29/2020 4:14 AM, Ard Biesheuvel wrote:
> > > > > On Thu, 29 Oct 2020 at 12:03, Ard Biesheuvel <ardb@kernel.org> wrote:
> > > > >>
> > > > >> free_highpages() iterates over the free memblock regions in high
> > > > >> memory, and marks each page as available for the memory management
> > > > >> system. However, as it rounds the end of each region downwards, we
> > > > >> may end up freeing a page that is memblock_reserve()d, resulting
> > > > >> in memory corruption. So align the end of the range to the next
> > > > >> page instead.
> > > > >>
> > > > >> Cc: <stable@vger.kernel.org>
> > > > >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > > >> ---
> > > > >>  arch/arm/mm/init.c | 2 +-
> > > > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >>
> > > > >> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > > > >> index a391804c7ce3..d41781cb5496 100644
> > > > >> --- a/arch/arm/mm/init.c
> > > > >> +++ b/arch/arm/mm/init.c
> > > > >> @@ -354,7 +354,7 @@ static void __init free_highpages(void)
> > > > >>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
> > > > >>                                 &range_start, &range_end, NULL) {
> > > > >>                 unsigned long start = PHYS_PFN(range_start);
> > > > >> -               unsigned long end = PHYS_PFN(range_end);
> > > > >> +               unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
> > > > >>
> > > > >
> > > > > Apologies, this should be
> > > > >
> > > > > -               unsigned long start = PHYS_PFN(range_start);
> > > > > +               unsigned long start = PHYS_PFN(PAGE_ALIGN(range_start));
> > > > >                 unsigned long end = PHYS_PFN(range_end);
> > > > >
> > > > >
> > > > > Strangely enough, the wrong version above also fixed the issue I was
> > > > > seeing, but it is start that needs rounding up, not end.
> > > >
> > > > Is there a particular commit that you identified which could be used as
> > > >  Fixes: tag to ease the back porting of such a change?
> > >
> > > Ah hold on. This appears to be a very recent regression, in
> > > cddb5ddf2b76debdb8cad1728ad0a9321383d933, added in v5.10-rc1.
> > >
> > > The old code was
> > >
> > > unsigned long start = memblock_region_memory_base_pfn(mem);
> > >
> > > which uses PFN_UP() to round up, whereas the new code rounds down.
> > >
> > > Looks like this is broken on a lot of platforms.
> > >
> > > Mike?
> >
> > I've reviewed again the whole series and it seems that only highmem
> > initialization on arm and xtensa (that copied this code from arm) have
> > this problem. I might have missed something again, though.
> >
> > So, to restore the original behaviour I think the fix should be
> >
> >         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
> >                                 &range_start, &range_end, NULL) {
> >                 unsigned long start = PHYS_UP(range_start);
> >                 unsigned long end = PHYS_DOWN(range_end);
> >
> >
> 
> PHYS_UP and PHYS_DOWN don't exist.
> 
> Could you please send a patch that fixes this everywhere where it's broken?

Argh, this should have been PFN_{UP,DOWN}.
With the patch below qemu-system-arm boots for me. Does it fix your
setup as well?

I kept your authorship as you did the heavy lifting here :)

With acks from ARM and xtensa maintainers I can take it via memblock
tree.

From 5399699b9f8de405819c59c3feddecaac0ed1399 Mon Sep 17 00:00:00 2001
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 30 Oct 2020 22:53:02 +0200
Subject: [PATCH] ARM, xtensa: highmem: avoid clobbering non-page aligned
 memory reservations

free_highpages() iterates over the free memblock regions in high
memory, and marks each page as available for the memory management
system.

Until commit cddb5ddf2b76 ("arm, xtensa: simplify initialization of
high memory pages") it rounded beginning of each region upwards and end of
each region downwards.

However, after that commit free_highmem() rounds the beginning and end of
each region downwards, we and may end up freeing a page that is
memblock_reserve()d, resulting in memory corruption.

Restore the original rounding of the region boundaries to avoid freeing
reserved pages.

Fixes: cddb5ddf2b76 ("arm, xtensa: simplify initialization of high memory pages")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Co-developed-by:  Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/arm/mm/init.c    | 4 ++--
 arch/xtensa/mm/init.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index d57112a276f5..c23dbf8bebee 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -354,8 +354,8 @@ static void __init free_highpages(void)
 	/* set highmem page free */
 	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
 				&range_start, &range_end, NULL) {
-		unsigned long start = PHYS_PFN(range_start);
-		unsigned long end = PHYS_PFN(range_end);
+		unsigned long start = PFN_UP(range_start);
+		unsigned long end = PFN_DOWN(range_end);
 
 		/* Ignore complete lowmem entries */
 		if (end <= max_low)
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index c6fc83efee0c..8731b7ad9308 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -89,8 +89,8 @@ static void __init free_highpages(void)
 	/* set highmem page free */
 	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
 				&range_start, &range_end, NULL) {
-		unsigned long start = PHYS_PFN(range_start);
-		unsigned long end = PHYS_PFN(range_end);
+		unsigned long start = PFN_UP(range_start);
+		unsigned long end = PFN_DOWN(range_end);
 
 		/* Ignore complete lowmem entries */
 		if (end <= max_low)
-- 
2.28.0


-- 
Sincerely yours,
Mike.
