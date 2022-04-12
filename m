Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED1C4FCEC9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240760AbiDLFTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiDLFTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A864634663;
        Mon, 11 Apr 2022 22:17:05 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C5EdOZ028178;
        Tue, 12 Apr 2022 05:17:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=aBixB9Gkn19U/GK5YkxyyltitqVV2RI2VNC5GPD8voXICsx+iLR951r0S0UO6pCR2wi2
 M0meDlsPSMj3Kq/rVi1dfDyaV/Lgj7m2ienuqmGU6M31vbkgGmG1qz2/IUMdqGc0BL3a
 CjiuuAhwyfU4awjchqvqXW6O19aJ2eDHsK4ZhzPb0LIL9WFNWc1b5mqon30y0dEK0MTn
 yanOtniCgLhKLYfvxhVyAAHV1DIPbLNFv2gZ9mEJIW8a+AKUXO3WIOF6qQMBxIBxKvxs
 q6O+JXFIxkER2mIhnc8FNNpwgla/F7gL0gnzv7PsTHnECo1DbFhyyDZrAHOMv6/yGcZu vg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219we0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GDG9034242;
        Tue, 12 Apr 2022 05:17:03 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9h01ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:17:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h5xijS5Th0JkF43g2KPDkUeiEt2i65wDNxu1PCUywBHTI/QXUxmrKWby7SyNsoR70T852zXj4ArEjZWTfM8R5JaysdIe2n4/GUXdcy3GKZ5i7x/Qp196MX4Ek7UIfXw0v+0S5KT7BMsTLbwI8qkNQ9b0DTMGCYAeD6PR4OfBKumYlzrlU4409kQo8dB0j4G2j/+SNVlsyD952W+RzDcVIt3tlpHxvu/+JbaI9zr6MTETL9av0o9Sia1xTMLg4ok4bGrL9iOWwY0HftuLruwj9zt5q98n+FPEp9DIXaf6Xgpkh1QAXKjtBZrW4iGt5a3h6SoVUr40nMkIX6zTSG6Vrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=Yq/DMCl6XM8i7GbT6RsfGpZPJbANEozGCJpZCLqtdhx1dZHIGb52sp+UDFR8Q4dfwnPT1If+ZPsPg9CHa189iuSzFVkUJwInMYknZLp8lqLjeXpMkxSWFyk0SnW4IpApraZCkbomKGQ/aoP/llgoYpfN/+aUm+3NZUtkAX0nwLv8/cyUaudEDu1GDT581BzcO9tg7tS3ueliKB9E7I3JExQq+sog7AQK1/35p5rYFRrDEiyJHmgfCTtzwbtLKgCectjwQi+uOCb1PYfcE0CIrFg064vpQPlVhYMWULdiCuIIQ577JiPDn+X6P3tjSKUqLtpm9SS5BWxQH+7Q1yDHSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rM2OYNDnjOSXgpIxpKd8yTK/tasdQ+W01Fq39WF5u3k=;
 b=PLlLcOPjm+bcfJkgfdSdtNmtkqvDbAywOeg41xaPAAw8BPb4He6PQ3I5UK2kU+1DpNY0DClghVpyThNdei3TW5URR1V4O9i26QBnV0/5/kGxgIl93QeoPSVfzJU2yQBvK6GN6tKlmm6ZJEwrE5cLVprO3VSI1ox/5Rxjfs3ugB8=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:17:00 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:17:00 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 12/18 stable-5.15.y] gup: Introduce FOLL_NOFAULT flag to disable page faults
