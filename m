Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0205E8CD4
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiIXM6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiIXM6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B7E10E5D7;
        Sat, 24 Sep 2022 05:58:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3SwEx015810;
        Sat, 24 Sep 2022 12:58:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=OniqqiAB2+6Wm7fxYwJpQToGLvvkA/L3JSGkeyKT295DnOmPNzRTP5yCFGj/35wAanei
 CCv1RPBu6pVR52B2zvd6+8EBwlrODzfN3mSFrrtSFYe1+7Pfeq0sgvO6Uzlre4KeORY4
 27AeUAzJ3RzLcetIxBm9X2hRUFcGSfj+v1XrBBfqdWPt/cwHKyU0wNxtar0nt8bD/A/z
 sytDfF3SQhJ8JNNVYD4YK5JBa21ewc4bm/lvRojtOBDDWuf6yNz2Yj0fBUgMSIWKYu6b
 wayjf9AuMj0msvw1QrUayjLSgXbUQU2iDh/jf6/9BCJjn0YD/yXVC8htA5Lj5TGTgYK1 TQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst138h15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:11 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4d3JS033158;
        Sat, 24 Sep 2022 12:58:10 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gwwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L+lJeNwrALHKwAQyCq8uH9zRHUC+UY0bo04NOuQrq6MnR9EvlvTC5sIyucmfu6a1l7Pifjr1ay6s8iQZW7D9bHoj1cq4XX4asIvVcExJdsfA37gVHhH9bgGVVZp3OGyzJ2QjqRm0H5RfHwsD6FqdY0dWHXxiIcUEvbBfLgrfDPlDxntd8GhMxBIIhFtbFgkO7TYUGX5dyy+XvUWxSLqaKPHbmgFwksusv2g+IAl3HfZkUvrkUZs04DZw818rGwTOC570TSdZq7Y4FaNHic6pvd+nK2P6UHCZAoKNPp7/Drrc4o/d+coiDWCWaFt1NDJokB7oIpUIvOOPkOznP7vqQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=ZSqeltjpuPDXb1wp01b2utl67B3GluAHsfGhSXs5NETfagBm5J2idZc63eOoGoXe14sA9t6l3gFzAp634O6wRmClIjIrH3c2nOIlwS6xvE93myvRxU8INnJc68f9MoE3KQHe2APs9rDl8NG1Itx7XXs00d4Vk6dSS9CLnorjHix3TNgMi26xEH4bwNIVwHG/NbKxNAUgnwPMH+4RMEaZ5EuoVWBLjCTwtkitco32jKM4oQg+8qZ+5/j4YbAQBNd4uuU8/jo/vP5P7xoSPlTR2LJnsP3e21Y1jwFqBE3ZMBYid2tLpJs5HyruOjl5IIHzLspKx2Uu8zAuBf7ZKRIPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=FAENnxR8qe8HeFkp1QlybRjfAu87rMHN/CCvTqTgdPCNX+8rR1oFqyNkdIoYWPZqtr8WNmRT5b9fMLKKj4YG3S4Dx2UjUt0XV7MjoXVZ235Uo4ZgHWRrJVFtEKC6oBo+3SwD9BzBdkFuQV8JQAqCUuJ7ExJfBmD7ngqg1LBPPjM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:58:08 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:08 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 09/19] xfs: convert EIO to EFSCORRUPTED when log contents are invalid
