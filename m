Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F023640D3D6
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 09:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhIPHfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 03:35:51 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8366 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234830AbhIPHft (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 03:35:49 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18G6Xoq4011510;
        Thu, 16 Sep 2021 07:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=2vCIfbrd0FAHsAZfZmLM12TTKbgUfSSpxpEZwSFDZK8=;
 b=QkVtFUS7irA7aMyw3YzVebna5apYcTfelTJyq7hePI2Tw1CqD3lCAB1U4u1nqgYXpU8x
 FAQaw+qCPFHeBNf3MdmSFpgET1mlhNNmygOcZ3DW5e2M6Ef8QcH+41+r2fzGYrApCkFU
 wo5LCTR1s4N+XUwZYLR2PSmpeOh5hjAofuChp2Kdq+UsRjazE4Z9ygLwj5sRlqpncCwO
 4io/rj9iH4o67iPia+/+fN3Wdbj3UM2/Kf23Og24L28FVU5NXcqsptxcfTLBy1OKQG3g
 AoYVk4oQO+pYcolWvSlpH4znXR0YBwNdr0RmNMUbMaZIVq/8TtubvfzyFkEQu32Ftcit Vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=2vCIfbrd0FAHsAZfZmLM12TTKbgUfSSpxpEZwSFDZK8=;
 b=eDVQuZek5v4cV2nfCpeVxpcof7/7N3czWSD1tyeN/jJy6mQ95tWJu1t4DF6Ypy4711lk
 cjMAKFQvePu9RhGuGOI4RhtlOHotRqNgUfkp5LRljTqfQVowkL2WEsEIZAthO7LqT107
 yTkcREn3NAPEo93XLnxuAKTb9/wRQ6+si4i1Cwbaq0oAuinf9hJxdDqHrKpQRBQEsfNm
 OrFn8vg1GzFsEZP/oQTV/w+6L3o4+NGAG34O1Zisb3TzYEzEHARt7LYRBPGygbDJWwap
 laNPpe0MU/1d5DBVicWjDSOCsJENGmnpLm7+bFILRqd4TR0Qj+blaizI+WbPZ2esqH9n uw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3vj10ma6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 07:34:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18G7VFPi112780;
        Thu, 16 Sep 2021 07:34:22 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3b0hjxsvyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Sep 2021 07:34:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SMJ/QAU8G8m7PLFRKelt67kYUcXLBQBwrd4fDK0W340juDsGN8woipquKHjRFd8k6F8jakc2eccWkKnHYHVsTRX2663QVmvKx91x9c6j/GVj/KpBOlLEmBSrxyiC1kckrE9zJ3rXkaca50Xddz2G1ZthE/5z7V5QMX/MlJRUXF1cUSITnhgVWgHYCj46HKUg8nT7k/Avjrcnh93trLJVe6Smo1Z0DJMOFib84OtgSeipG2qL0CiCGiu9ws0AnTNctqd1N1a2G25PVwW81/6/t7wwiKyve2KJsP2DIAoj6zJdHk9IVKkRUtuGIXS+2ehY89DRQZYor6y8JatdAneI2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2vCIfbrd0FAHsAZfZmLM12TTKbgUfSSpxpEZwSFDZK8=;
 b=O2VtU0gAt4xy6lkMq/640Wbn6HnRrmpVt5GThddiHtmgJenNDUqTUd6nC2/oZ7/skVSa4RF/2Yn1/AljSrS3cLhHwLGQublemzPgSZvv8Jw0j0t/uATnk0LAttH+c9Z+agfE33h6Fed6u+nLpF+XxZbsC1YVRToKXktHMdDwO7AEH/XtM2sEHo2BlXQCknkjyehHMTLuNEQjuw/yCA4yJ1K6B5ZQR2a4QHl5SpvMD5aHzYnybxQIs1LPpXqaDEmdHIGF9GEf1RHDF9GNrQIDfsO2c6ljeO16vumrNiOTc1+96uC4DLOMcureaTlTXLG0+6kIn1SfyD0V4uNUixRjIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2vCIfbrd0FAHsAZfZmLM12TTKbgUfSSpxpEZwSFDZK8=;
 b=mJpQbfSZgnA5tONv8Ja42/JGi5yTEYjUjNsGYHDLJCXw1z+82OuGA7Hqg24ByGdxUn7tS5EbE0c9ajlZBREVMUpM9quamkjYIuHtY0qmhQJczbMgxEImTAtdATxFr3gKslx6utgn3ofKOrUWqJ6S15FrEk59mnxuXVtW3DdTjAQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB4366.namprd10.prod.outlook.com (2603:10b6:208:1dd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 07:34:20 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::49a5:5188:b83d:b6c9]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::49a5:5188:b83d:b6c9%8]) with mapi id 15.20.4500.018; Thu, 16 Sep 2021
 07:34:20 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Anand Jain <anand.jain@oracle.com>,
        Alexander Tsvetkov <alexander.tsvetkov@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH stable-5.4.y stable-5.10.y] btrfs: fix upper limit for max_inline for page size 64K
