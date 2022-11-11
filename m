Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A556C625249
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbiKKEOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKKEOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:14:12 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4D626E;
        Thu, 10 Nov 2022 20:14:11 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB46SCO016433;
        Fri, 11 Nov 2022 04:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=igfgocxERVDzy9A8GoJMc/ONZOx3F4M8QXfRO2snhZc=;
 b=lLptfoGsAMvnUKda5Q0f+yLs0yJvofa9fkOxbBwc328nXHxDfSCbFWeO+U4q0XV6EH7w
 J0IdGihbdpnewUabxECORs2/7/fbkMIkFn3BhpfLOAB3VBBwAowi9y6TIrvs0T+2HVil
 dBFegsXvhBIK4ckJ4D102YnDSqMwFDmofmQ6QLJ2EBPIH5SyXb51fQFvcMvWCXJdSll1
 zw/geOdGiOWLCvB6EYH75Z2Wc3UKy5ongUxdn8g8e7Z4V342ajX94zXvRrUijBavy+6f
 Mhu08frhzMCwIfEAnwA6batBQxvttPr5M+2bc7LfZVOykvnPofPsrim29maeeRZ4qREU Eg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksea2r223-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:14:04 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB2avlQ019832;
        Fri, 11 Nov 2022 04:10:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqm126r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SN4L963RVQW1mB8FII+Nqzll1OFfEWHB3v74AhH/9k63aLgHj06i/lhjGSiUQzXFQv2hLPgTjmrBzZv8wqCFNvEBOEQY4Nomt3iFdmpWw+NxmqyCVBkRwfEzAcypsAH1YqiUouCaT/ld2HR1K3UoRA8E8OkA3PyZEJzXGGeF2+FaaWH6qGOa+Ib96guYOe8dy3YYcBOrC4f2dsOuIyYx6jCgLAG9ubsdZ98gPtlqzv9mXU+NXtegM+rsOYo6QfRlsl5Dj3xykbHfaos7OQ3eE40MX673n/CcsB6WvJc9ckJBu/6ccO1JXBQoR0ugs30UeUvKo9i4VhXKd/g62b6Kxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igfgocxERVDzy9A8GoJMc/ONZOx3F4M8QXfRO2snhZc=;
 b=VD+TKJhk+W4ZJ3aTO9WpK51WhqarsETaBJTwjCPhmxgaph+qHHTfv+AZ22Iq/sNsbCqIKAEikhBLP1/ViCrvgmSg4tTgdcxltwE87bzU6Krli6Qs0gXmTWeSW8le/VqLoJWB7HWWXBIbbYto/lrwfUrx+ZxWAJh+zCszjPadikvo9aeq6A5W75Dw1Y4Jmcg2+CF45/5IFjxqZ+sBPeq1W7CzqfOos47QcyjL3VIq4YDazMnSkYLT6gvLR8TAoy3+++VSbxQxnthWsSqs6jvDfC4S5W7KCgpNdY4I8EtrHx61+SNtceGJF1GsfJrxaiI+9AMlN1zE0Nei6JGHEVIi9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=igfgocxERVDzy9A8GoJMc/ONZOx3F4M8QXfRO2snhZc=;
 b=OQkkGe8DWwV9KFF86Rz76pnJ++6EdDjN0GUI0qcult/qw44Ooy8tFe3qEbkUN8pmwtQiegsc787xJaxghVKP65brF8dzWXdIiUekE08QGjcFwGxkP+fuDcUSXZePWHSuq1emRUmGjiAtrcU3Bfx7/XH87BV41wIxOGR4/c9S0dg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4730.namprd10.prod.outlook.com (2603:10b6:806:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 04:10:38 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 04:10:38 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 1/6] xfs: preserve rmapbt swapext block reservation from freed blocks
