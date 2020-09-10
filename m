Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46B726552C
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 00:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgIJWnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 18:43:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57048 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725274AbgIJWnk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Sep 2020 18:43:40 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08AMYwtH003597;
        Thu, 10 Sep 2020 15:43:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kY+V1fdqMWgRM7EPYgqDlSoI4UU9i91EG+BbCAB5Zyw=;
 b=iWU6CZa9ho/woA/YpJGVoj/X8J0NEswSeiNX9UOl4TVQYkQ2WKT8YDsx8ITx/hkpcYc4
 J7pq3SgnOV2NczQ5w4Jlbdvia3UXmzgIjOqQYFE0a+1HcMss37JXFm/Kp4u8bAcDONgS
 +HzRIpYm8Z0Nu+MDK63taBit7XIBa/Ofavc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33ftqt0sjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Sep 2020 15:43:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Sep 2020 15:43:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SncqFjtYO9MhLSklkREi7PGZ9w59scVRfmDhDmc80G2OXjbBm+2f9PQ7GErqDGGApqD/NQ9t9oFSm4c2lMXbI6rCdd0kGNyxp8PMToixt3XQiKzxJB9Bi30uurFL5Neea4F5dv4fNHRIaa4uNu09RwdWWIpGUzOvscAH5NRPFy/QZi6VqQzv+dbIyvmBfN/xjYHhUdfj9ZXNLeYNz/X9WbKD4TQSHAHVixdfdy2EBTUHxwxXR51w5KWBGAeCBV6nDuncGCagn0BKHQuSVQ+4kjGbW3YsCQEMxH0YOFWBf5rueDTVb/iS5n1cxfzLTXJtLspXVQXzKNuMac+gq/+M6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY+V1fdqMWgRM7EPYgqDlSoI4UU9i91EG+BbCAB5Zyw=;
 b=las8SEBI5zACzLVd/Uq4/buekedKGAmhG5zEkgflAV7A2dBSF4e+GlLlKlGXUXikkJcomdw9DKT5Bz1Imc174zufM5V3OfnMtr15vzMgC5jBBqArshBivJM7C0Aqm9FF11Lp2kRlncYVEmgf5dqBY14Iiu1u66Q6bE8ERgESkg/e7stqX77GvdIMDDrOZn/XtS88xgAlHiQ6K4y+J+FCLTvByEJaFBgxzrKIfxMn4inMEMq5D5fo8URQS7hn0Y6OLeWe3V9qMcTJ8cQLqUHwbMGcYUCPRAOl8hmI15VZRdgmSSdw/KbYMkSADHM5vX7g3eesI24CBtoO5ZIvMr2OAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kY+V1fdqMWgRM7EPYgqDlSoI4UU9i91EG+BbCAB5Zyw=;
 b=dx+vEJO/QIPHWHyv/tOlxiwYYH89xXky35SEev5PGtgql6rHiNvoZVlksHfZqE1iIytx5nfbOctnRtJGXxts1WfE5popuHoFv8CTyE/CnGBLM8LGoxZNjEGqSTxahe8e+vgsQriUVAM6TXsvjWQUrDvss5Q9keEZGZQPUfzF7Tc=
Authentication-Results: linux-foundation.org; dkim=none (message not signed)
 header.d=none;linux-foundation.org; dmarc=none action=none
 header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Thu, 10 Sep
 2020 22:43:15 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::354d:5296:6a28:f55e%6]) with mapi id 15.20.3370.016; Thu, 10 Sep 2020
 22:43:15 +0000
Date:   Thu, 10 Sep 2020 15:43:09 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC:     Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg/slab: fix racy access to page->mem_cgroup in
 mem_cgroup_from_obj()
