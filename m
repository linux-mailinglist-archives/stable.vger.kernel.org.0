Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAFA325543
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 19:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbhBYSLy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 13:11:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47360 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231604AbhBYSKt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 13:10:49 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11PI30Wn104618;
        Thu, 25 Feb 2021 13:09:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=C3lzRoPlPSGab7GqbUjKyBLhrcC8c0Q2sdpDOySpEsk=;
 b=V4q+8dFd7CV91+dSZMpAUlEmFU0hY18oMyWfnlUzPQavqfB/cBuiOb+OZuvG/bjZi4SB
 2i1OClhuP1tRUnQBBH7DCz7a//X0DXKW6x5hmpyTC+thdJxkypnysY3VaNChsWnUPDOc
 w0FsLq+Dk2fMN4F1l6ltsSdiOQpQkBnKn9uA/6Kd3F1ZBrqum9wQY17wyMEDQQoLmb/r
 lmFkk8FUa5dssLyUWjknWaes3dVGdROgdtLzSvekye4Hm9niIR1EZSOoURhPFN+5S53K
 bLq9rnUo5+5nRyJteQi93oJV7rYvdYvNKRb/yIRTQiM2reX/xzLp52xLjIKb3qK6o0cT KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xdpwykym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 13:09:46 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11PI3Ns8105600;
        Thu, 25 Feb 2021 13:09:45 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36xdpwykxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 13:09:45 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11PI2DT6024141;
        Thu, 25 Feb 2021 18:09:43 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 36tsph4nxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Feb 2021 18:09:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11PI9eu230146960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Feb 2021 18:09:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 629644204B;
        Thu, 25 Feb 2021 18:09:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2440642042;
        Thu, 25 Feb 2021 18:09:38 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.51.238])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 25 Feb 2021 18:09:38 +0000 (GMT)
Date:   Thu, 25 Feb 2021 20:09:35 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Baoquan He <bhe@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?utf-8?Q?=C5=81ukasz?= Majczak <lma@semihalf.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
        Qian Cai <cai@lca.pw>,
        "Sarvela, Tomi P" <tomi.p.sarvela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vlastimil Babka <vbabka@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v7 1/1] mm/page_alloc.c: refactor initialization of
 struct page for holes in memory layout
Message-ID: <20210225180935.GI1854360@linux.ibm.com>
References: <20210224153950.20789-1-rppt@kernel.org>
 <20210224153950.20789-2-rppt@kernel.org>
 <515b4abf-ff07-a43a-ac2e-132c33681886@redhat.com>
 <20210225170629.GE1854360@linux.ibm.com>
 <CAHk-=wj-0TeNTNhn+r8c9n76uy8ZiYw03AnXz3hyDZ_rQu35Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj-0TeNTNhn+r8c9n76uy8ZiYw03AnXz3hyDZ_rQu35Uw@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-25_10:2021-02-24,2021-02-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102250138
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 09:54:34AM -0800, Linus Torvalds wrote:
> On Thu, Feb 25, 2021 at 9:07 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
> >
> > >
> > > We might still double-initialize PFNs when two zones overlap within a
> > > section, correct?
> >
> > You mean that a section crosses zones boundary?
> > I don't think it's that important.
> 
> What if there was a memory allocation in between that could allocate
> the once-initialized page?

Can't happen because this code runs before any allocation is possible and
it is single threaded.
 
> Maybe it can't happen, or is not an issue for some other reason, but
> this code has been fragile and had a ton of subtle issues, so maybe
> worth documenting (or explaining here why it's just not relevant)

Ok, I'll do another pass on the comments in the code.

>           Linus

-- 
Sincerely yours,
Mike.
