Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EC45E8CE6
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiIXM7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230482AbiIXM7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:59:20 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD291111DC5;
        Sat, 24 Sep 2022 05:59:19 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OBf06j030381;
        Sat, 24 Sep 2022 12:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=9PTdTl0HIjxhByFC4CWfUVyqQcIna/qpH9RxISZna4Q=;
 b=AA+ko4X5zye1DVhUzGKmu5iv/9UkyKZKASM3jIoBiCH0gVzhHtBSgG9AkNZF2Eq/vwAv
 eTyLDmMjthk1xbly8+d4jqYJU4MKjkcfNA58X1bepiwo2beqxvy6Hwt31eHUAGktynbX
 aQWmk9ElH36nbcW8SGnow/QIpSdBHprbWvXtzZoqEix3Bj3ZF5UbR6Q/Pk1gOhhLIyXh
 7dIw/QqjKCf4yGMXQZr5BfAGsQQeUGCYnwdFMM/Y/tBUFUP0iNDmnoINxbD1NkppZbVD
 tkqd/Jw/LlctFRhvxFcJKakjP219zfRzdbDXbq/K5cFDCHpOrXXd43N4ocnNNa+e0vzx 0g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssub8gjk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:59:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4dk4b021078;
        Sat, 24 Sep 2022 12:59:12 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gtpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:59:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fERgwivibs0vHzEb3O6m/HjovWByKud7OCccSZLPLLSaQ0UdCQXVzWRqWgUeSk+0CBxmBSqYGZk9oyTaz1khYqiV+m5JEzvL9i9ps0jDml4FG5AasKn5xHIP2UO/eCsP/aCrTJ++MZUH5Kb5FoMYxcIrUK02uWtwR+ucMay+pg4pJjSy7QWCwD4GI0vyjdb/i8UlC9hcjf5JrHtw0VkTZfUSnP8QrezJvnIXviNZOHTn5CnItkezONSUzcDLkeZGBVEqUC3M4rqmpzDSrAXtiEQhiMsjol85gUYxPzN2nPowJqX/JscfhjE0X7BUoJHCfaXcCBaEx+VmF4qJaACSDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PTdTl0HIjxhByFC4CWfUVyqQcIna/qpH9RxISZna4Q=;
 b=HYniJyWOHhTx8dS8bYYu71ElX62gMZEFKcxnq9eGmE0xRL3T5yUtEEyFQDfqS0R86KgQzd5gM/jCtDBdNbsglJTCqRDGGJ86Sroi/vXAqzy5J83GTtLrSAhdPqFpxtAxZEfvK1wse+K8qxq+Je7vNxqq21EwhWajqyFmdKJpaqyhDDs3jJqJ1LqAI7fxl3dWQ2n/3NwYJY6E4aER2PJ1e7fd2wJ2Kjry0I9RfzitA/23i/+spE1deAne8tzEhARQJ6bMK2k51KnWPogZmbpyEgx8lGiK8j8xwtcpG2XZ6S0WJ9MAHhGcR39LkN9rGEu9Y5WLEs0frWWTlLnVu3ve+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PTdTl0HIjxhByFC4CWfUVyqQcIna/qpH9RxISZna4Q=;
 b=OoHEfG1Q0bmsucplG/8sVQsAQJ0Oybe91PMKsihWkNWlXJR/I0qgtagOWH45zcGI+PR9jKuudsUUM1Ea9qbnxJboU00CUYOpgPzw3mq5Ywbf/CSXrON/Omz/ALG0KUASneMxZsqqsv1IHsOw8yNil1DkdWOR8af/q+kGLVQsx0E=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by BLAPR10MB5108.namprd10.prod.outlook.com (2603:10b6:208:330::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.22; Sat, 24 Sep
 2022 12:59:10 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:59:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 18/19] xfs: fix an ABBA deadlock in xfs_rename
