Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0975460DB47
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiJZGb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbiJZGbZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:31:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52F39C20F;
        Tue, 25 Oct 2022 23:31:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nZF5017455;
        Wed, 26 Oct 2022 06:31:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1aU8+QCH+AjYn43tBfVw3u2X4TYKpWaFlXG4TIxIgic=;
 b=bTz+N9fy8E0ZvRWa05osxoI5rj0j1V/U/edBa2loFHisvCPe5J0RE3kINxktvmwbFmYk
 daXYgI8REyhBKAu8eyvLPC6K3wx8lxYQ2926lT4D1NDNXSFh5eECfHn6KORuu1IvggDl
 yER30zoRthsHSjfljvdO5I3YxGGcgD1TEWBFZpswMa6XJz5O7K+MRfydxTHV5/Ob3IkZ
 Gxgtx50Y/bkojIvYHs3Hl7HmcIpJudG5583aKVFDOug7IfnxSk0LrZVDK+z3EJqZfymm
 fuZ+Y3z/p9j09ze12tnxEA1Ots6+8ogtka2UWIEkqog7oEUdZuwNNgM9qGyCogh3UOVn YA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939e640-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:20 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2eg5G021972;
        Wed, 26 Oct 2022 06:31:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybpsm4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEF9gV9uVN/aNCedDxt+RO898icg5+HYm9P/emMGBVP//y3iOwZK70Kl5UGP53Z6eH/CJ6RbJuLeuw6Bmb9G9jiphI5XOF/7PBf4HPNawBVooKmLWtb6SoC9hXTj5PrPAlGkMGNlFVg9M4oDGwbiy4FtxSzrUfkkXNyAVuiJsWKODllVIFKIGJ97ZijeDcFqAuzO7U6smyzGvFbjbLTRusK28rLr/1Mv1+TqGkD69N4Z9WkKv1kkje/YgRw4IMTn97DqE4LIxy/f2aSJHMdI1qXAra04m3RKI5tXV3ygXPMEIqlSVkuI5FSxjln+lKtyQkXb4HWhOu3dy1rnQvhv4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aU8+QCH+AjYn43tBfVw3u2X4TYKpWaFlXG4TIxIgic=;
 b=Am9bxNPNl5NKrckYRrxM/NFOXK7CjLfNIwTDCvirApCDcwPDM6thT5MGXwGh4rwXgSVUcF6PYDtSHVCuvebaT3l3lVCvplIIzEJHrUj1ZwXBbly3HrMqMm9cp5Itiz+LCJSlGKeOopBKr9BdZkn9vDJ+TktvUYgElgMA4/W7D4yXhsbP65CqTdpv3PxbKk2fRzdskyp3vX4LGB/Yqnx7IZ8lg0Flz511gASDCu+KWpprckaD9ovAP1Jf9f+eGjP7MjaxFWjF8Swb1UUe99pntnyZY9M6xMG+NQWp8p1wwEurL1YBJGAU2b96uU4qE+SzIG7SyYCxlCBgh7WK2DdMuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aU8+QCH+AjYn43tBfVw3u2X4TYKpWaFlXG4TIxIgic=;
 b=qQm9Sp9iv2rOBaYGHtpH/63X1mOwN8DFN46p6MKkbc4erTDBmCsBfbzLXt54zMq2S+RitIbD+CulzvgimA19B8dz37rp2pnDb0z+K4tg5qHx7YSI4RJ284f9AfP0JIB8d+q+V6/QFScOiRLzOY2OoN2dAX9Gxm37cUmCFXXF8YA=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:31:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:31:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 23/26] xfs: factor out a new xfs_log_force_inode helper
