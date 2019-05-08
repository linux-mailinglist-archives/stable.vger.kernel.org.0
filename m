Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE4617669
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 13:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfEHLET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 07:04:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35142 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbfEHLES (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 07:04:18 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x48B2aGF103549
        for <stable@vger.kernel.org>; Wed, 8 May 2019 07:04:17 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sbtp6agcs-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 08 May 2019 07:04:17 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
        Wed, 8 May 2019 12:04:14 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 8 May 2019 12:04:09 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x48B48wv58327292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 May 2019 11:04:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CB9AAE056;
        Wed,  8 May 2019 11:04:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84F9DAE058;
        Wed,  8 May 2019 11:04:07 +0000 (GMT)
Received: from thinkpad (unknown [9.152.212.151])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 May 2019 11:04:07 +0000 (GMT)
Date:   Wed, 8 May 2019 13:04:06 +0200
From:   Gerald Schaefer <gerald.schaefer@de.ibm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize
 struct pages for the full memory section
In-Reply-To: <20190507171806.GG1747@sasha-vm>
References: <20190507053826.31622-1-sashal@kernel.org>
        <20190507053826.31622-62-sashal@kernel.org>
        <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
        <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
        <20190507170208.GF1747@sasha-vm>
        <CAHk-=wi5M-CC3CUhmQZOvQE2xJgfBgrgyAxp+tE=1n3DaNocSg@mail.gmail.com>
        <20190507171806.GG1747@sasha-vm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19050811-0016-0000-0000-000002798757
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050811-0017-0000-0000-000032D63610
Message-Id: <20190508130406.3c9237c1@thinkpad>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1031 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905080071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 7 May 2019 13:18:06 -0400
Sasha Levin <sashal@kernel.org> wrote:

> On Tue, May 07, 2019 at 10:15:19AM -0700, Linus Torvalds wrote:
> >On Tue, May 7, 2019 at 10:02 AM Sasha Levin <sashal@kernel.org> wrote:
> >>
> >> I got it wrong then. I'll fix it up and get efad4e475c31 in instead.
> >
> >Careful. That one had a bug too, and we have 891cb2a72d82 ("mm,
> >memory_hotplug: fix off-by-one in is_pageblock_removable").
> >
> >All of these were *horribly* and subtly buggy, and might be
> >intertwined with other issues. And only trigger on a few specific
> >machines where the memory map layout is just right to trigger some
> >special case or other, and you have just the right config.
> >
> >It might be best to verify with Michal Hocko. Michal?
> 
> Michal, is there a testcase I can plug into kselftests to make sure we
> got this right (and don't regress)? We care a lot about memory hotplug
> working right.

We hit the panics on s390 with special z/VM memory layout, but they both
can be triggered simply by using mem= kernel parameter (and
CONFIG_DEBUG_VM_PGFLAGS=y).

With "mem=3075M" (and w/o the commits efad4e475c31 + 24feb47c5fa5), it
can be triggered by reading from
/sys/devices/system/memory/memory<x>/valid_zones, or from
/sys/devices/system/memory/memory<x>/removable, with <x> being the last
memory block.

This is with 256MB section size and memory block size. On LPAR, with
256MB section size and 1GB memory block size, for some reason the
"removable" issue doesn't trigger, only the "valid_zones" issue.

Using lsmem will also trigger it, as it reads both the valid_zones and
the removable attribute for all memory blocks. So, a test with
not-section-aligned mem= parameter and using lsmem could be an option.

Regards,
Gerald

