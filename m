Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2A932AEC6
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhCCAFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:05:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:43190 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576284AbhCBE1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 23:27:13 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224IvdO141013;
        Tue, 2 Mar 2021 04:26:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=az4Khrc94L7DgkVl/ZIH8soGL5Svy3rO3vDOLSqjtmc=;
 b=LoDAdOaXiaKJ+0gDy3MQEA6k+R4bbABN7oOlv/58Lvv9H/D6NaWpZLT1JkyxqkIpvfqs
 X9AtNmlelLDbK7MzgCt8K+1FB4jhqJ53eX6nlyuZKDAo9HgXcr7BR0tgDhBzRrlzBs4h
 cdvCpuWjm+OSuV+wz80HXbkNP8+yq6wM/bQlO32q041uW5BHTByYR93cMQlWvRSK3vaE
 q8XrnkNTd1NLCIM2sVtfX7+Lu/h6moi6Fzt66L0Jw9XoGAg3mvla/d65ZsET3LwRxpYc
 TSIoIu1hwt+kN3U0m2vp6KRSa3huXWSZw+t9vGt0gJwGSGN0rIVVezVd7D+naqJRl/sq 6Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 36yeqmx25f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:26:15 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224Owh6029098;
        Tue, 2 Mar 2021 04:26:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3020.oracle.com with ESMTP id 36yyyybtmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAdXPo3qs5maRIOi9zV9HB+ouGqlX6jkKu7W8xpawI973b0gsi/GsDiUcw2i0zLGbryzxoAixtYfNRT+y1zGI0HkYiQO07aQIapJ6kSXv3PcpgNlJSUHs8TgsOaNTqsycOi3LFlqnlMMO23FKu4Cj+vxcg4Od6Eiu6YTfzMeSwSMXAFySIs2POgvrVGEs+03/7P8csGQBkIKsg5jQXurYU6cE8ONWv8AkAwdeHgntQ64wKd89pa9Anfr+OP1sAJ9z5d3cKlFpOdj4N+fPsxVSnrhCa61AqgJ0rQ/p+ytNdWVeNnBy87U05qvMbnsSrr2bFgly1tmJhuNRCo0sxMRjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=az4Khrc94L7DgkVl/ZIH8soGL5Svy3rO3vDOLSqjtmc=;
 b=HV8AQCtSZN1hgPaAUR06LcnZmgXcf04HBeXPT3OSyq9Rb3xJKlZOebafYjQfuYZ0X+mktZtt5HGwUmrC9ZTalyFG2c5AvL7LPaz7DGYaTo2nt4u9DuWD/0TkckZ1YwW+yf4AtdM4rYsD6mkY8Yw7AKYhl1vpnpKzg+raGE2XGK89EamneenWXF99cw5sJDojnpdcf7FfWPEBj4jqYNIm9FnKpxmMfV2se4xemGUWMxkpVBzjyPgAVI8VlaFGl6yA97UR2V2xR7R1w8TUwPD5I1h+I2OcehWX4Zi2NI8X+EX8TzLxL8IydNtcOSjM8yuWUn6xo2+ZL8yx/OUMJz+IOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=az4Khrc94L7DgkVl/ZIH8soGL5Svy3rO3vDOLSqjtmc=;
 b=Pi676Kiqs0czLJt+8pDMCyNxc0lnJpEY3DApzuv+Vb0BPJ2bFoD3xD5b1uo/++gcdEpVdMq2M2roREtq8nT0lHr4mrkKyPzt+O8Lu8CZCBUc8low8mDkf+sLcRK4Z9ObpHPKXZ1VpHKWKbHdGZMeclWm7hiLzE0hgYJNxoqXVsw=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3206.namprd10.prod.outlook.com (2603:10b6:a03:155::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 2 Mar
 2021 04:26:12 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee%6]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 04:26:12 +0000
Subject: Re: FAILED: patch "[PATCH] hugetlb: fix update_and_free_page contig
 page struct" failed to apply to 4.9-stable tree
To:     gregkh@linuxfoundation.org, aarcange@redhat.com,
        akpm@linux-foundation.org, dbueso@suse.de,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