Date:   Wed, 26 Oct 2022 11:58:40 +0530
Message-Id: <20221026062843.927600-24-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0051.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::6) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: e34b4dcd-1ac7-42a5-e8dc-08dab71bb023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5h29XHu0WSBZRQM28yy6oxvdXAfF45fDv00zt/r13dbKgEEFpTTBl1n3ywTE0DvFrFH7lcT/pDeQappRI+rqoK3BooEYCMK7TDQym6TGBFi1aYZ3BrkFbN7JzxXaf5nzXbduu/kV+HIyuXWYTHDiCQrzoI1cQHLyaOjkSyytMd4eC5tgH7i+fztT+tHJNJQ3u5+UsCIH4ltWArbSTPoCicSdfrYQx39O6anmDwegahDu9aLg/i7u7NWOCeOhNKPVwf+6FrOPLt5d3em4HcUJGKsPvB2yVu3o1VE3JFspqb3Lepv1GHNNPWojf2Yu4vXdrcORn2AOJLtTejYeeqUIVgIW9iLsoXLAmTAb04yGRKUza0W/1z9oVMKHsQPFewxNSYmFWx19FlQmCrS1tVWnS3D9ThD6SIIYJxdbt+EkJ8yDkMuQrF0hAyS1JoUAk5DnKv2pwOL3x7zVeSWvFVZPHy8NcRMUyGGSIMIrADiRIA85kISNyvfJasXnCs8tQvmg3wPwig0vH86diZ+QOMDoR0wkau8F+kyQSNbSm5yoxOWDp2VW+btSiKFiNHTjBdVeBM9s9n1Fy655RYt+iJaELQf2za3rC5KUhrAVcljgZMMC6Ouln7W6RTIAAmyJE3T7AHSpvUPb1/nvqH3s+PYlr7OZO69HNNsScfCi5GHfpGHwnARiY/nCLJwSbw5kP0YXHf7wLz9GldotpkLy8xRZNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cp8K+/3oMnIqHEdH6Eotr8o0OlMJEnHHKv0pxH7iR66jLYUD9/7b9uWGLz3e?=
 =?us-ascii?Q?UK3tzbiU1bBSvVJ56vWz1qD3AkzN3PG2Y0oFxX62ChhmGI810zwUL73OEOcw?=
 =?us-ascii?Q?8WthE8FSfBR/CDbr+SfOMWyMZUDadRHK+tkpIWbm5pMmPuQfbCk/L7H354od?=
 =?us-ascii?Q?Wp9myNxiZNT/u+ffyEZNaK+wXOnHB58mkUTutesf3NeM4eQBTlPUyOn40XyB?=
 =?us-ascii?Q?eyIaih2N7R8PgYMXR75dQtrhf/nv7L54cIAB8QFHV6OcP+tPLNnbIZ2Yww05?=
 =?us-ascii?Q?dkDLd7xl2hrgbWs4ET4f/E3wDJVtf5N5Z6v3BKvq0kTp4OwFl5XEb+F4tCCF?=
 =?us-ascii?Q?NLLm6QNB8RtQZduaCIO4VrHgCuI8rFtwHQu6LefKnRCXcG3AzJ4RrmxLBnRZ?=
 =?us-ascii?Q?hLy8QR/9d8BoawCg78bzUl+hZ9WzyxgLNmqDrFB90gUS7DQqDD9mttI0B1e3?=
 =?us-ascii?Q?Qn52Dhrhl8AszMJfoDcEcaLKKWV8GFJur1xBS1ja9M8GEzQw5QvVkbcyLABu?=
 =?us-ascii?Q?joJHVgf6Y4+mtqRoauUGaPg9BVwzdYiMqabKe5Duk1JVZTMyNToGc2oPYMJ0?=
 =?us-ascii?Q?NoNVJp9S2RdxNt27urqHM36jDnamC7crGLQvmAe26dSHXNtV2jA+zp2eA4dl?=
 =?us-ascii?Q?/WpDmECli2BYNPLVG6djEuzOFzJIx4STb/p9buf+XAJI+BmaJTTAGipC79ir?=
 =?us-ascii?Q?lw2HjiR/mncUWN4GyMNXmSlwWykGfCM5JyTZ2h+iiXEprEH54eT8Bg1flYlT?=
 =?us-ascii?Q?m5wx36hC3/BFGXrZJNYyBG9EvxONYJ882iPPrEo8oo0gLBF3YJrviWYItOua?=
 =?us-ascii?Q?7HUgGt8sS2X6Ab0anFqkW72/TY8a1wjEWTEwS6JtHAlk7x8yuzbslA/O3rEA?=
 =?us-ascii?Q?/PybF4Vd5IYidlcWhnxnONuo9KZI1GuclQIaV/9HB8/SDAA8IoIUU2DX5ScN?=
 =?us-ascii?Q?RgEZdqv1GoHlXgDTO4PHHd53zq2PTuRK6Ri7DckKlknWwKwUWN+MFzPzSoJz?=
 =?us-ascii?Q?VTnuAh3qOQNZi4O3DfPI40U7/dg6HkK70EkC+GCojc2a/CGDwkfXJ/Lc9lj3?=
 =?us-ascii?Q?oddnEc2R6X6oNK5NTEL5bZ/YKxPeAQpNdUMuOYP8jT6DJRYS+Dlqk7iiLUaJ?=
 =?us-ascii?Q?Lm4ZMvzsKHVxZbrjMG5hjTrFhFrPS8TOhSa9+sYD8NFtP150/26ThaLtFfTm?=
 =?us-ascii?Q?vgbnF3BLbKwnKWCVw/KEEgadLR8C5mYUsgwf+gyLKDJtAVuPhFpK/FvDtAAX?=
 =?us-ascii?Q?yxnhcbsn5wDMpQgPB9DEqbkgWjuacScz5vtMYtfhrSd1GcbD2VEwN77rPnts?=
 =?us-ascii?Q?zZN+qqTP1L/u8cv6xBHhzk6XKXH+X24njNLhRUmv2/CClByATHzKeO+/CswS?=
 =?us-ascii?Q?k5wkk+Mh6yvEcg/xn4DYBFnZvxCzb/KRUByEXeV5vpQcZEFS88QoNQBumE54?=
 =?us-ascii?Q?gDjo0wDfIYhN5t9pokUaELuobVnq6wf2qgIUZNEarqNwOhLptmS1Yk2/qOnS?=
 =?us-ascii?Q?uRH+73xEW0zK2IwzxIHjLDe5ibRZzkm2+BQYwXfLGmesorOUR6CIPtNIpl8g?=
 =?us-ascii?Q?r1zEp3roVpAhSwqXWo9F1i11B/c09PEUW3LUUu82XX9BMPs2A9cxqAhnf8ep?=
 =?us-ascii?Q?AA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34b4dcd-1ac7-42a5-e8dc-08dab71bb023
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:31:17.6314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HP5RYu9TvTd/arg41Wj9Vxu+WqocFmapGzyup9eJlyaKzwBtjGjPrKsZGvRsOU1VBgow57zdjBdjAO/cifDShA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: nbwcwfDLDrdXtu6mc2qiurSINwtRBTlI
X-Proofpoint-ORIG-GUID: nbwcwfDLDrdXtu6mc2qiurSINwtRBTlI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 54fbdd1035e3a4e4f4082c335b095426cdefd092 upstream.

