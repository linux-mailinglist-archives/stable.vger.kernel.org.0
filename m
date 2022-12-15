Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8941664DC94
	for <lists+stable@lfdr.de>; Thu, 15 Dec 2022 14:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiLON5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Dec 2022 08:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiLON5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Dec 2022 08:57:32 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997463055C;
        Thu, 15 Dec 2022 05:57:20 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFDuCDZ031042;
        Thu, 15 Dec 2022 13:56:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=sZD5GHL0Wts8M3LookLZiILQir76BKnZ83UrOMH34TU=;
 b=mJm0xhEmaVU5kZztL4q1aoGW/GPKf5tgHeE+As72FF0Z0CD14Mz/MLx53rL75d7vNqWY
 7Ph8GIuKaRAfvl7/ZmqAUWJpmnlxx96rlziZl+5y1i/Ob6DFzfKA1+3aKlaaalUgnSQh
 zwiqsvuU6CCJ5/DUAar1lDshMsGf0/nzaVGqTac/VtRmdEtvRZKY5WuaCedDMgUIDFTs
 M3tLxznHgMH0Jkdo4Jf7LvYuyccnj2UvhVrkS0PO2ciyt8MzP0swuiMMt8xO8FNK4rbs
 QNnLyUsI0HndCFxbIb2mqo+yEvxh8NNkTqFB459cZcxv5kmyoelUaQfcokZcz8aEv4FA VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg4wdr0ca-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 13:56:55 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BFDuUWr031603;
        Thu, 15 Dec 2022 13:56:55 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg4wdr0c3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 13:56:55 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFD3crx005714;
        Thu, 15 Dec 2022 13:56:54 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3meyfdxcw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 13:56:54 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BFDuqYq29033156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 13:56:53 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 939425805F;
        Thu, 15 Dec 2022 13:56:52 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7BAB58051;
        Thu, 15 Dec 2022 13:56:46 +0000 (GMT)
Received: from skywalker.linux.ibm.com (unknown [9.43.98.149])
        by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 13:56:46 +0000 (GMT)
X-Mailer: emacs 29.0.60 (via feedmail 11-beta-1 I)
From:   "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ben Widawsky <ben.widawsky@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Huang Ying <ying.huang@intel.com>, linux-api@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RFC PATCH] mm/mempolicy: Fix memory leak in
 set_mempolicy_home_node system call
In-Reply-To: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
References: <20221214222110.200487-1-mathieu.desnoyers@efficios.com>
Date:   Thu, 15 Dec 2022 19:26:43 +0530
Message-ID: <87r0x06a90.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YsxdgRmNPa0CM3b1-lNIiSE2FqANa2A5
X-Proofpoint-ORIG-GUID: cKSKxkmT5nN3gQQQGGgDepktkHOW77VH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_07,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1011
 adultscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212150110
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

> When encountering any vma in the range with policy other than MPOL_BIND
> or MPOL_PREFERRED_MANY, an error is returned without issuing a mpol_put
> on the policy just allocated with mpol_dup().
>
> This allows arbitrary users to leak kernel memory.
>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

> Fixes: c6018b4b2549 ("mm/mempolicy: add set_mempolicy_home_node syscall")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Feng Tang <feng.tang@intel.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Cc: <linux-api@vger.kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: stable@vger.kernel.org # 5.17+
> ---
>  mm/mempolicy.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 61aa9aedb728..02c8a712282f 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1540,6 +1540,7 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
>  		 * the home node for vmas we already updated before.
>  		 */
>  		if (new->mode != MPOL_BIND && new->mode != MPOL_PREFERRED_MANY) {
> +			mpol_put(new);
>  			err = -EOPNOTSUPP;
>  			break;
>  		}
> -- 
> 2.25.1