References: <161460245912839@kroah.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <92e44530-6011-2753-bfc3-c23780cd4b7d@oracle.com>
Date:   Mon, 1 Mar 2021 20:26:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <161460245912839@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR2001CA0008.namprd20.prod.outlook.com
 (2603:10b6:301:15::18) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR2001CA0008.namprd20.prod.outlook.com (2603:10b6:301:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 04:26:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0c0a4b6-5b56-4084-a045-08d8dd334fa0
X-MS-TrafficTypeDiagnostic: BYAPR10MB3206:
X-MS-Exchange-MinimumUrlDomainAge: kernel.org#8761
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3206A703EBDB05B774E912D2E2999@BYAPR10MB3206.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fK5jfeWGqgui64Jr6KtfxRbGseMUy0SlYWiGmceLp4GSG4KcXIpEyoYlFhJO3/xpAm610YrjY0HUlHIRLULGyB0H5/1OKVHjtqOStVMdCLp/Lo/rsyHIyClAELdwzE+gF/2cDXGZLID6XDu0WoH4ONjRZR5X1Wl/wOwySdVFvw5Hf221jhaVDkUBWVxFII232i2iVz6rWF0E8muKbZUAJOgOWShdWZ1LcX/JpyNdULx4Y4dIF9MjhPk+pjPokivMVZVpq/tYZB07hvmR2qdg+r6AtJNyNvms6CDIxrsFgPEgPsi7kXoZvnD+ICBcVXV10LU/swuqYTDwsffwY05l4wXMfjskwxQ/GBsZs1xa1QxuA1wthpRGZgjdL5IP7+sBPP6RzZp1BnxYA3Pb2omw+3upNOUcsFTywcDWrWfznXPhqyoqVfE62IS6Hs9euoQRGm7Nz2AvtJIPpoga1ztnKpOp4lxsdttAIEFLasM/EMoVniny+1K+34tVBBh99cX0h6ssCwBacwT9V0JoJHjwomisTTFOlEa0xTzHKINr1+UnBxCaObW5wJrRrkivA7Ji0jlJTa5jXr0ia8Wis47AAo+jKsX4/XfDH739iTkHEv4DQE9E8m/KbyCWGgbuGtWWBj0dFEUmpuZI+4zUPk96uVKniwHLoC43f/IybFMDhK2rDPNk/Bgi4fZZmktH4O/m1xJFu4BTd1beSmB5F62nOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(346002)(366004)(53546011)(2616005)(956004)(8676002)(66476007)(66946007)(66556008)(8936002)(83380400001)(31696002)(86362001)(15650500001)(26005)(7416002)(186003)(16526019)(316002)(966005)(478600001)(2906002)(16576012)(31686004)(6486002)(44832011)(52116002)(36756003)(5660300002)(921005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RVA1VW5pNGVTM004RUc3WXlyU2dMaGFScTV5MHJwYXNKUW9ZQzRuZ0JPWXVx?=
 =?utf-8?B?SzA5dnpmMEx5UkRscC9vaDRiK0d1aUd1dzV0K3EzVDRRcTZ4V1lrSnVqWnRU?=
 =?utf-8?B?eUUwVXZyQWF2Y2RrOWRhU3FYclpCQ2JkUDJ1dUZoNkhMWm5BcFN6NEdkMXRp?=
 =?utf-8?B?QVl4OFg2Y1lGZ3NxSTlGQzlBbkY5NndLaE9oMVZUV0FRcUN5V2EzN2U3L2l6?=
 =?utf-8?B?aFZQNXZLRDZHWFpFYlBzOENQNGx1WmFFWGx4ZGhuTjRzbHVMMXp3c2YxcUZk?=
 =?utf-8?B?ZXYxWFMwbHFreXZvV0VrZi9wT1dhNDVIbjlwSnhJRWZBNEJhWVZXbk5lNnRS?=
 =?utf-8?B?WHFDVnNBNWk1bkZJS0RrQVFRMHJoUlNQSS9wSWNybG1CY0NMcFBRT2hPOWlI?=
 =?utf-8?B?dENFVzNiTHNNVVhvZENxZjN3Z3NyZ2tHYzBVZW1MUm55WmluZDBuYnpGZVNz?=
 =?utf-8?B?YVFEL2JicHFjRkYrL1lKNWpLTGxjUGIzTHVLa0gxZHBxVGdzYTlJcGdROUFH?=
 =?utf-8?B?L2dWWlptNmtvN3dWUVNKeGE1RzQxNGhEQmJaak5ndURnejlsRFFVNW9McCt6?=
 =?utf-8?B?aG9KbXpnNzQ0dXdUcW42b284UW1tSUt1Zm5JZGZHLzF1NzkyQlRxeXZCNTcw?=
 =?utf-8?B?WElCdngrMGpsTU02VWVCYzN0UXhDL2RlUWJVdm5uRFRSMnViWU1xTjVkYk5V?=
 =?utf-8?B?c2UzcXhGcHMxL0tsanpJU0crcGgrVTBBUGpabVJ1Ukl6UVBZbXptOHdpY0d4?=
 =?utf-8?B?Q2FmOUNKdEJYNzh3TmMxb0R1NkRhZ1VGUkNhLzc0MGkyZHFhL09lS3FWOG5T?=
 =?utf-8?B?YjdQR1ZKdDBBQk0wSzFldzFKTVVaaWg1TGZiZ0U4V2NnQThZNlJpTWNva1FE?=
 =?utf-8?B?M3JMRzlWWXJOSmJ3TU01SlFRY0NWem1XRjhTVVNRQkJoWi9FMTNtdGthYkxp?=
 =?utf-8?B?TVFFdEhKb013aGRrTmsrV016RlE0ZzhpRndLOWJHRGlDN09xV25LY3BIS0ZD?=
 =?utf-8?B?bmFDZjRQZWRjalhqMWtxYjVSYlg1ZjQyZyt6elptU1A2amNFTXJ6bmlJdVdq?=
 =?utf-8?B?eVVpNGMyd2lCbURKdUI5T005K0lhczdLZGdzVUJUMk84VnpYdk1saExvNTBo?=
 =?utf-8?B?bUZWeU8waGhxWVJJQ2JSeStnaHUrVGQwKytwcDVPQm9KWDA5cHZadk1BVmVW?=
 =?utf-8?B?WDNvaTk5WFNCYUsyVzlSOUUxaDQrQnZ2cGRUS2I5TUM1VHZsZDVlLzlVMG9B?=
 =?utf-8?B?VElBNTdwYitOK0J4M005Rk9qT0RaWnZMMitTVDdTbkdGaUFZcnFUVXpuTDk4?=
 =?utf-8?B?THZIZDFKK01MZmlHVEFhTlJZTXV5N3JJOTRGaWRJVzhDUnEvTk9nS3FNZmRz?=
 =?utf-8?B?MlRkSi91am1ZWllGRCt2bnBBVE11UHJhaGsrNkdtd2IzYjA2MGduVEdRRGpR?=
 =?utf-8?B?ZVFDQUlvdDJyRVd3Sk1uUmVLampGSzFaWU9lTjdkMVc0ZHViQkc4VW0wVVAr?=
 =?utf-8?B?RGlUWmFmdkJINVRLSzZzVEZpQnI4WjRaZGpFcWpoc2xWcnNRY2pOaU44b0Ft?=
 =?utf-8?B?c25PbXRuc1hJb1VIbi9zYXlzeVVjVDVKM2t0eGZjeVdhWktPVWJXOEprbXVB?=
 =?utf-8?B?NFgxMjdVa3NESFcvVjVTSStWUTJCc3lGNHU3ckJPT3FObHRHWlBBQkJpNnJX?=
 =?utf-8?B?SHBrUnRmZC9ITkpRMnMxU1o3aW9sZ3ZTREdsMXd1cWlxRVczL0xpeHZCejA1?=
 =?utf-8?Q?eMkXuOYmO1rco/XRS+D7kX/5iP9fd+pf7H32UG7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c0a4b6-5b56-4084-a045-08d8dd334fa0
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 04:26:12.3884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8IoUUv36jGw+JJh7MF4NmnZhrJx4t9crTUlEq8c3GT74CfthuoF1UXTsp7dVaqKkMogLDHL2qtkVLvvbIz7W8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3206
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 suspectscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020032
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 4:40 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From 9931c7726df39e891b45d118cdcad45666d7551c Mon Sep 17 00:00:00 2001
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
index 5a16d892c891..a73c9fbbeb6f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1168,14 +1168,16 @@ static inline int alloc_fresh_gigantic_page(struct hstate *h,
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

