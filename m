Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DF33EB3AA
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbhHMJ43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:29 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18056 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233222AbhHMJ42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:28 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9pTkw007747;
        Fri, 13 Aug 2021 09:55:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=X133WTZhUsRBUhAsLsW+tddkHdUY3xLV+v1qf7T1rE8=;
 b=xWtpNaqbSCzcaUdTxO/f/nSAFrZ9QbSNX4sXVqFFRk66AIZyYkCUXDkfGGa93PrRjdE/
 MqeEvaco0sMHr4JUiLopdtg44AOw6f0nlU8Y3okJJs4+LwQO2HnUINNqoCETzBGv3AK2
 85mAzMEpz0tjF/nUnPQkFOFZgl7+YZXhRhq839FhXioV2xjW2vQku0RN8Tf+jGUI3M7q
 8g6SRuvpRTUdmhumuyOxJGXLLHKiWNL4Hq0HVYBkl5259ld+1btqQKTn4ylsX8CIeX7S
 cjYo8L9EIIxIz/huCsPW4sFggrQJXXo22EeNEi5LYQlosKcOJWrf3JeyAVURCyEq8hQy Hw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=X133WTZhUsRBUhAsLsW+tddkHdUY3xLV+v1qf7T1rE8=;
 b=nrYI/XbkySM2HJuNXofweoDg1YxuBEqMJCOHK/fqPf7CdtuWkLJCHhdIrhqe6dxCxvmV
 6sMpbbdt93kt9AbI+ouR5W5UkoP3WfUVRpLYVdkmgSBVTwjuYOvCIhUXaOCbmOldK668
 CPs2y/pAPxbK9qBAjAP/JPNUFHtl/26Gn1fMocit8v7SeRktyhMF+uV68RmM/d/T4dBA
 suDyD0afBqK2TfBteUdFvq/6nAAwGfHN2XF1RCbZel5TlLH9Ar6TICW7jkx0UTHwi0zm
 WBGATCdtEBzSdEc5fCh5gokO8QDJxgzM4xH4vz0vNhbGiRRvBEMIuMNzX9I0GySXChKY dg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aceudvyqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oKl1058940;
        Fri, 13 Aug 2021 09:55:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by userp3030.oracle.com with ESMTP id 3abjwaaksj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:55:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SWX4y1FW2zNK2kYJ73HXpCKGROOAxxDg0PnoMlgZKdBYxkxZoegNR8s6cbocr2bS78Qw9e1NBcyoRfvKAMFBOCu5BiygybDXzsev7wYTtsMlBu5liVpFzoSEbSH8oHT9/LzM14tdS4mStds7F2zrdpL0c0a2O/C56dlZYY72fgwJMNDlRybw4+hAKvlj5152bsAQOOCcsO7zzLQtU+ZFn4s60wT5S9HLqmpSIHq5GmavT5ZH5QT4JYLDcFcyL/f1v7L3BniI5dU6441fFZLJLRStmsxokqhaolnRCVSU1zSCzp0VCqc0FD4D4UjXY8Hu/mQBpAp4dJvtyqvaX2YQrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X133WTZhUsRBUhAsLsW+tddkHdUY3xLV+v1qf7T1rE8=;
 b=ZEhecHmbAr6z3zxqMUYoWbVpyIk3GvlUMR75el+9CuQSHrYWkqzZtKYAqkATx0zGIykZPUpEaSV0qlQxBFpxtxiLV1apc3K8ZxVdridjRChDr1vHaxd2qKSXopxfo+A1RDNCvMdliy8o9As7bODNWgGwU+uon1avZSnljD7YbsWfM72P9qDOh/R+VdfqxQokSTi/WL+IVJvcqKq/n14tHIcS8J6KH5q3jcqWJNkktBf0aB2u0ff58th4kwxfFlKCqiwQOnQbX58yNK7h3ieHKLzf/6FGs9Eet5E65ZhCnLJ4bVA26yGcqs574DCVA0QF7lzVqOMqbpWWY5fkoW2Svw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X133WTZhUsRBUhAsLsW+tddkHdUY3xLV+v1qf7T1rE8=;
 b=SRL3U/v65IxN5XWI/VpwUqO+rV52iTSGon4yu/ZN0T0y8lBpK1DNQuMZ0SaeX8ffZ63kr4i6E+1T7klAhKrYNTn9pD697iPqYZImPvXgQ7hf0Po4MXpcc1u+uBUmNCxKTOXNX/JRcOO+P1FDOyTdDxUNnNaP4U5lyx41per6ZXI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Fri, 13 Aug
 2021 09:55:55 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:55:55 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 3/7] btrfs: qgroup: allow to unreserve range without releasing other ranges