Date:   Sat, 24 Sep 2022 18:26:46 +0530
Message-Id: <20220924125656.101069-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:404:f6::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 06e62b02-6d71-472c-e833-08da9e2c6dc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lkUXkJNFoO+H3FJJYtnmk4/j1UNRxcxfD5eovY5fegqyh5wejoSvlGpx9ea/cZws4wBQpTv4ZSXgMRUuDvMo3MkGxD35zQz0R+Kv2UapVZeEiwStJamfxlK3lbr4HQ2CYncxp+eeTD4+pCflc41FbaneRB9fCIHWRrhKi/Upll5ZeQv1YzAR+l2HShyHCshgnFDFOyiW14zJIhsUPz0NO+DFHoPrBCajsfU+8HLDBekZbzy83xI3QwIocLCso0g/oLPKKZG5ESBDiJ5GjBTOfsoiyB+bThBMp43ySF2NR4Cj4SRHmi/YvIogBJ2qGUS8oSBcMx+6K7fRrEaVzUqe/fmqQpm8iyjYhrk92u/iOtRpggvqDCzdMbsR5wBSsbk6ALYDfbR7hNyOhmDOJSKxRTK9WNV8iJJ+Dd6wfdg7r4GRKJyv9tbPfyU+c73Oqoipy1VSMxfWh0y4kU9Nvx7WfIrh6fCYGUri5RrJ0bEGWRaTQOfG1yNzJ5le500GTKj4+HQkEtaAtqmVmOfd77JtIgQOT9bhaEDr5A5kb3pDhih2pAj1mC/0Ae+QspGqRpaxDvCeRlXZpTEtsRJrTP1PBfqMZgbYRRiz1/f7g+h82Q2yd1E/hneA4s99pU+aa3lTqAeGijpCIxXIA4qrEX3WAaIKDf8DOC7lUeyIg+jidr3qTXWY7wBPAJk6R8gghpEWIS5AdxwzzRDmlYs6HSTMXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OB+SuFWMi8S1cgPvaRUiKVXIvmtMduHQ62y9IJ5SwjTdHpq8/TAxF1TkIA1h?=
 =?us-ascii?Q?J9T9LscFgqKss9GycQb7osBe2HGptifcEizpEW5a5cLoepttdavRirRFZfKJ?=
 =?us-ascii?Q?+1KwZUeKelU4aP5A8N/Op6+ZDTDonyeUzDDdytHl4H7fkUN/ojOpeLAACWzc?=
 =?us-ascii?Q?LJw37tD0/a3OJmjwQDSLzKitz88Zha6TY6Jc4F+ffzQckIg4paJhHapxn2+u?=
 =?us-ascii?Q?njPLHGC1/dfCXRuK3B6r2ljk3G598M0jLoLck+MlSbO8Mpf/fSXUVqDu8Y9b?=
 =?us-ascii?Q?3ZGp/usizrLqrtyQ/8Fw/aE5H8sUJ4WOEIDD+AytoxY210nxDDeZAPUt9G19?=
 =?us-ascii?Q?3Xa1avsglVtq3uBMXXEMfZ8TMgCJlqt4MT8nXIzOtapGtDQWzQoyAOwyKilm?=
 =?us-ascii?Q?qtRq5tJM/gbgugjEqNicQpsPiKOH9kld8zr00KiwLEmSUrHETjVoEl31Z9Qo?=
 =?us-ascii?Q?o4HirknMOXJ1R8+orVgJkkWZGOKPdyg3E5ZK/XNKZX8LckeI7A+RQl+eTjIW?=
 =?us-ascii?Q?lWI5Qq+Dk8hR3NdRwuNNsQjGbiBEs08ODBxvKow1qVVk687p8SBm2VSrFZ4K?=
 =?us-ascii?Q?FGhGmLi5CDbJ0udc7yuYsgM3HOtYLzz/K6EyPvoxQZB6aSu5LEEYJvssWgDb?=
 =?us-ascii?Q?ouFikarR7Bj0mYz3pGJMmsYjjR+zZIbn9HH65LlewDjeJVMU0766LaeRUbCK?=
 =?us-ascii?Q?YbSeSwb7wjvHwl2Fkh+Ul461hH838uK4t1LnVXyS9WN8/53VbBiD3S8ks+Zm?=
 =?us-ascii?Q?yop/mHhhQsNNl0QpxRYLV+vq0yGPBrovLBtnEtpSvag3F/2a2a8GmLpxfDhl?=
 =?us-ascii?Q?IyNhOQURE8Yaq3f0SYVOLKL/mwLG30CGuYEA5LbGBoORCXnGdMKDGLFC5S2E?=
 =?us-ascii?Q?szx0CODZoBH8ls3hapGPfARdYNw7zvX9oxC95qTAZ2L/I+YAetEz0JbE1sK5?=
 =?us-ascii?Q?p6gFt/FMvZJS3CuSDmz/xyYuelvRity2lL3ouj5cg/6RpT+MMDJtdThlZMnO?=
 =?us-ascii?Q?ys6domr70hhgOXsOqtSlHXdcfDwU9H1rDuE6SzvKMAjZiH2BaDg1W0o4tnhZ?=
 =?us-ascii?Q?OXqhoZ+NhKHDb/cGniyqCaOIJDfs/quhMln+49vx1Z2r2bcjIlvuy/Q8g7fh?=
 =?us-ascii?Q?H+HhiiEGAwzjhFZ8hToxJ60oVTjMZQw2he0KzZ0Laj9oRzxwsc2B17+rpvKG?=
 =?us-ascii?Q?d/E4mgS3h+wruorozvIpSPAZOHu6A+kvbQR0Ifa1r+mE6ETJ2vJxXMaCnFDU?=
 =?us-ascii?Q?Ad0RmiAed6ScokG8a4a89iEUpfnLaHpXDlQDDa/hHhHoWl+xfphjEfRjXcOu?=
 =?us-ascii?Q?PC5jEknaKOEfdWbkVwrQzFcCeD974MNG+Yy2eCE8pQbooxiROK9TLaHnL10a?=
 =?us-ascii?Q?IKFUnTuRcHKD0GRH9IlxaDJOPUUXGSrHKO5NK64N0tJDwt3Lq+4cbvSO+Pti?=
 =?us-ascii?Q?r7haRaI3tXfK7sYi/XN5uOuWTqtkkUFE/a6CqIBzJQgwR/QLbJptmkqs10NY?=
 =?us-ascii?Q?eYA8uTpzAVkjiHPgDazlzMZfre+0oybCWgDPI+nI7Remzlz+HGHvV0IgRkpc?=
 =?us-ascii?Q?QVM2Gvlt2MHN5ct04umkAVnDhYXJRtabrSIO0WaG/XDcWfWL7/MbxRzf7wqn?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e62b02-6d71-472c-e833-08da9e2c6dc1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:08.5863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJDEgvjsZkWCuOcV3TgTyssmhDTCB9IBCUCHNlrJ86Q0yGxtIfVuzD18qabmlxWFe/gj0b/uhWQAQ1O7ZQl4Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240098
