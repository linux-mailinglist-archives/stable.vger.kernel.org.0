Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAADC5BF461
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbiIUDZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiIUDZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:50 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C02F97CAAE;
        Tue, 20 Sep 2022 20:25:49 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO34O015081;
        Wed, 21 Sep 2022 03:25:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=ZkCe9N2ZJz65yxvZGX7tb6M6XsiE64gQcNh1yxEmgWKyUsQsGiNFEfyKM57hXHyYWBPW
 INdYVeBXEMhBImD8vnpp83XwTrIjFf1hP4waKBOMJr+kqRKO+HLj4nFz2UpjhlU9ARYB
 f44mRyriwNTfOQ/hJvq1Ht5PtoPmZtti6UbRVXphBguwO5DSlLnGXUV8Sio/E4/nXt9D
 iZQL0gIYITNmj70iz2I3t6l5n2XnYs2oMIr8LBPCJgtLppW5eobOO6sOU90b3GGbdGuT
 mNZpAcZF+TcSzCPAeTZaAxpxihYm5wiefcFCaf/GANhHbOyW669w2r4RuGfSwbhOu2pE aA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn688gpbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:45 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2Tn0J007987;
        Wed, 21 Sep 2022 03:25:44 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39m016h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDNzE+orruAYRLqYUNV/1gWGZku3hXVZgi2GinBhDh5wrTTMnITj2d/+e66FjUJb7Il8lKfdzOKgVMHaSoadWMkmLBWZp6zUaj04o94E63b4MZ8ANQKexjpDzoS4re++q0BIKVpvY2E1V0PoWsUlaIklibuI+JmsglSrgL5ZfqiLfDAqZJAqoDoifUVceR5sw6Xob3Mo0U8Ez9UgNV18iZ2qlLsPrcNU48OnxIwFlms75zWGJ9H3aeVA76zU/xtzS0rcj107huKPJSy8SBHWqNE0vBD70tPzfbTcwLqhDx0iBG2oKN9TDLSvgOZPHwEMDmDzjnomJ+ZXUoixQ3mgSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=GedkosA6nWGxFqJys8do8yT2Uy7AhE2576CdvGB4ale0yFRKlP4tdhSqGCNSxfTP4j3NvjcJM+CuUYY0nL/loOS9AF5tt4UgZNjy8hMZppeamqFTtMv+uzeE0XFsLRA7JOJcxmyYErFVk+CrKvjFE7tPfF/H85QlpPR0ZsRsUBdqDELTWei2jyLKxpu7uAI6qMgfhEg4+BArjFZOjS53IY7SvRBk+BHcX+saXJfDemcy8M7JQBRceGR7GZCdMNOjGBV5JM/zvsxOmeYvXEPeG2GPJ5LmbuoE/0KjBB8iO12Og9vYNA6xK46TdJhFcccakOtULzXeQpE9K/T5be/JtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kJTQ4b0rmFtBM9yQvp6j02mKmiLabHNLBPVSwginXg=;
 b=CuDoxl4NoCwJo5gxZAXGIXJNJXe6gsv8UnuM08wz3bipHXmCgMg9ZapQ9tRZ7K7vmUL2limY92VlQttpsGuC0xScc0qhiLLbEOjF+Cj6Fa6XoBIXIP7VL/O/NvkWMUrY+fN8r2Np7rgoEhwfhTTqi8H4CbHJeArQtl54/j0xNG8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:42 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:42 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 15/17] xfs: refactor agfl length computation function
