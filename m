Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4EC5BF451
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiIUDZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIUDZM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D278A24F3C;
        Tue, 20 Sep 2022 20:25:10 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLObiD002074;
        Wed, 21 Sep 2022 03:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=uKmyQkey0R+nEpofdYw8ICgyc3TjBeXgXH+oTrmQ939gNmJ29YLRLu5nLKjJF2IAURUC
 A4ojMsPcWFomuddQTtD1mGTdKQbGDtj8e2cvgPjHjQtCUBDw7/1zDv/0QriS4hd4E//6
 Nq/fArAXmQbGBj3t958FgDOx/GyrgzIk2Q+fInR+j/W1XtaR7Cj+A7x/MYXUh/IMSVCL
 jFLtnPa5T0fdl6E5eHvUe5kOCz4kpraQd1szKT/8QHnPe0bc+MgALsbHtmxowzsh2+Gn
 XkVZh9oW7zH7Qu3sGjJbvVXIFTstYupMe6+sfem/kjo8HgYqENo7KJJ1NwTOM60VF8SN Iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn6f0gpth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:06 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L1UAiW027812;
        Wed, 21 Sep 2022 03:25:04 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3cnyuyk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:25:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzX6RLih45dyE9NYUpDv5sGzR1A60zOvq66/Qp3ClFCmkEXLHzuuHZR/uX7sGlboxUys5inybVZbmDn88VkQmFvrZ5gl+GRU+aOnZBCV/J1T39rCt/dgXL8NkNM8Bhc08Ct+ZDRh89mTW8mbakVylQSWaQQ2ZR4bvgUN/83TXeFUOXikGli/z5ufbQVq0zFPsVzzn5unydZhBUzaoOaGCSVZ+5VL4lJEkx3k2r9GMEUCo0p8SblsZ9feKpdNxzsPxI+9iH/WlV0nHoCcosUYtNlvmNqEIQD1TyG3rAS6ajlqr8CinJ3I3B8a4SssTrF1JW9iRl+SV7TZRaJFRZCbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=n7+1dSVpSrRaKMgIvJ7t5L5u3RK34qiw9LoN6gpvNauIqtZh+wj6Zpa/JB/Z/+N71biHJ0sL2G3WDRfVxFH5M9PUkUZTdBiaAkeey4fF9K6gWnz3Lxh4DNCXetIHZUoYUes3zUl1PE3wATSjtdtf5PZyWUoEMMfN/PYI8Wy7cU9VY6QysAryCiBO2CIyTDblbSDv876Ai2uSXcu8rQ8zJGu2F3rlXkrjRkHKayn4uWp8VAJykgLuBu9NQDYUbJQLamMc6Rfv5/5Y/PkGSmnr8catF+67rnTPFBKLvABYCJQgHBh0mbtPbJlm7EkcVb4g1ehSskSNr1QMUeQZg0uixw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q88DHcZSi9Ef5su7Sw3ISrjZDSsuudo27tMSIUZwGqA=;
 b=CILyJwwC0JAQH5e2Zb3HSt43OaHGZtPY+qKk2g8k3BKWc4m7z6juJRtGF912msyoh8iztbizpnFezu4hs2ZyzEfktSAXa0AidwvnKfMf0sU4leavFvgneNLSj3ZQBFexs6ect2hLEZdTDG/hI+1mDher7kfP3QDF21hoxPIkP0A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:25:02 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:25:02 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 09/17] xfs: convert EIO to EFSCORRUPTED when log contents are invalid
