Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DAD2D0D54
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 10:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgLGJqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 04:46:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61102 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbgLGJqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Dec 2020 04:46:51 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B79WOcW168278;
        Mon, 7 Dec 2020 04:46:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=qmx8hvrRJxFyiLrlp8b06k21aRfjkyZgFB+jcnLR3No=;
 b=KykL/1rfa9s+cJ66P+GRekk11dDiysYTzZAd2aXh9jazomZzwiQiD9SBVjxBnBirGUtl
 6cWSWxrT8nxMJgF//h9/HuXSn0Fk2nb2TOtpqF4yUiDfMWyAvimpYuEWnsAVD6TXKLwQ
 pYYwx4hb+NpJ1Ye6dIlcJ/44eV+u4onPAGZGfYe5vpTg5Fw8w2ZTI2P9CDkhxjCGYkqo
 /wqn6vgBRpn28lOZv8Z03FMWiXHB+PAheNl71Xy1Im/D5XyBTcXFVZ5khcHFnJVbtFUg
 VbijwnoMs38QfCjY3gRCRS6o+NaT/mNUL+kdTs8LSZq++dwwJ+Nq4plDtTgI6zic/8ow Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359h3g9sjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 04:46:03 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B79WUjF168967;
        Mon, 7 Dec 2020 04:46:03 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 359h3g9shk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 04:46:03 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B79SESG003655;
        Mon, 7 Dec 2020 09:46:01 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3581u82b62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Dec 2020 09:46:01 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B79jxIP9765500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Dec 2020 09:45:59 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 10A8DAE055;
        Mon,  7 Dec 2020 09:45:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C69FEAE05A;
        Mon,  7 Dec 2020 09:45:57 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.50.18])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  7 Dec 2020 09:45:57 +0000 (GMT)
Date:   Mon, 7 Dec 2020 11:45:55 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     akpm@linux-foundation.org, aarcange@redhat.com, bhe@redhat.com,
        cai@lca.pw, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org, vbabka@suse.cz
Subject: Re: +
 mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
 added to -mm tree
Message-ID: <20201207094555.GD1112728@linux.ibm.com>
References: <20201206005401.qKuAVgOXr%akpm@linux-foundation.org>
 <cb3bfacb-821d-6251-03c5-498dd07727cd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb3bfacb-821d-6251-03c5-498dd07727cd@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-07_08:2020-12-04,2020-12-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 mlxscore=0 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=6
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012070058
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 09:58:37AM +0100, David Hildenbrand wrote:
> On 06.12.20 01:54, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> > has been added to the -mm tree.  Its filename is
> >      mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> > 
> > This patch should soon appear at
> >     https://ozlabs.org/~akpm/mmots/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> > and later at
> >     https://ozlabs.org/~akpm/mmotm/broken-out/mm-initialize-struct-pages-in-reserved-regions-outside-of-the-zone-ranges.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> > 
> > The -mm tree is included into linux-next and is updated
> > there every 3-4 working days
> > 
> > ------------------------------------------------------
> > From: Andrea Arcangeli <aarcange@redhat.com>
> > Subject: mm: initialize struct pages in reserved regions outside of the zone ranges
> > 
> > Without this change, the pfn 0 isn't in any zone spanned range, and it's
> > also not in any memory.memblock range, so the struct page of pfn 0 wasn't
> > initialized and the PagePoison remained set when reserve_bootmem_region
> > called __SetPageReserved, inducing a silent boot failure with DEBUG_VM
> > (and correctly so, because the crash signaled the nodeid/nid of pfn 0
> > would be again wrong).
> > 
> > There's no enforcement that all memblock.reserved ranges must overlap
> > memblock.memory ranges, so the memblock.reserved ranges also require an
> > explicit initialization and the zones ranges need to be extended to
> > include all memblock.reserved ranges with struct pages too or they'll be
> > left uninitialized with PagePoison as it happened to pfn 0.
> > 
> > Link: https://lkml.kernel.org/r/20201205013238.21663-2-aarcange@redhat.com
> > Fixes: 73a6e474cb37 ("mm: memmap_init: iterate over memblock regions rather that check each PFN")
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: Mike Rapoport <rppt@linux.ibm.com>
> > Cc: Baoquan He <bhe@redhat.com>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Qian Cai <cai@lca.pw>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> [...]
> 
> I've lost track which patches are we considering right now to solve the
> overall issue. I'd appreciate a proper patch series with all relevant
> patches.

I think none of the patches is 100% right.
I'll try to send a new version today.

> -- 
> Thanks,
> 
> David / dhildenb
> 

-- 
Sincerely yours,
Mike.