Message-ID: <20200910224309.GB1307870@carbon.dhcp.thefacebook.com>
References: <20200910022435.2773735-1-guro@fb.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910022435.2773735-1-guro@fb.com>
X-ClientProxiedBy: MW2PR16CA0043.namprd16.prod.outlook.com
 (2603:10b6:907:1::20) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:86e) by MW2PR16CA0043.namprd16.prod.outlook.com (2603:10b6:907:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Thu, 10 Sep 2020 22:43:14 +0000
X-Originating-IP: [2620:10d:c090:400::5:86e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4611f0e0-4a5c-4c3d-5480-08d855dae78f
X-MS-TrafficTypeDiagnostic: BYAPR15MB4136:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB41363B4DCB0A19333148F4D7BE270@BYAPR15MB4136.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UUkZl9KOYKnEiYH6RrwB6kb0+ddKDV1EKpYgrjiepN6Zg63qUrnagKvEf9R6JxXQqoKdeZ9JWHIdOavHIA8dtypkUFGOe9Yfhrj2KMtAv12xJf7CVad7z8El+HtkusQWeNdPzuPni7kctcZgyd49JaWTEjTXLo1UACiY8b7s4b4DaFt81v1ro15kD53KGnqehJMQb9264o4TKs9dMF/spTHQ1hMsr/NG6KBczN/HsO0rrQ0ekmcBV6wr1dzffo2hYzsvxusGDxnUEVdcaWihgJvXirP+Fla7cYv75zuGsHsnKfdL0ruGCBUjLrFjxx3NccXUYzMcB3OT/x1FM2ujVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(366004)(376002)(136003)(55016002)(8936002)(86362001)(5660300002)(9686003)(53546011)(66946007)(1076003)(6506007)(316002)(478600001)(52116002)(7696005)(33656002)(8676002)(66476007)(54906003)(6666004)(66556008)(4326008)(83380400001)(16526019)(186003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nFDtUcLftjTNk5TpgQvbCJDEnyL8VHqCOnTuc9FpXf1LIUK2fEHRBv62EbYIqPfz8Lmaf89hsb7r3XnoqPL+n7PWIaWB+14DcOFj/prYR92KngH7gDWlN/f1KqGmZ9Lxjtkx2NEjBA6PH6BEcgK7RDyTZ3VoHw3b0/fdlVt5V4Mz7TwFnGBZuP0I+I9vlT5fWTsC46y6Ioz+uhKQugvKFXTtBzTEP8p3FWj+A/nhDKvwn2rtqP18+YkYQJdCUEFdFbQyw1QdoJII9WSW3j9WwbE1y65A9R4S8YO6duCN3806KnWND9fvKGnBfDLeNYaRjjHJBhHIIIQqJ5hsCVZCFWM69CrvfXgQtHJfisKyZZOCnuo5iUWvFFuV/4ZQ+RQvFPnju08/np9nB3snU1e0S6llcKNkDoY7g9Uac0EPgGfPu4sE37Rsj7cQusePCvsFTeg0suprXmjsmMsv6m0VcY9NOE91WNup4bpULr+v81Uf67oO7ochzY67/PncHG3POb6Tfr5Vez3D02a3/Vgfg1CRnrfrIdmeBqK/fxeC4GuLWb8R2sdnTvtS4w7Cmz7RdUr1Eyt5292tA8l7LgCk1FKexPDLsxxvrgwuAZuO/oR++gZEZB/OJEhVaoYjDCFAc4uaAK2gPN/VcYaMD3GlZrs6p+o+kY75+Xeu/lDfegA=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4611f0e0-4a5c-4c3d-5480-08d855dae78f
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2020 22:43:15.3444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJ3clPj10FDHI7pW4KY67r5bgzC0jYAZXwC96ycyygt4muCW4T6OW0O3P5tjDwg3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4136
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-10_10:2020-09-10,2020-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=1
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009100197
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Forgot to cc stable@, an updated version is below.

Thanks!

--

From fe61af45ae570b143ca783ba4d013a0a2b923a15 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Wed, 9 Sep 2020 12:19:37 -0700
Subject: [PATCH] mm: memcg/slab: fix racy access to page->mem_cgroup in
 mem_cgroup_from_obj()

mem_cgroup_from_obj() checks the lowest bit of the page->mem_cgroup
pointer to determine if the page has an attached obj_cgroup vector
instead of a regular memcg pointer. If it's not set, it simple returns
the page->mem_cgroup value as a struct mem_cgroup pointer.

The commit 10befea91b61 ("mm: memcg/slab: use a single set of
kmem_caches for all allocations") changed the moment when this bit
is set: if previously it was set on the allocation of the slab page,
now it can be set well after, when the first accounted object is
allocated on this page.

It opened a race: if page->mem_cgroup is set concurrently after the
first page_has_obj_cgroups(page) check, a pointer to the obj_cgroups
array can be returned as a memory cgroup pointer.

A simple check for page->mem_cgroup pointer for NULL before the
page_has_obj_cgroups() check fixes the race. Indeed, if the pointer
is not NULL, it's either a simple mem_cgroup pointer or a pointer
to obj_cgroup vector. The pointer can be asynchronously changed
from NULL to (obj_cgroup_vec | 0x1UL), but can't be changed
from a valid memcg pointer to objcg vector or back.

If the object passed to mem_cgroup_from_obj() is a slab object
and page->mem_cgroup is NULL, it means that the object is not
accounted, so the function must return NULL.

I've discovered the race looking at the code, so far I haven't seen it
in the wild.

Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: stable@vger.kernel.org
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 75cd1a1e66c8..093526fec4bf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2923,6 +2923,17 @@ struct mem_cgroup *mem_cgroup_from_obj(void *p)
 
 	page = virt_to_head_page(p);
 
+	/*
+	 * If page->mem_cgroup is set, it's either a simple mem_cgroup pointer
+	 * or a pointer to obj_cgroup vector. In the latter case the lowest
+	 * bit of the pointer is set.
+	 * The page->mem_cgroup pointer can be asynchronously changed
+	 * from NULL to (obj_cgroup_vec | 0x1UL), but can't be changed
+	 * from a valid memcg pointer to objcg vector or back.
+	 */
+	if (!page->mem_cgroup)
+		return NULL;
+
 	/*
 	 * Slab objects are accounted individually, not per-page.
 	 * Memcg membership data for each individual object is saved in
-- 
2.26.2