X-Proofpoint-ORIG-GUID: nKOeGXg6wKsmR2XRSH-mveR852DfNlPq
X-Proofpoint-GUID: nKOeGXg6wKsmR2XRSH-mveR852DfNlPq
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

commit 895e196fb6f84402dcd0c1d3c3feb8a58049564e upstream.

Convert EIO to EFSCORRUPTED in the logging code when we can determine
that the log contents are invalid.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_bmap_item.c     |  4 ++--
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_log_recover.c   | 32 ++++++++++++++++----------------
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 5 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 83d24e983d4c..d84339c91466 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -456,7 +456,7 @@ xfs_bui_recover(
 	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -490,7 +490,7 @@ xfs_bui_recover(
 		 */
 		set_bit(XFS_BUI_RECOVERED, &buip->bui_flags);
 		xfs_bui_release(buip);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e44efc41a041..1b3ade30ef65 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -624,7 +624,7 @@ xfs_efi_recover(
 			 */
 			set_bit(XFS_EFI_RECOVERED, &efip->efi_flags);
 			xfs_efi_release(efip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 094ae1a91c44..796bbc9dd8b0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -471,7 +471,7 @@ xlog_find_verify_log_record(
 			xfs_warn(log->l_mp,
 		"Log inconsistent (didn't find previous header)");
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out;
 		}
 
@@ -1350,7 +1350,7 @@ xlog_find_tail(
 		return error;
 	if (!error) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
 
@@ -3166,7 +3166,7 @@ xlog_recover_inode_pass2(
 		default:
 			xfs_warn(log->l_mp, "%s: Invalid flag", __func__);
 			ASSERT(0);
-			error = -EIO;
+			error = -EFSCORRUPTED;
 			goto out_release;
 		}
 	}
@@ -3247,12 +3247,12 @@ xlog_recover_dquot_pass2(
 	recddq = item->ri_buf[1].i_addr;
 	if (recddq == NULL) {
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -3279,7 +3279,7 @@ xlog_recover_dquot_pass2(
 	if (fa) {
 		xfs_alert(mp, "corrupt dquot ID 0x%x in log at %pS",
 				dq_f->qlf_id, fa);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 	ASSERT(dq_f->qlf_len == 1);
 
@@ -4018,7 +4018,7 @@ xlog_recover_commit_pass1(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4066,7 +4066,7 @@ xlog_recover_commit_pass2(
 		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
 			__func__, ITEM_TYPE(item));
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 }
 
@@ -4187,7 +4187,7 @@ xlog_recover_add_to_cont_trans(
 		ASSERT(len <= sizeof(struct xfs_trans_header));
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		xlog_recover_add_item(&trans->r_itemq);
@@ -4243,13 +4243,13 @@ xlog_recover_add_to_trans(
 			xfs_warn(log->l_mp, "%s: bad header magic number",
 				__func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		if (len > sizeof(struct xfs_trans_header)) {
 			xfs_warn(log->l_mp, "%s: bad header length", __func__);
 			ASSERT(0);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		/*
@@ -4285,7 +4285,7 @@ xlog_recover_add_to_trans(
 				  in_f->ilf_size);
 			ASSERT(0);
 			kmem_free(ptr);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 
 		item->ri_total = in_f->ilf_size;
@@ -4389,7 +4389,7 @@ xlog_recovery_process_trans(
 	default:
 		xfs_warn(log->l_mp, "%s: bad flag 0x%x", __func__, flags);
 		ASSERT(0);
-		error = -EIO;
+		error = -EFSCORRUPTED;
 		break;
 	}
 	if (error || freeit)
@@ -4469,7 +4469,7 @@ xlog_recover_process_ophdr(
 		xfs_warn(log->l_mp, "%s: bad clientid 0x%x",
 			__func__, ohead->oh_clientid);
 		ASSERT(0);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/*
@@ -4479,7 +4479,7 @@ xlog_recover_process_ophdr(
 	if (dp + len > end) {
 		xfs_warn(log->l_mp, "%s: bad length 0x%x", __func__, len);
 		WARN_ON(1);
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	trans = xlog_recover_ophdr_to_trans(rhash, rhead, ohead);
@@ -5209,7 +5209,7 @@ xlog_valid_rec_header(
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xfs_warn(log->l_mp, "%s: unrecognised log version (%d).",
 			__func__, be32_to_cpu(rhead->h_version));
-		return -EIO;
+		return -EFSCORRUPTED;
 	}
 
 	/* LR body must have data or it wouldn't have been written */
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2328268e6245..e22ac9cdb971 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -497,7 +497,7 @@ xfs_cui_recover(
 			 */
 			set_bit(XFS_CUI_RECOVERED, &cuip->cui_flags);
 			xfs_cui_release(cuip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 8939e0ea09cd..af83e2b2a429 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -539,7 +539,7 @@ xfs_rui_recover(
 			 */
 			set_bit(XFS_RUI_RECOVERED, &ruip->rui_flags);
 			xfs_rui_release(ruip);
-			return -EIO;
+			return -EFSCORRUPTED;
 		}
 	}
 
-- 
2.35.1

