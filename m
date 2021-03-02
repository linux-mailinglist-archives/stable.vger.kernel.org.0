Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD34732AEC8
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhCCAFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:05:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43502 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576327AbhCBE1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 23:27:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224IrNt141004;
        Tue, 2 Mar 2021 04:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=r6X+FNtP/7TkcOtoJs1TDi3G3jkGxx4ooYQ0//y2PZk=;
 b=Mwa75uI7UxeqTlj4awzZ+E3fjQs9Q7/8TO/BWBDM7WOpjakre23tASXy8FkMM5AF1v3A
 hdTvp3jgfjqriIuHmwkhtlxjo6HlTQBoe43v8NacF5ShDwY7VzvSlYyDsEjH0vh8IP9x
 n7ZwVpFpci1zVutiK236eQdM0LsnOc13DvRPZ2OJ5DuUuTlW0lwaiAiS1tYOwkAuQtMp
 HXwJ5O+1esGj7tR+pM+K7erR6QnCBFwf+6Sdu9wil2lV1Zrlgc14RFgIodGG86EuWMym
 LZ332iZRofnWGrmxNhAiOvm6A4PcAPVHsBsTNhvVXaUREHKvsOB7h6JPhoUZ6coWcGtk MQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36yeqmx26v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:26:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224QUbG028163;
        Tue, 2 Mar 2021 04:26:54 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3020.oracle.com with ESMTP id 36yyurfjwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:26:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ffKfFjbE5/U4UImwSHa5QkakkMaSeoFiknI4h6EzpM0eur87mtub8m4yUiihu7mn9ZdQsrahxBLXSxv+Oog74aw5htEzW7VJtTZQN/kQ1ekKjRDJXmHLkC4NVEAIzkVDbE+Wrn+UKNjKwWX2YhnxQhyFzdsJb44ykwg3u+OhCJQ3zhFDBQObF70Y7LmztHgQFWHdVnkw2TLvCjP5XJWsczmKkry+yztSd3YHtiiQ8mNl5VN/k0Ilh44rKocrU1RVN4VPQlFgwrl296//hkPX63syrsjBitNg0WIjgPXkriIHxdl35B88KjhaYoPA4U+QACBt9SOSiiXPmtFg1+OZOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6X+FNtP/7TkcOtoJs1TDi3G3jkGxx4ooYQ0//y2PZk=;
 b=RD67JpiU0+ojavbka0n++bE3zzEpYnQS6eJyT5+nuf7jgIzFYhJvPQ5iDlPnTYSSGm5zer4M5hlCjWz5aWfa6ygc/ewRe0HAPd0Ep5enGz0/sya5Khp+SADPmlBuv8gI0s24MQAdQUewAcOnHOMiDuz3nOy75HuoLqHS8Z45umaH+NrFxv/5iiKpJEspZjp+WzeAVkOKHIEiaDYhbvOt6vJ1UVJ01zriv2WSH41R/RMzvl+b4+sFBPBg3tMEZHnZAAJxdKV3P06B4SAtiV27WE69GA8zyp+MLFhFyBI8YJscxhT/WouOmOZ+oKHrWqLbGU34+RAm/hu7iyhZ1ytDmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6X+FNtP/7TkcOtoJs1TDi3G3jkGxx4ooYQ0//y2PZk=;
 b=jAAT2QyAOqSKz/opGd7yenYmWpqFw6ByEfMOpsHFDPP7sPM3gyZE4mF5Duy3mLDOf0Va4CFWcSNb6akVlOjci65h9zr2PikxF3kruKIRbp9buBoGxiZpfZRadNlq7SE9Xc2dSx/E7Xf8OVQEQgdKoHXUTFi2ZoM97kdNPinZMms=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3206.namprd10.prod.outlook.com (2603:10b6:a03:155::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 2 Mar
 2021 04:26:51 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee%6]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 04:26:51 +0000
Subject: Re: FAILED: patch "[PATCH] hugetlb: fix update_and_free_page contig
 page struct" failed to apply to 4.4-stable tree
To:     gregkh@linuxfoundation.org, aarcange@redhat.com,
        akpm@linux-foundation.org, dbueso@suse.de,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
