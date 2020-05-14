Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870BA1D3684
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgENQbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 12:31:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgENQbw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 12:31:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGQVUT016590;
        Thu, 14 May 2020 16:31:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=nANqSi2Q0m1t+eP0SLk3THs9oGj0soI3yk//uRnNE70=;
 b=hEOVkHcXj32/V6b6MB3lwAAN44IrxvE/LvvxO4Km4rdhziN/zMnOSzVKHN4azYpPlRxd
 11XjvhvDux15hKkUjITrcxwQxbKbZBTGl7T4V4Q90t8gyqC5886Y8TIZ818TkRrIF4cp
 8/qaJAji92yrp2XErfR1ivaRTs0ttW/WrrT6m+zlA3A7ARw7ueyHpCAd2eulRcYE3rsF
 bt1YwDnDSUbujXqUW1V2Ye+TnZ6QfIe9V+3quHv7MbwGo4LCp3NCu7rc2DN6n+WNJEQd
 Er/aELXNOF5rOcjGRHwD9VtQGNzVm3rQIjOcnv0qhA3bHLGUt1aG4LMMu89y4RQFFOP7 VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 3100yg3njp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 May 2020 16:31:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04EGMhYx027307;
        Thu, 14 May 2020 16:31:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3100ypn02r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 May 2020 16:31:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04EGV46q008613;
        Thu, 14 May 2020 16:31:04 GMT
Received: from [192.168.2.157] (/73.164.160.178)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 14 May 2020 09:31:04 -0700
Subject: Re: stable-rc 5.4: libhugetlbfs fallocate_stress.sh: Unable to handle
 kernel paging request at virtual address ffff00006772f000
To:     Michal Hocko <mhocko@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Kirill A.Shutemov" <kirill.shutemov@linux.intel.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Prakash Sangappa <prakash.sangappa@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkft-triage@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>
References: <CA+G9fYvvDjA5t+zi0Zyn2F6D=7aE-Gu-m13o47LXYYfCD3SvrA@mail.gmail.com>
 <20200514064039.GY29153@dhcp22.suse.cz>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <f3a2db67-f7b7-1bb7-340f-24806a999192@oracle.com>
Date:   Thu, 14 May 2020 09:31:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514064039.GY29153@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9621 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 cotscore=-2147483648 mlxscore=0 suspectscore=0 spamscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 clxscore=1011 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005140145
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/20 11:40 PM, Michal Hocko wrote:
> On Wed 13-05-20 23:11:40, Naresh Kamboju wrote:
>> While running libhugetlbfs fallocate_stress.sh on stable-rc 5.4 branch kernel
>> on arm64 hikey device. The following kernel Internal error: Oops:
>> crash dump noticed.
> 
> Is the same problem reproducible on vanilla 5.4 without any stable
> patches?
> 

Or, an earlier version of 5.4-stable?  Nothing in the changelog for 5.4.41
looks related to this issue.  There was an arm specific hugetlb change
"arm64: hugetlb: avoid potential NULL dereference", but that is pretty
straight forward.

I'm guessing this may not reproduce easily.  To help reproduce, you could
change the
#define FALLOCATE_ITERATIONS 100000
in .../libhugetlbfs/tests/fallocate_stress.c to a larger number to force
the stress test to run longer.
-- 
Mike Kravetz
