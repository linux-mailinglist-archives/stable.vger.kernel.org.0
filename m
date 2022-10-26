Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD12460DB20
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbiJZG3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbiJZG3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9621780E89;
        Tue, 25 Oct 2022 23:29:22 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nC6D023389;
        Wed, 26 Oct 2022 06:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=mLyRTUxWLzsK9l+p11J3vAAMydBHTPTyQhGcQLImiYk=;
 b=IH9djKL93JPVknbCn0xl/6YzBN+LXBZyl8eibbalibqa73kzo+TkhDKSEbEy/PXfQwR0
 S9CASqkFymKZwhAMk3ITFe728/tYuPFGWWshmDwjMELwSQlj35zp/3qDH3RCq1Y+ZUpK
 PX5MuWF6kEJpPhgufXg99ON8axBXLB9JeWpN1HyAZL2mAzPghRf85lKcb9deET4vqEvz
 uGjwbXVdrb9OvsdCWKXwqO7R9CeCUQCzNfQi33fQlJSFGe+6qQLpnCBK1yL6wZv1FgF8
 eWE67Z0M4Kcjr+Bqa3xfKD9fxpy1FlZb5yl4FqojZe3U64p9iyJviMuoyaPQ7tEpe1ic dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a35nnp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q320Ps011113;
        Wed, 26 Oct 2022 06:29:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5d7y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKwxVsmnS7v1BLuFdAc1Y5XWR7sTJEhgQLKtoAqODnHIoCYvYnLYUnt/syOvkp64+8ypHSE7g1eFAt+505pVDNTYDeeupZTmxQ9jB9kclH/0vSWJRSDAUGvF4CVbby6E/pBFCKhDoG8FjoxbLEZOs6+M8tOVyij3vaYNuGQd0jIkRp6ox8BKDGr7LG+CyCmLdckAbLv/c0NqShNKOvNYIz35rCS1GlerQ4ODtytWz3ZIJFi+sbItLXQUAwEmCV3hL4B/2ozDuEsDpfi3ernqTUP1/uVOUy9PVwyr3BODdLiipfv2xdg9Hh2/LNkVfHXqZFs4LdVAjD/z4GtLcPqxqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLyRTUxWLzsK9l+p11J3vAAMydBHTPTyQhGcQLImiYk=;
 b=RaoXAv2z+QcXlWhbzgZCritT6HJ7C9mM4OR2GbB+LfjLLtpgJX9EgUNQkfgmVxt9EBghIFsx7IEkfsr7lECaFMFfr7/aeSuwB22qfHIl8M2Ec5iR+9Ur4wrmo8B34wD0dGzK2o8XfkAsQuytwFTE2hYhjzCQkdwK9Rlg6n1+G3CVxvsuUTN5RRKdiO1JqqmS3/WY0Awv5a96sqp87wLxpsaXgv6X+bPPcxdEcti8zajlIvY9LKMsWtHABf0gu2zAhtFa54+QiVE5OUVDlXl4xcNxZcprsiFoi4rbblqgifzE8rflOLsbvqTAgXXhTT+eQCQyCEF0STZHap1H1YvYPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLyRTUxWLzsK9l+p11J3vAAMydBHTPTyQhGcQLImiYk=;
 b=CHB4ldYeTJezbN3p+MNoDzXKaq5Bdj7/wElAxzk/xwfpKFAQvykA0U/Yp0TntpjwVv6FO+PcRwKyhgEzVUlblMS/bnJwSKKqJEGbW++LQn+Bqk7Q/v+66gJ8LMF8fvBgcEP/WXaDh7nPOr/l8dU5uwJrlY7dazoNOGBrlLipkrc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 06:29:14 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:14 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 04/26] xfs: add a function to deal with corrupt buffers post-verifiers
