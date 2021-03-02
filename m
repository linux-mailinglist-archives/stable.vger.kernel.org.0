Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0E32AEC3
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbhCCAFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:05:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56240 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576183AbhCBEZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 23:25:58 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224KOLD030450;
        Tue, 2 Mar 2021 04:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pnx7ZV81YJnWtiLQOhmRVW4Ntth+8a9n4Rz1B9bJnwY=;
 b=FhxU3jXjWOqL0QmkRYw8uPqgKvaYX7ttm7Sl+bPCJq2mFsqERU9Rs6kCazvYAPbFgKrl
 Vb7TjdnPAJ3jxJomGtQ3b1fH1ZUKSLKflbDy+W9HwcqgShSwp2rdfF0WRPmTTDnAA0vm
 SNHD0KOJK1k7X0Q1k1xh5HEsky/rNJiCWQ+WlVHjH3ohGKUIJO7sRZvhJdsLaHNXz179
 oCrqgkE/a1VMwwNAzvZ3Pa3InPwBLLjr+qhsz4KV81b5HmO53xTx/rdxKQmSUv3Po+aM
 Gvvw9yWFAEEsg3odSzqtWC/3dCQXRhHyk8aAxrsqGItFXywZDG/QHbl9dnR0G9ypqsv+ Wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 36ye1m62ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:24:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224OuRK128397;
        Tue, 2 Mar 2021 04:24:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 36yynnmenr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:24:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4WtULTa0lfLuUrQ+PhihHjBgOPdF5RmmhUEt3mMsemHl1VN3YqSfqUpaXVx/kpV//OTdI7/I8OM3tYeGhZR+MCXtW3N+Z3brNCWhJ/XgGzDQBZUaPfPx0drOQFCc7A1oHCvhlaXPoe4Ap0+QPEuXXKr20YBzI+U46BydqSG9lf5n22iBkzTc0aA2y0bB2qRSfUObI2bAJ333edjfSgE4FEnAysqqvaDYg6RH3WrPwA/HBRQsyEr0hiErLeJnRPmx2+q+sPmpIWT0JorgyponnyhWh3dWJBKWJ9h5h+f7XITBiTiJs9aufvAqRdNG33VQe13nJwM0PAbl4TtCCqDDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnx7ZV81YJnWtiLQOhmRVW4Ntth+8a9n4Rz1B9bJnwY=;
 b=mTKOOx7e1gR7+Yu+np//naEbMDJkmICtGPRe9uds8bixlO1o0sOi/U1g6s6LRUmqowxGriEb0nHwpbih5obOYVx+I1DihVbiGxQk5hkqi9wCiTg9OZiDt8p37Lcsx2yx2W0aWiAAplAgWScyH08/IUEJJfWborkSpeU0mhllAUozRAVyqJTgB+0nci+jzYceUfl/6E6LlaAJs6gSynGg/Ym5NuPOcb5kROaHrMoGXqDLoWrOx+nq59EGMnhRtLINySLlwAmPdKvOBlgsfZQZltBFBloCKjnkUeJSHJHAA/On86olRIG6n/4kH8eJerBeHwj7ZZFgLUd6vkwpaGXnkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnx7ZV81YJnWtiLQOhmRVW4Ntth+8a9n4Rz1B9bJnwY=;
 b=Rr+TBC6uCc6at0mNNELlG7oXM5ju3dwrY3PNxJaUxYBTCqswNNj3j9OhMymDO+Mlt0giaU/WRP35lka8Pp4KtsmDQrNVTsvgXK0UCMjKgHm1CCCtbZpsP/NeejyzGAKGL6vtUVts28LimeRWnidEN8uCr1CrZiKrmXbtgQtzm2w=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3206.namprd10.prod.outlook.com (2603:10b6:a03:155::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 2 Mar
 2021 04:24:45 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee%6]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 04:24:45 +0000
Subject: Re: FAILED: patch "[PATCH] hugetlb: fix update_and_free_page contig
 page struct" failed to apply to 4.19-stable tree
To:     gregkh@linuxfoundation.org, aarcange@redhat.com,
        akpm@linux-foundation.org, dbueso@suse.de,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