Date:   Wed, 21 Sep 2022 08:53:44 +0530
Message-Id: <20220921032352.307699-10-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:196::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 419d80c7-6fa0-4dba-0204-08da9b80deda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JgHhV3nHIskSfNrECCXxVzRlnyEdoSd/szQXOSDBPJz0TdbsVS6sEvjzn7jMQfPuINbBiOlKLHREi+1MOVh7NZ/2TkGESXgIobyD5htYt9m40us8cKt4f9hAztgwjUqavpmAu8N7pYjFVV5VabuPZ5LSpHM3ODntuZokk2JRiwVfDPBU61zyzPtGfcqcLT1Rltw0za6cCkIqF0H9zPmPdO+nPjmjnkrJNESbs9OIz0C/KM3hZCE4atXDYfvDrxkBSUSkruVbsDTs1r7ymnYk8aACY2/kqjtc0/VIo2yJ/59t4z81jjBzMXOh5XQixo+ULIACk/NYgDlW1aIehvkvRWDSoQpFaxkhHiWrDIPz6cy3N3bcnHeBSAeqTmOrzDyBZRxc5USSmz5/657ZiV8C2oukHjf7c+qrld5MZ1ZBO+A4+xMfm2aikvPOsQ8qa0VKR4TKlteKVUOOI1zSunOWGhex1+Yn9clfY5xePvC1PCftQygSBs8aEvw5gPtkP3XsjnFbb6lcJrSwpfscHrz0qMO9zBA7mvKEAh8N9OF7X0zNZaq+f2mCq8p+v7rjP0Ft49LvU7l/5D7M/9RzQBdZMLgxr21ps8uwo6xeGLkYtgL1ABHaFcP7yvFplSJlgJjJMikwfDKjIEQKSL4FPUsIoM9ZO9RHxRMb3bvTkddjf8ORvYT9bAvsBGZtL791ypIrXrtJaTt4/BdBmaWSAHJdQw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PKfiK/4ij/52QLkALWbQea8j6T8vPVSDv5neyf2Qqc09GePoQhzhVgM8RLzo?=
 =?us-ascii?Q?U7EE4h4ZUNDInY8gvLVK9NWJJLSwDJfgod44PXsg622dqrL/+KaarwK5fRte?=
 =?us-ascii?Q?KzDpggbHSGMLPw+wzZqg+oYnn3TKzsLtu8dXsyBukTmUFLiWucJAm+Mgxcfi?=
 =?us-ascii?Q?tFWO8MdoMCUdPZVCSgfGToRWmXAHiOpthkAjViWpI+cNQ4R8Ik++X5l+MCag?=
 =?us-ascii?Q?YFvCyoVXvgQDpBl7U/Obt/Fkg8lG/te59WJWRCllzCr6q0MGBqX4P+I6u3LI?=
 =?us-ascii?Q?OPJY7zlxpWsNMR3O/HCGRJaYR2UJ1DDFoVXdaSls8uabMSN0aE/nAqi7MQa9?=
 =?us-ascii?Q?b28EDADXyM1vvDC87iP361RZ23dS+U02dDtk3gNsuJbfP9HomHupko/nPx8N?=
 =?us-ascii?Q?prDWqqtWLPc4UnlPEM8rMlk37c9Y4dLZZZHg0zr97+SbQc9AGj1Oq0KuiEci?=
 =?us-ascii?Q?5e8UvE9LGnX5C5QZElyoDUxrU4kGpmL9qLM+GYhcffMFm96DXJah6y7Fdd6i?=
 =?us-ascii?Q?27W8qsxePXfzOZuQy74elN0/if3L6d030bP0tu9alXCRDC89PZ/nE7I8jo1R?=
 =?us-ascii?Q?uc4Fwx6/nwZVFMKycR7eBKfygNWz+qkL1Eyr0m3GXejHL4dOSKzlyhADNrXY?=
 =?us-ascii?Q?zr9AAvN6Q6KtZ0tbFYBYAf+Icuv0q6jw+ZJCjNN3kyDRMQtfodH5kt/7DV6O?=
 =?us-ascii?Q?C9CtHHJl6XViIY2Mb1acrSJua5Br4iVX+PkBPCOadWVfNuCyUFW2UBglU6Pu?=
 =?us-ascii?Q?LmWcENkO8Xys34odV1Vp5/u871NyhMbOuXpAbwdmsMbQvfgOPas4hHhDwCRg?=
 =?us-ascii?Q?oYN+56qcpFqJfoOujcGghxRZECd9U/t7zxhN2K3DOmqjlFK0oFWx8YF/yRcR?=
 =?us-ascii?Q?pPLZ/75GnqPgwTjQGBYVO9JSFGiyuifSaK8aNCGcR1LOFv/6wtWfCM186i5i?=
 =?us-ascii?Q?ImR9yNivvNZ+cAiJEOVz99yoqTEhGuPxpJqRghZv3tWhb4cPXyIE2JuqiAlP?=
 =?us-ascii?Q?nan3NOce3Ox1PaAGz6Xm9VTe2rB2AHJJX16ND/37aeIu7gtN8/VsXCw/yDbI?=
 =?us-ascii?Q?kEInCtbriaVO3uwufoQFSJdgmFLVQmzbY+nta8DateEaRy67iTKPiq4UjgmC?=
 =?us-ascii?Q?BBdcAcG2x7x+nQtXDq0cMpnJ481Pt+RcbHWavZZ/dazkkRS9goJW6Jd2dKp/?=
 =?us-ascii?Q?xgYfSksvJowFr1rhFyPRyemE8A+ozi0rEOebk9Cv1lJRsDfwQU98K70Ph8ai?=
 =?us-ascii?Q?e85cW25xsIoAPqBSdLD6l/JaoshfIaUXdVkOJwKlF9EZqE+0QxIhbwtNySF8?=
 =?us-ascii?Q?iwtFL+eCBkZ9HnQoVGrCPywFp84auUcSbv1oO5WKPzB0tUEvRpCjz9+8PU6P?=
 =?us-ascii?Q?qZp5NaFcf8WZVGtspU97ZqHu66KvZMtn9So/4B0B9aiI13Y84ridg5ZJOjJz?=
 =?us-ascii?Q?WXwBSMbGPqpq3jRYpkkX9Eqn34ioElOJaKcuQd+u1eDoDCxIk56U1v4w8nW/?=
 =?us-ascii?Q?RgZYu4iI8f0MNFrUhEvJjKgWsZuenulIZWR+6MCljgI3vz8Kx75O6D+iIscY?=
 =?us-ascii?Q?hS7evlIbQ4E6h7g06tnkJuABhSSGw9r6ppT8CHv7U59r1UN+iqzpxqcs/iZ4?=
 =?us-ascii?Q?tQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419d80c7-6fa0-4dba-0204-08da9b80deda
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:25:02.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iUxHIv5zwMpJACxbIbKETVYeUHh2DpV83Ds57YrBFq/WuVYi4x6rEUp+j1j9BaSsDYdKkP3Vg+ILGD53phicew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210020
X-Proofpoint-GUID: SUbvDgGpbbWYgPQ3hcbQPUfOlXCeYZgY
X-Proofpoint-ORIG-GUID: SUbvDgGpbbWYgPQ3hcbQPUfOlXCeYZgY
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

