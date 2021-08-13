Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318283EB3A7
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbhHMJ40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:26 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14672 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240012AbhHMJ4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:25 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9pTku007747;
        Fri, 13 Aug 2021 09:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=7h7gwpVuLCFq9ptu1wZGkL5tIMQFR3GYqb2c7DFKjps=;
 b=iKhPgb68K8699DODxu6DxEQjj9oDHq3+sz0Wu+pr4wfRPHy2G3a9dflUnfVUWfQBq53/
 9FCewZot9x5Ncs2c3DlIG4wYxhlE0yJJkTMZFXaozSEwGUmht4eOwHjahyNN/+tm1Scu
 Ph+JQkxRkfW56tmE0PASaxe9ZaQFJyXMcaMhocCQ92zV5hZv0SyWUi4kVXiuAdGlJxDz
 zphwqJjndevVELSIoYFOWSG6QSXCPfiOu/7fUWcF9prA64CTc/NDgAk1q+Lx2T2s6wvU
 AJUkhu8q7TWkIk7wHwI/mkErshGJJKRKMoG/3GbcEzL6wwRHKRLUjiKzFBo363ooNya9 kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=7h7gwpVuLCFq9ptu1wZGkL5tIMQFR3GYqb2c7DFKjps=;
 b=i3FqDSoWz1OL95YiDJI9GgjmMKMJkrB6DvopcRg0vvkvL2d3yNsChQ1sQ2iIj/6mRhRR
 x3qXnHgPKfbb0MFKfaTZc6/flh6vAmejlNoOiCtCp9hxtEyEdvVWoXRTMwgxULnh5MX7
 Qbf2SPKbC1pvgWWlrCSlHseeesAaAXT94AGS4sge6/F8OOdVXi4NXPcXtY/nrp530ZRk
 WIlPWSp3D2I1ih9I7vq4tDHz2p7a3a4+o8no8rvwBhxP7WfztvBr2LKQ5TBNX91FGRnX
 rN2tPUQN/2yxM8aN5sD8A7pfiuep5iNKQVK0/uKlsAjILI/ssSiRozzDeTaujp5Ga8Tp bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aceudvyqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oJlJ058857;
        Fri, 13 Aug 2021 09:55:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by userp3030.oracle.com with ESMTP id 3abjwaakrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxFM4Dkq8ytizlpAxYJ4ErwY5KAZ2zJWVlhw3yhv5K0InLa1I6OfN2hWHh9yh4s8TUWZDEcDU73PMKXCzzNgH6ix/3Jqzwxrb9V+DCXVkeaiXJGWk/VP1TI4iDKVV4cfSttuj7pNG71c9SGeKAjrfrqsG2D/e1DJurjkTHljig5fldIn7CFphO0BkYdmeuIGN2AdBzRP17kusiX82/2RfghvMIsO+DlfMys8YztuXqhDX8KfIuHWZeh2MtIHqUtRe4zbMZqkpYYfWE6GvORFvnkZ5dj7EJjAYsq8WKVU5uAtcOx8s/OTgRc2+80Y3q3zWVyRZD2CxYa95++w4VsImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7h7gwpVuLCFq9ptu1wZGkL5tIMQFR3GYqb2c7DFKjps=;
 b=KPMNyaTR5zG+gEc88ZsLyFjiuXBcGKY8BgKwVTZFoZf887XDMd4z90xjDz0M3w2FRX9SIerAZdgiEmy9qf+qCkdk4u1KXYsBC4fL5JrXqrIH8mb9tnZiTHpyjFyHMIpmibvpGHP5c4hLwDTF6Ai32/WLyxvo3G4D9q2mh/+R6mzrQ0pJoiWOXa8sDglYXZpzqjS7CjBYq5tDVt6dj2NOJf5e8q4kjp4DBNIDWBPMYM1jabf1VjZ3vXNHuuoP8Xa/g7tbN8P3gL+nuUBPBEP6zZD6TJSqinQ0UCgqveT9YaG9OJZT5UbKVARpzlx2B57i3Y9zfpzGhFwBdhR2ivz1jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7h7gwpVuLCFq9ptu1wZGkL5tIMQFR3GYqb2c7DFKjps=;
 b=h32Co1bfYD0cANBP3zNzFwes4xRxf8nPxVv/MzQ5ae0DJob3r2viGuFlHLx5YoixcvM5QSYQQyCojGMcvVLIdS+0tr//gU0p/sZFK07a1TGxvMfuq2uwtfBDIl4x7pgOSsAR4j56+k5bI/gcAVqckuVM6h9aDCp9f0q3fLrqHdk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Fri, 13 Aug
 2021 09:55:52 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:55:52 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 2/7] btrfs: make btrfs_qgroup_reserve_data take btrfs_inode