Date:   Wed, 21 Sep 2022 08:53:50 +0530
Message-Id: <20220921032352.307699-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:3:17::34) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fe49a4e-fdac-488b-61b5-08da9b80f6ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O1IHeiHZeUf47kLhsHvDSVNoaktzclO2mSdEFh1MgbiHFAtWnYqQlaKxyOCaHn9RoQcrZ0Uf+uQbAbUX6YZF5E0MBt6+6UwagEZSEKifK8J9VUeDmmDeZa7krW+EQJBb5Rq1LqMlNAKzd3AzjxemfROFI6qs2s7qqy9LFvBhGxXTTvhFehwWyP1cRQ29rhUF9GLJWwMkHjb92e9ART8VVFNWfWe0C+P+q9fM5WQp98fba4bnzbbG7s+vdXbhSActL7gp0O8hSalS5PeDXBCV8L55p12Y2b14UsUNy3rx8D2Tt+xu6beOT1vKJuoCnIptghERNENu1G39n9IsGNy5T7QvSKiDf9ik56vMmKDmiyjj6UPFccaKGNE7nXtridubiLyljjB/RGwofYZNiBaG59pKpg6adLYOzZP1b2/2cSemBNOcsjBPLTzi+jXr1YpQbu6dsKe9i1wFF0Em/piPh3sksSjGPzRuXcBuHAKfkoRzCB2JUuJOWAEknxf8kf6FBOLHOzKSEPxNycrO1v9TZMOqZtoPwOrgJjKyPCx000waa2enWM9mIzUVvA5GtHQQu0OiSKAMUwW9mHqbOaijvxnzvEBRTYqAqEGjr1pLhtOYfrSCQpvDUErzsGZXuG710sglpUiXoJhv024DCIkpotmvpwBhhx/dD9hGUcWxdxFeZZnXsJqvuk8yN9gBpezlNtT17UZlcPI1n2pd6eYmPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1kJwOF0979xEpZMZug4WZliXUjvoj6wHITKmRbrQUB2r8ymH3d/m0ETlhFxB?=
 =?us-ascii?Q?oZroZTqg9b0PtQ6hOJvVBnkXF3bvuAuNnMTSr4ZWOpzqBVfmnUHVPP8Haj8V?=
 =?us-ascii?Q?OLSoLIctFqFfwXm1KSsfi9ok+IW6Efp76atLJpWcRM+fBgxqB02MsnVBHvsf?=
 =?us-ascii?Q?m7zkpIw3CIqeJdvt6zG3elddTVyw819ZArH6QTnsyoKT/c0khXNKf4sIwdkX?=
 =?us-ascii?Q?MIK6+iiuk2WR0iSBr6txumxx2GZ2U5KDE6njYxZwhkMnSShBlqFgkzrg9JRX?=
 =?us-ascii?Q?HK8uI90v/QghOyqPHb7Ki775IuVxzgkG9mDCPG4MFRz/Cf1NXF9+sCx8bMHn?=
 =?us-ascii?Q?e+R7JMx5ztH4sL8k0ShQfgzkYmXlwKyGYvBZNwrFJJ9x4JKe7BekeH7/8TNN?=
 =?us-ascii?Q?dJKbSMsAI7c1rcRUHNqrVizXQkc7uIehoDxYk3BdZl6DVcMpCVRXqMbEvKla?=
 =?us-ascii?Q?9B4Sv/GGLOBygXpOV6td93aAXR62fV6Ar2JN+cVEAZ1G2JFu/7CWx233OhVQ?=
 =?us-ascii?Q?BA7Hfko73TWllw8DoiryPhzTM6VKqFIbMnYTc2s0TUa2DSpLzNfP0aF5pygi?=
 =?us-ascii?Q?2X8XGxwLKsdEIczMkw2tr/7Zyh4bsQAUtEx/q95QB0xZAFJ47uYRDLPX8o7E?=
 =?us-ascii?Q?lr3oRa54ow/GdJlb7PPM2zV9fywFCjd+I2ejvFYKUdGYdVDFKvb3/nbNuws4?=
 =?us-ascii?Q?n5ggrS40iE6ObEKqn39ue0yoAmUqig2OaVv3sG6NOPnWlQyor3nVAdsUIHUm?=
 =?us-ascii?Q?Nkd55HP5IgNZ8rvIRkOXyvMR0unnzN4ebaKYC7KD/2LYWon0XxutmxsgcMWQ?=
 =?us-ascii?Q?hEvITJoWj7+hseqFcVXIa5hOxRJxyTZogPwjDhwxMupKsyMBTduaHXoSIogg?=
 =?us-ascii?Q?jCacMq17MSDvl1yoP0RQv8o1cPZSCUVL1MJjnwd6s5HtgO8JZk4segwf5W9/?=
 =?us-ascii?Q?kpvoQ/ZG6EaQk9AMqoc1xC1e5WDkN7ZyWX7ty1XTwQrhLVF3dl5+oKcs0MpD?=
 =?us-ascii?Q?VpyPr354fFv+QJ9gUy6tP/AErbMDn2pza0cUMtZVWe+r52f4/+sKCtary122?=
 =?us-ascii?Q?AdsxI4MjEhurM9ZU8wBoDbUTsWUmFcnWpJdBeQHVeLr03Zai6OfaI7R3XhiE?=
 =?us-ascii?Q?Mmt4MHcS2Yus5J4QRWfz57pdlFZXe/9iTUxFamo4bsEiNSyGx3dSXC2vV6NR?=
 =?us-ascii?Q?Bou6d17pINKOsY6z3aiiAjz+FIIDGSp7J2NIz3A6V8/iU7YHxa4Q+n4FmJjc?=
 =?us-ascii?Q?hxU8r0Oz4TL2VqGoLJL/eJtXZuZ+djidzf6fBvIL7gw7KD47ERiA1O2wfvC/?=
 =?us-ascii?Q?wOWjpz8xNejDILyI41Vw+LWqCHODD3n2q33epib8p4WwDtcHR/0KrYjjMpIg?=
 =?us-ascii?Q?hTZVE95Bd0CIwz1VYd5mrbxV5a65vuYeDOEL87R+AgAffFHDt4vWRy6Xef/0?=
 =?us-ascii?Q?wAYNa0/SHQzAMf7DDHwA4YGMHbvQsqZkEoB8z8BelhmxM4xXvVFtB4M6++ZX?=
 =?us-ascii?Q?naLtDeiNYAcaGDqIM11TbdgKgK77K9Q2ljEsrfjOgEMfp9135oAuonC3i8Dy?=
 =?us-ascii?Q?yX/zT1dWAHa1PX+AHXFtlBXVXSRI2H3jbAhU325dgA1Bb56bELSl/ixF37SL?=
 =?us-ascii?Q?rw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe49a4e-fdac-488b-61b5-08da9b80f6ef
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:42.8130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CMQbYeNZ1mwiA1gZoC6WFgY+pM9BDAVZ3e3vYbDwW1c1guco4X6oRo2b+GgS8u72aOVDuij2SxR3ASNbsKPr9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: eTySgRUfAFBsnBVy80HqS-pqtbQTBVyt
X-Proofpoint-ORIG-GUID: eTySgRUfAFBsnBVy80HqS-pqtbQTBVyt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1cac233cfe71f21e069705a4930c18e48d897be6 upstream.