Date:   Wed, 26 Oct 2022 11:58:21 +0530
Message-Id: <20221026062843.927600-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0047.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b5::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: 25137eb3-cdc1-4f4c-e4ff-08dab71b66cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwJNupSXivwqbBjcv37g1kp3GF2+PpJVK73QE8+unBoQBuxsQjxAB9nwk2jgupVQfcmr6cpnCRawXG1vpneQfzbr+qBmij8m5Qd/fcPPjppXagGtuZJyHLNJWb+n5U1FJAC9MAbu8Px5LRk9rlVPSlRKdVyqEmFNk/rPQSdvMJVlhfVkaPzHhe2Am8xGdkkIhl7MfW2UuefKxeHqjUbgzHz3ytES9eDjRbgRrylAb4Nk66r6cjjnbX/t1Wfirefunj+RRO38bEFoCCPy8GOuY1H76d0M6owxQxMxq4BHdRuX4RkIRvFisDaqm0Sqo9F3imM6PkGHbI9aXYBj1Rc/dzOjA9aYvxqYGU/hIPpzGDxw1NOoDHp2luy4/CNl9DgoOZH+m+xLuXLr5dq9Lcn6BIjovZutrj11b9XjZz3HVkTwTIUfeUrjDIvg62W3iZYs+kJ1l4/CH8pmBETtaFFYqWgLif38fKAXTgWwbdYxAMGXPXc7namcBrOXdbR7qBLE3v+1kvk8HN9LJQ0qVysYrujr3hPrPDMqb2CAkatg0kkLhHGVl5BrNDg2xTrdkF+RDgNw4wlDSvn+sbgZhxViSqICl8TsFxcrHh6DuFA/w8KiMn+6XWgi+BKlJAr1da+weJI36D5TSy4EFMz94FbpzofyZk+YaHWzeO+03lyYxPSrmP405PSpaQOqicycXTB1zSfNkadH0z5FRYNX3BDgEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(186003)(66556008)(41300700001)(478600001)(2616005)(66946007)(1076003)(66476007)(4326008)(2906002)(8676002)(38100700002)(83380400001)(86362001)(316002)(6486002)(6916009)(6512007)(6506007)(6666004)(8936002)(26005)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aERK2NwJ3z1OImIimTWPH8y7LO1bcMsfmBJTXi4BTTX4M3l8AbloIJEw1vo/?=
 =?us-ascii?Q?BhHunm3IEUfMv1MQAxAjWhf13X6z3B1Rxg0xjJfmrQRN2aGnL1CONahXvNLk?=
 =?us-ascii?Q?2htP0Ub1cFJqJDbFH0z6PBr30vuRE2jRkSw/OCiu6Bp0nE66c4Kk2KURN9Kt?=
 =?us-ascii?Q?PPCHqD/P57yjaOGtShfAmeLGLpG8zmH0l1J5kNvSHeePVKQ2PlbcvwRXn/CH?=
 =?us-ascii?Q?mVxQc8wudNf8Ls0KGHWOVZCENnNvCzApTNK/yfkLj+wOqtH6DfelXm03TWeb?=
 =?us-ascii?Q?3f2LSSmYDrrnXmqbNdnqzlGgX0seY+d4hF54nRr0p8DfTWNFNhL6zV/X9GbA?=
 =?us-ascii?Q?jK3IsXMrufQh0OdvhLl50QFFM2IcnGh1ur4U+yufrnMj3tzUuGGEBaQOU71I?=
 =?us-ascii?Q?319MfG7ibprrczTy9ZLAhSx7Tv+uLgzucWOjHmWjeHpMcLn6FVhMgwbPJbFc?=
 =?us-ascii?Q?3JAWyjTJr0PkBxV0hVWjYHMw1wlQE+f5fRla9MWlPp+84mndlPJ/W2DY4J4T?=
 =?us-ascii?Q?qVzfGmxzjNb4QW41Fiie/jguK6XO4YF5z4um+P2owDy31UlCxJGtl7aOpbXY?=
 =?us-ascii?Q?9+1rBTnxrUKv9RkYOOj2A0Awut2C4aBjeLffkliRo8hnkJtkVeEkTTlhIbH0?=
 =?us-ascii?Q?IwKyfG1Xlu9JVmiv0g9WpyGAGPdpGBefrE54LASZD5LBo4gIg09tVvu9nQAM?=
 =?us-ascii?Q?9yr2bF9CCiOvzHKhJyRrfMP530Nwgz6ajuluQG0w4FwBYd2ihuE9onrCllsf?=
 =?us-ascii?Q?2f2STWyyzk2upRBoo7COYyNoZ7W2bBZXSCxjJiiqkl7X96z13RKDjJWtErdS?=
 =?us-ascii?Q?nTKRmn1nd/quzcAG3jBmQHFE7F5j+D2g3PRmoE9ku7JsxPxi4NU5rkXKBMVw?=
 =?us-ascii?Q?zN61Tnn4e7sUE4oXdXvvjr9gNfMOOEOeQst6YT3lgNERhw9QpOGHDxIlx3dm?=
 =?us-ascii?Q?x+ztuCPYhsD5TSHQAgXgFLVsQQASEVaNOvuwHO1opjrgjkrk8KygSx1svmWN?=
 =?us-ascii?Q?YBH6OHkM2svdGuE5zZSMV11T7Ve6wm3t9yauEgEK8Blf31HSRHOhjvkfa4OK?=
 =?us-ascii?Q?gsE7FnTSrSicchhZB4lkBr/OQapg4k1eSgnvFPCAWOa5VAOTbI93UZ3NjVfV?=
 =?us-ascii?Q?OyErLhEeF3tT894t0L51PCkYM07z9NgCiR9HCl+G6c2nZh9t/eBg8vbRc/RS?=
 =?us-ascii?Q?HaRf4AEpEtfZ9D7zVvbMUcvcNypPZo4kxVbFG/bQr5Ys75iP4QWtvcojk+p6?=
 =?us-ascii?Q?gGFwmllgwSPhG/s4Kn9CExNT/k6fXNbnn3jmSGtynJKbjuX0Ut7yK8LoZMR4?=
 =?us-ascii?Q?afE03IjMl/1QLlo9iaCxo8AK3rsoZnJlwbLSx5F2UaR4VxVxV26QxGcRAX7W?=
 =?us-ascii?Q?n8qZNTjBVmbUoN73ornq0u/Ivp2FxZOlO6BWk08tvrRYiXCoXJXgEukib8GH?=
 =?us-ascii?Q?eBO9m9JqWo7Fly1XB9esME3DPyBtkGGXSZqVsAp+ZikVMzF0Nb6oblHOpJhd?=
 =?us-ascii?Q?VcpGqMVNktT3D3Xhqni8vvZMkCDRAMQc0T0OHyruydj91pFZRYKIk7NHBH+L?=
 =?us-ascii?Q?wyXA1Iztf7vM0oEPWgr8KXHCUa6PxytVH5G5xTmU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25137eb3-cdc1-4f4c-e4ff-08dab71b66cb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:14.6890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ci0YtTUPzLkupXcBt3FROWKPTKq6ElEMLB1vCaQ5OJpc16uAxZMZfRfH0vHn4PO5ma09xYl41vLJmrsM49rXhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: lKR0JCuafZ6zUYAgo0tDGqWZ7hDD7JRg
