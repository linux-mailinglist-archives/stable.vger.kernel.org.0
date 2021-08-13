Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7823EB3B0
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240071AbhHMJ4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:28180 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240057AbhHMJ4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:36 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9pTSZ007743;
        Fri, 13 Aug 2021 09:56:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=iZJEsTK164dm/ahHm0ra7kaWWUn61uol8Ldgp9wwJcA=;
 b=iIr+GaVX7rei4v1Id52DVBTf5dQt920a0ptA8JRVBZzBWPlhTllK8wqoXeEj29DJQELN
 ShQLl6SRK6qwmxK9GtCrBLG4iA8nVn383KRlsVLaIDL8LCWUsPb52CwvochG5Dd1ev6X
 ijnLPRWhmyFEw1X+hu1Hds60/uY90CL/Kcl2rJ1JNYEnDUQKg3M2sjtCPhfdzQGdv8Pr
 Mufisw7uwgORCQpb51eWg+Zak8/qocjt1+s742Uq2h4jJ8ptuZG+DEYDMNgjGStcMEkD
 KJ0TfuZqOG6iS+Yg8zkEF7hL9zK9V83sx2FlINcStjfZ4XJPIzST3ZMq20KDXfea1m+X 3g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=iZJEsTK164dm/ahHm0ra7kaWWUn61uol8Ldgp9wwJcA=;
 b=xVvXREODRDk9fxJPslcS0sBGj0kenDRmAA/9bW2ohynTODmJAn8xBQkTdgFNGAPkB16S
 rG1BJ+AaE4XO4IQtdQiP50FoW/iXHuf/OttuSuGbZAHruo1wD3fWkTpNbGnkSF0X7Pm0
 rK8DjtP/uZwfsjKHljM8/hY3P0m70oSVUTyNrKyKx2AXX0z5kIqm1S3n4VDr2qc02ele
 TH9MZrlV6777xViUATQiQeNyGKkFSowE6UZ+PeZE/A+XBkNYiQKIbkgUU9sB6i8ZVAoH
 EJD1bFIuqd9pSwO74QK1zMUucrTYNYTXWKFmHtXyosZmgxKm+nUbOKFj1dkNKs/a9GP7 NQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aceudvyr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9oZCl035884;
        Fri, 13 Aug 2021 09:56:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by aserp3020.oracle.com with ESMTP id 3accrdrqxu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5uLd5V+f2ClhYFY2mMYSzQB8R91wXZfpmPVL9WX5xib2Zz9xfKds3xwzU6hhrhXWW6tnG+nlO7VllJSF8OoJ6nkruTZAam7E+LaB3dVPzY3k2K7vqA+rv4L1Q4aSnZyN3P19lzybiSdndyHzUxbcc5Dvx57dVCfFN2PP0Vja5S2g5AcrX7BHFSRq/aZcDDqtGYkO0CXi7Z0WBnRWtPxL08HMNj3s0uf0l82RTyfy/iLrJ+Yu9FdnAswnOKfPsysuH5SE+tCYigoUTJPjw8F8hAc6/fjJc80h1I/Mb3x+sDZHvzanR76QuTvtlG4Ruu9CvJ2BtDCU+WpHpJZebXODg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZJEsTK164dm/ahHm0ra7kaWWUn61uol8Ldgp9wwJcA=;
 b=A06vzzisuanrgd1e2Vql0LRZoKhLii4bCda+XUJlz5jn8MtMiyCnc7jtow7KitEyLLzYKugPL3nhlVagyYDxifMmLJE6sdzMKGIx+J2crygKSS1ivlYpKPLII3dSaWQTnTkYarlFI5vfQ0VKneknTMphDjZKZ4JM0sui/mNdtU1/I3eE2eOCXD9QzUuVv3mH58pApD6tA+mPhvGQXJUX10VkIPSq7AZo/wEheBjN46PKIKy9cxvU9Mhs+Mh12iYHiOmX/elHwhxU+wDCDlt56bBxgnB7dpABhhuteZkyWpWvUKOGGN98dmQY44uQIIzaJYo9sNyKkIcPma1UR+lYeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZJEsTK164dm/ahHm0ra7kaWWUn61uol8Ldgp9wwJcA=;
 b=HkMj3BYF4eEJKFLpfHw3oeFli613vamt47ddAJ7n4glDxOm80fq6rINUemarX/3qDI5MskeorX/B5MVW4Aq26nF9zVS5CR+u4ndguU7x9MKk6iYzfr+7+dw2TkPfggBuG0ngg/vwmM9PCbIFiBF7vIBNyCobpmlrkb3coAI1jm0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BL0PR10MB2963.namprd10.prod.outlook.com (2603:10b6:208:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Fri, 13 Aug
 2021 09:56:03 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:56:03 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 6/7] btrfs: qgroup: remove ASYNC_COMMIT mechanism in favor of reserve retry-after-EDQUOT
