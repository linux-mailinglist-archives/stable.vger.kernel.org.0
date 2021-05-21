Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0446B38D210
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 01:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEUXm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 19:42:26 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34292 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhEUXmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 19:42:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LNdbV4003305;
        Fri, 21 May 2021 23:40:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=zP7w/QDYFkvIww/QtQ3wZfijTqfrhAKPzacskmIkfB4=;
 b=iHs3cs1V6JGD9crfCVVLs50Ws8KOJ/H3Awi6OQHTL0csROR8p38mputV76kZToBbrkwZ
 2G6io3erM6VJXT79goBy0ktcacZV1mgr/JLvmEXXCNM3Jjdy39dfZ12+3D7QUbh1L3Eo
 9idvGaUNZvcNdleWV1Li0blKVED3BsMLh6lOUY3nkcfIZcPkUJquHH0zc5xp3IdWqXx2
 72Yvm4X8XyQpOKeQh+9rQ2zfuvjlSfus30THtUTVAwT/0wuSlbhGo+gTs8OTgFf52PCy
 eVn6yJ08MkH794oQWn+PtGOAsO8Y2subVLuT+QOmHOZbmfdPK2wE2dtiL7Qx/uMZlS7Z 0g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38j6xnrveb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 23:40:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LNUbW4171088;
        Fri, 21 May 2021 23:40:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by userp3030.oracle.com with ESMTP id 38megp094f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 23:40:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQDaW6H0ZjlHrdoHcSv1Alemh9XEUEg2hQ12RmeL8g10smiYjuyLEcihhbOGoC6UgqK0tx3dC69lSFcrEyUbkpaovotWNV5zny323NS0DdaeL6JSPw3ijwXeQcPoQD6/dpkTCbIK+5I6oM8H+tOAE86e9oKr6ofWqnKeuAIbKQWeTKcVn2VbOrKoumTK7uJecZOOaneM+elUGLDwEvuUX3IO8xOqvYWn5zs+JEc43N9HCK1Kyd+UTTCOU11CKVaugG9HRFd+iPMMBIOuJfqr/heiwBmYrWE51tivGDGGvf2VUDRfLkDm+uzfnfMz2eUq0WLhIH/rVMIaUm9WoWeoRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zP7w/QDYFkvIww/QtQ3wZfijTqfrhAKPzacskmIkfB4=;
 b=PZC6djIjJaRtdT0QljytQ+XY7gJxoWfGHidtMvxSD+j1oScOy0QP/CzrikKD8qcT+XY+Jtern8CmSCJHFu+wnI4+l2qi+uI1Ii0SXm2jJOF+OxWJsxKGpL7cY0F6K1Jz9gg4WUTlTynYTHwsSHhrZu06KUBif6FtoU3fBRtPicMZIJwj7yPxCyb9q0p0HgyMt3kXCCGT044i3mgrWibYsO9M0qJXBVTDADNcq7kmrhaI5MsYl3E372aJlyU+rz8G6ATjVGKBaKHKCpFEBp2XQnIH7yiaSAjgSM9q8f7hWAnYCYR+dqAzYXQWgm2uxi59zM7yGMn/4Jz6m7KHK1Detw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zP7w/QDYFkvIww/QtQ3wZfijTqfrhAKPzacskmIkfB4=;
 b=cIS2OzfUUa623wY1rC7GTo52m5NtN/oliQ2pdoltNoh/hjAi0tIblchBK9cLDLHfJsTgNXMC4NanB5/zvprP3j10SdJIJ1dUEPQ+/g2uQ0B4962Nt9Mtugptof/Efr4GXU9L4OT4SGT0T+7KVbBhzN3gGQzfFNYHGTPZSu88GGo=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 21 May
 2021 23:40:12 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%8]) with mapi id 15.20.4129.036; Fri, 21 May 2021
 23:40:12 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Oscar Salvador <osalvador@suse.de>, Michal Hocko <mhocko@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Mina Almasry <almasrymina@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] userfaultfd: hugetlbfs: fix new flag usage in error path