Date:   Fri, 11 Nov 2022 09:40:20 +0530
Message-Id: <20221111041025.87704-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111041025.87704-1-chandan.babu@oracle.com>
References: <20221111041025.87704-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:404:42::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: 3289413d-c544-4be7-97c3-08dac39ab06e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ruuuka0VsVQKB9Z7PNyx47F/GYr67sYcVB1xixwQMTBbPWUQmhICkiVaNhy5Jqd671CCzmHFZQiLUnwJJlUHfiECPzj9GpxLQTazdvOAH4RlX1QjhMofe7K83lxLZ+TP9v4bfngd2y+cOKqTWFAlxV2qTDN54hnzHT5b8VBSKDmO3ru+z7sllR1M/71orRMmmy5BIHb7x5u2YlyK5mV6jYwMLiwNC1Q9ctvoX1JY9IpFLWv2EzOtcoFbOe5UmE8W/yeWniBMkSNgB7U2fBcUd8ZPRZnjrOiL7x8TlCx8qeRqUBBy1MwQsinPYTSirUVL+pVpXKx6dkqinY7FeY6vbU+c0SuexSBk9Y33AoeL4U6yhAq8KKS7B+eSCVw6GRHu6XYiXzVPIxI9GvO3Ut8gaWihQwU0yT2WPFhffaK9yMzYQLQ9fzUOK5ehh9qRK5gguub0iCBzszmlWtVzBnba77M+fkDLqQpRL69UwMl6UCw3GVqagDnKqg9Nb4YBGWWLPF4nYCjVgsY50X+IVRs3gRHEH2zTXKtKxCF1K/MGygcOcG0wUERSRkvhv3iLf84Q3gljCYHPPwSDiIgK4GooLQKVeUjpHcx9qNS1dfEElCCwkHBqe6i3LMadJDx9rjKSU5bLsokCzYVE6YNtPlIOWpM33fc7y773Ny+enymwq0gbQlvX+99Ewm3YlsuK+8LVdDD28Ehom/s+MOHpHobdhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36756003)(66556008)(6916009)(38100700002)(8936002)(66476007)(5660300002)(6506007)(66946007)(8676002)(316002)(2906002)(41300700001)(4326008)(6486002)(6666004)(86362001)(2616005)(186003)(6512007)(83380400001)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cm/92TJzYW5XJYkMNeMtbI3W3JmtEodkFvkPjS2M1CXjw44Sz5xwuSWld2cl?=
 =?us-ascii?Q?Et8o+fpoj695hpXZBs0EUtqjNJpmRTUZEWjTc+YZTxTrKy3DRu0BrzFaX8W4?=
 =?us-ascii?Q?z94GhDTl4ycTG36IR73yggyKCE9HJ++31k4S9Ythxu1u3EmjM3u93dx2t03b?=
 =?us-ascii?Q?p7l/ooetGmZooRLk+UPfEBQywQJrDBhz7l7OzsGCEnwPIxxz9oyZiHQ5bAFu?=
 =?us-ascii?Q?G0G3asppA+8BGjgDEOu3M+4XBByCaIGfS8LwGhPPg/AGeGjMW/3aMFcnwxyN?=
 =?us-ascii?Q?pcGLJPNL1q1gh/DwNRKt9BMpL9qQjfKzcwwtjG+OUF+7weTkTNKWDJ+fxFg8?=
 =?us-ascii?Q?DBsDUXbSo9OwqDMAcbdY8E5XpRbAfzDofcnTcD1drSTTLXvVXv+FHVAgiEqb?=
 =?us-ascii?Q?HfP1GyAsRs1EWaPxAwPb0u5RNpGjvDHxzF23d64o5Re92mjWUoYaw9a3ScaL?=
 =?us-ascii?Q?7BEk9t+332PiRr4zCwtkzS7+DgTEvKy99bOa7hcAfP/A+EHA5DGOHDnjUffQ?=
 =?us-ascii?Q?iYUYCTQWHWkJqMNAkiY1lgla0u7rHOpAyWEJwluwC56IpuAh3EDXr/Aa3XtC?=
 =?us-ascii?Q?odF9knFrCEcw7ZTtJoLf1jLGXYL+kxGt44PFEwC7jlScOiFMAbJiN3/88vi0?=
 =?us-ascii?Q?wzs6N3Xv2o3OCBJKgFhRC+vGRisqwk0I57hMMGA7wd0c1+BXPBfYucdPTlsU?=
 =?us-ascii?Q?U+ChzjwFZMJtijGrTbc7nGmtKAI2r/8mMpLfu+nXvTxXVv61sZMN6MEkxcUY?=
 =?us-ascii?Q?25CrWUg1qLBTx1INgbTGnx6h+zZu8xuAltIus5Y4vFsu90tcVxN59bYiVv6k?=
 =?us-ascii?Q?Rl0isRpAF2vUNqUpE4jK4fjYyJbbgdfJc3UshiQ038PF7RDP6T4tUEwtCLJL?=
 =?us-ascii?Q?5QXkIexmYCyskKwOnMNOLD3ypuPvmN23Ut8GoJ1lGqZPiRHVjhw8D23FZW7V?=
 =?us-ascii?Q?Zhc8ieaWliqsy8JZCU7KPUwxGdVuFdZIiXG3bkQa0J/kZ48DeZkwtwLMwRIT?=
 =?us-ascii?Q?ed9P7IzNspeODFbpMSoiUG5a4Keto9oF7khAlHEh8UIpXncPLNBge8N+jtCj?=
 =?us-ascii?Q?t96EuCD+JkX4VwklQJlTIhD6U4a+ojw//v60lapUi/TbR4R9+fkF1lUh/7YZ?=
 =?us-ascii?Q?cr9hrIaAU6WnyueUQkJnByzZqDuUF+k79bhGzbaZA1b70GaCNEvWiKSqlZti?=
 =?us-ascii?Q?45Vq9lzk5Dx1BHWcqX8+sOxXVMtxB1SUU19rSbD84pr4x9wgcDYn5f0yTzNN?=
 =?us-ascii?Q?Sd+pdHSYJ3eAPlrpY2XBFIay9FSPMZohDILdymNlSQCOEJ/2urwaw0pJq8Qt?=
 =?us-ascii?Q?ACnSkoT3FQ1bllzb3yM1Eb/pBVtI4NgDB1Jgsqv2OsMZXWnUa9BHyCKXa+eC?=
 =?us-ascii?Q?Amg9lVH1VG6R/oLHYdMnssjDPn8n8823ewIpQ0/UF/8AShuEPNkyaElCQCwB?=
 =?us-ascii?Q?pFIVkV5uOtI8K/Bb1vLn8s8mdFJakmuIMFDsENu+dJAlOCN73XqDYPvBnz2x?=
 =?us-ascii?Q?D1OpXUGZSLVfNupp9Dx7AELU9oTyK7UK/FK36yifb7sKhd0kpHup9cE5V2VL?=
 =?us-ascii?Q?6i/5u7qWdChBFK57s3qX+IzsGbzkHr3cq1PFXE7k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3289413d-c544-4be7-97c3-08dac39ab06e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 04:10:38.0963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8AWGa3JTuSTEwxRysbovE1SH5vIIUm0oBQgrdRibvbX2UIDcWYXA9uIluzDrh4fNqvLX2tPgSKfG4BLYJO9jlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110026
