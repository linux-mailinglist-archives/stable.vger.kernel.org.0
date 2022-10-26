Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2AFF60DB29
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiJZG3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiJZG3u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22AD3AE;
        Tue, 25 Oct 2022 23:29:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nbxc017465;
        Wed, 26 Oct 2022 06:29:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=OFVT115MFHUIDHpSuTakzBw7/XiBRobQCx28kmy3LiE=;
 b=NGqnlyr6ZvA9CeqblIy+xjXBqyfw4TFOisCmA1LhaQ2KOjM4oY5UY8/INK+SE9Q7zfWd
 LZQNs25fnW0yE/ioQW/DZ8c02ggcPWXUjhwxfZ1Cekity7bSnWSjtKEODNoHolX8m4ck
 omeR5cYmXQ1KD1M8HVi7gkNb6R6mksiqGeYh7jLAWtbpYRMOJkEnWs2bhlYwm5SQGstF
 TsQy/zHBOlZmlyo0+dM68v3+dsPmeBzHWoui33LJ7CuxelF3mHHN5tWQJ3T0ZLJP6x/W
 zpdjowR2UX5ODB6BqA4uFestiM7dCCXK7C5x5zo9CnNakSmUMXkZ49dLbLMoJP7VGAcF 5Q== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939e60k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q35rxW031899;
        Wed, 26 Oct 2022 06:29:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybe7g9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmP0gUuFdbYnXh8RxiD+nl5awZZD8Z8kSTPXjJsbKNIqRqXB1kKNoLHCyxfuE3LL9jDPfNUfFLePZCWeJt5VVOTPsNzWFDEIbgKUC4F0WMk5EF1hwswvbRjKBH/7Mv2Hj68l8g/ekiDuC5w7y81atWCf7/K1FY+mcoMGnGPYJLYHO46a7rWru8ninJqr9S/MkmYE7bl5OcGvnAhhPbRemiu+JWIiW1uRlasC0azqibh6X8wv03qbt3x0Xqr4KEz0vxgdcPz/PCWjabSfZbw+NnmEDX00kNhdpgdve42nWXNkVsOwhakXOlKVpVzQnXSX9RX78PlJybKb9aeGFz/JzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFVT115MFHUIDHpSuTakzBw7/XiBRobQCx28kmy3LiE=;
 b=Ircbrqyo6mMNB75ekdwzaachSZU/f0iNYRnFVYddMsmOQSBtTzsROQvUK+ocJZn0Z+d/a2rkr/9iFoIVHCya+RJrUAJx/bd+YGpwiooxZWdeqwqCWBd/bklDOECxG1DgOyq7KpVNShHN+zq6Yam2HJgBp2kagdoXgd9PBZQQhQ10l8Y3n+0AOHejc1rKBmQUsn4fFO0OC4m3C+4bBidNASqI6qE+O3gWL9fn6UTwseF9kqv7Vzhiaezxci5LokgflgOK2Osp2BAjoa9HYFVGnBL4uYZNNPFmytUtk2cPAp+vUjiyIL1M0yCUol4aRwNMJ8kcP6WSlFXegUCsC4F2HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OFVT115MFHUIDHpSuTakzBw7/XiBRobQCx28kmy3LiE=;
 b=BROhEFyq38d6ZDDjxEuaxI9lU3tvQR2MjghvZrVvEvHEm++uwuNj3zFj9zCpcUD3jz5wej3l/WqMJoMjNDMaA3XfqMt5tVq3eYf/jkk5JkNV7z6qh79VKe7owJRxUXVJGN/u2OGcpY1+gf1pAYJ6ROckTnmMReZbfl0ajFPlY/Q=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:29:38 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:38 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 08/26] xfs: check owner of dir3 blocks