References: <1614602458155165@kroah.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <c55de41b-2d47-b1ac-3a14-587b97ff8ef6@oracle.com>
Date:   Mon, 1 Mar 2021 20:26:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <1614602458155165@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:300:117::29) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR03CA0019.namprd03.prod.outlook.com (2603:10b6:300:117::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 04:26:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7e4c4fa-628c-4d88-2f98-08d8dd336700
X-MS-TrafficTypeDiagnostic: BYAPR10MB3206:
X-MS-Exchange-MinimumUrlDomainAge: kernel.org#8761
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3206BA3E737BABBD408375C5E2999@BYAPR10MB3206.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Vz49OP+Ha76rmmjNmEuky6rU8bqcaJVrvCMqdCZCCgVD+E3IbvAFSp6ClPKuoVgjG0dKVm1xg18xJtUUo5dHVGNXZovQ8QmqQ9WkjTRZq/SqAhJXmChFpkKPL4bWAnhp4rQl/ON2NIHScyV4RjHrXnqxjsxJDcAzPLSiOG1f62Y2Vhn0e6ThvGXJZrE3+8qR6j7kVNinttCs6p/YnjknfAUcQHwmwVjFyD3aom2kXUCRwQZb323+Q7RX9TiS/YkbIKS8Ir5Rl6qeMP5Ohi4ZsiSNjugdQf9dQ1z0lnd4GNySbM9Zk2V4nD2fPJtqOTtog0zYBWbn/BhqO17JnJtxCkvSfeH3YoH4470b97ZpuYbzNujCQ/II8ltwruGy2pH2Bl8f2Ri1MGmgMAUaJZxRS1LWfxLbPyumlYZuFxFjkl4Z5PMPs8gKAX3lbE+LORC5Vljsl81bt6ZWjhR684zi0omfM2AsfDi6RWyK0+Hr2EpUUpolEgjpnHxHwGeXYn+UzHpGJ7MH+s5a886EmsNZY8aAwR4ahrjU12PcuWVcEz8SGZbFCrQwzSlIFos1VsA/ObZr+Wz+wVUPnIbofdUgCVImRHZ9RWokf0y7YxgvJ13KX4ZT4XGMCsQAbl6FS1mxyudXjrG7XSnVxahL5bEpjQ2wnA4il/NSLOHDJlp2aajQetGwVYsVvWNVN8ttswVoff7Y/tSOtq0yTQANKOUGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(346002)(366004)(53546011)(2616005)(956004)(8676002)(66476007)(66946007)(66556008)(8936002)(83380400001)(31696002)(86362001)(15650500001)(26005)(7416002)(186003)(16526019)(316002)(966005)(478600001)(2906002)(16576012)(31686004)(6486002)(44832011)(52116002)(36756003)(5660300002)(921005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?THljN1R3Yjl1UTdrN2cwN3FPbzcxTXJZUmliTnRudWpFcjhYQ2pGQUFEWUpI?=
 =?utf-8?B?Wk9OVGZoWlJERTlQbkJ2ZEZxd2RkTFRiNFlhbHV3bC9uREViZFg2bHUyVnVa?=
 =?utf-8?B?aTV3WkRycFVYaXU2WFNWaUhQUGZuZ2IrRUhrbHdwZXVtRisybkovRkgrT1RF?=
 =?utf-8?B?ZFVXUUtBS3lBTlQ1a21tcmpOQmw5eTkzR09WNjJHOGhwV25PT2VMR2Z6b2Fr?=
 =?utf-8?B?OHlxTjFma2lvZ3piMWRyUXpxYW1FS3BERUhYcEl6OXFQdi8rTE5EOWJiR1Zi?=
 =?utf-8?B?cTFCTjhCUnhBVlozWVQ0bkh6ZjVKMUZCOExNTXJkMkpwY09Nb3lxTlZnM0pC?=
 =?utf-8?B?SUpZR2hiblZVNXRtTG9LOTVDdVRCNnJ2czgyRkI2NXJEa0JXekliRmNEb3JT?=
 =?utf-8?B?WVFDaENmQTVpRkU1WFg2VmpVWlk3eXlkRXRtMGtXNkFBMEhZV0FmeTBVaDZv?=
 =?utf-8?B?LytVNGc5RGNYanY4UkVMcnQ4M243TUQ4enVYRzhGSWVETEFNYng1Y2VuKzdU?=
 =?utf-8?B?SlpvY2RQNFBTQU5hSkVNOVRvM2hhZjAwbWxBQ09WRDhDOUFPMDlnV2JUTVRX?=
 =?utf-8?B?eXpVNUlFRWp2S0lUS25ONzFQSjhWOTVmenhBNGZaZzFDQ0xjVjJxKzJqRlFV?=
 =?utf-8?B?anRyTFIrWWRhSm0wVlVrUXpVcy9jYkpuTTFsdU9aOTY5N3ZUcWVNbnNkSmF5?=
 =?utf-8?B?OVU2Q081T1ZBTWUzbllLZnd0M1JyemtCVFdvbTd4QjJMRWZDeThrVFVaNDR3?=
 =?utf-8?B?ZU1MbStlNHVQWWJiMFJxUFVIelhPRUFOVVRUYVdwcHBMTkVVTk9USmFmZzdL?=
 =?utf-8?B?eXgzNndqaHZ6UGFoRVRoSHF0a0xJampLYlpUZWc4WFpHd2pmZG4xMHlGZWw1?=
 =?utf-8?B?a2tTQkE5R0wxRmt1RmZxTldjMkVPL255ZktnOUFmeTYwblcrNXp1Wmp0MDNr?=
 =?utf-8?B?amVYRTBnZXFYdXdMV3NGL3ZEWUNETHp5THJSdTVBd1BJY1JTN09NYmo5eHIr?=
 =?utf-8?B?elE0ZW9OUEgzQU1sVEkyTHhYVEkwTlkrK3RJWE9neHBMbFE3aEtBYjdnRUNE?=
 =?utf-8?B?cFNiM2FsWXREZmlVeHcwOUdVVG1QckU0dURQcHRkT1pUSi9iay8xdHJlZStT?=
 =?utf-8?B?aHBqSG5lcDY2ajBSaWtLdmFEUmpCQ3cySnNRcU8rTjB4TkdWRzJZbGIxek9u?=
 =?utf-8?B?QjY0c21iZGU3WUpEN2QrdW9uaUMwaU1yMjRyUDdhVkdrRTl2TkFkRVkrVjJm?=
 =?utf-8?B?UHBXVjRPUXpZLzMvNllJdkNhY1dtSGREWWN0SWh2KzNRWmVCU3h0YlQzZDRN?=
 =?utf-8?B?RSttQXdhZndpMTBWNUxhbEhiU2R3dE45clFmcThRQXFHUVRha1NOVW9Xa0R4?=
 =?utf-8?B?cEErY09UVXFNSGlYaEVGcmtEb24rYkRSKzV0TXVSVE9CelZoWDBxbTE0RHlS?=
 =?utf-8?B?QSt6U1lySzBQcktqVDNTSjNWc3B3OHZIcnQ3SFh5ZUp6MElmSE5mazlvcVZF?=
 =?utf-8?B?TEdkU3BTUGxLODk1dmYycGdjY01KcVkxNHVEZnpWajBYM1FzaEFzMWRpb3ZD?=
 =?utf-8?B?TjkycUM5MFgxZ2Mrdk5yME5OMGZ0VXE5N1RmcE0xbFVLYzQ0UzY1bnQzSE5L?=
 =?utf-8?B?alFkTVI4Z0ozMkRmQ2xsc2J3ankrcThRMXR5dG1TMzJVZ2JHN2ZoQ3FYWnR0?=
 =?utf-8?B?L20zM0lxc3czS1l6WlR2VXJVRllWWGpRZkRwNUIyaUtKZElRN2dlckpHT0Rh?=
 =?utf-8?Q?NFbNKP+htWqaCS0hBt5QdV96HW/sK0MvRV5nE6Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7e4c4fa-628c-4d88-2f98-08d8dd336700
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 04:26:51.5684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iqwPDyqRf3Wf/JB/FV7aathximdJ02QpO61rmTNTWml/j18nWF13q7+ipSHH96hVrglZIvC2ubFcaS3PZjpWZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3206
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1011
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020032
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 4:40 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From 291e3463b1b7e2f71cb5999f68d3aa2a80178570 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 1 Mar 2021 18:12:38 -0800
Subject: [PATCH] hugetlb: fix update_and_free_page contig page struct
 assumption
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit dbfee5aee7e54f83d96ceb8e3e80717fac62ad63 upstream.

page structs are not guaranteed to be contiguous for gigantic pages.  The
routine update_and_free_page can encounter a gigantic page, yet it assumes
page structs are contiguous when setting page flags in subpages.

If update_and_free_page encounters non-contiguous page structs, we can
see “BUG: Bad page state in process …” errors.

Non-contiguous page structs are generally not an issue.  However, they can
exist with a specific kernel configuration and hotplug operations.  For
example: Configure the kernel with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where the
gigantic page will be allocated.
Zi Yan outlined steps to reproduce here [1].

[1] https://lore.kernel.org/linux-mm/16F7C58B-4D79-41C5-9B64-A1A1628F4AF2@nvidia.com/

Link: https://lkml.kernel.org/r/20210217184926.33567-1-mike.kravetz@oracle.com
Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at runtime")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dc877712ef1f..7539b49bc74b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1142,14 +1142,16 @@ static inline int alloc_fresh_gigantic_page(struct hstate *h,
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
+	struct page *subpage = page;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_supported())
 		return;
 
 	h->nr_huge_pages--;
 	h->nr_huge_pages_node[page_to_nid(page)]--;
-	for (i = 0; i < pages_per_huge_page(h); i++) {
-		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
+	for (i = 0; i < pages_per_huge_page(h);
+	     i++, subpage = mem_map_next(subpage, page, i)) {
+		subpage->flags &= ~(1 << PG_locked | 1 << PG_error |
 				1 << PG_referenced | 1 << PG_dirty |
 				1 << PG_active | 1 << PG_private |
 				1 << PG_writeback);
-- 
2.29.2