X-Proofpoint-GUID: FBqDjiBV2wDNa0_Ky6Pgg3ISArvg5VwL
X-Proofpoint-ORIG-GUID: FBqDjiBV2wDNa0_Ky6Pgg3ISArvg5VwL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit f74681ba2006434be195402e0b15fc5763cddd7e upstream.

[Slightly modify xfs_trans_alloc() to fix a merge conflict due to missing
 "atomic_inc(&mp->m_active_trans)" statement in v5.9 kernel]

The rmapbt extent swap algorithm remaps individual extents between
the source inode and the target to trigger reverse mapping metadata
updates. If either inode straddles a format or other bmap allocation
boundary, the individual unmap and map cycles can trigger repeated
bmap block allocations and frees as the extent count bounces back
and forth across the boundary. While net block usage is bound across
the swap operation, this behavior can prematurely exhaust the
transaction block reservation because it continuously drains as the
transaction rolls. Each allocation accounts against the reservation
and each free returns to global free space on transaction roll.

The previous workaround to this problem attempted to detect this
boundary condition and provide surplus block reservation to
acommodate it. This is insufficient because more remaps can occur
than implied by the extent counts; if start offset boundaries are
not aligned between the two inodes, for example.

To address this problem more generically and dynamically, add a
transaction accounting mode that returns freed blocks to the
transaction reservation instead of the superblock counters on
transaction roll and use it when the rmapbt based algorithm is
active. This allows the chain of remap transactions to preserve the
block reservation based own its own frees and prevent premature
exhaustion regardless of the remap pattern. Note that this is only
safe for superblocks with lazy sb accounting, but the latter is
required for v5 supers and the rmap feature depends on v5.

