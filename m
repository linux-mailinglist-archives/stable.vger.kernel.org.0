Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D9560DB1A
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiJZG3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiJZG3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:29:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8A78111F;
        Tue, 25 Oct 2022 23:29:05 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nbxW017465;
        Wed, 26 Oct 2022 06:29:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=CuS5xwhzrGiDYNrEZC6K96sMt0jPZlNlAqj+Qp4/0UY=;
 b=f6gKPcdGsZ1v6gGE2NuiWfoeBKAEBW3cWGLQrs1kLDw5vP+XszUVdCKkrTtgjcPwI7wY
 prylM7FvQ0lKo4YLAMjCvRXbl1ift7NxbeIIwnOKOn1SZSnjTtLZvcd68puDEZe2J/LI
 ezbFlFV9evYOOsThwkLSMIF+7zx6XWnuE+H0hJrLon7+z1yOFg0O9U20EoU8AzJnBZzz
 pW9kQEo6Vvu7PYKAbaitb4WoTavOnT7dckvNAf7gKhzYOd6vN0X1KK8yLNKBG2c4Z6ps
 wRM6y4mhTHT8m3qvuIzX4TXS87GaKdOSnX5HKhvmBzUb0dwKcu+DwIc69eBx8EeYQdY8 Yw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939e5yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q368wX031888;
        Wed, 26 Oct 2022 06:28:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybe72x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:28:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbeRmJKDLxeLPXppC5XwzvXqFQZmjJD1BaXJZdag6NHQ7HSMuMtC+blsh1ZeuzY4yyrKhN4WM9kBuXxpId4sYNQF1rLA3r+IIkvBgQaJeIVHCDxl52hT+pelVvqaI5XKdUVk+kp/EW7FY80v9kHguvrnQ5hWFBcxU4GyZ/fSIheFPvK1wSrPNPyaebvFk4YW9GIk8hneKUBnfQCvzj1KzOSIk6l47A46L+seOZvzUInxgnedQxmX4141QAplXBKidJPDbrsbRWBtlSStBpogNkFRPPxpY6E7rPAKL4o03IGUWz+ZamZuEhs+gmt/cR2kbsAaUdmFlQcVw8VZJvINYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CuS5xwhzrGiDYNrEZC6K96sMt0jPZlNlAqj+Qp4/0UY=;
 b=RwQjRA2j5URuUsbmGrVGWusyiO3aJ7vjkMRz8+BdISlBIcg0zm/0e+zskpf43oORWhvZ+JyvFcIWBgmxkVFHSgeK/7h/IBKh8lnDLtFasWRSm1zUvk4VbRMcYgQUrb6pflr7GA8Jp4lhTyF93JI2ANWhP0FYWno4SfFo5x3nsN3GV9XWBr9yPO55TsmFVT82tjujw17/E6xtXikDUunxrITAXp/4ZGdOQzAX4zb9LI+CBg5OxJMDxSF+VmJ0SBwYomc8P6mAbLeSLRr87xCynd0s+vYy2Topi2dBpZ6RTx0lyHsn3mBRl2tbAtBtHWNvYabPKlqbuRegb2QrNYyTmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CuS5xwhzrGiDYNrEZC6K96sMt0jPZlNlAqj+Qp4/0UY=;
 b=gRsjFDITko9pfrsT7KEbUWdB0UzYirsrHuZ0konekLcYnrXns7IouPOsaMsGBCX1GJrL0X6EBRVpsRohUyW2fKJVGh/8Nbecmw1t0gjMF09OxhGnv0GGTBxOna3gpqGepBi/1LL2S7kYR1wUtVeIPv8z6Fz5AJeZPkPVxhe6fuk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CO1PR10MB4498.namprd10.prod.outlook.com (2603:10b6:303:6c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Wed, 26 Oct
 2022 06:28:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:28:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 01/26] xfs: open code insert range extent split helper