Date:   Fri, 21 May 2021 16:39:52 -0700
Message-Id: <20210521233952.236434-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW4PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:303:8e::30) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MW4PR03CA0055.namprd03.prod.outlook.com (2603:10b6:303:8e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Fri, 21 May 2021 23:40:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6a9166c-aab6-4ad0-19ff-08d91cb1c6c7
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB4196D11BC95A6C7E19185E87E2299@BY5PR10MB4196.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7CnTH7r7rkMa4/yfq1Op/L8b3Y7F+J1LEzHy000D6lYq8wxLQ6Kh5o1vOyBYS9Z7BvTVxYCYHilfFxcwORVHt2Af4d7xnC4EKETBaYvEEwix+Q3DTUfYXw2LCeHKOA+tLG4Ys7USi/nFanQZSLbuyQBGNV6+bhmsNQcROqC7QJhiytRccJ24mYiFi7lfYGkSnYDPHYPD9OPpfAsrwaO8tBQfa9l9HrT7i2BHh9KWJYm4unDZ1vKO3vLYoV5aSZN7sKYB70aP4FuzhpTYxYRM+/MXHAOaB0DtganBLg51JLIF6Ev7WLdHI8VmGEwo/8Bct7Rj3pZdPO+Ptfs+cePTnUy+SOPF8IRJPqRvWLGnVpCAM5KPLN9Um1Xrbzw0lHeEknwmE6DvbDfpvJsIiDcybFm24FFjQIuH4eAkq6ZUf7mywaMghog+E440zrmXeOmPkTM6iB/3lVJzXpxTk/tHqJtJbWhfgdxLMybV671jqOd1zSWUUrlg3wqVierFO8RenLoRSZH/YLJUaQz9ICuJg99hlkzYBaK97UDpp/J2yWu882wPGl72gJE6ahEg1uH/mTIKXu+hF6UYnfKKhCDUGUytPZbAz9v+I4bg8D4TILEz9dkMnl/FUUIfN66CuYB5D6Y4LtEZku2h1T42FfQrtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(956004)(44832011)(52116002)(6486002)(2616005)(2906002)(83380400001)(7696005)(86362001)(478600001)(36756003)(8936002)(66476007)(66556008)(66946007)(4326008)(7416002)(186003)(316002)(5660300002)(6666004)(26005)(54906003)(1076003)(38100700002)(8676002)(38350700002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Bv4kuuJw3bsufdAqkF2qdM8crtuxBLEmdgKzuU806RkU0gyh1eaoL4UMZtAB?=
 =?us-ascii?Q?MjvgH9tSF3zhFowDiuEfwtNMWLZvB01qRiCG88DJ44fQAlODilM/Io3jWLhx?=
 =?us-ascii?Q?zGHIDmoaZ8KwtI0ovXs7Zx3MQzoEDZNC6Vx/tEq6c+mNSd4FDPkpDnhxCnE/?=
 =?us-ascii?Q?2SvqT9p5qtvKzDk21z9gateXaNnvhkhHXwvPEbOlAMe/671u7Kj9a2pZHUdO?=
 =?us-ascii?Q?KRQY0jjCzlDSFwGORTrIDRM6aQmZi9fgFIWiWs2SJmMY2Jm5GGJMjxyZP9k8?=
 =?us-ascii?Q?ay922jZq8hBBvPgEFRb4HP+VYUP0pDI1qxUF32ooFDf9/tPFFTIOSZfauxRi?=
 =?us-ascii?Q?Jx5SlOzFZU9erC0vCdKBhHkp8DPfyhuaUSPJiLywVKTVSXD1Bu9RKVHFlGhc?=
 =?us-ascii?Q?HNuyhjWBE/ONIQRHj+3I0ffzX/O43Upr53b0z3/MpgjExkz30jDIiORuhSNX?=
 =?us-ascii?Q?Wu7M6Duj7Vau0yfGOcMc30kbodr/E3zqyRtf8cx47Bu9k6Rbo9n7a+0zL2dW?=
 =?us-ascii?Q?VGr1EvOBRQO9zbWcRAxfnh/S4eh4E1L3EDF5lo5TOPODBkeJdVELcGR47KDB?=
 =?us-ascii?Q?mDP4eYSuj96jJlGFctmRtaoZvKk9qUogENJpTLzBxldKh75lbxGIi3y+z/sn?=
 =?us-ascii?Q?aVAVLkBIe9BYVFCUN1wkL1dw3o0iSHRD9RKJQ32VL05ZpB107LaPGIAwcz9f?=
 =?us-ascii?Q?L8UMnqF/VWpVWKpGKsybuJEnvRynSSxE4WPlLjdV8gB/SguGsg/w9tHVX5pn?=
 =?us-ascii?Q?IKB1+RmewnKsbSiT9OwEPMT27T4tiLtnW4WAd2z1m3CoythvrI4HAzDfyv3L?=
 =?us-ascii?Q?YESncWbjj4Nyal0MM455xmF3q6TE2gv5eurpuwviVX1jTVNlUqmy5mEY1FbY?=
 =?us-ascii?Q?15+Vqi+MWrmMArqHIYD1oizG7l3N6tPjM7+gEAlGA5v5mSUeQcRpatV3TE02?=
 =?us-ascii?Q?Pgf+2AQ09wwUWtveA2/FcFMe5r8KydGEgjwb5710Ij6wV05fHGm51F0tlG6Y?=
 =?us-ascii?Q?0Trv4IiuWkfp02SWd1k5Am33bnpU4FwI8at7hOunkohRhUAdP1fOzSZDqcI5?=
 =?us-ascii?Q?lDyVRx9nAJ5reLChe5ygOOx/gBATTYmZfBZYLSBT+rnLDHO8yEaPq8gRMyLL?=
 =?us-ascii?Q?E497hq5qh8gAtnsZAYD/WXAKSTFGma+3YC5ZGCd5plvTb2pQujPt+Be6NhNz?=
 =?us-ascii?Q?2wgnuMN66a5VTIkYCOotee5xltPGXvxtQK0xN4kRsacBO6btnlgC1S11OFxC?=
 =?us-ascii?Q?QF5WEVo6YFMu7qpVxNpHa6stClDXkav8sp5Ticj88BoYkaOYIreycwYTKKKb?=
 =?us-ascii?Q?PzxAuR939HdyN1pZeJ35AitY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a9166c-aab6-4ad0-19ff-08d91cb1c6c7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 23:40:12.0626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nK9XlHD3H/NS0468ZKd415NaiCMbOBgiidWhhgqcGIKvnqFvYFLIVfJr2S+x/K3amJgPwNFRHBPDXpnw2q8Avw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4196
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210134
X-Proofpoint-GUID: VJiTswUfzM3e2LnSCLtp4Zdqd1z1PT2U
X-Proofpoint-ORIG-GUID: VJiTswUfzM3e2LnSCLtp4Zdqd1z1PT2U
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
page flags") the use of PagePrivate to indicate a reservation count
should be restored at free time was changed to the hugetlb specific flag
HPageRestoreReserve.  Changes to a userfaultfd error path as well as a
VM_BUG_ON() in remove_inode_hugepages() were overlooked.

Users could see incorrect hugetlb reserve counts if they experience an
error with a UFFDIO_COPY operation.  Specifically, this would be the
result of an unlikely copy_huge_page_from_user error.  There is not an
increased chance of hitting the VM_BUG_ON.

Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
Cc: <stable@vger.kernel.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/hugetlbfs/inode.c |  2 +-
 mm/userfaultfd.c     | 28 ++++++++++++++--------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 9d9e0097c1d3..55efd3dd04f6 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -529,7 +529,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			 * the subpool and global reserve usage count can need
 			 * to be adjusted.
 			 */
-			VM_BUG_ON(PagePrivate(page));
+			VM_BUG_ON(HPageRestoreReserve(page));
 			remove_huge_page(page);
 			freed++;
 			if (!truncate_op) {
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 5508f7d9e2dc..9ce5a3793ad4 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -432,38 +432,38 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 		 * If a reservation for the page existed in the reservation
 		 * map of a private mapping, the map was modified to indicate
 		 * the reservation was consumed when the page was allocated.
-		 * We clear the PagePrivate flag now so that the global
+		 * We clear the HPageRestoreReserve flag now so that the global
 		 * reserve count will not be incremented in free_huge_page.
 		 * The reservation map will still indicate the reservation
 		 * was consumed and possibly prevent later page allocation.
 		 * This is better than leaking a global reservation.  If no
-		 * reservation existed, it is still safe to clear PagePrivate
-		 * as no adjustments to reservation counts were made during
-		 * allocation.
+		 * reservation existed, it is still safe to clear
+		 * HPageRestoreReserve as no adjustments to reservation counts
+		 * were made during allocation.
 		 *
 		 * The reservation map for shared mappings indicates which
 		 * pages have reservations.  When a huge page is allocated
 		 * for an address with a reservation, no change is made to
-		 * the reserve map.  In this case PagePrivate will be set
-		 * to indicate that the global reservation count should be
+		 * the reserve map.  In this case HPageRestoreReserve will be
+		 * set to indicate that the global reservation count should be
 		 * incremented when the page is freed.  This is the desired
 		 * behavior.  However, when a huge page is allocated for an
 		 * address without a reservation a reservation entry is added
-		 * to the reservation map, and PagePrivate will not be set.
-		 * When the page is freed, the global reserve count will NOT
-		 * be incremented and it will appear as though we have leaked
-		 * reserved page.  In this case, set PagePrivate so that the
-		 * global reserve count will be incremented to match the
-		 * reservation map entry which was created.
+		 * to the reservation map, and HPageRestoreReserve will not be
+		 * set. When the page is freed, the global reserve count will
+		 * NOT be incremented and it will appear as though we have
+		 * leaked reserved page.  In this case, set HPageRestoreReserve
+		 * so that the global reserve count will be incremented to
+		 * match the reservation map entry which was created.
 		 *
 		 * Note that vm_alloc_shared is based on the flags of the vma
 		 * for which the page was originally allocated.  dst_vma could
 		 * be different or NULL on error.
 		 */
 		if (vm_alloc_shared)
-			SetPagePrivate(page);
+			SetHPageRestoreReserve(page);
 		else
-			ClearPagePrivate(page);
+			ClearHPageRestoreReserve(page);
 		put_page(page);
 	}
 	BUG_ON(copied < 0);
-- 
2.31.1

