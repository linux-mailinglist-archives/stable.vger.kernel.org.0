Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294B532AEC5
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbhCCAF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:05:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60814 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576240AbhCBE0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 23:26:33 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224J9XS155029;
        Tue, 2 Mar 2021 04:25:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rgA/HDQTrecxZx9VfyhNcIEPujdDCLOrcuV5HifWvOA=;
 b=HQyBuGaZ6rreWeQMox+vg+O9TpHBiGKdZFqR5Ku3fwoa5drUTG/+g0TfEE/MIzlrp34i
 KMgXnCOjxQLQ1067ErFe6M/wJ5/Xgk2EBXBKgrjMSx1YjeZB1GWk7JxOkGrwk5KpXznY
 Rz4q4hBvyl6C+y2QYrmXlhEhJkqkE3FD5/FyNg/IRQnpS1tsIp4PxatEqlu9uBECF5YG
 +0S9d1BW23lsLmmEs8ijYJKm1yrwuQSijqxo1UqNv4HesSzKWV5r1qe9y8khYnRo0piZ
 smeRhg4Ccmtbs3oQzsKAGEqvvBUv2fSUTY4rCf80QXCNexLb0zccU44RzwFwdVutTQyE rQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 36ybkb673g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:25:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1224Ostx122299;
        Tue, 2 Mar 2021 04:25:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 37000wf46c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Mar 2021 04:25:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mxubMQ2TwTysuLEcImMUo5rHLeqs7YXdOuETkOh/HHmHKueeMLJTaK9aZ7BEdrg4MFydMvk98YDexHAMnI1amHYT0sfun5ZgpWWSEhjC0T9vRW60NUVGQZvq1LPOziFfmgfHM/CRntf5vJbrLRyzBGDYkTQRfsrNuc33Sc1Ky87TkutfKTr0H3kaYmPyFXUMZIAmX3kfWVVCm+ie5krY48POYb5MXFBQ7pHIhc5lkIk4BSfnhFCvmOehkLiM/QG863ILsq1iY0v5cJvUqerMrurX/RJyfcWRETYvYlStJVZwjhoRYe8nJ15uM/LUVSIdaXHbo93VS2qkqgTRzcZNNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgA/HDQTrecxZx9VfyhNcIEPujdDCLOrcuV5HifWvOA=;
 b=Krb2xmCwt+zkMMNBmbuyI8A6c7kqP7udo/YshL21LyA5AL2m1P5y0sHYoJOhOih0/HbhbAIipYTshVXOYs544AcgbQHrIHbDvEFR6G4hez7Yhs8ARJg2EQeDa0qRuE+KJ9HkKkgf1vN3UFu5u8tRruWS11hWq3eTQPV3MslP4w/2BRNMKdev1IwGu+/GKY0ueA0lRfLrv2NjkfkboaG2X3HtEo2aVovCknLmBFc0hH+RlYVReeSuwlBW1qwLKF/pH4MPv5+9ejYzonUzbBoDzvpZuErlWv48/gZ9momGXT3Z5yd20BrLuvWmP9QYElg84Oj17FTs/7xqw/K6ehhkaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgA/HDQTrecxZx9VfyhNcIEPujdDCLOrcuV5HifWvOA=;
 b=hI30UdfB+JbOSPpk142iRQQismcGGJFINe9OIWQZ0ivW6XDLa3tD621RcTYHceIyIt9ezlmneAW2k/tKiDL96SUpzMFXVYBkG6Gv72rU1thiwo6ziitvHNfg7l1jl+YzuMuYy8QcUmugMAsaaEfjRxDKIyONPjeh8tj5cpixkM0=
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3206.namprd10.prod.outlook.com (2603:10b6:a03:155::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 2 Mar
 2021 04:25:28 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::980e:61ba:57d2:47ee%6]) with mapi id 15.20.3890.028; Tue, 2 Mar 2021
 04:25:27 +0000
Subject: Re: FAILED: patch "[PATCH] hugetlb: fix update_and_free_page contig
 page struct" failed to apply to 4.14-stable tree
To:     gregkh@linuxfoundation.org, aarcange@redhat.com,
        akpm@linux-foundation.org, dbueso@suse.de,
        joao.m.martins@oracle.com, kirill.shutemov@linux.intel.com,
        osalvador@suse.de, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org, ziy@nvidia.com
