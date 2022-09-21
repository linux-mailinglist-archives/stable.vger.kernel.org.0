Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2482A5BF446
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiIUDYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiIUDYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D50CFC;
        Tue, 20 Sep 2022 20:24:32 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLOMiu019171;
        Wed, 21 Sep 2022 03:24:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=Q0iIdutIYgy+wQz3jxoNzOK8kp1o9dRQ6hyGfW1H5h9MYNJL/egWk6ijIi7IOXBNIuFq
 uft7ttP5oIh5vmBtHA3V03QJqaKm/2eS2TEOOG3354GlhuNa/vxgvkTZLWqhPUJ3K0gd
 A+RetePdNQjoOXu66DDcxXw+O65tXBhVV1oTJaww/DxJ7OnIgvp34iSvKJd/Wo0bNLzb
 OrOtmyCijvu/T3gxy9J1F+xaZ/qBMYBFnSjd7qCgYkdF/WyrxDfpXjH8Gh+++2n7azyz
 lo5yeTN9enwhexU0G/dsUbh7n8jAJBs+TfpiskpZaKo+UpiWQtaMqQ/NDKTdlCm+d6av Tw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6sth4r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L1lLmO009978;
        Wed, 21 Sep 2022 03:24:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c9p5kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHiqoJYIXqt1gC8LZDy7bLopiSePsmPYgBc9SvUdyqoJTBLsyjcAPaGzSgNL5VmQxpZ7CtPzebMILL686S5YLC662L/M8Xb1+yxim4qZS/khMbUKxfKuMpqhV1T+Uj5bFwlJfi6FzR4/6uCvoLx2JBpKovMJAXc93c1AsK7MvwUn12Z6MxSvCRsqvF/iEMRDZF0o2HJoQUpNgn6d2hT1jw7Ka/6RDYkckM08+3NNs+6x1bSdqUYscfDBt5VyOP0uwRXYaMTOUFO4f8ooCe47CJHQrZMvPgShIKL9ioFInY5sg0X2Be7lJ9qvxwh6OXEysqi5bxas8/Ml+JwblZsc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=W3PKSmEgaE1ka0EQiuw3LHeQVNQeDA334v4z+GSKsRU1BVXmGLKc04/5lnceRgfbxt9sD6WLU87phLQXqVnQf5mx0PrlMw0fBqrNiwEqz60ICrt8m9LFPaGRST2tVvcSfxn6qhX/kKsW+Fay1m0p1vVR5lBzZ8+8MC+nnN8ybMAqn0/ILZbWUT5MqbVeiGBFf0Mr32dHuF8/sQhhEIaVGyw2VWYh8rpRleGxFn5nIqh42zZ3QQnALUMUy6lsjrYMqFNFL1GtLWdvwQ1SA8z9juFTCrsq5MtV6v41h5ILCq2wua0ZLgJ9pnwgESMzHbdPab2i4/mPil6JcRLCgurzDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHk0q8PABHBBA1CeTXQ3C3YFifcVVCJvCLoXW3zH8HQ=;
 b=DMDmRX+S9ksjhMzjb4VFG4l/Es+IWsFiJ8c7tRFFCJ9HzXx6BnaWqmnKpgjXhWxltMb+WfOhUfhPMwqARy7msvTEHqak5g2gE4QAd5vNhfhXF+ltrJ9OFiTl6LpRye2i7sWKs7ZPdQEUkMP0+0v+9a8KmgLLJGBNfQX5sFVsnUo=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:24:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 03/17] xfs: replace -EIO with -EFSCORRUPTED for corrupt metadata