Fixes: b3fed434822d0 ("xfs: account format bouncing into rmapbt swapext tx reservation")
Root-caused-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_shared.h |  1 +
 fs/xfs/xfs_bmap_util.c     | 18 +++++++++---------
 fs/xfs/xfs_trans.c         | 19 ++++++++++++++++++-
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index c45acbd3add9..708feb8eac76 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -65,6 +65,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define XFS_TRANS_DQ_DIRTY	0x10	/* at least one dquot in trx dirty */
 #define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
 #define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
+#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 12c12c2ef241..5eab15dde4e6 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1740,6 +1740,7 @@ xfs_swap_extents(
 	int			lock_flags;
 	uint64_t		f;
 	int			resblks = 0;
+	unsigned int		flags = 0;
 
 	/*
 	 * Lock the inodes against other IO, page faults and truncate to
@@ -1795,17 +1796,16 @@ xfs_swap_extents(
 		resblks +=  XFS_SWAP_RMAP_SPACE_RES(mp, tipnext, w);
 
 		/*
-		 * Handle the corner case where either inode might straddle the
-		 * btree format boundary. If so, the inode could bounce between
-		 * btree <-> extent format on unmap -> remap cycles, freeing and
-		 * allocating a bmapbt block each time.
+		 * If either inode straddles a bmapbt block allocation boundary,
+		 * the rmapbt algorithm triggers repeated allocs and frees as
+		 * extents are remapped. This can exhaust the block reservation
+		 * prematurely and cause shutdown. Return freed blocks to the
+		 * transaction reservation to counter this behavior.
 		 */
-		if (ipnext == (XFS_IFORK_MAXEXT(ip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(ip, w);
-		if (tipnext == (XFS_IFORK_MAXEXT(tip, w) + 1))
-			resblks += XFS_IFORK_MAXEXT(tip, w);
+		flags |= XFS_TRANS_RES_FDBLKS;
 	}
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, flags,
+				&tp);
 	if (error)
 		goto out_unlock;
 
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 2ba9f071c5e9..47acf4096022 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -107,7 +107,8 @@ xfs_trans_dup(
 
 	ntp->t_flags = XFS_TRANS_PERM_LOG_RES |
 		       (tp->t_flags & XFS_TRANS_RESERVE) |
-		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT);
+		       (tp->t_flags & XFS_TRANS_NO_WRITECOUNT) |
+		       (tp->t_flags & XFS_TRANS_RES_FDBLKS);
 	/* We gave our writer reference to the new transaction */
 	tp->t_flags |= XFS_TRANS_NO_WRITECOUNT;
 	ntp->t_ticket = xfs_log_ticket_get(tp->t_ticket);
@@ -273,6 +274,8 @@ xfs_trans_alloc(
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
+	ASSERT(!(flags & XFS_TRANS_RES_FDBLKS) ||
+	       xfs_sb_version_haslazysbcount(&mp->m_sb));
 	atomic_inc(&mp->m_active_trans);
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
@@ -368,6 +371,20 @@ xfs_trans_mod_sb(
 			tp->t_blk_res_used += (uint)-delta;
 			if (tp->t_blk_res_used > tp->t_blk_res)
 				xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		} else if (delta > 0 && (tp->t_flags & XFS_TRANS_RES_FDBLKS)) {
+			int64_t	blkres_delta;
+
+			/*
+			 * Return freed blocks directly to the reservation
+			 * instead of the global pool, being careful not to
+			 * overflow the trans counter. This is used to preserve
+			 * reservation across chains of transaction rolls that
+			 * repeatedly free and allocate blocks.
+			 */
+			blkres_delta = min_t(int64_t, delta,
+					     UINT_MAX - tp->t_blk_res);
+			tp->t_blk_res += blkres_delta;
+			delta -= blkres_delta;
 		}
 		tp->t_fdblocks_delta += delta;
 		if (xfs_sb_version_haslazysbcount(&mp->m_sb))
-- 
2.35.1