Refactor xfs_alloc_min_freelist to accept a NULL @pag argument, in which
case it returns the largest possible minimum length.  This will be used
in an upcoming patch to compute the length of the AGFL at mkfs time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f1cdf5fbaa71..084d39d8856b 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -1998,24 +1998,32 @@ xfs_alloc_longest_free_extent(
 	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
 }
 
+/*
+ * Compute the minimum length of the AGFL in the given AG.  If @pag is NULL,
+ * return the largest possible minimum length.
+ */
 unsigned int
 xfs_alloc_min_freelist(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag)
 {
+	/* AG btrees have at least 1 level. */
+	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
+	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
 	unsigned int		min_free;
 
+	ASSERT(mp->m_ag_maxlevels > 0);
+
 	/* space needed by-bno freespace btree */
-	min_free = min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_BNOi] + 1,
+	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed by-size freespace btree */
-	min_free += min_t(unsigned int, pag->pagf_levels[XFS_BTNUM_CNTi] + 1,
+	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
 				       mp->m_ag_maxlevels);
 	/* space needed reverse mapping used space btree */
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		min_free += min_t(unsigned int,
-				  pag->pagf_levels[XFS_BTNUM_RMAPi] + 1,
-				  mp->m_rmap_maxlevels);
+		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
+						mp->m_rmap_maxlevels);
 
 	return min_free;
 }
-- 
2.35.1

