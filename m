Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67DA198A8B
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 05:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbgCaDf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 23:35:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54258 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727464AbgCaDf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 23:35:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02V3WZuJ012226;
        Tue, 31 Mar 2020 03:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=p9RK0f0OgxUJrUJi1uoWEVppifSVQKsD9fi4Tk10j1c=;
 b=a3IRhC0moANYxyzM5zP9vOiV4CB+ZUncOceypQ2NJw7upu0uz6KHiAg6q69I9NShUXzd
 Z/XpWmmG34aX1IVly5C0WH9/HO4K1vCz7zaNBkMM22piRhwlk8tHh33V7rZJZg30trZd
 zZkAwoc4zdFHb9XrSdgf/j6afX5aow7NIcxjdd9Y7+PoaP6nHB64R6tpxq2MzyiKxQB7
 x4Ez8f3n3/YhNbGEm1rikG8tFY93zo2e7dmTVQettDVjRqNY4aIIOPan/heRmIAoH5z8
 8Z+8MShbVJN5Uv+AqLMWbF+T+EnNm8rEWhm98KSFsU5EqCVRIYHQFHJa/JdM5FDOc2gv sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 303aqhdkpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 03:35:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02V3XY7j066452;
        Tue, 31 Mar 2020 03:35:34 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 302g2d4g1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Mar 2020 03:35:34 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02V3ZVsi026736;
        Tue, 31 Mar 2020 03:35:31 GMT
Received: from [192.168.1.206] (/71.63.128.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Mar 2020 20:35:30 -0700
Subject: Re: +
 mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch added
 to -mm tree
To:     akpm@linux-foundation.org, jgg@ziepe.ca, longpeng2@huawei.com,
        mm-commits@vger.kernel.org, sean.j.christopherson@intel.com,
        stable@vger.kernel.org, willy@infradead.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
References: <20200328221008.c6KdUoTLQ%akpm@linux-foundation.org>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <eea7c1f8-a2e4-5af1-acc4-3eb21a076d37@oracle.com>
Date:   Mon, 30 Mar 2020 20:35:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200328221008.c6KdUoTLQ%akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9576 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310030
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9576 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003310030
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/28/20 3:10 PM, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset
> has been added to the -mm tree.  Its filename is
>      mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> 
> This patch should soon appear at
>     http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> and later at
>     http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-a-addressing-exception-caused-by-huge_pte_offset.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Longpeng <longpeng2@huawei.com>
> Subject: mm/hugetlb: fix a addressing exception caused by huge_pte_offset

This patch is what caused the BUG reported on i386 non-PAE kernel here:

https://lore.kernel.org/linux-mm/CA+G9fYsJgZhhWLMzUxu_ZQ+THdCcJmFbHQ2ETA_YPP8M6yxOYA@mail.gmail.com/

As a clue, when building in this environment I get:

  CC      mm/hugetlb.o
mm/hugetlb.c: In function ‘huge_pte_offset’:
cc1: warning: function may return address of local variable [-Wreturn-local-addr]
mm/hugetlb.c:5361:14: note: declared here
  pud_t *pud, pud_entry;
              ^~~~~~~~~
cc1: warning: function may return address of local variable [-Wreturn-local-addr]
mm/hugetlb.c:5361:14: note: declared here
cc1: warning: function may return address of local variable [-Wreturn-local-addr]
mm/hugetlb.c:5360:14: note: declared here
  p4d_t *p4d, p4d_entry;
              ^~~~~~~~~

I'm shutting down for the night and will look into it more tomorrow if
someone else does not beat me to it.
-- 
Mike Kravetz