Date:   Tue, 12 Apr 2022 13:15:09 +0800
Message-Id: <f9b38b8c230b3c460e5f7fc4562c35847a8cd624.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0113.apcprd02.prod.outlook.com
 (2603:1096:4:92::29) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 073872d8-1bb0-44d5-d47e-08da1c43ac44
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3329451E71C8C500EABBA151E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LkJMzihdX0jj5K1d6Sy0OjuGJ6VkfFk1EjRKJGpgkqp79I1rON4Ie6HEoEJxQSYVV5uDOsb4mUogV11bOwYFOQeHyNy2S4VUq5LyU0DolufDpG2Xgj3z8sEAoVFLtYPXgzrxG4HvX7XKaVNkUhucziFve/14EbdALUixxglQm9YI4z3A+D54BwQ4/ucO9cuBMLi46jlD+sgJe//rwzmRD7dzgSNDaOXwfELPynDkSuo+D0qBbOCqJ3+RziPeoKhCeTQ7mXDeklcqrGfvywNX3Ncg3wrpM/dxRDTJoFI79dPdhUsLpvJrEsyBvyGQegvX3MYweac3pvBv5iJn/IfnhQCP9E1oETX1pdlNk8HSI2DPFZAggE0naazwnwWpYlgo0cPsf0FSU+a1BTyni6oUCCw6LNdtzTk9EdZAzUaJ+baK5cAQp2QEpt2XB8/levsON/DMDtBdrdpsX916M/VEIVa84/d0sG4fI3Bz6bedJ2dmJ9Gv+uXTNNL5344sf4KXFqZLKAMsV0Tz6d2vJvlQjR6WKbOkYmn/YtjUSRv6wEzmvjRSuu8m41+Qw9MJcE55Df4yJO2lP/D5qS7xyLZu7mozwkuHf8Fy/SeH4RadXSkLsWYqk9wNZSE5+w1EzKtQlANe9GyJXua18i8PyWemTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W6cAK96s0AO/ikHQRP+AiS6E+I5YziHlzmCUTp50vFUH3axzzqPxAKBk1DsL?=
 =?us-ascii?Q?p3pK6gpVtwS5QBWeBArE20onJVTIEfA9NewX5nJg9ep8R4AyRUiLiewarcB8?=
 =?us-ascii?Q?apGfyDi6a6Tisy8Q8mw2IhUCw0PSZEdldZtocN8KLpXTphJb64w9UcZmZ2iB?=
 =?us-ascii?Q?rOtVfFE8zw27UlkR7haEshFYQyitoBil/WmD/ROWSSX7L9kDRZxgh0oiSaxt?=
 =?us-ascii?Q?15ijHRjV/rtIqZfO57vcl2llz8q9+xscNpWEmyzY9bz/ICx0y7kcLhYPBogA?=
 =?us-ascii?Q?eaA2IzEKISGqtx77HhqrOF1f+qt1SgppHZ+A5HoY5Ezg35pRnBjdvzk6XJG7?=
 =?us-ascii?Q?Y/87rYZyavuMVYFu+04rNMZa8trvfulBcj7/H7qDkTP4k3hSWnuVIOfXVmdw?=
 =?us-ascii?Q?NWajh59Pv22l5c1gjQcFnR1VSh1GSVCQziuExwYgMBBlN5AuCqiPU3Ah9RcA?=
 =?us-ascii?Q?NnGM/xR8KQTmR3DI29FF0+2vQjchiBM7oJJqf44P6JR7ReNUff7SSb7tasex?=
 =?us-ascii?Q?fe97f3y77EmGcHYR6w5Rhg2VbUs30PGC1jAuxrCQ3NDAAXGsBUm64hyPWyjG?=
 =?us-ascii?Q?XrkguysQCW91JHueNfKTjrAlti5x6ZX8CMJf19Mr7W3ZLtj1HuxupAcqcU/m?=
 =?us-ascii?Q?TdtxwxQxEAXGgZDntdJW6ajKRfpKsYbJ2du5K8RSx7zNF2X9YNlTt6m5WT9a?=
 =?us-ascii?Q?gDlWRlMUHql767BnRbtq969SUw+0glJbdVDQLk2nS+Zvlq5MpHjkttJOBIa9?=
 =?us-ascii?Q?/vxprGBGNaCcQUcf/bQholZT4RKmIJqMze/E+Yu0NQz0Q/XwU+gS2c1dHKHP?=
 =?us-ascii?Q?MaUje8OOqEuyEeS8vH3VsFDLc7lM4DGcC30Vlb6OFOKbUmKaOaIZDPNULnV6?=
 =?us-ascii?Q?b2eALCDmAUw7b3+Z0//hlkb7MVJTw8n3FYd9J5saeb8inqqMs2hr7Ij2LSa7?=
 =?us-ascii?Q?XKIXEzXGtEWNTgIL1Au1Ons6tLgaUcr9zVRIkVNHF3i2mz1WpuxRn33+cW5E?=
 =?us-ascii?Q?w99YkVus/DiAS7LUUZkdJFM4oajCS2h5A67bDpvHOzqWBdn5nzOumesAICrg?=
 =?us-ascii?Q?e8sLzVgFsrRBK55IP+WBFYNg99Bd7yJZJOqzsglU0it+E5MS6ZgVogfRL/cH?=
 =?us-ascii?Q?cfAtfoJ4f/8bOhn+809uMH20M5KwWZdK6BzFCmBrjKCoRE230JhIeefhvCFx?=
 =?us-ascii?Q?02AFhN3abd63XfCDgR0M338AiEpEvWHYem3gBc1ivoXCCpFEEizh3E9HCP/s?=
 =?us-ascii?Q?eG2UJH13BztGJe6UaIiykE9CZhB/7g2wF+aVGZKia/hZ+Dl6jDpWenkTswFe?=
 =?us-ascii?Q?HHRjhlKXKKI+42YzSfF6TqyVPgKEGwjej6wQAp1J5YvVAnnHfTtNK3RSf+jB?=
 =?us-ascii?Q?aeiw3GktD0ae2MZMXY1otFzI9WHVmud6MMWygpmJ+gwsACWZ78xvcptxs/ug?=
 =?us-ascii?Q?u3aAmx6DHmooR4H0jrMfklDERYu7X8waI9PPKtzqvSJ4VWpY+47HyxuLkdhB?=
 =?us-ascii?Q?BGoNOFLhCF95mVNE4EyzlfpImY2VjdMktu8cgAlM7nmTssT9KzZ3d7RiAUyP?=
 =?us-ascii?Q?OEuEmBkr1f7gVdqVJzU3SIgFtE1vYB91GrbKxYnc66j4Gj/hjvgTi2dfqM5u?=
 =?us-ascii?Q?+uXAP6PR+BFlcTEBTjOn+xxP/J74S4E+tREK9pTyHAmjcfH7WJ5trzhyQp/x?=
 =?us-ascii?Q?D2abCePUIvuo8bUOl96XdAkIv6VwshGt9R1UB9U8XZDcZWCksvO3VTfzDozm?=
 =?us-ascii?Q?d1koCIK4xNXVaR7YCYUVPYpskZKBmT2+oI+dTFaiLL3fWS0SeG+u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 073872d8-1bb0-44d5-d47e-08da1c43ac44
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:17:00.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YraeoAyUnLlzv9PcmsDAWdqOigvJTDmdlI7hI9CHEqGhrX+rsgXYTh5LFGqcCGmM+cTh0YKn/5zi9Wcy14fW8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-GUID: 16tHHUSMzVtWeApHZcZ_HW1CGxTpuvBP
X-Proofpoint-ORIG-GUID: 16tHHUSMzVtWeApHZcZ_HW1CGxTpuvBP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 55b8fe703bc51200d4698596c90813453b35ae63 upstream