References: <16146024608753@kroah.com>
From:   Mike Kravetz <mike.kravetz@oracle.com>
Message-ID: <109a4aa8-f832-6192-b194-a6c8857f4af4@oracle.com>
Date:   Mon, 1 Mar 2021 20:25:25 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <16146024608753@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR2001CA0005.namprd20.prod.outlook.com
 (2603:10b6:301:15::15) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.112] (50.38.35.18) by MWHPR2001CA0005.namprd20.prod.outlook.com (2603:10b6:301:15::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Tue, 2 Mar 2021 04:25:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b722f633-175c-417b-c4f8-08d8dd333512
X-MS-TrafficTypeDiagnostic: BYAPR10MB3206:
X-MS-Exchange-MinimumUrlDomainAge: kernel.org#8761
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB320648DD2486EF7F05B857A5E2999@BYAPR10MB3206.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+QiG24zuIciJ1+X3S+e8uV93KIWnqkzt15xPi8J/O3k0Ka1y7ERKGdg0uqE/WWvJaqlfj7MB0v1qp3NzB+iaGNQkde7cemezYXg9RdOkJE1PVXxXh8nCINCMM+WAA+VMpmohwhGMVILe5Ya59/3J6yUg50CGr1ZpGe1pKEa43S7pIelVRFl/FvRTU/Fln8wA0ir2Wkx+CQzq0aRsK640cDG5tyELYoJSE1pj5nQRB9OehrBeeUYzmFy6OMSyOikUt62mRVRfO56N90r68o5tcDvRx/aL4bmo1uCWxpicptCR1mVXYRwidwKMdWxBMLGIk8R3d6KFf9HvcySZeiRTfFCMOPupX/aBM3r6Q3UrRZ98aqV6Ss4TgDi3vK3ji8LRw5kV2TqU/Co/iByoN74SDo11aK5NKn2/YHE318m1cRP9OnFcXY8I9hZDlVd2ThDzQZBT/PIvjmB++gk4qC54TFjXKWpETJ189yc+mtHr57u5BWYiEthxoJhidqW/K66MQ+wG3UZHcDgb5GtF0cSkysvglPtryrXR1JAEjIUHxU8BEI2nDkqxSOmZfcJzUYzz6PAgC0s0fGT7K7MMJDL5TK8cdc21VcoL6/zpzKlgYLEoJU8/SnfE5cBmBsIivGyiPVav2QNGw2hzKYaZs9xfsbnB4eTLE/Giat3mlulowK19DuxofxUbjcht8aWXtDLAKlsXw3/bZ1ZSUgWMWqFjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(376002)(346002)(366004)(53546011)(2616005)(956004)(8676002)(66476007)(66946007)(66556008)(8936002)(83380400001)(31696002)(86362001)(15650500001)(26005)(7416002)(186003)(16526019)(316002)(966005)(478600001)(2906002)(16576012)(31686004)(6486002)(44832011)(52116002)(36756003)(5660300002)(921005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QVBYNEFKZDNBbnZTaXFuSEZiTm1uMEk2d29KcGxkM0RZaGlqUFVCTnViSEJv?=
 =?utf-8?B?MDVldXNFNnlSOUJjTkJVdkR2cS9kSTJBRnlnNFU4VUluQnFFSlVwUWc0OGpk?=
 =?utf-8?B?RE4xVUphNVRmV3dNZmtGTWgxY21ubDdYaUVVd2RSZk5USHFmYzVDektvMGcx?=
 =?utf-8?B?UnNqT002MzRKdUhVcUNQK3VmY2hIRDFKcTdJMyt2bXpIN0xVRURBNkU2OWo1?=
 =?utf-8?B?ckNMa2RrWGlDVkc0bzJqaVhaQ2VRdEwxb3MrMGVPdkFvSXB1cWgyTVNQUElV?=
 =?utf-8?B?WXQzSjMreUFLMktrd1FCRmZSRUZVYVhuWVhyYXVtK0gvWWtpc2hLWFlDU1lJ?=
 =?utf-8?B?NGl5enQ3dlpkckhTWndWTXFWbjlSWVdjZDR0T0dObEc2SzYvSWVoQisrRDhF?=
 =?utf-8?B?YWxndzdlY0R5SWFLRWVpc1dQdE9nSFhQQ2NxbnNLZVQ2Mm5qWGJIbXU2TGtL?=
 =?utf-8?B?dVZ0R2tBT0loeFN6cjVnN2pkUHBkMmdPUWNUNEhLbWlFS21qQnJWRlhXUGRL?=
 =?utf-8?B?UHhNU2x5Z3FVOGRCM0lpb0NVQ1FGQnRYeDNhUDdSY01iTVVRd2g3cklqd1dl?=
 =?utf-8?B?dkZvaGhSSExwbVBjcTdSWnA0MisxNjRNRnB0aFM0RWN4Ui9mMlR6Z1JzeXZj?=
 =?utf-8?B?Ry90bUN6STBicHRkb1EvaVhLb0h1bm85Nmg3ejhUbUZDQ3VjS3VTU2tZVGtD?=
 =?utf-8?B?OWdiRVRLZHZ3ZVYyNTJubXVWUW1BcU1yY0hxREZoTDU3dUpEN2Y0VDIyUmJT?=
 =?utf-8?B?a051RlFuVmd6RWF0OG4zRWNWZEJnK3d2d1BmSXdHQ1JlUzhhY2VQYXR2d1lH?=
 =?utf-8?B?ZU03YTM3YmlSdHlmZXlSOVZXWUZUV0lUM2NGRVV6QXROdEhJdytWa1Q2TkN4?=
 =?utf-8?B?RmJrMFkxVjF5RzduUnFRTmovWUNZNXRocjNDSWlnQlRYRWcrZ04yY3A3eE40?=
 =?utf-8?B?NEdKS1JzZFdCQnRIYm43aGQyMjl0V2FzaVpRYnlNOG9CSmtIcXpVOU1WMklS?=
 =?utf-8?B?RUI5TEZnVW9OZEt3d2hRLzhFR1VoM1A4UDhpMEVtMld4WC81SEllSVNpd1p1?=
 =?utf-8?B?QXNoQ3lxblVNaElZbmkrZEQ2NmErUGZhSGdlM0JDTC9rbjA4ZVNlNGJPYWI0?=
 =?utf-8?B?a0Q1WkFSVE14L1BwdEpWSkpXSGFvL3ZKU1NzcXhyeWpGZW1kVEk4cEhscCto?=
 =?utf-8?B?LzBwUkdvdUVtd1VIMTUxN2Fadmw2SWdWNk5SNHJzSTdPYUFFTnVRUTNnbC94?=
 =?utf-8?B?OHFCZElNSlByNEtxT1B3UzNkQU44UDNBNVdWVkNOd1YxYk1MbVdNb0hwSXVt?=
 =?utf-8?B?NE55WmdJTUFDbWxFR0NsWnRqOEFKTmVmSktVRWdVYjdUTXF2c0U4MTBRNTlI?=
 =?utf-8?B?TmpWdFgzRlpncHpFTUwwQlQ3bC8vUDhZNGR3UjZHemo0M3cwQUVzKytMQUpo?=
 =?utf-8?B?UmJYb0loM0NJVnlWdHQ4QnA5eTZNRkEwMHBvVUNhREpjSkdDMjVVVkNibGkw?=
 =?utf-8?B?OWZrY1RtQi9MZVd3Z08vRS84NGtpWTRrNE84VUFrMEpJWFFTM3FYM29ETzA2?=
 =?utf-8?B?OGRzN0ZPUmFzYXEyN2Q0bFJydWdOQXNHOEJKVTA5ejRzMFZHTlJ2V1dHaFVq?=
 =?utf-8?B?TjZXcFpSVEN0MHN0TG9jSDVXNEdYcmxaR1NqaHBpanh3UmJLQmQwbnZGYXQv?=
 =?utf-8?B?WkVEM1NiUTlzS3ZsNkxQZ1FFY0Q3dFRSKy9jTkRRU1Ayd0xEODZBVitYS01y?=
 =?utf-8?Q?OI073MWCNjdZhRwyO+cOE69lXposhgwtjxe+UlI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b722f633-175c-417b-c4f8-08d8dd333512
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 04:25:27.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +I5hqKrFi8HtiJLdLd3jFxYhRmyPeSlUt/mwAuAi0bxM5hoRa37ifOEseEShVks1rR3J6OvuUbMbMfRzPcAULA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3206
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103020033
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103020032
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 4:41 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From 81d94ecc0850c5badb697b399641433187497eff Mon Sep 17 00:00:00 2001
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
index 5f0d0f92adbf..a033b415238e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1191,14 +1191,16 @@ static inline int alloc_fresh_gigantic_page(struct hstate *h,
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