Date:   Fri, 13 Aug 2021 17:55:26 +0800
Message-Id: <d0ba354d6d4e08af313127e0acd44143125b3372.1628845854.git.anand.jain@oracle.com>
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
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:55:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6fb6b40-e004-42a9-19d2-08d95e408ae9
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB485243E3C081E7FFB62225C6E5FA9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f7QafE+gw5fF4AzXmGIym+gwChyyTp39Bb1Jph7WMTu6tEg/U4NEeUoa20+4V1OAe6gI01n/0UMimfD1CGgbOX5yQEhHFWgAcWlo6Z+v97y92Nh6xTSjTxdODmSEcoTicCeQPcmZbm7RVrj5/COlgCbOwuftEaRVLyvBxfx9tQrgNSqT/vnLU3WMRGpn73WkI54HaFTAazIKiAZZCDV3CqhqkY3nDvK3lLNTeql/4OPCoY6Mhq14+Fsr0+Bvss8ClpF7a+f1sq2ZaVtdVQXOhvFwDxtGEW7Wa5TekQxfD6BA44zKJVy5HmZalfcLvvi+Vacna9ZQcNebK/Xt3tEQ73xZDUwwTfgzI22zJJu8rMB1dtUTA7tS6rvMuREa2VYa6d0sKC2bg/OBaEdb2+aKwS49dDmN/1fOxnjx1SzNTXrbG5EB867kE3bArB72VZTyP9Ja6zzsG29sGJGntsSVRJx3XKksUfMDy+dTsYkBdBgPKFt8Wv8jn5zRx4qclDuLHjtUCOntNAyodBM1F8jRXyOkJ3HEl3MM1HRd7BPSK7+fKCYPYQ6cqz2ZkE+sOc47/6QWVfqqc3UXkNYHgOHxf199TEm5RB2u6zlgFMi+YKee5N72IMqwHXgOwljd6ty4VxvyMjxBLBWQw6ZosMYKYt3so92zSRAsUWRtKsWz7uppi5TehfeuyWqfCcybuU8bPRpgCfVUBL54Nq+35pM/Zg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(107886003)(8936002)(8676002)(2906002)(478600001)(316002)(83380400001)(54906003)(44832011)(4326008)(956004)(2616005)(86362001)(186003)(66946007)(26005)(66476007)(6666004)(6486002)(6512007)(52116002)(66556008)(36756003)(5660300002)(38350700002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hOJX0Nl8H+BL3D5msRvI9ZR8jk7tExxjsm3FpfCnOPuKHI00NOm9kBnZyylV?=
 =?us-ascii?Q?05gzYg4YQcRn5KCiwS6+1XWFVVMEDUuJdy9VUbtLDn+1YBXDSpFmiDgkP4WE?=
 =?us-ascii?Q?3guYR7WVhVGkKSdZ7RgxUHktQxAQifwx/47JW2dI+lXkuDXTTTPc3ijzyJrc?=
 =?us-ascii?Q?LRMSNi66mWymsC5+GhPTUo50u/ZIf4D2dEpyqwfOWBacFrskrYMEubAgF3+h?=
 =?us-ascii?Q?E7nhDjfKMAmWDb6YneihU9Kb+6ozeuvX2AH/0SH3E99WnHoSsCRcstoGiovj?=
 =?us-ascii?Q?0WVWjMUoWUC8l1zAD59dwmMFlbnI6kSKfclt1+lfwR81VuUjkvnbAA9T9zxZ?=
 =?us-ascii?Q?xmS7DZxEnLYb+KvPjIIlJgACgMzFbcMhMHls9AgJmH2n+2a5XB7oob4EVoDn?=
 =?us-ascii?Q?KEyIKjuum8ewECV/x1SXWjSbby0KDISMrRfg3cm0L6jeevBldsmLzkfXf3Uj?=
 =?us-ascii?Q?63KRhLTFFgIrhL8JOljQjupg1RbKxcBwb/x/j+4SWGW9XiV04MHZiqt7Bhxg?=
 =?us-ascii?Q?o36I2jO8UmYhZSVd1FWf075Fk20F5pBq5hFWGkacjNhEwVAQ1yr288ZZDkJF?=
 =?us-ascii?Q?CTCbkMGQf8PuDA7Prd9O0C2MVY7hHhs9chKjdoGu8cDabHb0eMlewCpHpyut?=
 =?us-ascii?Q?6Rr9PLR8HXg8/D4eaOPYUDVuI8kTbl+3SWPXCN3tuzEt1U1/zhJT8JhI5TD+?=
 =?us-ascii?Q?yuwVxG+FDCMZIqgIvBHPoGV1P+GIZQaptpXORJC1ASrRaWY1Yg/U5dMh40E5?=
 =?us-ascii?Q?eUityGfEVL6dUuadUo5UffNUK5c3T3B5a46WvXGcfWxwHTiFllFf9kw9hpPO?=
 =?us-ascii?Q?bwwMzjp7/UZVbjYUiee1fGzHo31QVCpN/HqhgkcbPmwFjXWz2zroGmMUgBtA?=
 =?us-ascii?Q?/4A06ufPUJCQjjh8ho3y9P2z5WDNYARrUI8f+FcG1D5p6cvvHuKuGs9PEr2U?=
 =?us-ascii?Q?6FidxZ8ZDjTJsb8ec27rhc647BNX/spOyc0b8D/glJRqfU8QA32291Ip8kST?=
 =?us-ascii?Q?Dp590fx0428v4JO6ktshW5A2KI1bvcau1o1i5Zaxr74fgVeTxEnHqzJORcRk?=
 =?us-ascii?Q?LyT4iN9yQV39NUr8urGv2D/72GsD5V0bdwwZqmuTMNp3KtDX+FW09hEuI9Cc?=
 =?us-ascii?Q?wbtlB//3BcdEn9FVBrN7xQpe21dQLhWLnh08MEqoVgmQrMaYB4LvxNxgsDqf?=
 =?us-ascii?Q?BCMvEWx1JhYKHUYr8lLxufZteB+zOEuT89vZDRyp0hqgMSvx1j9+/Gq72oe4?=
 =?us-ascii?Q?CfESRGu3UH9chJoT8W7tb+Am72rSylodjQfxaipEkOCZXw9jUm9tjAtK3mO1?=
 =?us-ascii?Q?HjxfFn0g4O57uWNG5DBaZXYM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6fb6b40-e004-42a9-19d2-08d95e408ae9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:55:55.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Im4y7OHwFvjwiaB8OrtU5ZdXChjbFOautBagQFGW+W+AHyhC6X3UaSlaQfwx3s6U5ppr/xsX2U8Bad2vFKjJ2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-ORIG-GUID: a2PXQ31j9fAFukkpVDpFTyb0mAvIOTMO
X-Proofpoint-GUID: a2PXQ31j9fAFukkpVDpFTyb0mAvIOTMO
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 263da812e87bac4098a4778efaa32c54275641db upstream

[PROBLEM]
Before this patch, when btrfs_qgroup_reserve_data() fails, we free all
reserved space of the changeset.

For example:
	ret = btrfs_qgroup_reserve_data(inode, changeset, 0, SZ_1M);
	ret = btrfs_qgroup_reserve_data(inode, changeset, SZ_1M, SZ_1M);
	ret = btrfs_qgroup_reserve_data(inode, changeset, SZ_2M, SZ_1M);

If the last btrfs_qgroup_reserve_data() failed, it will release the
entire [0, 3M) range.

This behavior is kind of OK for now, as when we hit -EDQUOT, we normally
go error handling and need to release all reserved ranges anyway.

But this also means the following call is not possible:

	ret = btrfs_qgroup_reserve_data();
	if (ret == -EDQUOT) {
		/* Do something to free some qgroup space */
		ret = btrfs_qgroup_reserve_data();
	}

As if the first btrfs_qgroup_reserve_data() fails, it will free all
reserved qgroup space.

[CAUSE]
This is because we release all reserved ranges when
btrfs_qgroup_reserve_data() fails.

[FIX]
This patch will implement a new function, qgroup_unreserve_range(), to
iterate through the ulist nodes, to find any nodes in the failure range,
and remove the EXTENT_QGROUP_RESERVED bits from the io_tree, and
decrease the extent_changeset::bytes_changed, so that we can revert to
previous state.

This allows later patches to retry btrfs_qgroup_reserve_data() if EDQUOT
happens.

Suggested-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/qgroup.c | 92 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 77 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 3d8cc8d56274..50c45b4fcfd4 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3411,6 +3411,73 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
 	}
 }
 
