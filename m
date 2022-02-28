Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B435F4C65C1
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 10:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiB1JfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 04:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbiB1JfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 04:35:16 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E6F40A08
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:34:31 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21S71d2v021800;
        Mon, 28 Feb 2022 09:34:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=KcyXjQ+QkXV98LyWyZJYmjRBxIYSZhbHWX1ASLRXZp4=;
 b=GOkRE/ZNyof8aCpItT10sh4uWusEXO6Zt6z9HQMuBFcHJX7HyAtl4MK+trsrna2Swo5U
 iDnye1FPKHAXnC1OkfxpQXHKzrxuv0Xnv1P7OQmDad8zTzZa3vKqtYp5myla8qIWH4l5
 IABI1IIPTKukh2djCDUxy+UMFJzbeIkZWAwgU+nR6MGqRMReRp7SScn06XK3n8dTRZqX
 eIZEOEMM075cYzC1oPVSMfzWy52IWPu37MmddOaxwG6kX8CBXINgiZbK/bO0fcdZ6m8D
 o9J8h1z/fqYlKn0crae//y5/1JOt1PY+Ma7OS467JlQ9yf8O72FA8XFRj3rrE1DSkvKI Sw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3egq5yexkn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 09:34:23 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21S9XL93027101;
        Mon, 28 Feb 2022 09:34:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3efbu8xh2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 09:34:21 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21S9YJNE55706104
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 09:34:19 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 178BEA405D;
        Mon, 28 Feb 2022 09:34:19 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75327A404D;
        Mon, 28 Feb 2022 09:34:18 +0000 (GMT)
Received: from linux.ibm.com (unknown [9.145.147.106])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Feb 2022 09:34:18 +0000 (GMT)
Date:   Mon, 28 Feb 2022 11:34:16 +0200
From:   Mike Rapoport <rppt@linux.ibm.com>
To:     gregkh@linuxfoundation.org
Cc:     linmiaohe@huawei.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] memblock: use kfree() to release
 kmalloced memblock regions" failed to apply to 5.15-stable tree
Message-ID: <YhyXGAK9Se/ohdh9@linux.ibm.com>
References: <1646038723220154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1646038723220154@kroah.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RHF_-FnLSVS7_kIq69gXgmjYs-CSRAr4
X-Proofpoint-GUID: RHF_-FnLSVS7_kIq69gXgmjYs-CSRAr4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_03,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 suspectscore=0 clxscore=1011 adultscore=0 mlxscore=0
 spamscore=0 malwarescore=0 mlxlogscore=988 lowpriorityscore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202280053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 09:58:43AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.15-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

This version applies to 5.15 and should apply to older version as well.

From d4895990ebea634715d2dcf54121c5ae5a6612bc Mon Sep 17 00:00:00 2001
From: Miaohe Lin <linmiaohe@huawei.com>
Date: Thu, 17 Feb 2022 22:53:27 +0800
Subject: [PATCH] memblock: use kfree() to release kmalloced memblock regions

memblock.{reserved,memory}.regions may be allocated using kmalloc() in
memblock_double_array(). Use kfree() to release these kmalloced regions
indicated by memblock_{reserved,memory}_in_slab.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Fixes: 3010f876500f ("mm: discard memblock data later")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 mm/memblock.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 5096500b2647..2b7397781c99 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -366,14 +366,20 @@ void __init memblock_discard(void)
 		addr = __pa(memblock.reserved.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.reserved.max);
-		__memblock_free_late(addr, size);
+		if (memblock_reserved_in_slab)
+			kfree(memblock.reserved.regions);
+		else
+			__memblock_free_late(addr, size);
 	}
 
 	if (memblock.memory.regions != memblock_memory_init_regions) {
 		addr = __pa(memblock.memory.regions);
 		size = PAGE_ALIGN(sizeof(struct memblock_region) *
 				  memblock.memory.max);
-		__memblock_free_late(addr, size);
+		if (memblock_memory_in_slab)
+			kfree(memblock.memory.regions);
+		else
+			__memblock_free_late(addr, size);
 	}
 
 	memblock_memory = NULL;
-- 
2.28.0

> thanks,
> 
> greg k-h

--
Sincerely yours,
Mike.
