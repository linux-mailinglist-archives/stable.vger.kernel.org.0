Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8765E8CC6
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiIXM5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiIXM5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:57:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89354109779;
        Sat, 24 Sep 2022 05:57:33 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OChARN002054;
        Sat, 24 Sep 2022 12:57:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=SbSQRZVc8luEFAt18QPIEgUXVsgnthkYU2YkaUMbBE0a3Btg5rUgL8rtR7Ojo28j6ZGj
 9A3smnRSQa4ksv70UoBu8c9pA+ABLkiJCJKq0G0pXOp1ODBYbddANetLFb6nDH0vCla5
 uostA+odk8QVTpCUor2gHd+14AQIWz2IX4JIYF3gZGfr1M15voBbXGrPRFhAZfAAO92z
 KQ8P2t7UK8fsk5E0PmPf5IliXT7n0WZ3DuBYqXKjlxsDnbxO/GxWEFCamEABdzcbFBGQ
 ltGWEJ5arSt9nMjYisb/aKEdapSbLuH9nQagFLOwnVR+2Mas9+2iusv2wSHbXbZOP7hS gA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst138h0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4d98Q002843;
        Sat, 24 Sep 2022 12:57:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1s659-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrVgMAjgMcMs6DuMpEkeBB+JO5mF0Llh2FuBJEfnGL8DmmpkE48qvGxtRl/Cgpkf/Bh+qiU+xQNWN8JItIEr4uOgSSDyF1tnuAz5RiWZsvBX9DrxmE+KLNLZxA891iwPPeYtMsupaPhpyp6U8VsLNM+XuD+JV3oVJoBZEI8FXxtQhIw7cWfzgFyjxzs39Gg7cVUmycH/j76Nk8JgXM1aTx3A8CE2JhR/v7eCMQBhWrCTjcllJ000BarP4N4DSj0BepCXDKUVzbOLXM69qrWHRGqyMfs0IzKSMRD2+bz+0ITO4O0A8e15w4Tx6tqHi7UIKxLVtAliUX7J8OyK1M0ciQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=TjKIWdeNrrLI29wid4NJZJN8kWVGLeIUqFa4uVeZO8JqBYNsqZvPMUNBESO5hwyfMY4dU+ONW1uFgStYgh8uKU8OgoTMJElPYTT2uq0FFOChdSUOovMfq11JnJUL2IqHCZqa4aa58lTy3ACXnv1fhHt23aDnIionoFouF3qwa6M2Sp8GiTw5yjtwcfpert0mJnMwPXtHzsfntlwScKdPr8ONMA2f+bqOQb51YgF1y0ilXxTkLEv7Icb6SjoO8Z/YCFoEPbfDcEWrR2fvBBZVbNXh8fVBULKCFtxohHFJ4xh2WMDjgL442mElrZMIDGjI0br63Yz8hu1sg2oEGEp1MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=NFqrq09z1B2jKiAZfl4byvFXl6IuV8F4a/iFJfxvbQhKv1Veeo8IQMGp738J9spLVmifYh0+rYh9fuBJmKM3xPXgp7z1G4IK+TcO+0ECTde9T0+tAQQqh9VZsfjQ5VzZFcduFjdw6Q9g4rS2BZUdUKOXUltu8GpPrNlqSHbhAVc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:24 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:24 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 03/19] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
