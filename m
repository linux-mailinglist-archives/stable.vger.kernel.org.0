Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18EF2CACCC
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 20:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392282AbgLATxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 14:53:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50600 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389571AbgLATxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 14:53:34 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Jk3PC006597;
        Tue, 1 Dec 2020 11:52:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=qGoh0NjOVRP/QSnr/sd5RDHqb3FTC5//82m/Y7A/PuY=;
 b=og/fT9yfzjoL9sLhd3kuYU1o6VaIMt5MhsHIPIXI2YczlpdfnxVM/NNxaEz8JMB9ZngJ
 w3KeS6cu4MG/9oYW+7ViIOLHM33g2YG7ONiDGH9UAMUmWlW9D1hbOZh+nHTmJJFCmvTm
 ncOawk35NzYf2f92CKSBMpOlAHZw2Aad87Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsymsay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Dec 2020 11:52:44 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 11:52:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afGBmPIBK90ixm/yhBFdeXpcC9hFdPQVMjDb0JrgJOBYf8foOQQGwVVBILEg05bMTy9lmrypA9Sqo9/iOF72p3DNEEfIEjssieFWeo3BHr0dqa584mb0nFthCHVWCZa6kPx+SiLu7rw/XppmyW/y9dfTTc9m+YwC0ukHCKpQ02RL1sKJcmb2pWeB9PptPTdvwuC+VTsCZ8M7qZByJPr5YY/dE6J9Avr4fF7/nnjj2Wggn7PwTPgb3Dh3ABCg+88Jzr6nleUAx/y7WHANzNyAgtZ7IZ9/OiFnwy91WcsO5ZGtjVeoWUz+hIoqLv7HCnvrbE8ZQ9mJkFDZZYlF568+Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGoh0NjOVRP/QSnr/sd5RDHqb3FTC5//82m/Y7A/PuY=;
 b=bkY71BU/Sfdn3JElm13MR1vrfpQsKraJp9QdQD0n2hg85hwUptaJZy0Bqi3AJkGhuN1uqtexkteIvSOR7688tPWYmzUL+uVyswXW31vngS1HnqWGRIrgOBvqBRMSheoQx7TSixM1eJAkSH1tq52TkapKWF0N5SCJn+cKo+BxBTMffqqHzlRMJuClZ9Q70sjrAmqDAldjpcXonLP6XTAaGmBqEAXHXjs0WLexqwZY7xJvL0Qk8sORAzKTfgA7MTy7dgIx/ycvgQJi5qnBFw3VgoiDgOg8Slh0MSl51BLISfMttIh5TErBkdBKr7vnkng7fm6TqtzRhuWWTjpNIb0+RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGoh0NjOVRP/QSnr/sd5RDHqb3FTC5//82m/Y7A/PuY=;
 b=AtsIx5fHMQm6kUiqqmadx8BSvSL9712G5ouy9JPAC9z+K3C3FKK1zKvElS6YMjuHnLnyZXSfyTE82pSfit3xfIXQa8S1Fjz56nii6xdVonDLcPnoZPn9/tRUUYF4tB8+/rtFfzOlN6FxRJEsivD3hNHH5kvIiYyvCK7MZaX8leA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2343.namprd15.prod.outlook.com (2603:10b6:a02:8b::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Tue, 1 Dec
 2020 19:52:41 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3632.017; Tue, 1 Dec 2020
 19:52:41 +0000
Date:   Tue, 1 Dec 2020 11:52:32 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Yang Shi <shy828301@gmail.com>
CC:     <ktkhai@virtuozzo.com>, <vdavydov.dev@gmail.com>,
        <shakeelb@google.com>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [v2 PATCH] mm: list_lru: set shrinker map bit when child
 nr_items is not zero
Message-ID: <20201201195232.GC1375014@carbon.DHCP.thefacebook.com>
References: <20201201174449.51435-1-shy828301@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201174449.51435-1-shy828301@gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:8c2e]
X-ClientProxiedBy: MW2PR16CA0042.namprd16.prod.outlook.com
 (2603:10b6:907:1::19) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.DHCP.thefacebook.com (2620:10d:c090:400::5:8c2e) by MW2PR16CA0042.namprd16.prod.outlook.com (2603:10b6:907:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 1 Dec 2020 19:52:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeed32ce-dc60-4b8b-72a6-08d89632a9db
X-MS-TrafficTypeDiagnostic: BYAPR15MB2343:
X-Microsoft-Antispam-PRVS: <BYAPR15MB2343C3246B80BCE74332C336BEF40@BYAPR15MB2343.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QCW5owA3+t2mBNuPdX704hTuBQZilUPNVXRXkVyaJtFXTnA2bTZlgVQ+SWlC5VV+MejpiGRM3JRMDxkokgEzMr6tI9PutzOYLeYJMWSMYvOFxKdnbgQ0VyRMj4i8k6YmqDxdm9P/TEG/dXKzkXysN7Hg1ZUN4NoiNbipMu4D/NUyieDtMzbMUQBerb/By4g+LB6dq22QHB8EGpV/98hyp+NNuDONAN3LqNsNOjKZEf9MKwuoZc5rmUDfYQw/SRj6Dp0VQj7sJiwkfNQGzMCWp2t2t8jXrW3ujHM8L736vimm3hfxy4nVI+vhRMYIpWPI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(39860400002)(366004)(16526019)(1076003)(83380400001)(86362001)(33656002)(316002)(5660300002)(8936002)(8676002)(6506007)(66476007)(66946007)(478600001)(7696005)(6916009)(186003)(4326008)(66556008)(9686003)(6666004)(55016002)(52116002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?t2HGQH2A37BpDiecVfXg+Yr0pI3zUh4AuRxwXtKDucHEyR7zF8gh7nLZ3liC?=
 =?us-ascii?Q?P17pi5/d2sAeKN6AgP5EhC3WOZRg6cbLWHVfw1EI5nUaVcu4Sc8LRUw62BxS?=
 =?us-ascii?Q?ZgKbT4SVU6Pe3YEVINEiDzYqsYGLPhB5346LGpqYlgSv+Edhb2MRHgQFz1jZ?=
 =?us-ascii?Q?dxDqSqdWKKvs2iIJuxgpPSDbL+AiKU/0OyPOrDcWdihxAW4GGgzS5Dk20Rwf?=
 =?us-ascii?Q?lgEkRErXKGZgdyDv1XHg/FpZsa+/rQAW9GreQcfh5uzRXzeQmHhQiq80CizL?=
 =?us-ascii?Q?uDppB9kH6NA+qcSb0PsLuq7vZonVIHAbLZ0NCenDFw9rT2NG1CcJyx4nhatN?=
 =?us-ascii?Q?cJxJwBw2CDUCJy4273JL5+twvihPkCSGOPYcU+CDj5dVqfna2fwEG12l8Aoj?=
 =?us-ascii?Q?Q+3CThxePso/8OGG/7HrMam+UkZta/0XhBYoKDb2VgufvDy5ZOuvTaayGpWS?=
 =?us-ascii?Q?0qA5pNGLVZP0XcVinh44gUES+ae1HU0AhccUssSemjKDlzfl3SBX5HPm1mAg?=
 =?us-ascii?Q?lZdZ6NNfHN57xlX5ezoqy1z8gAo2bQTBkBooDyP4cZ/g65Qtz1U9nNIjGLEV?=
 =?us-ascii?Q?lHGuLsbt2P4bd9zUS6I4ac9yvIXGZC/Pu/GwEjhmN4bxVwX1hkphfx0rKSUo?=
 =?us-ascii?Q?v7hLkQFcFNp8t2ifrrMP4SQr+esML/vNlz9UkyM0iKZRs3cO7u9m65NIvs5e?=
 =?us-ascii?Q?niWkQ4i6VV5DHq9T4n/ImxnFefBzuEayTbYQjsWmiMpx9iyqSTso7N8cb0ag?=
 =?us-ascii?Q?oVcBO0v4GvjG6p27FY6gDtEauSwN7VJ4zGYPNNFtaYKGMzMjeenI1Jyllo2o?=
 =?us-ascii?Q?JDtWSj8R8pXL8s9jTyloT9E2iLA8tu25GAPCjClxgkGE6KmHL+mm6k8fZcbO?=
 =?us-ascii?Q?e8pEDHR3aFrO11HfbgDw+XyBWEl3yxtxIhHFlSwq7nVj4xggaDW6RBFIEl6+?=
 =?us-ascii?Q?3BrcTCIZpuYCyggabuWvSOVONCFuL8yEse2qIXPOUvEpDbAT5UCVNHFv7NqR?=
 =?us-ascii?Q?SjYdNQ1aiS1awtMgGqqV/88lxQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eeed32ce-dc60-4b8b-72a6-08d89632a9db
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 19:52:41.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zP5BpcBjvY1RM0OXa+HfIinqQi1xOIVDsXgxveI+RjI70I0DLpFso9lMlT1Xk6rA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2343
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_09:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=5 mlxlogscore=999 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 09:44:49AM -0800, Yang Shi wrote:
> When investigating a slab cache bloat problem, significant amount of
> negative dentry cache was seen, but confusingly they neither got shrunk
> by reclaimer (the host has very tight memory) nor be shrunk by dropping
> cache.  The vmcore shows there are over 14M negative dentry objects on lru,
> but tracing result shows they were even not scanned at all.  The further
> investigation shows the memcg's vfs shrinker_map bit is not set.  So the
> reclaimer or dropping cache just skip calling vfs shrinker.  So we have
> to reboot the hosts to get the memory back.
> 
> I didn't manage to come up with a reproducer in test environment, and the
> problem can't be reproduced after rebooting.  But it seems there is race
> between shrinker map bit clear and reparenting by code inspection.  The
> hypothesis is elaborated as below.
> 
> The memcg hierarchy on our production environment looks like:
>                 root
>                /    \
>           system   user
> 
> The main workloads are running under user slice's children, and it creates
> and removes memcg frequently.  So reparenting happens very often under user
> slice, but no task is under user slice directly.
> 
> So with the frequent reparenting and tight memory pressure, the below
> hypothetical race condition may happen:
> 
>     CPU A                            CPU B                         CPU C
> reparent
>     dst->nr_items == 0
>                                  shrinker:
>                                      total_objects == 0
>     add src->nr_items to dst
>     set_bit
>                                      retrun SHRINK_EMPTY
>                                      clear_bit
> child memcg offline
>     replace child's kmemcg_id to
>     parent's (in memcg_offline_kmem())
>                                                                  list_lru_del()
>                                                                      see parent's kmemcg_id
>                                                                      dec dst->nr_items
> reparent again
>     dst->nr_items may go negative
>     due to concurrent list_lru_del()
>     on CPU C
>                                  The second run of shrinker:
>                                      read nr_items without any
>                                      synchronization, so it may
>                                      see intermediate negative
>                                      nr_items then total_objects
>                                      may return 0 conincidently
> 
>                                      keep the bit cleared
>     dst->nr_items != 0
>     skip set_bit
>     add scr->nr_item to dst
> 
> After this point dst->nr_item may never go zero, so reparenting will not
> set shrinker_map bit anymore.  And since there is no task under user
> slice directly, so no new object will be added to its lru to set the
> shrinker map bit either.  That bit is kept cleared forever.
> 
> How does list_lru_del() race with reparenting?  It is because
> reparenting replaces childen's kmemcg_id to parent's without protecting
> from nlru->lock, so list_lru_del() may see parent's kmemcg_id but
> actually deleting items from child's lru, but dec'ing parent's nr_items,
> so the parent's nr_items may go negative as commit
> 2788cf0c401c268b4819c5407493a8769b7007aa ("memcg: reparent list_lrus and
> free kmemcg_id on css offline") says.
> 
> Can we move kmemcg_id replacement after reparenting?  No, because the
> race with list_lru_del() may result in negative src->nr_items, but it
> will never be fixed.  So the shrinker may never return SHRINK_EMPTY then
> keep the shrinker map bit set always.  The shrinker will be always
> called for nonsense.
> 
> Can we synchronize list_lru_del() and reparenting?  Yes, it could be
> done.  But it seems we need introduce a new lock or use nlru->lock.  But
> it sounds complicated to move kmemcg_id replacement code under nlru->lock.
> And list_lru_del() may be called quite often to exacerbate some hot
> path, i.e. dentry kill.
> 
> Since it is impossible that dst->nr_items goes negative and
> src->nr_items goes zero at the same time, so it seems we could set the
> shrinker map bit iff src->nr_items != 0.  We could synchronize
> list_lru_count_one() and reparenting with nlru->lock, but it seems
> checking src->nr_items in reparenting is the simplest and avoids lock
> contention.
> 
> Fixes: fae91d6d8be5 ("mm/list_lru.c: set bit in memcg shrinker bitmap on first list_lru item appearance")
> Suggested-by: Roman Gushchin <guro@fb.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org> v4.19+
> Signed-off-by: Yang Shi <shy828301@gmail.com>

Hi Yang!

Code-wise it looks good to me. Thank you for updating!

I think the commit log can be simplified a bit: you don't really need 3 CPUs
to reproduce the problem. Also, IMO the section about fixing the problem by
introducing an additional synchronization can be dropped, but it's up to you.

With the updated commit log, please feel to add
Reviewed-by: Roman Gushchin <guro@fb.com> .

Thank you!