Date:   Fri, 13 Aug 2021 17:55:25 +0800
Message-Id: <7df1756cf877dc6c51330a5793008453a1ee730a.1628845854.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628845854.git.anand.jain@oracle.com>
References: <cover.1628845854.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0124.apcprd03.prod.outlook.com
 (2603:1096:4:91::28) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:55:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4708e45d-601f-4993-c057-08d95e408949
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB4852A3A39F5B8CB13E69EA11E5FA9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32/jZSsCfDvAfyLHAvgxF1+wWw2KQdhPWFcGYFNLszQS/+JM5wnoF+Ne1xfKpXvQQkxB3ZkEyHV2xQCzPmJCCjZmE9xDcPR6kvRjVaQwLKxeVWNwrZGEojsuufy727Zzxzkemgpk1ss658u0c4jUXBo2SbqAon+rCp+q1yq9n5XOr/uTVxCMrlLJm09fM2wdMeR4SnL7k/aWz82wxQXsVuyFEJmvd2C8HWmTkZf9ZISu+rt7AKbHDo7MuPYtXhmjuoBJFWCwBswMHfi/XJcfubkajLFjpfM5jBk1lOyczotNXzaHmZ0FzOuIAlm+199kEBatdSqZNHgg8ie5myrEN0xgS5xm/V4FY3kGmO2r6EXDoUF5xIuwYTGdnKaG1iwlCl380d7AXl4z8gb3xPltwQJerC4wmlJ0g1ctC+zrtfO7V2eoqs0OilyRUSf67CniYO2mSQGznGEUDGEjPTME/mf+uejaeT6ECl+qCjCyw1j1KVD4ua1fB8D/PmdCwK3S0B/VRbzWKZx1C8t9P3aqP9XPzkmFCqxVYBr/Sf6VUIZYr4wNUnLS1KD/sVpcFtTbE0YGHvMOb47Fb2bxzVeHtFCLrw7iFludfp6IDkyPLwduNgtnTJucayxcCjxSkEst1t4PCD8YnE2u2JplFwLjt97VW5mxNgITF86vuTwVXoee5RgO7tibIim7aR0qKvMS9R3pa3P5Dp6Ott+bTm9erw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(107886003)(8936002)(8676002)(2906002)(478600001)(316002)(83380400001)(54906003)(44832011)(4326008)(956004)(2616005)(86362001)(186003)(66946007)(26005)(66476007)(6666004)(6486002)(6512007)(52116002)(66556008)(36756003)(5660300002)(38350700002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lbOOQi1UZhAS831md6XDSrrDVHSKN5r42UpgpsLBKs3MTZ0sfiMn47D50pRf?=
 =?us-ascii?Q?n0qH5w9PBXObC4VjjPTGitUZWaZ2+am6ccFy9/feYbf7QGqBIQiAwkj5/aNl?=
 =?us-ascii?Q?m6QmQhnydvJ5sicok5w/znw2MW8Aoe516wWu0kjTFrWcODKkSYKtw0VPRBAh?=
 =?us-ascii?Q?D35ZXX8WkOCYDmyau+jYStpRZLh/Sz+T8LemXlaYQBjjFLNCOP2bAFHJ47PI?=
 =?us-ascii?Q?MNQ5/GqX1Er9pbkkrjxubPsKaMM89FHwf7IK291Cr7xqNJ/Ey7ztiXVRaKE6?=
 =?us-ascii?Q?0CBpbs53P4Nw6H83tCXHu2VBkW2PREHJwLH49XOz3ewcw2TTXn4QFM5tK76h?=
 =?us-ascii?Q?9DZvYv66S6++wLA2zFGYSDI7KWICvU2q5jGwLI4WA+7CKlgeQOVaAGqsRAIw?=
 =?us-ascii?Q?jVQ4FgEsMoQta4uKOnYOcviwpoeOW4RcjHhS5a/QCVllpxL/idN2wpHXN3lU?=
 =?us-ascii?Q?BL7LuDBppTDlHEHypzhXUtyRnQwICdS4DBG/DGdrtqliXe03i8acFSKPbszj?=
 =?us-ascii?Q?NFdFbv5VoDDUSdebJj40ZSIEBjBJOsopPWnaqUJzzeuqbFQPMZV14e4zcU6s?=
 =?us-ascii?Q?9UdLjKk5w1GeRwO9WHDk4Aocyw3SNL78n1x/OLFZ8P5ICDMDC+amUyI6DkUY?=
 =?us-ascii?Q?Z/BHoEoKMqkYy4dWdkHqOFsfIpxJlbQuSEg1VIOiscnLGQoeIYA5ZFxfbj67?=
 =?us-ascii?Q?10ITthc2d30wm1Gug+5z5YqxMNyPVSlWDskZfIiPDVxWfAmFidOE0k4M7Kcq?=
 =?us-ascii?Q?OY4m36zwx+WZ0vKiDzNx3fKQLovvzyeY7PF7uzCecST0wjWVmAXrtlAGXOVq?=
 =?us-ascii?Q?uwWNGOomvbSBtYhT6hubFhHzs+QjJ+mO2YuBLKw6tLvcJLyK5iuK47Rcm4ML?=
 =?us-ascii?Q?LHTN65izeHZRmcD61Q+C0EhQvuqGU3dtXErJZGvII9t1SoMs+Rz/b7eJadNB?=
 =?us-ascii?Q?9UTscxOL4/iEe1lVtdXftfhHk9WROxsaNhqEHlTusTPl3B9tUsX8G7k7QQz1?=
 =?us-ascii?Q?O+AiK5q7KtR+wAITQhhRyBvyIXx4+a4Tjyu4gtgUOE2ezP1R6bh7ih90Y5xn?=
 =?us-ascii?Q?6jtWbzwEwvLM44Ssg2h/18aJ2ysMCgdnEB/EIfP9qzznKMgiQgtnOfyFsXBN?=
 =?us-ascii?Q?LUULYj80jqV6twq94wUdWUG5Tavm+XaojxYNl0RSvmX3czW1/LWJiae0CzYi?=
 =?us-ascii?Q?VMWWUN9CxK/621KO+TASKqGmjrojPTQHZ3B5ha4CxhwFHsfvtEqPEgzzYuj/?=
 =?us-ascii?Q?pb53+eTvOUog0FECxBj902r9i6wNLjrWb6iFTXLg5A97D1VvQsL7emRIXytv?=
 =?us-ascii?Q?3tkhWkXxiTpzLtaaQ1QnD3YR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4708e45d-601f-4993-c057-08d95e408949
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:55:52.6981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMeuJcszM6T+Tr7Ity7gbs/wvmzU14+d3Mx8uK3DCo/SiB7xNTiXLEA8xkOWYlc0H1zU7YYsOcreRKELZuh68w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-ORIG-GUID: otG1OePlMt3j3J2IxohCIf_MUV08GQ6Z
X-Proofpoint-GUID: otG1OePlMt3j3J2IxohCIf_MUV08GQ6Z
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 7661a3e033ab782366e0e1f4b6aad0df3555fcbd upstream

There's only a single use of vfs_inode in a tracepoint so let's take
btrfs_inode directly.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/delalloc-space.c |  2 +-
 fs/btrfs/file.c           |  7 ++++---
 fs/btrfs/qgroup.c         | 10 +++++-----
 fs/btrfs/qgroup.h         |  2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index db9f2c58eb4a..f4f531c4aa96 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -151,7 +151,7 @@ int btrfs_check_data_free_space(struct inode *inode,
 		return ret;
 
 	/* Use new btrfs_qgroup_reserve_data to reserve precious data space. */
-	ret = btrfs_qgroup_reserve_data(inode, reserved, start, len);
+	ret = btrfs_qgroup_reserve_data(BTRFS_I(inode), reserved, start, len);
 	if (ret < 0)
 		btrfs_free_reserved_data_space_noquota(inode, start, len);
 	else
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f6308a7b761d..400b0717b9d4 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3149,7 +3149,7 @@ static int btrfs_zero_range(struct inode *inode,
 						  &cached_state);
 		if (ret)
 			goto out;
-		ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
+		ret = btrfs_qgroup_reserve_data(BTRFS_I(inode), &data_reserved,
 						alloc_start, bytes_to_reserve);
 		if (ret) {
 			unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
@@ -3322,8 +3322,9 @@ static long btrfs_fallocate(struct file *file, int mode,
 				free_extent_map(em);
 				break;
 			}
-			ret = btrfs_qgroup_reserve_data(inode, &data_reserved,
-					cur_offset, last_byte - cur_offset);
+			ret = btrfs_qgroup_reserve_data(BTRFS_I(inode),
+					&data_reserved, cur_offset,
+					last_byte - cur_offset);
 			if (ret < 0) {
 				cur_offset = last_byte;
 				free_extent_map(em);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 1f214f80d664..3d8cc8d56274 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3425,11 +3425,11 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
  *       same @reserved, caller must ensure when error happens it's OK
  *       to free *ALL* reserved space.
  */
-int btrfs_qgroup_reserve_data(struct inode *inode,
+int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved_ret, u64 start,
 			u64 len)
 {
-	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_root *root = inode->root;
 	struct ulist_node *unode;
 	struct ulist_iterator uiter;
 	struct extent_changeset *reserved;
@@ -3452,12 +3452,12 @@ int btrfs_qgroup_reserve_data(struct inode *inode,
 	reserved = *reserved_ret;
 	/* Record already reserved space */
 	orig_reserved = reserved->bytes_changed;
-	ret = set_record_extent_bits(&BTRFS_I(inode)->io_tree, start,
+	ret = set_record_extent_bits(&inode->io_tree, start,
 			start + len -1, EXTENT_QGROUP_RESERVED, reserved);
 
 	/* Newly reserved space */
 	to_reserve = reserved->bytes_changed - orig_reserved;
-	trace_btrfs_qgroup_reserve_data(inode, start, len,
+	trace_btrfs_qgroup_reserve_data(&inode->vfs_inode, start, len,
 					to_reserve, QGROUP_RESERVE);
 	if (ret < 0)
 		goto cleanup;
@@ -3471,7 +3471,7 @@ int btrfs_qgroup_reserve_data(struct inode *inode,
 	/* cleanup *ALL* already reserved ranges */
 	ULIST_ITER_INIT(&uiter);
 	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
-		clear_extent_bit(&BTRFS_I(inode)->io_tree, unode->val,
+		clear_extent_bit(&inode->io_tree, unode->val,
 				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL);
 	/* Also free data bytes of already reserved one */
 	btrfs_qgroup_free_refroot(root->fs_info, root->root_key.objectid,
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index b0420c4f5d0e..d1f93585f217 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -344,7 +344,7 @@ int btrfs_verify_qgroup_counts(struct btrfs_fs_info *fs_info, u64 qgroupid,
 #endif
 
 /* New io_tree based accurate qgroup reserve API */
-int btrfs_qgroup_reserve_data(struct inode *inode,
+int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved, u64 start, u64 len);
 int btrfs_qgroup_release_data(struct inode *inode, u64 start, u64 len);
 int btrfs_qgroup_free_data(struct inode *inode,
-- 
2.31.1