Date:   Wed, 21 Sep 2022 08:53:38 +0530
Message-Id: <20220921032352.307699-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::19)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 42267409-5204-4fba-a867-08da9b80c574
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 390ZDVjIvccRMHi4QLPdPLJjwvl+s/+SoKoYIlSh7zEtepAfs5VrBI38HyPcWYO6RL+GWkY6Hk4+2a3sUYaGHh8YK+EgT07w3vkcleuB8nrIBhkIoxm19jYwE780JeSQ97KCpISVOs65C9F8g0g1vcoytNg6EMLgpd9hKFAPyeNOKzjgDCVqIMiy/0IWGZdNReCNQ2q0nC88tldGl+IEEb2e23CR2z1PnOtFfpTHWTBm9TmpLBsAmOsssT1Z/hj7+2xp3O7wGdInLCFrrBAJJCuhntxJ1u2uxWNMyzPlfKirrY1HwlMipaRXmH2oszVeVQuBrtIGSOBPOyhSAYoEq2UtecstEytATza1v1WvOuWRigQCTHNMj6Otb5ZtypaTsPlfQwpL2cyZm8B5zGcxxxyvevLsUa7d5DrmMlB+tOXKxTcnGg45TNldRWJBf7d6HkGGVm3BbIzUA6yBiDY/CklS1vcwao0a6Saxsh6LmtCEhcJVQqACfafPr4d+hwzGXnilIgUi4a486NOkXvYQEaTOmpKKDptujxrUuMWT+cokcRI77H4BMFhqfc2mD8rYe7Vy4h1HLrxqsGt/IYqfpcneqD2NhVzSJr7FXZgPhJ8RnvUCyMiiUYzS8WkRiUxxRbdVxpCVBXBvlfCFYtPP4hIIZhfZ15MwFwHRbe8RyHHIsG8i7pkIZ2ojXsbVi/pCg8NHASj74L9RmjmcTHYHFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AGH0KU//n+IAvRFizlM6m0N1JK3X07hW1hiuFvkR6iQ+tV8fzX97ZjPQyrxj?=
 =?us-ascii?Q?TWmxF3VQdSKOuFoCgUmbIajcqh9dbDkJqdVkEWbR0qbGCSyFUvobCrB9/FtG?=
 =?us-ascii?Q?LnjZhiVZxblneiZ0dFYu8aPLL4ejf0me5acY24YMUj9w08RG91jJn8QMG9QO?=
 =?us-ascii?Q?P23jj/7yBMGM1GeKazIP/HntHhp36NSR4x38Bb6O7+NMgsmS9NbuECNQ8Tgp?=
 =?us-ascii?Q?jVRQ9ORgOHTo0PG2EjNOia3nDZ/TBykvuJiw5fb2BRgvMiUPB0bM2oY0PW8a?=
 =?us-ascii?Q?AG0U6UGC/Jiie8gNp2hiWKB2q5jl7Wjweh6QfSHg7Y4gtKmRyV80Qn6DG8++?=
 =?us-ascii?Q?hnnXJQqXA+85aqTWD69ohlm6KASjc7ZSApBuS1DVCzju4p3ug2Sq/TE874xe?=
 =?us-ascii?Q?cqyprQxktUgck0zBwq+7LOCDr8QAnnf38YrwA9kkziCBxhMCXg3zT664pjZm?=
 =?us-ascii?Q?NgHD++OwZxK7V2Idu5rBBY8WxeZkKAEb2kVaOQlshvM4X9hDc9tNcYNjwC0C?=
 =?us-ascii?Q?1RIi+1JvBACtW08ox72p8XdPYC+BR7Ye9q0hgqmC0u/0rmUfNum1QBuLnhiS?=
 =?us-ascii?Q?GHpACJe2VvMDvYfWhvFrtSFZSwW/U5F20MB8jl+6jfmshfGWv2b7C5hddSjX?=
 =?us-ascii?Q?nqHO6CYkNSCxMKNuA55bYf640XzEzop4ZtgqOQgGn7eIqTs8ok8nwshXvBly?=
 =?us-ascii?Q?QLBkBgVgtmIvb9bqinM065ny/pMyASJS6CTImgUhxKS4WMsR4hL9GLmOEzkF?=
 =?us-ascii?Q?cX5e3X5Z30/Fmu+4HpBwBgtzJAWVBL0z4TquxCKJoVgPCL0jQnfMaJYFtzkt?=
 =?us-ascii?Q?7aNvF4mmMU4Nb9HB/mrUFZrfK0M2wegSFTO9WLxMBxgwQI770omBFs7WHAbm?=
 =?us-ascii?Q?JTCYkvRduBydxPzYpbNC0M+dwX4K0a/aG0/Mh6SWCZvCEEFK5SxSubeX/Yl9?=
 =?us-ascii?Q?+SV8drtqNTjmzSxvKuWJ7cNqbwt4YHETYhTYYH3vcqN/mFpwqhYncQFwpyPP?=
 =?us-ascii?Q?FrFPBYJNBMCafayNAqoTbK1SJTRkMkx56nOTUmuRL1vb93I0SSSQuHOgI7jC?=
 =?us-ascii?Q?e8WZ8EAQDMnToDYfY/FJIrAzJkros+l3gf6w0iGAWznRMReed+xgLVNP1dBX?=
 =?us-ascii?Q?0aJktINUTIGmpFHOJEj385+kdEmU2JNhyeOz6TXPssRQ9FMIGQrTCoqGjcDR?=
 =?us-ascii?Q?XBuu16k5N1MptC4lGKoU8mqJ4NViB2PS95khOXWBcyUTNlHPoRsI+awb+t8E?=
 =?us-ascii?Q?M6epe+dwh6M98r5Wl2AA0XkJ0ZC7+Bwh9yNJdp5KJBNH3N1r+gP3hKNcJ4SD?=
 =?us-ascii?Q?g1aOYxxTDgsk8Z/26kM7xUuTZ19rzmolHitsnB8MYkfZ9G7Qro8Fmwp124nB?=
 =?us-ascii?Q?zUOXYPI2LfCXIET4NQ9MQVBSustQKGjzB5H+dbWW7r206AXEfm2oPppS9isr?=
 =?us-ascii?Q?q/g9WsilSVUTlyixF6DJVAC2kxlydJv4ggojgz3zME4BSTjyB46kx0CQNpAC?=
 =?us-ascii?Q?aNmaOP3nB6y+wslzHttWekX9LlI0dKseABIBap2AAMIB1TSDaCcHaqChfhDW?=
 =?us-ascii?Q?3diNpItVQK5tzV1w+6hS06AAL9vNcbC66ZQDx3Hnax6vB+Qg2SyO7fwJjNXa?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42267409-5204-4fba-a867-08da9b80c574
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:20.0033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W6vy9RfO/lqFkJda7sILyqfc5BTOIoFAvoIowbEVrv0r6Mb3bWOA5fDKzrwL+lIknKGX+7p+xOWhvoeCAAed/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=963
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: 4ti3E2JmJRHnDGULzPTLIeausP0zEV3I
X-Proofpoint-ORIG-GUID: 4ti3E2JmJRHnDGULzPTLIeausP0zEV3I
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