Date:   Sat, 24 Sep 2022 18:26:55 +0530
Message-Id: <20220924125656.101069-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0217.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|BLAPR10MB5108:EE_
X-MS-Office365-Filtering-Correlation-Id: f43154eb-ee52-42fd-81b1-08da9e2c929e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZqIUs9NagiparOcuwAXvlbHJw2XW/OSv0h8yadq6nZaRxRxlCLHeceeHbVPVJ5CnDchiC5v2CfDxGlXPnAmSbiP1NW1heEbBGX9917a/+bm3qBGhwtqd+LB9P6y7+CQId+JJGhh5ZIfdIGOEVVAPOKSlX4n7s+zrv4N0FRxt4eKEoB4oli4VhIBVMB0V8x+qw83zBaw9dF96blf40Hbj1sriD1pKGkWI8b6CAvyzlA2m6Wu5hSRdDr3VmV0g79elE1hHleZHddCM93e0gKkBMiMNdRpp4tShbgo5A/9je12T/pAxql0XqzlQNZ+NAeZCmUpvBhqM0P1DLGq834tnYMZKskbnDAw67AXRhmePwlzMVgxnl+1A0zlmooGvSD1DUZd9Qy+r1JSS6bQxexh2sfUo0YoVnakjcZOl6Npqmx9KvZ94T6C6ddQAgs4QprZe7MPRCgWJPLh8dQOYPt5Rz61YEiE4mZeuUOQflzNXFUOXdhZIKgATJrz/2Zcf58+N+iEpaLS4l78z/L1KQe0zumHMUHlKi/+fFs7h/yjL7yXyru1LukndRnsugJt0JGaBdQG1OAyAZgT/3BJXId3NABt5a6T5Vg+eyn53/L0dXIhYeasYkDbEjy7OPQ8dZ8eK3C1dAxTUhR/Kg+8gCbqdIb1yX+wWm2i/szZFJsqqQ0+jNouT5Oq8V4C0baylLQwAOgo0Ovo2kAz9G86zTg64g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199015)(8936002)(6666004)(38100700002)(83380400001)(6916009)(478600001)(316002)(6486002)(4326008)(66946007)(86362001)(66556008)(66476007)(8676002)(26005)(6512007)(36756003)(6506007)(1076003)(41300700001)(186003)(2906002)(5660300002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2y2cZykhKvnab9hrb/Xh52aFlZt1+I4fHmESduq8Dsr7g8EltlJROkOjktzz?=
 =?us-ascii?Q?UGgWdIIu6LnqIhXM4moCDoJwMjh/WUW4VQAd0IQErkyGBtvxANvYeiSUZ5la?=
 =?us-ascii?Q?uu5OqTe9sK0mZPfbG85GXoODddAGpp1++0PKWT4M0o41Zdf+yf7ZwvkNCRjy?=
 =?us-ascii?Q?EnGZMudMDmlAnwbc7Rtkt1Aw2oYM6VcDBOSANXy1t2dfPRnG49uDpBmL8FIT?=
 =?us-ascii?Q?46LrccUYW9p31rA1dHHd+xCu6iq8XbXTmZflfAneglHNqJnSH3Kn1Wpdol4n?=
 =?us-ascii?Q?13Igxwj4TAn1egYBWa8i5MFtncbzXi/dz3LePR/TNoqKYbRru6LkBKa/H1Xm?=
 =?us-ascii?Q?cBY3hEHLmjLefV9ZbpVupBjaiBMpIZp8ytgrq4MztEds/7fPL1T3tFahigML?=
 =?us-ascii?Q?bzR4JBt9NDCpfJcTlHmvv4gFc8CNYVkQec2MYEFDAXFkOHqgbUibCtaUS9La?=
 =?us-ascii?Q?EzyMGzecn+//MyfX2/nZlXzoC1WO/dRIwIYvjvwx/3OcNkJ23AS+R1I+9KB3?=
 =?us-ascii?Q?Ti0qr0QhiqfZ421uM4oC2Qig+Dthu1a+cY/y4RfCo46g8LatiWBQUpyqVtdZ?=
 =?us-ascii?Q?dlU2Sxt5dRLWqm2EbJ8Pg/KO16ElQtpK6GSmfpbOAKSdPAxncg9RMTT6USKM?=
 =?us-ascii?Q?RQ3yDKn714zcXOg606srrcvNP0+kfPmkxlUOWRtPHQlUMwj9LHwkyvOYSDc4?=
 =?us-ascii?Q?kMLLGkEatlujjT4wGoKGNt6Fowb4ihL1+rInu5SeJbCU8rfhoiPGaUk2UVyR?=
 =?us-ascii?Q?c/zUs3od5Ff0cTgcmAI+SLsr/wfC54DbthPv8/SiGYHkmZd/aVKXjRp6fiwC?=
 =?us-ascii?Q?QHY+3VJUoGWIofITq6v14HumcdIeg7fdAHxMRJ0y2C7564DBznAM5y9C+pnp?=
 =?us-ascii?Q?GLyF1l9K45GTS+FaVbb+IPjiNKkB7SPrFXpzwNdk5HMLCat3pcUnS7YSr7by?=
 =?us-ascii?Q?3MPGCeGuWycGt/vptx9Oo8ekVXlIZdqPQBIP/xeUtGcB+2m7ouxbjNweEuzS?=
 =?us-ascii?Q?8W3lZJHHYRRxAXrY20uLorgr5ic+waGI2L3ip5WAF+pW0LYbf+ce9IHRFxW3?=
 =?us-ascii?Q?PfU0Q6xnaQqsdyj048soeIlcmFzxBVI8FFjrLqNu5ijz/EC4U/U+Gc0gpwUK?=
 =?us-ascii?Q?FS45eTcJWi6ZdkUAlYqnWIFGmtcKLWgDa4iWyHCOhje6nRuygneIwmHW/fUU?=
 =?us-ascii?Q?1yfmp4s38yy0LQWwImQYQkqxVTaTTiiNUQyxCRe6Lwzo5CpX0mTcSvZ0kvoj?=
 =?us-ascii?Q?yFJ3GT3YrINwL0v7xgoIvDjn3V3oVjGc60B48hzEidZGXWcdJVV4TxLW/vET?=
 =?us-ascii?Q?QpmWlpRyo50UHjNE/EhpL+byxoh1tN3KsTtSgTzXVVEbhwEnr8H5DXis2MP6?=
 =?us-ascii?Q?Np8OGvWMDyTLav0jWdvohtwi1oGRm0bCpqhGY/MSqGgvOwbI2d84yOcIYWF5?=
 =?us-ascii?Q?/QSdK4BI7peBtoAFEIhv0mQpR7y0rkHlGRUMmElvlVIRtjzaTh2va2Q9a9c0?=
 =?us-ascii?Q?23Vrf6mLSQ+wDjAhofcVsSGKiRh87Lt0dNmKQRQy0oWQAdx6dxspEqfwP/3o?=
 =?us-ascii?Q?ryviOak13tLSWnwzRYTzqMOiavXkGqfdtYV0DhOOpxoo3PevEMmVrC1OItPc?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f43154eb-ee52-42fd-81b1-08da9e2c929e
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:59:10.3988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0VwouHpq3+vqFwb8HjTU6mUz2v6kwUTBPbGbhr6KQHrMckJsaz8kXcuFw+xAYFEE7uoS/ADixnnVclfIN/KgiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240098
X-Proofpoint-GUID: 9H8jW0JPyNjk997OBAU4KBqNk-W9Y0jB
X-Proofpoint-ORIG-GUID: 9H8jW0JPyNjk997OBAU4KBqNk-W9Y0jB
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

commit 6da1b4b1ab36d80a3994fd4811c8381de10af604 upstream.

When overlayfs is running on top of xfs and the user unlinks a file in
the overlay, overlayfs will create a whiteout inode and ask xfs to
"rename" the whiteout file atop the one being unlinked.  If the file
being unlinked loses its one nlink, we then have to put the inode on the
unlinked list.

This requires us to grab the AGI buffer of the whiteout inode to take it
off the unlinked list (which is where whiteouts are created) and to grab
the AGI buffer of the file being deleted.  If the whiteout was created
in a higher numbered AG than the file being deleted, we'll lock the AGIs
in the wrong order and deadlock.

Therefore, grab all the AGI locks we think we'll need ahead of time, and
in order of increasing AG number per the locking rules.

Reported-by: wenli xie <wlxie7296@gmail.com>
Fixes: 93597ae8dac0 ("xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 --
 fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
 fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
 3 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 01b1722333a9..f54244779492 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,8 +124,6 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
-extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
-				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 90eff6c2de7e..f980c3f3d2f6 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -947,7 +947,7 @@ xfs_dir2_sf_removename(
 /*
  * Check whether the sf dir replace operation need more blocks.
  */
-bool
+static bool
 xfs_dir2_sf_replace_needblock(
 	struct xfs_inode	*dp,
 	xfs_ino_t		inum)
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 70c5050463a6..7b72c189cff0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3224,7 +3224,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
-	struct xfs_buf		*agibp;
+	int			i;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3336,6 +3336,30 @@ xfs_rename(
 		}
 	}
 
+	/*
+	 * Lock the AGI buffers we need to handle bumping the nlink of the
+	 * whiteout inode off the unlinked list and to handle dropping the
+	 * nlink of the target inode.  Per locking order rules, do this in
+	 * increasing AG order and before directory block allocation tries to
+	 * grab AGFs because we grab AGIs before AGFs.
+	 *
+	 * The (vfs) caller must ensure that if src is a directory then
+	 * target_ip is either null or an empty directory.
+	 */
+	for (i = 0; i < num_inodes && inodes[i] != NULL; i++) {
+		if (inodes[i] == wip ||
+		    (inodes[i] == target_ip &&
+		     (VFS_I(target_ip)->i_nlink == 1 || src_is_directory))) {
+			struct xfs_buf	*bp;
+			xfs_agnumber_t	agno;
+
+			agno = XFS_INO_TO_AGNO(mp, inodes[i]->i_ino);
+			error = xfs_read_agi(mp, tp, agno, &bp);
+			if (error)
+				goto out_trans_cancel;
+		}
+	}
+
 	/*
 	 * Directory entry creation below may acquire the AGF. Remove
 	 * the whiteout from the unlinked list first to preserve correct
@@ -3389,22 +3413,6 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
-
-		/*
-		 * Check whether the replace operation will need to allocate
-		 * blocks.  This happens when the shortform directory lacks
-		 * space and we have to convert it to a block format directory.
-		 * When more blocks are necessary, we must lock the AGI first
-		 * to preserve locking order (AGI -> AGF).
-		 */
-		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
-			error = xfs_read_agi(mp, tp,
-					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
-					&agibp);
-			if (error)
-				goto out_trans_cancel;
-		}
-
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.35.1