Date:   Wed, 26 Oct 2022 11:58:25 +0530
Message-Id: <20221026062843.927600-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0073.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31a::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 447e8d16-6805-4f28-2d88-08dab71b753a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7iwEmX9W0MOe+90o0TQ7/jRja7yH6a5HwMdpdIQQeoJUSkxgv1h13A3AKgwnPRwsr81FQHe9cGYPSISQIMdd91/WwmRnaQUaW5UOdGOmUzptU8qEs2gxBkpXBrMz26sd4+ACFPyZ1acLp6penM50+dA6jfaa/6E0eDazlCSG0KexLYbr1vE6dHsWmqkdelS9gtzMFZzWCmJHuXMfPe0Jve/mE0w/S2DFTKg68RoAPjYxNtQ8tal5FcpwSNQWg1yCGpH+fB5Lt9Ik/Teiay+8PeyiGkYDqQOV5VUwbZHTSHvrGWGz/BAgl3VFj2Fd9dFsTJFQ01iWEM3Ak7V3SClsQMuLrs9PP9BF/+GU/v/P+JYlHdO+Y9VYysDg2fSnCGKUSoQTuxu1auhkDYP9IViymldh5VGPX3hgkaWwodVdKaZFQQNnqdmMFJSYvJgohwKWZ1s1iwVKfiIu4cuNKo54/z4vRoV0ut2n2HcLmgT7sSjGZH5ACyFVB23wIPFpyBaIXSTnYuit79yjgZT1G1n79Drt/ewfIvnq077YZ88ooegYyCbWang96jQTVPsZPSZHx7t5pTw9coDvE1/4gpLRDeH8gUKVx1R9cfNJZeilygScE3WDRuS41D2wTdRiov86oJWOE4aLM7m8KYtx31ys7RxYdDvcgYb0i99sfHyqwTi2TRO3bOozT8rGNB728oZhSqLV7L2HLQPGTF8Pqu4qWMgIfNLuIsZmc5/sXh0vC2JPST/dhdPxfQ6hbUsXkC9O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CUHnziIPhNkhHA1LShZjCiudCXsoFjZIbTry4c3GjvrVljLoqn3DxzMc1Ojw?=
 =?us-ascii?Q?eBzmwnjm9JBomyRiAsj2MfFofIEMVtd4arRQPQF6L7ebcTeYMx3+h8ioIOzg?=
 =?us-ascii?Q?azYJsdm9HFBcUf0ftkXZTI+hbmAQ+gutF0/DH25kr+Hx/+xnj6TujNCX09ZF?=
 =?us-ascii?Q?/uQ3fTXvSbVghgvL989sWX/nnRJbJNVfQtCOgAnwQWrVPGLlWFcvwth7t+GR?=
 =?us-ascii?Q?7r7rAum5JCapm6XpOYOGG4Dy6LSp2aInStjoYZJvTiqo1pBdSCdWbAOLvBzz?=
 =?us-ascii?Q?9Ta8MPCxOaUdUPkRTbjzz5o5Kcqr7s4HxxtXUVxJNdFxeFXqamYxu7Q/zoD+?=
 =?us-ascii?Q?bY8hTvZfAg1ed5+XvZG7D4meykDx5VkgCznwIGqAArY0NyhL9Yno7nsebGFh?=
 =?us-ascii?Q?5gIehLQGqJt8c2Ulc6edP4zzzfHuZ4IKujXP88a46Rc3iTRSYxoRfhDev/0s?=
 =?us-ascii?Q?Isnj5e5N9563335l5DzVTNlEN73V7jtt0Dq+ArvJNMvt8sFjKDaev5Tr8nAF?=
 =?us-ascii?Q?M8TYj31NN82hlyvYoRQRAagNfvbkvIGlON0j5uil1rF+zXQca/a5fKFIx6Y4?=
 =?us-ascii?Q?ibZtXFzat86M014bG9+yhMjkm+0LmLzd52zxEafKqRXFHRqxc9AN8Z3I2wgc?=
 =?us-ascii?Q?d1zZ1ttgmdNezJBusO7OTV9De5j0HpyUsag2RNOttllf7/ck572sYhhzZT1D?=
 =?us-ascii?Q?GI+DE7xjusBJDqTTgf6YlQsBzZnLWuwXSGKdMPzodukCvNurC/asiuDvAoqq?=
 =?us-ascii?Q?fRV3M4TKhSnPX77a7d91d/GsHqG+R+DFfYRErMQdcBLVn2SCsKVcrlHn/9PV?=
 =?us-ascii?Q?cwj6UiW9r7sIsom5MqR8tUmNIAnYXIEER6TtioTI28RpKxhOZYgJ75vZICbs?=
 =?us-ascii?Q?xTaccQzeB/aQyyFX35sKdYFIbJzq/+kggCZi1G9CYeye3pWTvq6B3lxaLORq?=
 =?us-ascii?Q?boH4fvkWyzg67DzI8zFRIIdUNlEHPWaltBmaocUrTQ8gMBaC4jvSOmm7uAA2?=
 =?us-ascii?Q?I1SO3+Xqx3DguEbvo/Yql4g2XSY64eTOeQR54RHean0d5DyZvpPbxChDnUKQ?=
 =?us-ascii?Q?UrDHu/4V76Vwel9C32bv82AYd+jatdvAoSIBBtijCadV7f01MLdNXZs8RDEt?=
 =?us-ascii?Q?HVxwuOEotK2TRbX33Zq/vDlEJGcoFuzKQWg4Q9yYfXTEEXbvieG5cDrFxNc+?=
 =?us-ascii?Q?6KntlqabJMZAKvFCWIUDkiESqZFvN9SxA7uCbl2CO0Ffiy+0FiO7gXxCsrDp?=
 =?us-ascii?Q?CVkncx2R0CeQGPyL6YGsuEG6dk1VXxh3T1wKbzqKDOgJV7yW5NgkdBvNMkpO?=
 =?us-ascii?Q?vlNkF3CEO6/gMopxHs987iRs7tU2ggqZRiexuq6IahDwdHnLX7CGCLZosshN?=
 =?us-ascii?Q?J/jYaN+8F32inYB5vH206YAmr+uv1xJcIzSPyHH+GRaN+Py71yLuimoDtIP9?=
 =?us-ascii?Q?3JEOrLnMZiEupNnB0ZoM1FGmlfETRXGe42jEeYmu7FP0kH0CV/yHFhVQh1J+?=
 =?us-ascii?Q?cmC8uP2PxBuMSDWoJ1Og2t9QRvrz5a8ZxI/IDyreIxcYZ/w5KX6bFwnrOXT6?=
 =?us-ascii?Q?jZVzXBE6HaCkpzfI8ls614jNKKproMxB6QGAzuxm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 447e8d16-6805-4f28-2d88-08dab71b753a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:38.7426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZrYL++CCJdvCWcxTNduIYzu42gq/GPv7U4Vm2HqnP6gWgVXbVlzN4Uc1RvIDpVPSFLKtjxByCvpFHnzAhevOGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: ZONPDpSnTc-IugwYIAS02-0y26UgusY3