Create a new helper to force the log up to the last LSN touching an
inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_export.c | 14 +-------------
 fs/xfs/xfs_file.c   | 12 +-----------
 fs/xfs/xfs_inode.c  | 19 +++++++++++++++++++
 fs/xfs/xfs_inode.h  |  1 +
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index f1372f9046e3..5a4b0119143a 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -15,7 +15,6 @@
 #include "xfs_trans.h"
 #include "xfs_inode_item.h"
 #include "xfs_icache.h"
-#include "xfs_log.h"
 #include "xfs_pnfs.h"
 
 /*
@@ -221,18 +220,7 @@ STATIC int
 xfs_fs_nfs_commit_metadata(
 	struct inode		*inode)
 {
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(XFS_I(inode));
 }
 
 const struct export_operations xfs_export_operations = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e41c13ffa5a4..ec955b18ea50 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -80,19 +80,9 @@ xfs_dir_fsync(
 	int			datasync)
 {
 	struct xfs_inode	*ip = XFS_I(file->f_mapping->host);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_lsn_t		lsn = 0;
 
 	trace_xfs_dir_fsync(ip);
-
-	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip))
-		lsn = ip->i_itemp->ili_last_lsn;
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-
-	if (!lsn)
-		return 0;
-	return xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
+	return xfs_log_force_inode(ip);
 }
 
 STATIC int
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5f18c5c8c5b8..f8b5a37134f8 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3973,3 +3973,22 @@ xfs_irele(
 	trace_xfs_irele(ip, _RET_IP_);
 	iput(VFS_I(ip));
 }
+
+/*
+ * Ensure all commited transactions touching the inode are written to the log.
+ */
+int
+xfs_log_force_inode(
+	struct xfs_inode	*ip)
+{
+	xfs_lsn_t		lsn = 0;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	if (xfs_ipincount(ip))
+		lsn = ip->i_itemp->ili_last_lsn;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!lsn)
+		return 0;
+	return xfs_log_force_lsn(ip->i_mount, lsn, XFS_LOG_SYNC, NULL);
+}
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 558173f95a03..e493d491b7cc 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -441,6 +441,7 @@ int		xfs_itruncate_extents_flags(struct xfs_trans **,
 				struct xfs_inode *, int, xfs_fsize_t, int);
 void		xfs_iext_realloc(xfs_inode_t *, int, int);
 
+int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
-- 
2.35.1