Date:   Fri, 13 Aug 2021 17:55:29 +0800
Message-Id: <f06f7e9af9501ac1b737c1152ad509b00913c6e1.1628845854.git.anand.jain@oracle.com>
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
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:56:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f1594a3-9b48-432e-71fe-08d95e408fe6
X-MS-TrafficTypeDiagnostic: BL0PR10MB2963:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB29630607DA3DE3EABA96BE57E5FA9@BL0PR10MB2963.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2puExxuZtBa58/PXecO/DKY7UrUFh7UBS08rVEKSrGhymWLhcNavQ+7jrwO04H+fIXldyn+NZxYpZ4gTK9W8GzMXvXcJztjdTdaXlUzEQEKPtGONNdG6UBvGQcI4wCrLydr/QFi41z6GBuAppqRB4WjoavgqD6Wts7oEcAvKMJKXFRQiuykkoKI4pyMLhSS4fmXvrGgGcCGDQTzwMkn4ogiKUwpD/+yZeMcP+SHu+NxJMmoRbk5YGV/6FQ7EV7OhPzM777YswMbSyefAP+pZOG4pqJKyAMu7lf59aeuka7Rqp4bEbYn4R/8ak63CpFUwjvQ7iZn3eHJhYDTqqySd5JQHPZWdiFWW7UvIy9XtA5lOrThQFjJgj2WYgC2Yczc5DmaNAr1z/MthbBZqQ0ehM6YXJ5RLEvQGawKK1jf5VNSCz/rqMTfNrZQqeFHZugbvsBQ5nW8lq5gHtph0cn+cYxzjggJgInCnw6xaqL3CALcbzDF7cjrCAdxQlWTlyE89AiPh1AkeFXYTuXxIapS38FzMBwK0WJR7mHsg/UfDGNt+wpPHTN8a1ul2ri1QFzeqLHL/OpgvvAyg8rz+P0bt/Km/VXgL2Xb9W/fy/5hFaCYpZVXPxJSrUl5RL/pDEVBOILPMHYa7OT+aVljbSoksy8j7wj3uPo5Pm2g9UunQy69Y66E/MWHqUFiczGcIpSihFDmD0PuEAaiUpZh457oh1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(376002)(366004)(346002)(6506007)(478600001)(52116002)(83380400001)(86362001)(2616005)(54906003)(5660300002)(956004)(316002)(107886003)(44832011)(2906002)(4326008)(38100700002)(38350700002)(6512007)(26005)(36756003)(66476007)(8936002)(66556008)(66946007)(8676002)(186003)(6486002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?alROwZBvv6g6ub9/u1C726JAokImuGlVFBCUINYlcbkGGanFQq82TETJLE7a?=
 =?us-ascii?Q?gCXsIoOKiRU1F4OXmqBO6IZvbwbxt5EUQE0BgkClKeB610Xi25EAbH9T5Tv8?=
 =?us-ascii?Q?ChVi8kXTW/nkhP1OgoIWKeYDBc4cGhylwYzcjyTuXRjOSgmAcSTmLt1dMNNO?=
 =?us-ascii?Q?WU9uVoQW4qEiXymZiu4bVvtFfH0RrS0igEWX4HLEmeaFQE7xmVNhxSS80bP8?=
 =?us-ascii?Q?yjnvqpyPlGAM2HITQKePRiPEkxBak8G7wd+9rykF/v9bdRLI1N/Sa3QXp4AR?=
 =?us-ascii?Q?AnCTmbWC1wOdl+WzZ25yhCLBpE8kYMIqbAqa3ybRknYL08dT+Tf7ezVht9Jg?=
 =?us-ascii?Q?WT+qIJpCgKUBOvUu6rj1dWbmTttHEDj+wAYOE4tIHtDX2c0gk+n/NWUiB87a?=
 =?us-ascii?Q?DcZS1y3V08XFrXfbsEkiLSGxnnJpozrn1BQr1q5JQRXk2TmQ9zs6lRoYyNys?=
 =?us-ascii?Q?m1wTjuGRRCAqM4O3gzCJl8dBLx1cgFs6tanTQMZ0DfcQ1KylGeMt9mQ4ozLJ?=
 =?us-ascii?Q?U2DzlcjIrP2w98JdW5Bgr2+CimhYKDzQFUinfOvTRGJ1xnhBCla3xXdMXwuz?=
 =?us-ascii?Q?fpoMDd44A29Hssbbg5X9V2JQHFiE6DzVv6N3hHPj4urefJbEG4So07sjbFGx?=
 =?us-ascii?Q?kXY8hjZWD0rTwe5GLF1VRy/pO9aUrmxM5HhNm7Kyy174C3vSrX/4sy4yCYQZ?=
 =?us-ascii?Q?lkHLi9MNOQTKgSFW/3wu8uotFfIp7Hl373a1jRxCd659UBLI8HaJX6bijyPz?=
 =?us-ascii?Q?RTJfkcc7DKB+BVA+JUChpMDH1dZ35EezYr9Xr5aurpNJg2rbi2W62NoTgLpk?=
 =?us-ascii?Q?Uj6HkXa4nqNPn1UXHA697HoyPD2h+3qGurst9doTz9xntundLyM/zyNtCSPM?=
 =?us-ascii?Q?HzKUhOXIL1+bH6/Nawk7ebea+TNLXI5w7qx0axWNUCoBHHNXpNf3vfK1FXkQ?=
 =?us-ascii?Q?+ZYu3yB9lKd871gQlkyHQl/AHPEzmE2qAM/ksHKboq7yFLX6sLPhuQ5KRxHT?=
 =?us-ascii?Q?QuhEcOY5xpE18yE0W+AGTpX8HkE87E01el81oUC1NLXP99iT4pcKs4XgCOgQ?=
 =?us-ascii?Q?tmL2wKrXQTSurOijC2mjXXb+7E2ffD5PJOOZR1HthJ6Fb4LhGsOsLdoW1IdB?=
 =?us-ascii?Q?LBA+mshN7EjDsGRCTlPoABF71O7DEArGTRsVFuCwyy4isE03foj+EpOGOvPf?=
 =?us-ascii?Q?B6sx5uLBSdHhc9/wjaWGgwb2MZHv8nMAyAFhr8hdycJ47MTGiLUOTakhGPfk?=
 =?us-ascii?Q?mSdcazlwe8ThKrY0qCrp773ZtxLWYt3//8Bl0wwt1EzLwIKCHTpe+jNW8N3Z?=
 =?us-ascii?Q?zNl1MYWlvHRUbHiLfclFXmtB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f1594a3-9b48-432e-71fe-08d95e408fe6
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:56:03.6002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpkCbaPHhIsgFMdkaU/+wbQ6zZqcR5285GPRv8pztGSY8M5kTCq4sc38hS1IlONNS6gr+r+KjBAFvyCnMjNYHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2963
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130059
X-Proofpoint-ORIG-GUID: nEKoCQmY65XzXXIvs0bzJGxOzDuwrIll
X-Proofpoint-GUID: nEKoCQmY65XzXXIvs0bzJGxOzDuwrIll
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit adca4d945c8dca28a85df45c5b117e6dac2e77f1 upstream

commit a514d63882c3 ("btrfs: qgroup: Commit transaction in advance to
reduce early EDQUOT") tries to reduce the early EDQUOT problems by
checking the qgroup free against threshold and tries to wake up commit
kthread to free some space.

The problem of that mechanism is, it can only free qgroup per-trans
metadata space, can't do anything to data, nor prealloc qgroup space.

Now since we have the ability to flush qgroup space, and implemented
retry-after-EDQUOT behavior, such mechanism can be completely replaced.

So this patch will cleanup such mechanism in favor of
retry-after-EDQUOT.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/ctree.h       |  5 -----
 fs/btrfs/disk-io.c     |  1 -
 fs/btrfs/qgroup.c      | 43 ++----------------------------------------
 fs/btrfs/transaction.c |  1 -
 fs/btrfs/transaction.h | 14 --------------
 5 files changed, 2 insertions(+), 62 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index 5448dc62e915..1dd36965cd08 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -504,11 +504,6 @@ enum {
 	 * (device replace, resize, device add/delete, balance)
 	 */
 	BTRFS_FS_EXCL_OP,
-	/*
-	 * To info transaction_kthread we need an immediate commit so it
-	 * doesn't need to wait for commit_interval
-	 */
-	BTRFS_FS_NEED_ASYNC_COMMIT,
 	/*
 	 * Indicate that balance has been set up from the ioctl and is in the
 	 * main phase. The fs_info::balance_ctl is initialized.
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6d6e7b0e3676..9373b4805da2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1749,7 +1749,6 @@ static int transaction_kthread(void *arg)
 
 		now = ktime_get_seconds();
 		if (cur->state < TRANS_STATE_COMMIT_START &&
-		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
 		    (now < cur->start_time ||
 		     now - cur->start_time < fs_info->commit_interval)) {
 			spin_unlock(&fs_info->trans_lock);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index b312ac645e08..4720e477c482 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -11,7 +11,6 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/btrfs.h>
-#include <linux/sizes.h>
 
 #include "ctree.h"
 #include "transaction.h"
@@ -2840,20 +2839,8 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 	return ret;
 }
 
-/*
- * Two limits to commit transaction in advance.
- *
- * For RATIO, it will be 1/RATIO of the remaining limit as threshold.
- * For SIZE, it will be in byte unit as threshold.
- */
-#define QGROUP_FREE_RATIO		32
-#define QGROUP_FREE_SIZE		SZ_32M
-static bool qgroup_check_limits(struct btrfs_fs_info *fs_info,
-				const struct btrfs_qgroup *qg, u64 num_bytes)
+static bool qgroup_check_limits(const struct btrfs_qgroup *qg, u64 num_bytes)
 {
-	u64 free;
-	u64 threshold;
-
 	if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
 	    qgroup_rsv_total(qg) + (s64)qg->rfer + num_bytes > qg->max_rfer)
 		return false;
@@ -2862,32 +2849,6 @@ static bool qgroup_check_limits(struct btrfs_fs_info *fs_info,
 	    qgroup_rsv_total(qg) + (s64)qg->excl + num_bytes > qg->max_excl)
 		return false;
 
-	/*
-	 * Even if we passed the check, it's better to check if reservation
-	 * for meta_pertrans is pushing us near limit.
-	 * If there is too much pertrans reservation or it's near the limit,
-	 * let's try commit transaction to free some, using transaction_kthread
-	 */
-	if ((qg->lim_flags & (BTRFS_QGROUP_LIMIT_MAX_RFER |
-			      BTRFS_QGROUP_LIMIT_MAX_EXCL))) {
-		if (qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) {
-			free = qg->max_excl - qgroup_rsv_total(qg) - qg->excl;
-			threshold = min_t(u64, qg->max_excl / QGROUP_FREE_RATIO,
-					  QGROUP_FREE_SIZE);
-		} else {
-			free = qg->max_rfer - qgroup_rsv_total(qg) - qg->rfer;
-			threshold = min_t(u64, qg->max_rfer / QGROUP_FREE_RATIO,
-					  QGROUP_FREE_SIZE);
-		}
-
-		/*
-		 * Use transaction_kthread to commit transaction, so we no
-		 * longer need to bother nested transaction nor lock context.
-		 */
-		if (free < threshold)
-			btrfs_commit_transaction_locksafe(fs_info);
-	}
-
 	return true;
 }
 
@@ -2937,7 +2898,7 @@ static int qgroup_reserve(struct btrfs_root *root, u64 num_bytes, bool enforce,
 
 		qg = unode_aux_to_qgroup(unode);
 
-		if (enforce && !qgroup_check_limits(fs_info, qg, num_bytes)) {
+		if (enforce && !qgroup_check_limits(qg, num_bytes)) {
 			ret = -EDQUOT;
 			goto out;
 		}
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c314f26d1f15..948b11748fe6 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2295,7 +2295,6 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans)
 	 */
 	cur_trans->state = TRANS_STATE_COMPLETED;
 	wake_up(&cur_trans->commit_wait);
-	clear_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags);
 
 	spin_lock(&fs_info->trans_lock);
 	list_del_init(&cur_trans->list);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 761cc65a7264..d8a7d460e436 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -207,20 +207,6 @@ int btrfs_clean_one_deleted_snapshot(struct btrfs_root *root);
 int btrfs_commit_transaction(struct btrfs_trans_handle *trans);
 int btrfs_commit_transaction_async(struct btrfs_trans_handle *trans,
 				   int wait_for_unblock);
-
-/*
- * Try to commit transaction asynchronously, so this is safe to call
- * even holding a spinlock.
- *
- * It's done by informing transaction_kthread to commit transaction without
- * waiting for commit interval.
- */
-static inline void btrfs_commit_transaction_locksafe(
-		struct btrfs_fs_info *fs_info)
-{
-	set_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags);
-	wake_up_process(fs_info->transaction_kthread);
-}
 int btrfs_end_transaction_throttle(struct btrfs_trans_handle *trans);
 int btrfs_should_end_transaction(struct btrfs_trans_handle *trans);
 void btrfs_throttle(struct btrfs_fs_info *fs_info);
-- 
2.31.1