Date:   Sat, 24 Sep 2022 18:26:40 +0530
Message-Id: <20220924125656.101069-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0004.apcprd04.prod.outlook.com
 (2603:1096:4:197::22) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a97a024-89d5-49ba-c5fc-08da9e2c5352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qpfoDqMMlu61qhph2wV6yhK1q2LtqG7V/dqakskya3Sl8mmS9yWROa6Kz7wkbTtrTdf8njVy6DCyAVCWm5sDfdHm2BSkZjbX9v4InZH1HJruHnxlasGA/YTZYHpzpvgIly7MsnSuG+TCfWQB6zfR2IeqRQ9v5H9iCbesnTbB1qM19AVzVz4i05ZuOmM0H/PXG4HpUtuUb+xnnZG7vHlxsrjerNqVq4oAbVOhTB4/oC0iO5HYwxqMaKaMvfd6uR3vpw8xjCKSxY8ZK7fd/Zsil8gUGcT0FgV2et5LiKZMBWwFTHPyP/h9IAk0OmdKXOL14mhmZWSMM1k+kerEwGtk0bFb3rV05O3CLGMcsgd1OIjb2rB7RbEO2+CR8tV56voKkn71j0EXqOPvq6fpfJqOSygCz1FbStEBFowdb0OBNFZK4HRX4fbnhUwJ2hjrDkCnwJPLTkb80Qg0Un99ftFoaC/WLxIz3IYPZw1y0+KugxKR0CBg/+OGrByrk7zP+Z3TVxA40NOcXSTuB5/7FiMzAoLHVsDqMMGVw7cRxVo0cGl90yRlZRgGXHBJThiOMgHeTmhlIpE4yRKfsDFKlvwN8QwhH1SRap+cRSDiPPZO7Bg5to6tTE45k6ZLb6t1Qv8a4UGlvo5JHWPSXsbooLZMh1qrXhLpON3DbD81cGYUW1nxSO2ZGHFogLYuWaPmCaNUp2Jh1GAEndLrLVFMVNKu4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SPQ2u9cZ0TjyBXY2xIL7TNapH92PSHiwO0UL8TtIlR6lNyz3di9oZX4JIDpA?=
 =?us-ascii?Q?QvRtl7gRyV/T9SMpwcAIKHyOskyyMOoApip9LHgD55cDE6a+vCixThOexDKf?=
 =?us-ascii?Q?rzgxB10QewlqVKNdas+/BPO6hZSDo4IQE1A2J6pVsqBxfQ1jnVuSRA68Y95m?=
 =?us-ascii?Q?LEaLbbPgTvjHmaRoLpsxMXAIDto4qVQTAFzM09Mss9LEhXFH2gIF9aDSU6/D?=
 =?us-ascii?Q?zcG89uDTpSNHu6Tiu7ddQE2bpe7HJ0kARj6N4fSVPq76GwDGiEFdDH8rx31S?=
 =?us-ascii?Q?fK94VruCZ1r15lSnt6H4lOXT0ZdbdwM9YK1Tt9WNosnlEa50cLE9UGZ/yiI0?=
 =?us-ascii?Q?RMtB9mjalu+rx2P5LE9tIa2uBYDvsBScstNhxNM4UZU9Ohd77y74DIc9Oo9E?=
 =?us-ascii?Q?DB8zIZYtezMVGjYHd9AEmluPjtQC4FoxQYeCWaIn0jDM5e1aiUM/oejPfodx?=
 =?us-ascii?Q?pM1IrFxOweTvS+K9+Yg+IBOYEMsVjwGF2QqWNZK90GE/QOBDLhv4cPjPYQUH?=
 =?us-ascii?Q?Q2yjMjEXCLdIAC+XfMzCRdeMPW/DDiWovAtyCfjaMBE5B3OzirWkgj6P7GhO?=
 =?us-ascii?Q?zmUBuMFzii+Ih7N2Ly6yGrQ5nMHbxg3GOpG+tmBTdQVe04FoThTvNHOfnbZt?=
 =?us-ascii?Q?5h0ZZFnvT1NM5vMmhCtIiQEWGgd2ezhtOtgOVeCcggP3uEXm1x/YlkJb7hWD?=
 =?us-ascii?Q?TgPsumUb1JCOW9lVUTscfl3xmT8QLlfauMI7P56mq/K1GhB/iEthetdJgCE5?=
 =?us-ascii?Q?SvI4W/t3nXVprmvDp0ZzGQNkTU+JnOlT0c0u1zxyFxGkGPYyzO2Bq3E4bLi1?=
 =?us-ascii?Q?DQDkWrMU+jcFdPQ6Zy8c4I+kSKsOhFVdQofBiiAx3JsoFkkyehxPz5x0qzY6?=
 =?us-ascii?Q?pGx/YNzKAmun6NytTlkZTBJzJS6VbXpDMo8h1rJ5CYR++5sXXDjuz8koxJW9?=
 =?us-ascii?Q?pxc7rwamAQPmlqj/srfUJlSeUr+5ZCmFAHVRv4Hw3ovcOi7Ssc5Td+BYhCcT?=
 =?us-ascii?Q?9mHaZOOrVAn7dTPdM2Ll3nI9JKMiASd6gUsRrQYDF2pzMjQj6UhMol5MzI/+?=
 =?us-ascii?Q?NMvgZeQ8ZDl/5FQ9FtY1ZSnDXitFVL/3dKImmDLT49Fd6SfldquCEN+DNqTR?=
 =?us-ascii?Q?emnFuUvvfIKijbDRtngTTzgez306KG8uncoQDbr0COCgWv9VKuZpPAW0f//h?=
 =?us-ascii?Q?POcLIPeke9fYlO6atObaSTkpth5GZ44Gc7AUZr7SbHNHB1M2ClybOiowVqf2?=
 =?us-ascii?Q?N0/kNuC8bbMBp4klHxGU5Yi+9yngMEgnsh01UH/AbgqOm1S0ud1pDp0zFpiF?=
 =?us-ascii?Q?S2XWZTB8cS6a+KwvIfEG2LGWeE4IX9rCO6QrVaWZyA3Ivhi8K2FrXu60l/7E?=
 =?us-ascii?Q?LZDENdLVNqHtoQqoxbqbCM2qlXIGTy2JCHRFaQQY7/tkWUk6r3ADCictvYM0?=
 =?us-ascii?Q?mtBRMGKj0EsnEjdrKu13w8w9ks6F/1+84EUiFrySCgypgBVSc2w4sdU9wE/3?=
 =?us-ascii?Q?xUZ6Pm132yPgIZB1E2zNTXQIEaThIE2VlnP26IhxIVb2r9p9nXa9P0yBdB0W?=
 =?us-ascii?Q?NzCL5R6vWQELfT+NG8SQkTnDPZA1S/+Oyo6J3Yo+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a97a024-89d5-49ba-c5fc-08da9e2c5352
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:24.2841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ip46LQbH1kuVaBZTtLj6KkddbLkBFMAWGueQeFUhzEoqVo0+2aH+UGE0x+pcFM39X8Zg8S8z5gBhYoYBG09Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxlogscore=965 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209240097
X-Proofpoint-ORIG-GUID: KYZCigo6iT90XyUkb-DZDyh2exWHoES7
X-Proofpoint-GUID: KYZCigo6iT90XyUkb-DZDyh2exWHoES7
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

