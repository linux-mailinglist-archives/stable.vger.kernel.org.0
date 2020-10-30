Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3AF2A09E4
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 16:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725844AbgJ3Pam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 11:30:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726890AbgJ3Pam (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 11:30:42 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UF1NoA007107;
        Fri, 30 Oct 2020 11:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=T33zqOJqojD8WVWVqOqNqvPk0z9OEeoWFKvCwxxVvFY=;
 b=LGn1rSmzaJA/10hwFW7SEqktvLj5ES2qHQGLcs9s27eRZ+pvZO9kSeq5qMnVqTt0Oh8k
 WKcKFjHeO8EQZNOgIF2TNWEbfwNusLAhMskFYCv41Bd/0KFZOx4Eb2vxAaoRo1xgJMLX
 7PRa7jinVo25ofusf51wXo+x2gj3ZEkHPZwZwLjzFyCXTilZvOuw/RepVYIDdgrgJZnS
 LULY/i8B2NRcnoXX4SEWVFKkqkzD6P52AywTwm+Q3cofC6vux3FLUoG8d8SvPnKOK44V
 PiI3b5pU+89rrhtWzqTZfakrzMdjSeopspdwQnAQVU84ZZMRBCDwfJ/vGvZHm765rE7l Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ge8uxjbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 11:18:29 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UF1PZI007313;
        Fri, 30 Oct 2020 11:18:29 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34ge8uxjam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 11:18:29 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UFDXuk005384;
        Fri, 30 Oct 2020 15:18:27 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 34fv15rp6w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 15:18:27 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UFIPgQ33423632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 15:18:25 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41E4011C054;
        Fri, 30 Oct 2020 15:18:25 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69B2D11C050;
        Fri, 30 Oct 2020 15:18:24 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.79.39])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 30 Oct 2020 15:18:24 +0000 (GMT)
Date:   Fri, 30 Oct 2020 17:18:22 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] ARM: highmem: avoid clobbering non-page aligned memory
 reservations
Message-ID: <20201030151822.GA16907@linux.ibm.com>
References: <20201029110334.4118-1-ardb@kernel.org>
 <CAMj1kXGiJtqp51h2FA35Q44VDrsx8Kd3Pi=e45Trn6MLN=iV9A@mail.gmail.com>
 <013f82d6-d20f-1242-2cdd-9ea9c2ab9f9c@gmail.com>
 <CAMj1kXEQveNVAbH=uZzqz4-KVFK+bbafGQ2-U7fCnD530PPq_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEQveNVAbH=uZzqz4-KVFK+bbafGQ2-U7fCnD530PPq_g@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_05:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=5 adultscore=0 spamscore=0
 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ard,

On Fri, Oct 30, 2020 at 10:29:16AM +0100, Ard Biesheuvel wrote:
> (+ Mike)
> 
> On Fri, 30 Oct 2020 at 03:25, Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> >
> >
> > On 10/29/2020 4:14 AM, Ard Biesheuvel wrote:
> > > On Thu, 29 Oct 2020 at 12:03, Ard Biesheuvel <ardb@kernel.org> wrote:
> > >>
> > >> free_highpages() iterates over the free memblock regions in high
> > >> memory, and marks each page as available for the memory management
> > >> system. However, as it rounds the end of each region downwards, we
> > >> may end up freeing a page that is memblock_reserve()d, resulting
> > >> in memory corruption. So align the end of the range to the next
> > >> page instead.
> > >>
> > >> Cc: <stable@vger.kernel.org>
> > >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > >> ---
> > >>  arch/arm/mm/init.c | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >>
> > >> diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
> > >> index a391804c7ce3..d41781cb5496 100644
> > >> --- a/arch/arm/mm/init.c
> > >> +++ b/arch/arm/mm/init.c
> > >> @@ -354,7 +354,7 @@ static void __init free_highpages(void)
> > >>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
> > >>                                 &range_start, &range_end, NULL) {
> > >>                 unsigned long start = PHYS_PFN(range_start);
> > >> -               unsigned long end = PHYS_PFN(range_end);
> > >> +               unsigned long end = PHYS_PFN(PAGE_ALIGN(range_end));
> > >>
> > >
> > > Apologies, this should be
> > >
> > > -               unsigned long start = PHYS_PFN(range_start);
> > > +               unsigned long start = PHYS_PFN(PAGE_ALIGN(range_start));
> > >                 unsigned long end = PHYS_PFN(range_end);
> > >
> > >
> > > Strangely enough, the wrong version above also fixed the issue I was
> > > seeing, but it is start that needs rounding up, not end.
> >
> > Is there a particular commit that you identified which could be used as
> >  Fixes: tag to ease the back porting of such a change?
> 
> Ah hold on. This appears to be a very recent regression, in
> cddb5ddf2b76debdb8cad1728ad0a9321383d933, added in v5.10-rc1.
> 
> The old code was
> 
> unsigned long start = memblock_region_memory_base_pfn(mem);
> 
> which uses PFN_UP() to round up, whereas the new code rounds down.
> 
> Looks like this is broken on a lot of platforms.
> 
> Mike?

I've reviewed again the whole series and it seems that only highmem
initialization on arm and xtensa (that copied this code from arm) have
this problem. I might have missed something again, though.

So, to restore the original behaviour I think the fix should be

	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE,
				&range_start, &range_end, NULL) {
		unsigned long start = PHYS_UP(range_start);
		unsigned long end = PHYS_DOWN(range_end);


-- 
Sincerely yours,
Mike.
