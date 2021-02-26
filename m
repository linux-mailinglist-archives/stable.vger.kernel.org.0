Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C983261A9
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 12:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhBZLAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 06:00:15 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230134AbhBZLAO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 06:00:14 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11QAYtWN131166;
        Fri, 26 Feb 2021 05:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=00s2MsyW/a2AE1oZWb1iglLJz/LlWkEfj9iznPhKodI=;
 b=bseSV9G2g5lxLnBShjcXJu/ZNxJuc2/iqsRHGhZeLxB/bwhXzvUmrJXxdQkJnRiIUo1i
 TX2cwgiPQfK4AyUJmWIG5zmIgData+5xUuAAIXcrrh/77Rse5nEmkczvLVPh8FIqQ54h
 udRtO13yMzwUeOnWLw2/qMR596vqi97GoCjd7yVRdGOwYUNPT6cpFVI/KyYF8u1Q02W+
 upR8eLGLcnk7ccYzL3UtteSgJYDo6a6q2iDKNIXl2UxCrWIKx8zTUvflWU2uP6UrYw+n
 TnQgllGRjHTJn5eaRlDwFIrsT98Wf9R01cmEAJW4BGU2gMWQYa7IqzJWzeU+jAOH9uhq ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xjs1bu2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 05:59:10 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11QAgGew169368;
        Fri, 26 Feb 2021 05:59:09 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xjs1bu1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 05:59:09 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11QAw117007075;
        Fri, 26 Feb 2021 10:59:07 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 36tt28trc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Feb 2021 10:59:06 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11QAx45V41419216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 10:59:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6CBA5A4065;
        Fri, 26 Feb 2021 10:59:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 415A5A4040;
        Fri, 26 Feb 2021 10:59:02 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.51.238])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 26 Feb 2021 10:59:02 +0000 (GMT)
Date:   Fri, 26 Feb 2021 12:59:00 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Hildenbrand <david@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <20210226105900.GK1854360@linux.ibm.com>
References: <20210224153950.20789-1-rppt@kernel.org>
 <20210224153950.20789-2-rppt@kernel.org>
 <a4b2ba7e-96a5-6a75-dad7-626d054f9e8b@suse.cz>
 <20210225180521.GH1854360@linux.ibm.com>
 <a458a933-91c7-9fb5-d7f8-b9a7af93a11c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a458a933-91c7-9fb5-d7f8-b9a7af93a11c@suse.cz>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-26_02:2021-02-24,2021-02-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260082
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 07:38:44PM +0100, Vlastimil Babka wrote:
> On 2/25/21 7:05 PM, Mike Rapoport wrote:
> >> 
> >> What if two zones are adjacent? I.e. if the hole was at a boundary between two
> >> zones.
> > 
> > What do you mean by "adjacent zones"? If there is a hole near the zone
> > boundary, zone span would be clamped to exclude the hole.
> 
> Yeah, zone span should exclude those pages, but you still somehow handle them?
> That's how I read "pages that are not spanned by any node will get links to the
> adjacent zone/node."
> So is it always a unique zone/node can be determined?
> 
> Let's say we have:
> 
> <memory on node 0>
> ---- pageblock boundary ----
> <more memory on node 0>
> <a hole>
> <memory on node 1>
> ---- pageblock boundary ----
> 
> Now I hope such configurations don't really exist :) But if we simulated them in
> QEMU, what would be the linkage in struct pages in that hole?

I don't think such configuration is possible in practice but it can be
forced with e.g memmap="2M hole at 4G - 1M".

The hole in your example the hole will get node1 for node and zone that
spans the beginning of node1 for zone.
 
-- 
Sincerely yours,
Mike.
