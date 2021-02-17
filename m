Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24B231DF39
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhBQSud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:50:33 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhBQSuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 13:50:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HIhrQ1041668;
        Wed, 17 Feb 2021 18:49:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=YrbqfKqMpmcE3gvWEAtP5ZU15hRGe56Dl1Rq+gBAZBo=;
 b=WPtIIOG23auuVFBpRs7TTK3mCNAHYpEjSnbax9pj+vZu2l74/tbAwnCB49kv3MD6k8pd
 97XVsqDL2q2w76DxEEhqA6kCSTOUhiHemHaYEbbbTMCgGzmnSZpOdR1NQZRmo6H0SP0k
 GknrHn8M8VsMAEQ7wF5/x49iF9e7O16/Ycb28A3TVE8Auq+x4k8sWW42lhJMV646jNMg
 7+BomDRk+1e4yj8eEgw/toWOQBipAdbxNVktGP7qBySwOVAon0H/BStZiQLNF2zqq9TN
 t/Oy0YraCU5OCBqk/zw/D+VyX5UB7fMSfqf5ZCdww7IKw4E3Wo4fJzPEepg+vhC0cHCj uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9aay6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 18:49:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HIk7sb061146;
        Wed, 17 Feb 2021 18:49:39 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2057.outbound.protection.outlook.com [104.47.44.57])
        by userp3030.oracle.com with ESMTP id 36prpyg5x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 18:49:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXD5Me5iZDgJ7eZPrZvB8EpIpLbCBKrmDUUh3N+RYFW09YfzbLHMXk8psx/i74G01vvZ0XGzZTz+lnKHIR/MY7DFCtUO40zw4cFZtwPZZkzrG/tV7SqUXwLYnxuihMMv7RQlIsac4WtBN9buFFjxpCnbRBlFRGERa5ktqdV8eA3ONJMeD5xIXan5LA9DmzqOCMnxpOpZsAdXJ0Ac2cAU35Ll3YeuerUam5Xl4bKqLnEi2D9OPWVQe7FuBY0n1//OVoLn9pnZFdYmnPgfvAfbcyCGblvZIvf90H9JssBDw2Xm8NiP1eBu0e8tLNTpbOPMeDl4XGbIJNC1pkS5iSigOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrbqfKqMpmcE3gvWEAtP5ZU15hRGe56Dl1Rq+gBAZBo=;
 b=D3C4DQTAvZ5091uk9k6dZiDuGJ7vAqbH5HzWVau2S5PFKwEhodGT6xhufp6s/DrFh4qClb/8SyhKTati5PoBky/1ObtqDykTpOZF9IrDqLz/o/wVr/2lhGhI7Gu/vIrFXMQ/Ng/rOyESuHGaOrM+hjJyV2jmrYB9RORa5jYXC3ef9nuy76K0Ov92AfNcitPqHlesnFRrdE1cX+JkIRhnc3EoGEMT4/fKbi5amGbXwXMkiuveLdz/LwZrGTsj30WaiZAHiVIdVFbeP66w7Zd/2Ns9w1lELFrPtArj3nr6W/Oa+QIIisWSJP4amEX0osCkauPdmqAmMzT4Hf+N0jTXNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YrbqfKqMpmcE3gvWEAtP5ZU15hRGe56Dl1Rq+gBAZBo=;
 b=ao5gQMqyKRm+rUrgjGHfs+9kqbP5+Z/+UFoqsf+Ee+CczV2QWEsXVyQYeHQTaJXPqm/7tr/tXsofn+ajtEQiU1+UZxGdgbzqWplHyR/cz8U4D/CF9ZKfzouvmXnFb0A8B9feLNjnwc8YNlFxiIufm5pX7YXNUlUjqyjJB4GNmtY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3589.namprd10.prod.outlook.com (2603:10b6:a03:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.30; Wed, 17 Feb
 2021 18:49:37 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00%4]) with mapi id 15.20.3846.041; Wed, 17 Feb 2021
 18:49:37 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] hugetlb: fix update_and_free_page contig page struct assumption
