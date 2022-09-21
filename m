Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB735BF444
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiIUDZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiIUDZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:25:07 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56303205DB;
        Tue, 20 Sep 2022 20:25:02 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLOPwn000811;
        Wed, 21 Sep 2022 03:24:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=SqTaj/6wP6sp4mp8lWTjXMzexUvzV2l6wHnpkCoqHNg+Wwy0mq9VPDA88dwpOlFWKb5X
 GcQB8hElsbo1QosI4DzOyj2LRBm7X/eG/ZUvsjW9N1oSLMrxrRwJc5sJu5+u8S+bhh/w
 xPi+VJlcTZOKAEoGdZ6qIbh8A+L7Xfy/AoR/b3Xc5thkCwBusW1Nsn4cqKk9M0T7hbSN
 PN+MD7cc9oHejcwdT6oH7NwnugYEu2ReTC7KuOkLz4jQUbjlDD+YKUA3TcKFukmsdwpF
 oj5w5pm58s9Wm2ifa7cxloK65cUYvsKyqz521M6DYbsXg3OoHu/efZs/4WwIub7YJt2M YA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68rgwm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2Z0ax009922;
        Wed, 21 Sep 2022 03:24:57 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp3c9p5tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qmp5WiwLRx1+zqjCiLCyS7OopN6axb4NybvCPXTTfc9d/2oeCmVTlqKSlCa/o3mJS0AIryX7Ns0lYbukOV/TNnRKLFFe1m7u1zIVdPe3obwIi38Kt6cZx+3RijlfXUx4a0W57pqHnvCHDh6YKtWrC7wtSPypbKsX7pjh228solsG9HEsjlTYabSFOgQQ8UQvnWDvqTuCPcIU3m/VPC4FYig0pQV7+m1ElOKwIGBYzIiMlctjvcd7xuiyhAhVoqMjiOMmPzHsDX9kIGRG9jxbkv5lxRLTlIVf5HRwy7sqPP1iqdGwhvislQGSgeVBO8zXc1ZsIw1O5M+LJqjClPlR1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=cv24UnN/WZoGB7zX2vlvapoSgv4Z83LUhiuo4jrx0C7bhcumCiPnaOrThJduEMpm6erBD7bkSEO6U5zMrlCATKcYjjkiOcqw8lzmkNoyVaELD7q2NQ1IgUmt7t28LjmwgcWs/BZfYkyiZ086dNo9kZI/2gFsalELZJgCVHIytpGDpJuq4Mti6cAzu2D5Bdy8gemW9h0SH7GZTkerQuQnDGe9FB44KYhVOhf3V4wyoj28vofPVSCkq/1f+bk4EEjMOBtUNU02BtFdoF47CAL/SNwWMwSTimmRIPElo3BijuUwrfAjI0WPPVohwj1EMh9UYoTBjhD0xL/FPhSReA1R+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=CTnK3MhbGwG64eonagh77M6hb4V01fi0Iem/339FFHpu837Zd2NgbtZV9zcmO7f77b7YmYAyHjtuJp7IMNUr8dE7rW+8zqSAchGaMxVHeYS7IdXNc07F+3XDvlsNH3mkwBEgXAaPoCQ2f0ndIXpoSHVq9+gV1ITjNOitvV4xcxc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:24:55 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:55 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 08/17] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Wed, 21 Sep 2022 08:53:43 +0530