References: <161460246210369@kroah.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <4712beaf-1714-e19c-32a0-ca76d398961e@oracle.com>
Date:   Mon, 1 Mar 2021 20:24:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <161460246210369@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR2001CA0023.namprd20.prod.outlook.com
 (2603:10b6:301:15::33) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR2001CA0023.namprd20.prod.outlook.com (2603:10b6:301:15::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 04:24:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bdded80-3366-4f8c-a34e-08d8dd331b9f
X-MS-TrafficTypeDiagnostic: BYAPR10MB3206:
X-MS-Exchange-MinimumUrlDomainAge: kernel.org#8761
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3206888D5CA9FD3BF7F0022DE2999@BYAPR10MB3206.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wk+rQFPlQT4ob72n+9waySNJpxhTrMweoI9lZlI7ybFHBVlT/3oV32qHJ7NUEfndF9q09W58rVPZ7E42Qlv4wlUhUYT7eVbJqIO55R5gbtnEHG6qFBpDwLJLMkhsF8cz5lltrTPCOE9FclkqKuN+wKWRntnhF1FalmDMWOO4ZR6weG/vbJztjkpQXjjQ6cwW66hgbxxWS53OZCeZqx2ZijvOKJsb+84aHi4reJ1HoPiAVqjVtQwEIG705UNE8DGoXT42MDpI/Pf4sfh+nIsPVAelBBvO3Xd7Jjl5EZE9ZBJYsmmtam/abPzozScVWST9/sCm3UrOHtl8xrs1HH7TSm0u6i5jXQoZyt20apLGVNBU2isNFRD+wPlbS6axtTmtdY5oRCKEO34Ac3xVvEXHGb8T3Cb3o3NT3Bi1Pd3slZQcXiwjHNdInQaiS03esOYVQMq2U/XUkRrgJM0OUNCbponwy9KzExuRR/iHEUSUALO+6snip9vbHwO+IF835U4MJcnGQKVQzepKzbOHEZ0lSFtoQIGmxuv3wwz3Lv6cgU5OnciLYmhq0bmCSV+ugQUt0mDVjHVQBXsli/mwnmwVlR0Mk0T7UaxqECBClivcebg7Ws4+bLQYlwmhHg+gZzU2AjIyiKwN6CDh72zQeFqT0iFN8RD2UnHqK5TkGsNkGXJjojeihNdJFcI2gQ/HnJE/vxIwFpbg+7BPz+GtfkBS3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(346002)(366004)(53546011)(2616005)(956004)(8676002)(66476007)(66946007)(66556008)(8936002)(83380400001)(31696002)(86362001)(15650500001)(26005)(7416002)(186003)(16526019)(316002)(966005)(478600001)(2906002)(16576012)(31686004)(6486002)(44832011)(52116002)(36756003)(5660300002)(921005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S0lPTkJUTUg1ZlhNUWljVXpVUVdlZEFhcXpoRzhHY3pEQ2tVUnZyRDFiOVZK?=
 =?utf-8?B?YWJNblJJNzgzWEc4VEZQQmpvTCt5OTEwenl4QVF0eFJOaElkY0FrZVVvK3da?=
 =?utf-8?B?UGd5dVdXUXhqZm5Rbk1GUVI5SWYwQ0F0MGxKOUU2a2xrc3JQcEk4SFJEOVNa?=
 =?utf-8?B?dElPVEU0WVBWdE9HbUZEQURnMlVhT1BjT2ZYaGd3dG5XTXg5VGNMNUNPVG9n?=
 =?utf-8?B?RzlRUS84UTMyL3VWN1R0SlpZNlVVZ3FNTFJGNWozK0JMTHhsb0I3K3Y2Vy96?=
 =?utf-8?B?dURLVm9nejh5SlVQbGtrRWtMdWk5T0MrZ2xGSHA2MHJTRVZmWUszSFJqZVZR?=
 =?utf-8?B?QzJTSlkzNFkxNTdTd3V2VC9rdXg3QUFxdWtMc0RKaU5pVHJ0TWttcjlOeTdR?=
 =?utf-8?B?cncxRVFWaFNockE1RzJvcWFHVGU4UERUdTNoZytiRXZDcU1FRHo4WHE3eDBl?=
 =?utf-8?B?ZXNQaGRkNmN0cVBlUmY0UFg0THQrQUl1dzFpVEpnRy8wckpiWGU3bkxiSHRr?=
 =?utf-8?B?VXlwalhwK1RDL1Vla3dINmtxSnl6OUorSTN0blZTUnc4ajIrT0hjeEZIbHNZ?=
 =?utf-8?B?WGdmSURJZktHcVh6VUtFRFpYd2lyTnVxaWRPWktxbDl4U0pDQ2o1TG44VkFj?=
 =?utf-8?B?SlFKZkwzWStZOTZZUnR4L2g0TkZ4ZDZYSVNYK1M2ZjJHNWtUc2Q3T3dET1Vs?=
 =?utf-8?B?M2orTkx6aFNZZHRoZlRwN2svT1lnRWs3RWxLMGN2MHY3dFNZUlBEZ0svT2hr?=
 =?utf-8?B?d3oxMGxVcHNzeC9TWllpWjhPZ1VCUmhzaDRIVUhzZnY1OHpCNUdRRDFHSG1N?=
 =?utf-8?B?dkpXU3hVSWVwb1JDZTdNWWtpR01xT3pRMkVlYjBzcHZDbEpXM2JPUG5qOG5z?=
 =?utf-8?B?bWJXSHRLMDVrMndiOGpjQ2d4Tlc2a1hCRUpWNlhFS1I2cWZlQTlINEpIbDBZ?=
 =?utf-8?B?NmVpK0hoN3dWUGVlSU44c2lvQ2pCZzFCT2lEbTdLRVZLVDg4VlkxV29vdnIx?=
 =?utf-8?B?VHROcjVWM3NNZVh6TElFVHBvdmNhRGFIZklFR1VRRTN2K2dpUmtHMWQwZ2pn?=
 =?utf-8?B?Y1JFM25BbUxEcHNYcGh0anMwM0pVSFJ1Ni9PbGY5U0xKMUFLdHJaOXVGN1VP?=
 =?utf-8?B?UmMwYWl0Q2dmOU5zaS9oOW1iNllneGJDSUxod1JpZUh4RkVqV2tJQW9HVitk?=
 =?utf-8?B?em1ESFBkTzBoNU5KZEVwTTZpc1UyQk9tNXJIRVh6ZzF6azR6ZmJLRnJTQkhC?=
 =?utf-8?B?dGhzWTljaFRMYXZ6MjVZTGphcS9kVHpSYmZ3VjVSbU5ILzRuWGloaml6MWxw?=
 =?utf-8?B?aVZnS1lKWnNMWGZhUVZjSTZBQUlxQTcxOTFqa0ZjK21TUEEycjRpYUNZNkZT?=
 =?utf-8?B?bDJveTRLaFBDRkFuM3RUM3dMcWZGRE9WcHF4OEJaVHJteW9Dd1NkSUJRT1Zj?=
 =?utf-8?B?NG1sc1AyanYreGVmSTBIK2RUaWdvTzlWbUllSnBKa1M1ZHp6TERyYW0zNmhQ?=
 =?utf-8?B?NUw3S3VqWFRhaDR2R1hCbkUrUm44M2xCSHlaWWcyM2NNSkhUZTZKalZNZzY0?=
 =?utf-8?B?SnVjNkYzMWQyNjF0OHc1U2EvWVA3QWNOQVo0WVZyMk5qRUVLTjVQTHBBNDRw?=
 =?utf-8?B?eGxuYUtmWTdoay9SZE9ndHRPM2xiVlBLZzNsZDNrOFZPUGU0ZG9tVVlQbEZC?=
 =?utf-8?B?dHJoRlhrMlY0dEdSeGRHdjNockxVeU1vaEUrdjdMRWlHOGtwSVhnckFaV1gy?=
 =?utf-8?Q?B/hqU9ybpbgUpNBKDkx+I4eXgWSaH0r/etblFYa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bdded80-3366-4f8c-a34e-08d8dd331b9f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 04:24:45.2140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFPoD6L0acEdLBsWEj2LKxpGtOQqskanK97PemYpPpWmz+wmZCwvmar2acszGpgUJeeBm6cwjrm9sM4ulyYDjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3206
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 spamscore=0 bulkscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020032
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 4:41 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.


From b6dec027a8967feb788e14f3bbd57f318005001f Mon Sep 17 00:00:00 2001
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
index df89aed02302..49026c9f8570 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1171,14 +1171,16 @@ static inline void destroy_compound_gigantic_page(struct page *page,
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