Date:   Wed, 17 Feb 2021 10:49:25 -0800
Message-Id: <20210217184926.33567-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.29.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW2PR16CA0050.namprd16.prod.outlook.com
 (2603:10b6:907:1::27) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MW2PR16CA0050.namprd16.prod.outlook.com (2603:10b6:907:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 18:49:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08a07dc0-f47f-4370-149d-08d8d374c65b
X-MS-TrafficTypeDiagnostic: BYAPR10MB3589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB358959A1069D6A90D06C1FCDE2869@BYAPR10MB3589.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XqIiUK9AiB4tRhs3QNOjIP122WlBy5VzRZEqPaVIkBqhsVKcBR395j05TQDzF6VWBqus1UHCJm2+PBS7FwLKVOINqQ49ylEvRZuO+nQ/evTDnreGQu3xJX1KhGvzJaubI49e0GXAtUYlfyxymo3IkO7O2o2xkKLc/zRfaGjSY2/LdPlSq/NgDyPGXQoD517Vcr5tFCUQKtxQ2So+AXTLExchd0g1+mwvJVGmD5nY7WnQ4sLLDdAGspDqeHH8YTYqOIaojvSYP1iLKgma6EfVxFVVaDfe6Z6iCs0Zn8/lprAkY1QtMtWAV991lZ1JB9ehkh1urYpfvVzo0e3B7ih1depkxmjKCyLIfM0Cx971gHwfxy/dRxEaO/j5uLUZWzUjygj2gQiVOENgSeEYH78qVpHBp7v/i5vbZrLVXq7LpaVV89vfnJfvDG+0Jq/HbbXOxn2+b7dPsjt0EyjvQSNHihiOZLXV3wquN7O/Pa4xJXlNoA7PQeHinQaJ9qi2NZ8O6MRll2+IP/eCi+QvBgbyBh10jQcnqcRORm9NpqXeDm53EmmWWYFWmn+Q5LjslowC+d6IBy4qJB7sTKXj5TGB/1q5hq3XvMi0dfAgciHGptg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(39860400002)(396003)(376002)(1076003)(4326008)(83380400001)(36756003)(6486002)(186003)(6666004)(2906002)(26005)(316002)(5660300002)(966005)(2616005)(54906003)(16526019)(7416002)(66946007)(15650500001)(66556008)(478600001)(52116002)(7696005)(8936002)(956004)(8676002)(44832011)(86362001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dkxZR2t2WjR3TnRlL2VxejJScjlCVE81d3pjUHI1Tmo1UjVMRnB5S1RSNkNx?=
 =?utf-8?B?SjZsZTQzMjN6SHJtMU9KV2dBV3ZXZ1ZKMFliQzNsQW44UUtydlRhZGJjUEt2?=
 =?utf-8?B?L1gySzJMNW05UFZLZHhnd1hxMjUxYU9tc2xwRTBQVjF0Unk3U0tWZytlUHB0?=
 =?utf-8?B?VFNTLzNaamlxUWxNQk1tRTVGSlEyYVFZVWpMSHpMbmFCSkZyODYzUG1CR0ta?=
 =?utf-8?B?eUNveTUrSTcrUkhRWHgvbkFjalBxKzNsOFMyZlNsbk5UNi9uWHhZN1Azd2V2?=
 =?utf-8?B?c01qMkhoWUxqY0tnajBjZE1TZ0huMEVkR0N0TVhSbnpPTHNxVkt2Yy9xZ0FW?=
 =?utf-8?B?R3duZFMrVTd6MFlpbXpXV3d5cVF5RmFiUk1rL2NwNHBPa3BwVzVNVjlldUNO?=
 =?utf-8?B?VUxlSE4yTVNSRG84UVFqSXJ1M201VTdPWmJDZ2F5MDlvNTJOSzBEcEozd2tU?=
 =?utf-8?B?SFZVMytpaWt3dG93ZWd6ckF6VSs1NkJQbE0xbytRVGgwMHpkZ250ZU84dThp?=
 =?utf-8?B?WmF3U0hhTHVBeWlhTndoVjI1UDFmRmF3ZlRZUHJsNG43N0tJNm9KSjNUZHcz?=
 =?utf-8?B?VG0vdTd4aDhNTWViNXVJczhxUnN2TFJkLzQ2OTZlVDlFdXRpTW9HZG1HQmUw?=
 =?utf-8?B?TDRnaWN1RHJnc3JMWDZWbHN3NHNyRjFXOW5JK0xiWnBMcHhKQ3VkUlp2Q0tD?=
 =?utf-8?B?U2JHT3hwMXNXRUxDTWlEaEtVRE16U1JMU0RqOVdDSGRONFBiN0JIUUlROVdP?=
 =?utf-8?B?TEFvQytEWFlGd3JtUkNzaUd5OThYaGliUktJZHROTEdJdU1KY0QrTVA1eUc1?=
 =?utf-8?B?UVB2Um9EVndSUjhtdklhVXhXcC9aUlZqWnVkWmpmaGhtcVk5ZzZadWkyR2RC?=
 =?utf-8?B?NzU1ZnY1S21XSENBUHdnb2FSN3lJTG5sNlordDFhVWpSeXdDZTF3S0NGYzNS?=
 =?utf-8?B?cmVMME8rcnE0NDd2N0Q4UGNWUFZlQkowVTZyT0ZvY1FrVm80d2V6N1BPdFlj?=
 =?utf-8?B?aTF0VHNFb3BrL0ZnZUFkbnpqVklib1FkbVFUUFFHNUU3RHloeERFT0RNV1FE?=
 =?utf-8?B?dDV3R01GMHV3WmdmYzZ4QldpSzZZb2YwOEJYQm9tY2k5TkRJbTIyODlybnNm?=
 =?utf-8?B?MTIrVWd4OXJOT21XWDh1ajlmMExoTFFNNWdJdXViaVFPRkZocWsxMDRoOE9m?=
 =?utf-8?B?NHVzakRIWGVKa000dnpPTTgzN1NKV3ZOSThaWjJTR3ZMMER5MlNoaHNqVWdS?=
 =?utf-8?B?eVQ1cWRoem5iM1FmU0x2bzBKR2FubjRFMy9IVXcvYWlyZUVJMEpsMmlpb0F5?=
 =?utf-8?B?bk80QzdtNFp5UkZvT2J0Nk1PS056ZkZscXRIQ1FPeFowZ1VRSHd1MFRUbHBt?=
 =?utf-8?B?RXhxMTF1R2FwZUlHRGNGeWpKTHdZZVhYSEpwaU5LVFRmTm5vajgvQWJ2UGg5?=
 =?utf-8?B?TEd1S1EvQzBxdy8wQmV5aTZ3RDUweEhxMURSKzVnaFc2bVN0WTY2cmNQVTdh?=
 =?utf-8?B?aXg4UzhDRDJJOWdJQTh3K1dQRGxtTEl4dktrNUVHYkhzV1J0Y0g5Z29JRS9W?=
 =?utf-8?B?VzlqNnkzY2JpWmZkbkJTcUlLbmpJNUlBTmQwbmdaL01ZMkgvb1JJc2o5M0FM?=
 =?utf-8?B?ajRibWVGUDIzK2JqMlY3Tmo2QzVHejNmYU9tdjI0RExXNzMvRkxaV29KSEhQ?=
 =?utf-8?B?enAvbmUwN3owOGVhVEZCYjlHUXBqay92cXRFRXBsVVh0d2JKdjhTS2FjOEtO?=
 =?utf-8?Q?HqxhqNQzyPH+IdUqXfsAhCYGlZZUy7FCxIpznOj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08a07dc0-f47f-4370-149d-08d8d374c65b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 18:49:37.3277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrp7fCGvrEBvXH0d162YCN58kGFcC1ODWOX9iyCiumsEX/R+t24tLqDYdCQkMVJE67gRMk6SbzQ1qspLY2Y24w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3589
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at runtime")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4bdb58ab14cb..94e9fa803294 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1312,14 +1312,16 @@ static inline void destroy_compound_gigantic_page(struct page *page,
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
+	struct page *subpage = page;
 
 	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
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