Date:   Thu, 16 Sep 2021 15:34:01 +0800
Message-Id: <305e717a1ce9bda18b1867c6fb079f91d6e54c98.1631776544.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0122.apcprd03.prod.outlook.com
 (2603:1096:4:91::26) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
Received: from localhost.localdomain (203.116.164.13) by SG2PR03CA0122.apcprd03.prod.outlook.com (2603:1096:4:91::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Thu, 16 Sep 2021 07:34:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36abe5a5-58ea-4126-fe75-08d978e465aa
X-MS-TrafficTypeDiagnostic: MN2PR10MB4366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4366B61A6A5B9299761E598DE5DC9@MN2PR10MB4366.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EqkMiI574d3PCJJByeOdvyDnpy1UKEIpQ/56srG4mvvYiQpkY8KrawEUQpdLxGxt9V59Pv2O8bpAtq/J86cX10PewVCK7Hv7gGuggSEnqqlwzlxoiHDvvHHuaW/dDfjJqNhZZNWlk0Gq2mUvjv+d0jtN9tjMEpMWRsn3S7SQgBZIHVMkFmLJUT/TMJyKIoFWm/A3kAplBo6eqqwKPaCuVR9PfAi6dJhwkhlEDxJYO4fK4HDSXqH1J8301aGMFrFaVbPfwO2UoTE90/Qw1SEZGdQ6Gr4owhxXnsWESAFhNCEc/b6teETl5Xmg3dp33C1RiApLOvyW/O1Jx6rqICHHlSN4I18YoV1OuMHMeGwN556tzR3HtaKQmx9CcYzI/JNLLNyFpWjnfRpUjlo1HsGQ1nmYorZ92DYFcNBwRtYOry4RfXEckwQYlhhyxiQuLvKxQhw4gukeDuPsKBAh02bkLbWHVOpU58VzkEaeoHvaatwRwMPZ41R4WVlZSBDhcBVz0NjASLYM1UX2MZO5OB/6Cxyx3tsgonGfCMEai6odS1AibH9P3M6L1aRBDJSz4SywMNeW0ToH8jeNePZEGwbkbGfgMch9q9VZGgV4Y34m2GM/ia33CRiAozz8YEKN1Rc3EAoQea4fKIEwBPyrvGzZF3Smnl6Hju1JQWTfIK0ZJzTEiEl2EI7Q4oPt86jOvZ7ZDa8F5EzqaOvX0A5Uf3DiWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(2616005)(38350700002)(38100700002)(6486002)(8676002)(2906002)(52116002)(4326008)(54906003)(44832011)(316002)(36756003)(8936002)(186003)(66556008)(66946007)(66476007)(26005)(6512007)(83380400001)(508600001)(6666004)(5660300002)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tbM+I3FdOF1OQgUn1DWwDTluFyyDY02jWJXeweyfprmIgtZm6PLmzKZFpAVE?=
 =?us-ascii?Q?yia3qd3dcMgTqv8wAfcBNgFuxklKgkj+0gb57pDl4x1RDM71RD3KG0JdcghK?=
 =?us-ascii?Q?nPZ8bnjZ+zFfdXoC7MdcmDbA9P+kpNSjbCTRZbipywjai8/8YLVCS60kuoD6?=
 =?us-ascii?Q?scxujBIdMPcdQVR7j3Hg6ZIIaskelsN/YHa/Jd518k590dd+P3l+wf5A1JTs?=
 =?us-ascii?Q?3zj6cS9QxYiY0NvPa7XPM3JbsCTf9HF6cVDKGbLgtuJUKE5ig27nosGOOrh3?=
 =?us-ascii?Q?z1CF+rmKRapW3ihQSr5AvD8w3eVKsKk7L5c2FD53gOR3PxsDVD4ZLAcvsMrs?=
 =?us-ascii?Q?/iGpIsH96NrnJSFdsKkD+QA1zcFQ+BgCoVy5EJDjNlnd0FMa8VaITmByQldN?=
 =?us-ascii?Q?ux/9Ir9erMM0+lo9UOvdECmi3GLDJQODpwbdUIvoXtVC3UsMO0+5fADgADcJ?=
 =?us-ascii?Q?EEYlCBdIvFnrEuI38cJJsKTWBWq0uZzJIBc2sqIHavWpN6ymgjMEUsH/9UKX?=
 =?us-ascii?Q?QMzt+Lp8Fq58o+h88amWjbQqM9PqO8kEw+rb+wyvG2Iu2fbN9e3Pnl7/rLD3?=
 =?us-ascii?Q?bwoKL6IAOgy5VA0QneBBRZJDl6N3kT1TtC9ZmWLT/AFsXXAOGjV/AeCHEQ+M?=
 =?us-ascii?Q?Og6Q+akjdhrDtwOLcsb0zmyVHArpDJKsPWWuddPIXORvqGlwHHVtLqHj6Q31?=
 =?us-ascii?Q?fwJbCwsONe+9aqzd5vNndW9GTW0ldqq2l94gWRvUIneOWEW0YiwCSf3O/jfG?=
 =?us-ascii?Q?1/xY47UprzWoGuGCkHapHZKGpMu3sa8hUMCH23FZRR5iImFKX0FZcxk5SKEX?=
 =?us-ascii?Q?MTISYsflFVAKl1y0yCNt6oKMcB/WfrzcoCGFj9qBYSrbageU8wKytVrwV71q?=
 =?us-ascii?Q?xpGwgRYQvALR1ATDG+qzTP5CEnv+0Fqog8DYXVF499Q9bqCOhvGVjKit+e6V?=
 =?us-ascii?Q?J401YzlAcPau/Vv1xyOrqs7ev2LdFYs9PwZUAoRF0EZnj9jMfqFjtvUfJ+GG?=
 =?us-ascii?Q?gxXap9nHJTZl/lESDVHfqqNT/dty1ismFAVl3PssFVoEDv6v5brDfLPCDdXr?=
 =?us-ascii?Q?5iAKJY4slLeB0zwe5CcgXqn1bPU8qPpi6MvaE25LG4jochpuKkMc2ZV6A+5c?=
 =?us-ascii?Q?pkTj/nasW3bl4fcclmT0yFm4B0NtmNKdTRF+b3gKoZaCi5f7S1WNMdTspIhy?=
 =?us-ascii?Q?tDC4tBfFntfjF3gQAXNkbkG8Rsi+TpeUUKUX5pWX2Hn/7saPx4yn6RlPDV98?=
 =?us-ascii?Q?UtT4QelPZ5bEAdcooXtuY+MQi93PVKF8DVjuvf0LnOaFP1nMmYfsKkinKfMC?=
 =?us-ascii?Q?VYL7HGP1drZw5cd5rquxkhcQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36abe5a5-58ea-4126-fe75-08d978e465aa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2021 07:34:20.6821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCBwcHHHXWTKRgolJNxHOzcF8kHa4YDK3u2xG50BFRMjedHFV8OTyqKyHgVy5sBA0di0B6xyXwDfsW8vG+Y29g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4366
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10108 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109160047
X-Proofpoint-ORIG-GUID: A8IUwZ4CxdxqZsGoSoUFSbC1bGJL98-a
X-Proofpoint-GUID: A8IUwZ4CxdxqZsGoSoUFSbC1bGJL98-a
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6f93e834fa7c5faa0372e46828b4b2a966ac61d7 upstream.

The mount option max_inline ranges from 0 to the sectorsize (which is
now equal to page size). But we parse the mount options too early and
before the actual sectorsize is read from the superblock. So the upper
limit of max_inline is unaware of the actual sectorsize and is limited
by the temporary sectorsize 4096, even on a system where the default
sectorsize is 64K.

Fix this by reading the superblock sectorsize before the mount option
parse.

Reported-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index dacd67dca43f..946ae198b344 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2894,6 +2894,29 @@ int open_ctree(struct super_block *sb,
 	 */
 	fs_info->compress_type = BTRFS_COMPRESS_ZLIB;
 
+	/*
+	 * Flag our filesystem as having big metadata blocks if they are bigger
+	 * than the page size
+	 */
+	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
+		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
+			btrfs_info(fs_info,
+				"flagging fs with big metadata feature");
+		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
+	}
+
+	/* Set up fs_info before parsing mount options */
+	nodesize = btrfs_super_nodesize(disk_super);
+	sectorsize = btrfs_super_sectorsize(disk_super);
+	stripesize = sectorsize;
+	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
+	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
+
+	/* Cache block sizes */
+	fs_info->nodesize = nodesize;
+	fs_info->sectorsize = sectorsize;
+	fs_info->stripesize = stripesize;
+
 	ret = btrfs_parse_options(fs_info, options, sb->s_flags);
 	if (ret) {
 		err = ret;
@@ -2920,28 +2943,6 @@ int open_ctree(struct super_block *sb,
 	if (features & BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 		btrfs_info(fs_info, "has skinny extents");
 
-	/*
-	 * flag our filesystem as having big metadata blocks if
-	 * they are bigger than the page size
-	 */
-	if (btrfs_super_nodesize(disk_super) > PAGE_SIZE) {
-		if (!(features & BTRFS_FEATURE_INCOMPAT_BIG_METADATA))
-			btrfs_info(fs_info,
-				"flagging fs with big metadata feature");
-		features |= BTRFS_FEATURE_INCOMPAT_BIG_METADATA;
-	}
-
-	nodesize = btrfs_super_nodesize(disk_super);
-	sectorsize = btrfs_super_sectorsize(disk_super);
-	stripesize = sectorsize;
-	fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));
-	fs_info->delalloc_batch = sectorsize * 512 * (1 + ilog2(nr_cpu_ids));
-
-	/* Cache block sizes */
-	fs_info->nodesize = nodesize;
-	fs_info->sectorsize = sectorsize;
-	fs_info->stripesize = stripesize;
-
 	/*
 	 * mixed block groups end up with duplicate but slightly offset
 	 * extent buffers for the same range.  It leads to corruptions
-- 
2.31.1