Introduce a new FOLL_NOFAULT flag that causes get_user_pages to return
-EFAULT when it would otherwise trigger a page fault.  This is roughly
similar to FOLL_FAST_ONLY but available on all architectures, and less
fragile.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/linux/mm.h | 3 ++-
 mm/gup.c           | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 90c2d7f3c7a8..04345ff97f8c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2858,7 +2858,8 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
 				 * and return without waiting upon it */
-#define FOLL_POPULATE	0x40	/* fault in page */
+#define FOLL_POPULATE	0x40	/* fault in pages (with FOLL_MLOCK) */
+#define FOLL_NOFAULT	0x80	/* do not fault in pages */
 #define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
 #define FOLL_NUMA	0x200	/* force NUMA hinting page fault */
 #define FOLL_MIGRATION	0x400	/* wait for page to replace migration entry */
diff --git a/mm/gup.c b/mm/gup.c
index bd53a5bb715d..a4c6affe6df3 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -943,6 +943,8 @@ static int faultin_page(struct vm_area_struct *vma,
 	/* mlock all present pages, but do not fault in new pages */
 	if ((*flags & (FOLL_POPULATE | FOLL_MLOCK)) == FOLL_MLOCK)
 		return -ENOENT;
+	if (*flags & FOLL_NOFAULT)
+		return -EFAULT;
 	if (*flags & FOLL_WRITE)
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (*flags & FOLL_REMOTE)
@@ -2868,7 +2870,7 @@ static int internal_get_user_pages_fast(unsigned long start,
 
 	if (WARN_ON_ONCE(gup_flags & ~(FOLL_WRITE | FOLL_LONGTERM |
 				       FOLL_FORCE | FOLL_PIN | FOLL_GET |
-				       FOLL_FAST_ONLY)))
+				       FOLL_FAST_ONLY | FOLL_NOFAULT)))
 		return -EINVAL;
 
 	if (gup_flags & FOLL_PIN)
-- 
2.33.1