Message-Id: <20220921032352.307699-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: 208901b8-47e5-4e3c-88e8-08da9b80da6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yO/6gDNkq/RIzFhI0cLl9VvZz4P4HRGds5dNfq877P8mfk5WhMGiyUCEiUE4IznCl/ywJsLJLfyFX4zuc6jbQbnza3000lhUdt03354cNYuosjvZw0plY/+sNZjWSidERh5sOu121s6/jPk4O6Y5mfZT9ULT7vUi+W+jrsRan+b0r9Jneq5X9uKa8hQz2OLMzjMQSFIJwOHtEVnxvo1HWUm7nUkrB3lYUsZ63lUP+8V/a0L+Y7lAQRorXGjWxFMuDff2OwSYci65ONfY6CoN6NboesuLtfyvqF9YAKUbeCnaTWkTSbuvSnoivSido4USHXeoa7Qo+/RzdLJJOQzfbLrEyJyZbhSyUCVcR3FSOvkB5f1tZW5L6TRMXyjzszQzMo44XsSf+I0UmhOUvwki7T+/3rniufedruIUUIecEOrflZS5lFT06IJjt4ejo+h2cT1fDjOEU/JbYgVUQ4QtLoRjVIePbB2QztUWKB3VRIuf7giuy0/6mWtvd5Lev5plua5K9AB6378qLVnwAvi+TtU6A4cMYUEu4lXL6nRRRHbPYcnZrTiWGEZD5sn+A5a1sIvY4SnTpcUr3gWSofSV0ppN64ItG/B2mg0iDA0Jg7b5ia0JS+VBLGWSY4T7F7rVGalxtHWxTflkbRLYOwMcxj2699rv9TFYXaQcLBdmAZwTE3z8Q+rBQd/i9z1oS9yxyYmPCZmgDaAmNqNnlf4S0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HDJv0HcrllRHC0yo7hGykmdsO1h0JtBRzDLJsyOUbdMEKeUmCtlFnXPLn7yy?=
 =?us-ascii?Q?Nx9RAJufU9UVJmVZJSzQiij8VaEcJ8zYXmQ6NvA1qMZ7XcmzpeCkkdQTEnZ8?=
 =?us-ascii?Q?roJO9kgA1C5QjQAkgJie1t3NzGlSQFp5RYCz99Z90CPU7O3KK5Y6u/kRxBzO?=
 =?us-ascii?Q?ot1BsH5S8HYUKhinV0Qus6XATp1sK1Kw8gpaTYIuji4m93JvrA2iEH3rw9sa?=
 =?us-ascii?Q?IVgVkDYbus3NzVaYrRSaM2NGMbgBhvA0qru/t2XuiPLwaWcE2zIBmva1k3qF?=
 =?us-ascii?Q?e0yJYKRSU/CI+rZ/H0AUv4UOoE5+hHr6bJ4p8qIZVBmPnST9bVvLCsEbRvOL?=
 =?us-ascii?Q?qC8W16QGZPIBGgnEMNeWPv5t9m6ICU0fN5yNo9JPjwokvOVKG3t3iZIj6LDU?=
 =?us-ascii?Q?/M5KiCOKSV8DOsVgJ+ojByvlpuJRCXlHS/EXN9FMfBGe8+BozsBPWWQvWzJi?=
 =?us-ascii?Q?PZtZGk3SgZV/kFqCjbXzGSzLP6CnU9LIpQM/YcBfK52RS1UtusFbzwMBah7s?=
 =?us-ascii?Q?4va8IUukp6QtN5+45SV6vXpJ3eWsuIwHlgM8NOtlAmOz5eLOvyrKZ07RWhD/?=
 =?us-ascii?Q?ndO8U8bE1JKz9oNQsRR8NJ4Rbrfo3oH9VmycvudOZLMq/i1D/MHssONlnZo8?=
 =?us-ascii?Q?HPvFRLHW6vV8R9IxPZ5ypeVtYLNopt2il9Po6ZrtLqxoghE/8z8Ld2q3jbbu?=
 =?us-ascii?Q?wfXLQCX3JbErEOb+/f8NIUf45MPlLORHSzMwphwcz+9Flk3nL/yKoIjP9E5M?=
 =?us-ascii?Q?HwHriuWmah4fMv0zvqnjRmeDgZRn9lBrAVdk1qbEf06WN2RMQ8XB3W83gslG?=
 =?us-ascii?Q?ywdQTfnbCuJtWhQ0vou1mXkAnEpfXOcRurfEYLurBH0hNMc5ezOEu8DwKENO?=
 =?us-ascii?Q?vTGTFWyI7pWLQbiz09LQMCZjK37rL5Xez9OyPpbyMf5zGOkrSOgvPi2NratA?=
 =?us-ascii?Q?lj9PAwzs2Hid3kf309ip1U9p+DavzQTHTskJaG99T2LSpt29y+aQIzFNnX5H?=
 =?us-ascii?Q?L0Ij3rH7jyQUBzxMd6ZUm9nx7BVmgA0G7/e5eNyVE0/0m8p1sWGXbmhXJ43/?=
 =?us-ascii?Q?xvnvLNkeG38vgqlLq19wLwh+jpXTrVlj2yZg6q7g9rq0Ubki3DhZk0WUjv4y?=
 =?us-ascii?Q?wIgwwSWnD76GNf6OWeqzpiK1scR+afU0/iIznmpZwFGcVOhH7yBgotQqC69J?=
 =?us-ascii?Q?otaZTYjlkMDSW3SB7KH3xlS4jrIsaE9TPqg4MrcNGwga+rPB6ar3awyuv3+g?=
 =?us-ascii?Q?Y9so9MB0MkVtOwbTUFQUaC0F5+WgRAlWcyAg7I1G9BbpYPQYjgLtI2a5E7mQ?=
 =?us-ascii?Q?xZXnq2dOOA6TqlUoG/SMwYT77sOJYBm3KimTKVYZyv1YD0YXyzW8HTZDx2wL?=
 =?us-ascii?Q?iMiT4hfPa1CvCYHfREwFzGm7gDrFnu9G10/8QHnLKJZJgAvjmRFno8PZ2eop?=
 =?us-ascii?Q?5bhjnnacjMtRTXFbdKcS3eTuK1ap/Ix1T8fQTnCE8+ukVfy6+cofeKBKQTlt?=
 =?us-ascii?Q?r18njwZnvHS1EKT9uk9K49vwdtfVpEh67dqTRYQf5Ff71tIw6AgfamwiWVuN?=
 =?us-ascii?Q?DFpzKYzlVXgqI+ax/pW8Z2xMyVYnum3idDd+iydRZPNHkn2cXuN160YvA/jl?=
 =?us-ascii?Q?0g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 208901b8-47e5-4e3c-88e8-08da9b80da6a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:55.1704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLe1OaUGKn8WMrIc1JIYSHmTf9WpDHvnxxEosygHlHnUa/1aTNBNzFqKfesk6Kfcssh0hoEZ5Cp6I1BEbEit8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 mlxlogscore=779
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209210020
X-Proofpoint-GUID: MB3NymfFpexj0x7tnklx85rXlosZMoRl
X-Proofpoint-ORIG-GUID: MB3NymfFpexj0x7tnklx85rXlosZMoRl
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: kaixuxia <xiakaixu1987@gmail.com>