+#define rbtree_iterate_from_safe(node, next, start)				\
+       for (node = start; node && ({ next = rb_next(node); 1;}); node = next)
+
+static int qgroup_unreserve_range(struct btrfs_inode *inode,
+				  struct extent_changeset *reserved, u64 start,
+				  u64 len)
+{
+	struct rb_node *node;
+	struct rb_node *next;
+	struct ulist_node *entry = NULL;
+	int ret = 0;
+
+	node = reserved->range_changed.root.rb_node;
+	while (node) {
+		entry = rb_entry(node, struct ulist_node, rb_node);
+		if (entry->val < start)
+			node = node->rb_right;
+		else if (entry)
+			node = node->rb_left;
+		else
+			break;
+	}
+
+	/* Empty changeset */
+	if (!entry)
+		return 0;
+
+	if (entry->val > start && rb_prev(&entry->rb_node))
+		entry = rb_entry(rb_prev(&entry->rb_node), struct ulist_node,
+				 rb_node);
+
+	rbtree_iterate_from_safe(node, next, &entry->rb_node) {
+		u64 entry_start;
+		u64 entry_end;
+		u64 entry_len;
+		int clear_ret;
+
+		entry = rb_entry(node, struct ulist_node, rb_node);
+		entry_start = entry->val;
+		entry_end = entry->aux;
+		entry_len = entry_end - entry_start + 1;
+
+		if (entry_start >= start + len)
+			break;
+		if (entry_start + entry_len <= start)
+			continue;
+		/*
+		 * Now the entry is in [start, start + len), revert the
+		 * EXTENT_QGROUP_RESERVED bit.
+		 */
+		clear_ret = clear_extent_bits(&inode->io_tree, entry_start,
+					      entry_end, EXTENT_QGROUP_RESERVED);
+		if (!ret && clear_ret < 0)
+			ret = clear_ret;
+
+		ulist_del(&reserved->range_changed, entry->val, entry->aux);
+		if (likely(reserved->bytes_changed >= entry_len)) {
+			reserved->bytes_changed -= entry_len;
+		} else {
+			WARN_ON(1);
+			reserved->bytes_changed = 0;
+		}
+	}
+
+	return ret;
+}
+
 /*
  * Reserve qgroup space for range [start, start + len).
  *
@@ -3421,18 +3488,14 @@ btrfs_qgroup_rescan_resume(struct btrfs_fs_info *fs_info)
  * Return <0 for error (including -EQUOT)
  *
  * NOTE: this function may sleep for memory allocation.
- *       if btrfs_qgroup_reserve_data() is called multiple times with
- *       same @reserved, caller must ensure when error happens it's OK
- *       to free *ALL* reserved space.
  */
 int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 			struct extent_changeset **reserved_ret, u64 start,
 			u64 len)
 {
 	struct btrfs_root *root = inode->root;
-	struct ulist_node *unode;
-	struct ulist_iterator uiter;
 	struct extent_changeset *reserved;
+	bool new_reserved = false;
 	u64 orig_reserved;
 	u64 to_reserve;
 	int ret;
@@ -3445,6 +3508,7 @@ int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 	if (WARN_ON(!reserved_ret))
 		return -EINVAL;
 	if (!*reserved_ret) {
+		new_reserved = true;
 		*reserved_ret = extent_changeset_alloc();
 		if (!*reserved_ret)
 			return -ENOMEM;
@@ -3460,7 +3524,7 @@ int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 	trace_btrfs_qgroup_reserve_data(&inode->vfs_inode, start, len,
 					to_reserve, QGROUP_RESERVE);
 	if (ret < 0)
-		goto cleanup;
+		goto out;
 	ret = qgroup_reserve(root, to_reserve, true, BTRFS_QGROUP_RSV_DATA);
 	if (ret < 0)
 		goto cleanup;
@@ -3468,15 +3532,13 @@ int btrfs_qgroup_reserve_data(struct btrfs_inode *inode,
 	return ret;
 
 cleanup:
-	/* cleanup *ALL* already reserved ranges */
-	ULIST_ITER_INIT(&uiter);
-	while ((unode = ulist_next(&reserved->range_changed, &uiter)))
-		clear_extent_bit(&inode->io_tree, unode->val,
-				 unode->aux, EXTENT_QGROUP_RESERVED, 0, 0, NULL);
-	/* Also free data bytes of already reserved one */
-	btrfs_qgroup_free_refroot(root->fs_info, root->root_key.objectid,
-				  orig_reserved, BTRFS_QGROUP_RSV_DATA);
-	extent_changeset_release(reserved);
+	qgroup_unreserve_range(inode, reserved, start, len);
+out:
+	if (new_reserved) {
+		extent_changeset_release(reserved);
+		kfree(reserved);
+		*reserved_ret = NULL;
+	}
 	return ret;
 }
 
-- 
2.31.1