Date:   Wed, 26 Oct 2022 11:58:18 +0530
Message-Id: <20221026062843.927600-2-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0002.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CO1PR10MB4498:EE_
X-MS-Office365-Filtering-Correlation-Id: e354fca5-fe53-430c-fa74-08dab71b5c03
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fQObL2MXhXKj9mBFxFGGhAF/6SQq4/iLu6s4b8kE1qv9s6qfNH8aXzKD1/oXAL9bicncnt9xg2G7MEEQLbVxuj+VhjaNVAV/y3Oxrpck4yJeOQZwgXX55Yi+KpigUbSlRrL9kgYdqL4tgR3wVHKUezLbg5AagL4SdPK1Dl+4DBv7h8jaIZWIrohT0UC/pgGZNSXu/fQhjla7IYC1aqYCdyYy0i0fHzQrmZqjVaig6C9zBXGZfksTGxCpAM2ceVROD9iELfbioxhROSGH0oQIYghJVyGF5q0gS46tu8pRk9RwU3fY15bbsbhxJfu4Ip3d1mh07vYSo85eD4GTkDSHRJE2qiaZlfNa3lbwaag0iR1/0My2lqQOVvVtR6rnUwMexNterEnXNuNLNYJzX3MBYgeMDBE8AhYLddbESs4pT8fQcfuxjrfOPPKMpAgl79wYsbN7dU5TlgMFGERaP3lW9qwshVg62EaiGx7j839tR+FsMuBaKcs7U3niUlHhOV3VUWxUM75lOmyHig3NF8oeyB+zkQGFXDvRnfE/mtL9lJLs3ZUdG0ZfE9ZK+af2kmbvz5M4iUfrwPst91JCdG5srD80PeEiutgqeVtfLPxfPPb0iH6dmAZOzef048xvRMJwFTpUdkFV3GQD2zXMZTTKgtABipddnkl5IcyfcuxXjQSsZjt1gmV7lkJkOWnM1ZhKavf93LzzVznhAL6Azm1Izw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(186003)(66556008)(41300700001)(478600001)(2616005)(66946007)(1076003)(66476007)(4326008)(2906002)(8676002)(38100700002)(83380400001)(86362001)(316002)(6486002)(6916009)(6512007)(6506007)(6666004)(8936002)(26005)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fspjqld80oYbefSCRlyrhdZLC+CaG6rUy5Q7XhzfYJAByMXm5vCXL+hj9gY/?=
 =?us-ascii?Q?I77DUGtb252QtTTkxGO0tnj/Bo6ZO6hcpQiubP04gL7MWXgTCaSY9gOlTHCX?=
 =?us-ascii?Q?EiaY5E66T+a/ygQMsLReuwO78jhozpBlY5M3ct5oemipEYlSsKgggW6aboD/?=
 =?us-ascii?Q?wQa7hOPhxERqjvrLEZ4Qm49d6Qd3tOKGzKajEpkxl3K0pJllk4dXuqtd3QVx?=
 =?us-ascii?Q?jhfihZgr267JrjWhygayDfFRNBFbPFu7ptOJvfOTYu2+AQVOZliM5SGbouO0?=
 =?us-ascii?Q?VUsAOXQ38Zrk/XGoDj5IIcjtbdtOsiaB0Gw8G/On/2u4MX3mrhzZu50pAfCw?=
 =?us-ascii?Q?LnB/A1Uz8SON3SJdg7D/XYMHI7zcQtw/7f34Mt7hSVpxxDZq9dn2FJY9eDL6?=
 =?us-ascii?Q?CYJLzZ0TF8y59dcN21o2d2MAC4DwWG7HiEICQ+6emt0XhSUX99LSKRxnm+z0?=
 =?us-ascii?Q?yKBcwqC4YeRZXQOiWuEOi84Dh81/1P0Ot/P5C1JmJJjSmdd7oXZ4K/eazrwb?=
 =?us-ascii?Q?j1yb+t2Yfd4mmsuTShRwrC6FvH8ysRdAR5Vgz6qYC9awGbssgselOjCuMxTN?=
 =?us-ascii?Q?cWT10KbDVxbnkguGX+rMGJHjlbb1LYI6zVhkiavM2nvPQByYWfNxgiKWYAn3?=
 =?us-ascii?Q?C1DnEZBIGDMHCTL83qgw5Wll1Z1gnyYb8v6bk/bAqHn0mTHkx3mn7Z4L8TAj?=
 =?us-ascii?Q?SkcXRu3u2xN33rPgXdHD54J9JPOBsUwm73PaqOqSvHz9tKuxqcRn2IyGDHIH?=
 =?us-ascii?Q?SO/kfzyycfXLQoFDz6+P3NMJEZ3vB+tOLfMuUHFvkUfgEaHTMKNehrBcst5e?=
 =?us-ascii?Q?5xXtFOEW5Dnjn9szMP3RsvnNFZlF3uRKO4vWNlMAM9Fclgeusl0EL+3C8jnI?=
 =?us-ascii?Q?hOMB3MuKvZXVP5pON5Q0i9DQTv0YFJQUgX3doSrXRqnNEO6HN+W35HnK7ciW?=
 =?us-ascii?Q?wT0aayeQl0pErtc4dlSZLC2rwFzqMs08OHAL1P0TTpaTGfEeuim575bMF/lT?=
 =?us-ascii?Q?RX5Kxe81TozhBzlkN+yIICd6Knv4TeVAdd8MmjLHFkU3Q/BZ00uJF+4zsygD?=
 =?us-ascii?Q?RspWoLd4isqTGf0l7MwCo24byQp6I3Xat7Uxb1X1lpKbyHx8k4v47dlUjKGv?=
 =?us-ascii?Q?zNTc040tb6Jf6NJvNFoC/ypKgE+puKvLiAWs2nrovwYAQ9lspWQYk5fCZwZq?=
 =?us-ascii?Q?kPFdFoq99trIgrY0HyHNUG+AYCApiSvauvkRD2RU8AdCcVufY31nsRScAhVs?=
 =?us-ascii?Q?OJQMd5C87YI0L8BkKbkFMjZNyDWRHRE7d98oCuRTKxI4xmH6HLgrEEIxy5DU?=
 =?us-ascii?Q?nSB/mT2iOKXzT7RAhSL0fV4q4BPvmo+Cl1KPO0H0IOu1E51Nh3o6uhmYQ4TT?=
 =?us-ascii?Q?QPw+wuQb0YXwA9Z8pwHOPX0/B16nA40+8QFTrAClskasdVnPQErQHKAYtwLb?=
 =?us-ascii?Q?vAZe6enJiJlyde6my31Ku1Vc0xdfyHzHdacgt9GYgClS7gtHd3u3xj6QBsLh?=
 =?us-ascii?Q?rvjt0pl428YUICGdBxYb1+U+zICiCCCHpTWnnQOIJnGy3lBeY+6yYHqz+Wsm?=
 =?us-ascii?Q?Oz86OmXX5Q42FmgLaOzWC01mX8mlKxzB16160Wiv9U5iNUhOBVOJfSV3xMMY?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e354fca5-fe53-430c-fa74-08dab71b5c03
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:28:56.4297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Al86mhScFM0vkr0vq4+yefyK5Gf7hG7By5FXebi3AKMl4Ol71xxhgJuTOV1h7HCJBwmEip3y/AsXvR2lx3ROLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4498
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: oaiI9gpd-z3oZM0rUSBFAwGYdaNVvQDz
X-Proofpoint-ORIG-GUID: oaiI9gpd-z3oZM0rUSBFAwGYdaNVvQDz
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