commit 93597ae8dac0149b5c00b787cba6bf7ba213e666 upstream.

When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
need to hold the AGF lock to allocate more blocks, and then invoking
the xfs_droplink() call to hold AGI lock to drop target_ip onto the
unlinked list, so we get the lock order AGF->AGI. This would break the
ordering constraint on AGI and AGF locking - inode allocation locks
the AGI, then can allocate a new extent for new inodes, locking the
AGF after the AGI.

In this patch we check whether the replace operation need more
blocks firstly. If so, acquire the agi lock firstly to preserve
locking order(AGI/AGF). Actually, the locking order problem only
occurs when we are locking the AGI/AGF of the same AG. For multiple
AGs the AGI lock will be released after the transaction committed.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: reword the comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c | 28 +++++++++++++++++++++++-----
 fs/xfs/xfs_inode.c          | 17 +++++++++++++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f54244779492..01b1722333a9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
+extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
+				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index ae16ca7c422a..90eff6c2de7e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -944,6 +944,27 @@ xfs_dir2_sf_removename(
 	return 0;
 }
 
+/*
+ * Check whether the sf dir replace operation need more blocks.
+ */
+bool
+xfs_dir2_sf_replace_needblock(
+	struct xfs_inode	*dp,
+	xfs_ino_t		inum)
+{
+	int			newsize;
+	struct xfs_dir2_sf_hdr	*sfp;
+
+	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return false;
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
+
+	return inum > XFS_DIR2_MAX_SHORT_INUM &&
+	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
+}
+
 /*
  * Replace the inode number of an entry in a shortform directory.
  */
@@ -980,17 +1001,14 @@ xfs_dir2_sf_replace(
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		int	error;			/* error return value */
-		int	newsize;		/* new inode size */
 
-		newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 		/*
 		 * Won't fit as shortform, convert to block then do replace.
 		 */
-		if (newsize > XFS_IFORK_DSIZE(dp)) {
+		if (xfs_dir2_sf_replace_needblock(dp, args->inumber)) {
 			error = xfs_dir2_sf_to_block(args);
-			if (error) {
+			if (error)
 				return error;
-			}
 			return xfs_dir2_block_replace(args);
 		}
 		/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a9048c4c2f9..8990be13a16c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3215,6 +3215,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_buf		*agibp;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3379,6 +3380,22 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
+
+		/*
+		 * Check whether the replace operation will need to allocate
+		 * blocks.  This happens when the shortform directory lacks
+		 * space and we have to convert it to a block format directory.
+		 * When more blocks are necessary, we must lock the AGI first
+		 * to preserve locking order (AGI -> AGF).
+		 */
+		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
+			error = xfs_read_agi(mp, tp,
+					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
+					&agibp);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.35.1