X-Proofpoint-ORIG-GUID: ZONPDpSnTc-IugwYIAS02-0y26UgusY3
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

commit 1b2c1a63b678d63e9c98314d44413f5af79c9c80 upstream.

Check the owner field of dir3 block headers.  If it's corrupt, release
the buffer and return EFSCORRUPTED.  All callers handle this properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_block.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 49e4bc39e7bb..d034d661957c 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -114,6 +114,23 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.verify_struct = xfs_dir3_block_verify,
 };
 
+static xfs_failaddr_t
+xfs_dir3_block_header_check(
+	struct xfs_inode	*dp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
+
+		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
@@ -121,12 +138,24 @@ xfs_dir3_block_read(
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	xfs_failaddr_t		fa;
 	int			err;
 
 	err = xfs_da_read_buf(tp, dp, mp->m_dir_geo->datablk, -1, bpp,
 				XFS_DATA_FORK, &xfs_dir3_block_buf_ops);
-	if (!err && tp && *bpp)
-		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
+	if (err || !*bpp)
+		return err;
+
+	/* Check things that we can't do in the verifier. */
+	fa = xfs_dir3_block_header_check(dp, *bpp);
+	if (fa) {
+		__xfs_buf_mark_corrupt(*bpp, fa);
+		xfs_trans_brelse(tp, *bpp);
+		*bpp = NULL;
+		return -EFSCORRUPTED;
+	}
+
+	xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_BLOCK_BUF);
 	return err;
 }
 
-- 
2.35.1