commit b73df17e4c5ba977205253fb7ef54267717a3cba upstream.

The insert range operation currently splits the extent at the target
offset in a separate transaction and lock cycle from the one that
shifts extents. In preparation for reworking insert range into an
atomic operation, lift the code into the caller so it can be easily
condensed to a single rolling transaction and lock cycle and
eliminate the helper. No functional changes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 32 ++------------------------------
 fs/xfs/libxfs/xfs_bmap.h |  3 ++-
 fs/xfs/xfs_bmap_util.c   | 14 +++++++++++++-
 3 files changed, 17 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8d035842fe51..d900e3e6c933 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5925,8 +5925,8 @@ xfs_bmap_insert_extents(
  * @split_fsb is a block where the extents is split.  If split_fsb lies in a
  * hole or the first block of extents, just return 0.
  */
-STATIC int
-xfs_bmap_split_extent_at(
+int
+xfs_bmap_split_extent(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb)
@@ -6037,34 +6037,6 @@ xfs_bmap_split_extent_at(
 	return error;
 }
 
-int
-xfs_bmap_split_extent(
-	struct xfs_inode        *ip,
-	xfs_fileoff_t           split_fsb)
-{
-	struct xfs_mount        *mp = ip->i_mount;
-	struct xfs_trans        *tp;
-	int                     error;
-
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
-			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
-	if (error)
-		return error;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-
-	error = xfs_bmap_split_extent_at(tp, ip, split_fsb);
-	if (error)
-		goto out;
-
-	return xfs_trans_commit(tp);
-
-out:
-	xfs_trans_cancel(tp);
-	return error;
-}
-
 /* Deferred mapping is only for real extents in the data fork. */
 static bool
 xfs_bmap_is_update_needed(
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 093716a074fb..640dcc036ea9 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -222,7 +222,8 @@ int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
 int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
 		bool *done, xfs_fileoff_t stop_fsb);
-int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
+int	xfs_bmap_split_extent(struct xfs_trans *tp, struct xfs_inode *ip,
+		xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
 		struct xfs_bmbt_irec *got, struct xfs_iext_cursor *cur,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 113bed28bc31..e52ecc5f12c1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1326,7 +1326,19 @@ xfs_insert_file_space(
 	 * is not the starting block of extent, we need to split the extent at
 	 * stop_fsb.
 	 */
-	error = xfs_bmap_split_extent(ip, stop_fsb);
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
+			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_bmap_split_extent(tp, ip, stop_fsb);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_trans_commit(tp);
 	if (error)
 		return error;
 
-- 
2.35.1