X-Proofpoint-ORIG-GUID: lKR0JCuafZ6zUYAgo0tDGqWZ7hDD7JRg
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

commit 8d57c21600a514d7a9237327c2496ae159bab5bb upstream.

Add a helper function to get rid of buffers that we have decided are
corrupt after the verifiers have run.  This function is intended to
handle metadata checks that can't happen in the verifiers, such as
inter-block relationship checking.  Note that we now mark the buffer
stale so that it will not end up on any LRU and will be purged on
release.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c     |  2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c |  6 +++---
 fs/xfs/libxfs/xfs_btree.c     |  2 +-
 fs/xfs/libxfs/xfs_da_btree.c  | 10 +++++-----
 fs/xfs/libxfs/xfs_dir2_leaf.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_node.c |  6 +++---
 fs/xfs/xfs_attr_inactive.c    |  6 +++---
 fs/xfs/xfs_attr_list.c        |  2 +-
 fs/xfs/xfs_buf.c              | 22 ++++++++++++++++++++++
 fs/xfs/xfs_buf.h              |  2 ++
 fs/xfs/xfs_error.c            |  2 ++
 fs/xfs/xfs_inode.c            |  4 ++--
 12 files changed, 46 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 084d39d8856b..1193fd6e4bad 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -685,7 +685,7 @@ xfs_alloc_update_counters(
 	xfs_trans_agblocks_delta(tp, len);
 	if (unlikely(be32_to_cpu(agf->agf_freeblks) >
 		     be32_to_cpu(agf->agf_length))) {
-		xfs_buf_corruption_error(agbp);
+		xfs_buf_mark_corrupt(agbp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index c86ddbf6d105..e69332d8f1cb 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2288,7 +2288,7 @@ xfs_attr3_leaf_lookup_int(
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
 	entries = xfs_attr3_leaf_entryp(leaf);
 	if (ichdr.count >= args->geo->blksize / 8) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2307,11 +2307,11 @@ xfs_attr3_leaf_lookup_int(
 			break;
 	}
 	if (!(probe >= 0 && (!ichdr.count || probe < ichdr.count))) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 	if (!(span <= 4 || be32_to_cpu(entry->hashval) == hashval)) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a13a25e922ec..8c43cac15832 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1820,7 +1820,7 @@ xfs_btree_lookup_get_block(
 
 out_bad:
 	*blkp = NULL;
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(cur->bc_tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 1e2dc65adeb8..12ef16c157dc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -504,7 +504,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
 		if (be32_to_cpu(node->hdr.info.forw) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -517,7 +517,7 @@ xfs_da3_split(
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
 		if (be32_to_cpu(node->hdr.info.back) != addblk->blkno) {
-			xfs_buf_corruption_error(oldblk->bp);
+			xfs_buf_mark_corrupt(oldblk->bp);
 			error = -EFSCORRUPTED;
 			goto out;
 		}
@@ -1544,7 +1544,7 @@ xfs_da3_node_lookup_int(
 		}
 
 		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1559,7 +1559,7 @@ xfs_da3_node_lookup_int(
 
 		/* Tree taller than we can handle; bail out! */
 		if (nodehdr.level >= XFS_DA_NODE_MAXDEPTH) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		}
 
@@ -1567,7 +1567,7 @@ xfs_da3_node_lookup_int(
 		if (blkno == args->geo->leafblk)
 			expected_level = nodehdr.level - 1;
 		else if (expected_level != nodehdr.level) {
-			xfs_buf_corruption_error(blk->bp);
+			xfs_buf_mark_corrupt(blk->bp);
 			return -EFSCORRUPTED;
 		} else
 			expected_level--;
diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index 388b5da12228..c8ee3250b749 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1344,7 +1344,7 @@ xfs_dir2_leaf_removename(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
 	if (be16_to_cpu(bestsp[db]) != oldbest) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 35e698fa85fd..1c8a12f229b5 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -375,7 +375,7 @@ xfs_dir2_leaf_to_node(
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
 				(uint)dp->i_d.di_size / args->geo->blksize) {
-		xfs_buf_corruption_error(lbp);
+		xfs_buf_mark_corrupt(lbp);
 		return -EFSCORRUPTED;
 	}
 
@@ -449,7 +449,7 @@ xfs_dir2_leafn_add(
 	 * into other peoples memory
 	 */
 	if (index < 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
@@ -745,7 +745,7 @@ xfs_dir2_leafn_lookup_for_entry(
 
 	xfs_dir3_leaf_check(dp, bp);
 	if (leafhdr.count <= 0) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		return -EFSCORRUPTED;
 	}
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 9c88203b537b..f052de128fa1 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -145,7 +145,7 @@ xfs_attr3_node_inactive(
 	 * Since this code is recursive (gasp!) we must protect ourselves.
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
 		return -EFSCORRUPTED;
 	}
@@ -196,7 +196,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			xfs_buf_corruption_error(child_bp);
+			xfs_buf_mark_corrupt(child_bp);
 			xfs_trans_brelse(*trans, child_bp);
 			error = -EFSCORRUPTED;
 			break;
@@ -281,7 +281,7 @@ xfs_attr3_root_inactive(
 		break;
 	default:
 		error = -EFSCORRUPTED;
-		xfs_buf_corruption_error(bp);
+		xfs_buf_mark_corrupt(bp);
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 8b9b500e75e8..8c0972834449 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -271,7 +271,7 @@ xfs_attr_node_list_lookup(
 	return 0;
 
 out_corruptbuf:
-	xfs_buf_corruption_error(bp);
+	xfs_buf_mark_corrupt(bp);
 	xfs_trans_brelse(tp, bp);
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1264ac63e4e5..948824d044b3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1546,6 +1546,28 @@ xfs_buf_zero(
 	}
 }
 
+/*
+ * Log a message about and stale a buffer that a caller has decided is corrupt.
+ *
+ * This function should be called for the kinds of metadata corruption that
+ * cannot be detect from a verifier, such as incorrect inter-block relationship
+ * data.  Do /not/ call this function from a verifier function.
+ *
+ * The buffer must be XBF_DONE prior to the call.  Afterwards, the buffer will
+ * be marked stale, but b_error will not be set.  The caller is responsible for
+ * releasing the buffer or fixing it.
+ */
+void
+__xfs_buf_mark_corrupt(
+	struct xfs_buf		*bp,
+	xfs_failaddr_t		fa)
+{
+	ASSERT(bp->b_flags & XBF_DONE);
+
+	xfs_buf_corruption_error(bp);
+	xfs_buf_stale(bp);
+}
+
 /*
  *	Handling of buffer targets (buftargs).
  */
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f6ce17d8d848..621467ab17c8 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -270,6 +270,8 @@ static inline int xfs_buf_submit(struct xfs_buf *bp)
 }
 
 void xfs_buf_zero(struct xfs_buf *bp, size_t boff, size_t bsize);
+void __xfs_buf_mark_corrupt(struct xfs_buf *bp, xfs_failaddr_t fa);
+#define xfs_buf_mark_corrupt(bp) __xfs_buf_mark_corrupt((bp), __this_address)
 
 /* Buffer Utility Routines */
 extern void *xfs_buf_offset(struct xfs_buf *, size_t);
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index d8cdb27fe6ed..b32c47c20e8a 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -345,6 +345,8 @@ xfs_corruption_error(
  * Complain about the kinds of metadata corruption that we can't detect from a
  * verifier, such as incorrect inter-block relationship data.  Does not set
  * bp->b_error.
+ *
+ * Call xfs_buf_mark_corrupt, not this function.
  */
 void
 xfs_buf_corruption_error(
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 30202d8c25e4..5f18c5c8c5b8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2149,7 +2149,7 @@ xfs_iunlink_update_bucket(
 	 * head of the list.
 	 */
 	if (old_value == new_agino) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 
@@ -2283,7 +2283,7 @@ xfs_iunlink(
 	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
 	if (next_agino == agino ||
 	    !xfs_verify_agino_or_null(mp, agno, next_agino)) {
-		xfs_buf_corruption_error(agibp);
+		xfs_buf_mark_corrupt(agibp);
 		return -EFSCORRUPTED;
 	}
 
-- 
2.35.1