commit c2414ad6e66ab96b867309454498f7fb29b7e855 upstream.

There are a few places where we return -EIO instead of -EFSCORRUPTED
when we find corrupt metadata.  Fix those places.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c   | 6 +++---
 fs/xfs/xfs_attr_inactive.c | 6 +++---
 fs/xfs/xfs_dquot.c         | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c114d24be619..de4e71725b2c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1374,7 +1374,7 @@ xfs_bmap_last_before(
 	case XFS_DINODE_FMT_EXTENTS:
 		break;
 	default:
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -1475,7 +1475,7 @@ xfs_bmap_last_offset(
 
 	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE &&
 	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
-	       return -EIO;
+		return -EFSCORRUPTED;
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
 	if (error || is_empty)
@@ -5872,7 +5872,7 @@ xfs_bmap_insert_extents(
 				del_cursor);
 
 	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		goto del_cursor;
 	}
 
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index a640a285cc52..f83f11d929e4 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -209,7 +209,7 @@ xfs_attr3_node_inactive(
 	 */
 	if (level > XFS_DA_NODE_MAXDEPTH) {
 		xfs_trans_brelse(*trans, bp);	/* no locks for later trans */
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	node = bp->b_addr;
@@ -258,7 +258,7 @@ xfs_attr3_node_inactive(
 			error = xfs_attr3_leaf_inactive(trans, dp, child_bp);
 			break;
 		default:
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			xfs_trans_brelse(*trans, child_bp);
 			break;
 		}
@@ -341,7 +341,7 @@ xfs_attr3_root_inactive(
 		error = xfs_attr3_leaf_inactive(trans, dp, bp);
 		break;
 	default:
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		xfs_trans_brelse(*trans, bp);
 		break;
 	}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3cbf248af51f..aa5084180270 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1125,7 +1125,7 @@ xfs_qm_dqflush(
 		xfs_buf_relse(bp);
 		xfs_dqfunlock(dqp);
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* This is the only portion of data that needs to persist */
-- 
2.35.1

