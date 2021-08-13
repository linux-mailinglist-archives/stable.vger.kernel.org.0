Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE9B3EB3AD
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240035AbhHMJ4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:56:38 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47914 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240048AbhHMJ4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:56:33 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D9qvSn013389;
        Fri, 13 Aug 2021 09:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=x3URvEkKIYiBz3gxpAnXPAPHuNQ1Jc19r1NI5vnA5PU=;
 b=p1nt7pnpVscepSplfcmIjOjyrB/DbjCKnk8AxnO+XtcoqEJ+8HieYFJtcltOpyg0eCMq
 ib0snP1wvw9FM4Lm+rF5pF8mxGvZUZLiCyorU7oihtPeHRJZ6Fbf9Q5RjZp/qCHbLloN
 uAseusBrOpUYGG1ySv11dOTyaD3RCcfnizqhMTi9r2WSLRGeBfBjpuM/ppNtoh/um8FJ
 Xw6nF1AniIRIDjIkadP2Fd21abQcO+XgLXNXpIIBBAsuVLODHu6FqKFy9ETKNuJ41bmt
 D3P8w6mPbN/QxGczXvH/mos3UYj010ZZdRC37K83j5y1z7u8GNZYyt1CtYjurs+5jlVw sQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=x3URvEkKIYiBz3gxpAnXPAPHuNQ1Jc19r1NI5vnA5PU=;
 b=ip3fGsXspqzCIde013MGZ/IB5MgNRCnTZ06qNQnTqwwyRIe3TPVSH5rEBJcvOP1gHm6V
 u2h5JGpBvKHRlp4mPFL9V+yIB9BBXQkHu3/Tvas45XMi3ESvqwRj5P5UMzdxhRpidaq5
 O9HaUhTNQPz8lmBhiYfCSDeYZxaW9wHge5E4+jIva/WyqWdMJWG2WEJrD5o4xS/mcd1w
 fG0JBBlKZu+wYWnTnI6UoIykYh+eJ3tSbU2Ew/3rg3LEbYKD0wuTR7y1A9JwX6w/M1Tf
 dL623JjUs+MvL2WpK30+f+NxXqC5h4wt4j4VBj2h5fscbwJe7BVYUHzzrO0tA7aX7YIp tQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3acw9p30sq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17D9og6Q033353;
        Fri, 13 Aug 2021 09:56:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 3abx40ew7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 09:56:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihcLdVGsUrGe1G1gf619UyXiswzxEHnq67B5NfAIlRL3vrmsaa6IcUDXtbfsFvTXDYl1GkgPY9z95mn+A4ZABpIgY5RTwjPbrdYfZ4S9bcCmV1HdUIYxvV/Tw55y2NuZlQImzHP7IvLdbQF1GiplhSqReOYNT6ZM8gyNpycUtUfUauhpU98UD7tvLrv3lq5H7GBx9fNlKAEeWQQXJpz5ru6q3IyV2dHMDStlfww5iQxzQ98lSLWYE3WJPo4HqKdl9s9FqxinxnhXkFFgUl5MDGu4NmL/fTvsBQ8RTJzhbFaQnVDXtYTx2Q5PMQg0WAG/llksAnbRp3ihziRMGyG11g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3URvEkKIYiBz3gxpAnXPAPHuNQ1Jc19r1NI5vnA5PU=;
 b=ENQ0J0x/hoUGpU6tLSpQIckttXmGFthi7fbjZF5Xikk7XsRdb4U7jykXNPulxfBxYBPilRZx3v+16gQBAMVK2EH9YkMeMy4VbKEIYTL7yHxjD7TGc7uGICS5eowl2veADDhavnvHYflH5gqgzlDqcXzFW8QxmXl3jaCo2vi7VwuhdMS8J2TUiQvbyqXz7fY4Sc0Spfv8MER5HwFrkBkP306YWNWrRKRrkBwy5lXNGA9A8tPhL3gzYzArn7Ttn0TgqLQmsM4pSEZMAPYQMETb/OWsJNXExaySRvlKStjveHgOxdf1oVnLre3TYgCts+CMtzreoacGckLjZ1cStnW2/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3URvEkKIYiBz3gxpAnXPAPHuNQ1Jc19r1NI5vnA5PU=;
 b=uLdsbfRsIRgA9FEC3xGnQ07iqjvF4gjTvADNgObspTYDV+jKcSButCTWChCmQsUtdLKgxKTl/mKvy+tXPbXl7217oRVGkVnpt/XhTjv/9UCNMPXOPPxzgLl6b5E3wC2AEANwNAzV8BX+C8boyWs2tNfN0C3/BBTiHTx9gqTuQ3s=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by BLAPR10MB4852.namprd10.prod.outlook.com (2603:10b6:208:30f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Fri, 13 Aug
 2021 09:56:00 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 09:56:00 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5/7] btrfs: transaction: Cleanup unused TRANS_STATE_BLOCKED
Date:   Fri, 13 Aug 2021 17:55:28 +0800
Message-Id: <7c24989ec90962679cdcf9f6f2ba6fd39fc569ee.1628845854.git.anand.jain@oracle.com>
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
Received: from localhost.localdomain (39.109.186.25) by SG2PR03CA0124.apcprd03.prod.outlook.com (2603:1096:4:91::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Fri, 13 Aug 2021 09:55:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: af53117a-f41b-4d5e-3a41-08d95e408e12
X-MS-TrafficTypeDiagnostic: BLAPR10MB4852:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB4852DEBFA8831FEB0EAFC724E5FA9@BLAPR10MB4852.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gMNLb713qsu3smFwWri40uyjPqT/PWtJKhBPl6x0n0wJxLptSjHF2nD0nBtpmHiIGeSsukrKNA6Zv8Zo1ERX0pZ9jx7uSk42lYVoZg33vi7qcHyLvV08o4k6VGQfz7zAQeFXhfv/41+DEiMisXRJhkfmoO2dBuSrRzq3QL6A21hUhiHxMoZvlH2Ch+whueWTxARgkWqCBoLX3c7govaiwp3tzVFWc0I0HQRN7hhQEdIgKw3UnJFqRunC8zHvgM4jifhcrYz4Aa2IhEWFbwfu4eZNgD7pl5e+74tT10b4wRrbxSClsGWElsl0jGJXLzomHNd+9oHO2YB6xTjf1+LGwvjLvZAM1HbBsy9P/DdGa3pGCM/mfO3k8cwvOZyWJ5bCUOKvbFfUtV8roZAa0O2p+JNeA3roKYbkXb7yhfVaPZMMbf2BoAkseioJi2ekStYuz8x7xLiDKbOqK1i8m7z2y4/Yd7u/7/lV63PQC53Rf/3K3RScxt+FJYRQVOBn2R1GVTLZUIKP9p5pO+Q0HKXD9727iw5Xb1mNxRHVFN8p38JOspoSlDuAUPLqbkx5gsUydittW6jz+tmCXFgZ2ReD3Vdj/S3FL3Mlx0rfcsWpWJaNP1Jlc9byU5fxCSOpw/0IN6/R8kyk6lzd03kn5JB/LHbdhH8fHmvGldk+j36hD26FnxU5tWEn8bWiwphWiNccKg/eBzil1PecISSZbDkIKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(107886003)(8936002)(8676002)(2906002)(478600001)(316002)(83380400001)(54906003)(44832011)(4326008)(956004)(2616005)(86362001)(186003)(66946007)(26005)(66476007)(6666004)(6486002)(6512007)(52116002)(66556008)(36756003)(5660300002)(38350700002)(38100700002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d44ccb0fT+30WGrhisYOWL1YcmoXbKGyarqmc5Izpldf4af+XTk/ZHaSKrjo?=
 =?us-ascii?Q?8EVa0bhRgdWR9ccxuMzK6OJLcJK0jc6YI8kd6oNPVpBzpZQCnKORhp2kgoPo?=
 =?us-ascii?Q?U4v+E1WBlAGKPX+bOB4Kntl1XPJZpgMuuGG+pfkBcvQO9pTAxY63/SzbJZCR?=
 =?us-ascii?Q?TpT2H4WHLQNgznRupX2aNWIdBDYMl8XZQUiCY1A1xYYyf/+Lg5AOxVdWrVQW?=
 =?us-ascii?Q?IXwLunTds4qClbJPR7d+JzJ/T9kUL3hVLZxnIucQl5vfTfqzaDUmbsQfQFfU?=
 =?us-ascii?Q?ojgLXCCWtbTJ3AkXtDIGdycp+jkEVa1Q4PKar++JGY4nrD7OgBLNMIS4qfts?=
 =?us-ascii?Q?FyWD0uXhbnfaQhv/Vt9G22B+Ogs0ZkNgnIUKbilqouN9+QZFQYPZPylAPrHB?=
 =?us-ascii?Q?KTpNAJgYNIB00RiNNNTNLbaufu6XGFtQKYB9Haqko9DLxfWU/EASIXbBJSCd?=
 =?us-ascii?Q?8AcXXW4Tvbk/iN9yBKICIENe08Q+RJ2V2J9v/bqwn5NMGSnvAtyhOuIGsauU?=
 =?us-ascii?Q?SQeG0hFuW8VXH+f6psL6YT7IPQ4upEHTuzLOLSu5hDocNOErsQSRCeb4hxzF?=
 =?us-ascii?Q?/Slj+Y9lG+DKLVIRqndALxvh4PN0BUSQ63zYWG0toc/XcYoUpyTJQQFl+6sd?=
 =?us-ascii?Q?fERWxMtcJY3N3kyyhHggHkowd+8zKG7FqpNuDnn375fN6qQOAczXpcRjYrXr?=
 =?us-ascii?Q?nL5NbRcXRtWjWhQphUzzvnviNl5p1OZT6T+N01WJxYvgUEfwL5pt7+2p70MB?=
 =?us-ascii?Q?RFrPAQTJP9haB0TUvxcAdXLxF20Fh1Xl7Rp/v3MGiVKrXAOdz7+5b5IhvEyG?=
 =?us-ascii?Q?2VDu7dK7h6/uxnVp55USyWLy57kBhONBy4FO55UhWnwtD7VC/YqUTPIUC8bb?=
 =?us-ascii?Q?VNKBaMmrIvd0zhWtBOYZf7VQLDo6FaJZiKya/SsyFq1KtHbnidL+TVBTEcD2?=
 =?us-ascii?Q?tsCqvL1zx1rK/jsnek8QDxUm/YhRDOIQ5qdANYSt91Qa2oDkjq022C0rqV6Q?=
 =?us-ascii?Q?yaxYW49a26RK7MnBw4UXOXPG3/u+xckqcIjVkraZc8g/BybbtZZm/Lw26pyn?=
 =?us-ascii?Q?eDfzOdlpYC/eSXLbfcF8oexxiELe/msg09j/Qd9RUbh4W5aU6V/4zOHw0mp9?=
 =?us-ascii?Q?dX4wtLIMqkGlZKg3yMK/9HhwIhIc1GTFlfhTKSTxwQ1vcBPL7g0nXubykdQ3?=
 =?us-ascii?Q?dQur58w3gk2CO9EThJ3qugn9ojsk3RG3J6PzZuGYalNxAgAcutE7nIZNxFKo?=
 =?us-ascii?Q?HqRMmAMwUADGjhkE0uJ61DZhK11ip5V69HuQv0WeS5ysxsKExCUVdRR5bihl?=
 =?us-ascii?Q?J9ILayOQOzvUVY1XzazqRxNJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af53117a-f41b-4d5e-3a41-08d95e408e12
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 09:56:00.6980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ukPMEY9MQ3Fx4szDIr/Zz2Hv2Sjj+2k+QmFejASmNkcm3xHROJ5XfeH4lzbhTd+nG5EhUJE/WPtYMi3tjdmCKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4852
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108130059
X-Proofpoint-GUID: 5YIKCEnEV-1xFpS1yCH3xedH0RJJGFSb
X-Proofpoint-ORIG-GUID: 5YIKCEnEV-1xFpS1yCH3xedH0RJJGFSb
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 3296bf562443a8ca35aaad959a76a49e9b412760 upstream

The state was introduced in commit 4a9d8bdee368 ("Btrfs: make the state
of the transaction more readable"), then in commit 302167c50b32
("btrfs: don't end the transaction for delayed refs in throttle") the
state is completely removed.

So we can just clean up the state since it's only compared but never
set.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/transaction.c | 15 +++------------
 fs/btrfs/transaction.h |  1 -
 3 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e3bcab38a166..6d6e7b0e3676 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1748,7 +1748,7 @@ static int transaction_kthread(void *arg)
 		}
 
 		now = ktime_get_seconds();
-		if (cur->state < TRANS_STATE_BLOCKED &&
+		if (cur->state < TRANS_STATE_COMMIT_START &&
 		    !test_bit(BTRFS_FS_NEED_ASYNC_COMMIT, &fs_info->flags) &&
 		    (now < cur->start_time ||
 		     now - cur->start_time < fs_info->commit_interval)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index aca6c467d776..c314f26d1f15 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -27,7 +27,6 @@
 
 static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
 	[TRANS_STATE_RUNNING]		= 0U,
-	[TRANS_STATE_BLOCKED]		=  __TRANS_START,
 	[TRANS_STATE_COMMIT_START]	= (__TRANS_START | __TRANS_ATTACH),
 	[TRANS_STATE_COMMIT_DOING]	= (__TRANS_START |
 					   __TRANS_ATTACH |
@@ -388,7 +387,7 @@ int btrfs_record_root_in_trans(struct btrfs_trans_handle *trans,
 
 static inline int is_transaction_blocked(struct btrfs_transaction *trans)
 {
-	return (trans->state >= TRANS_STATE_BLOCKED &&
+	return (trans->state >= TRANS_STATE_COMMIT_START &&
 		trans->state < TRANS_STATE_UNBLOCKED &&
 		!TRANS_ABORTED(trans));
 }
@@ -580,7 +579,7 @@ start_transaction(struct btrfs_root *root, unsigned int num_items,
 	INIT_LIST_HEAD(&h->new_bgs);
 
 	smp_mb();
-	if (cur_trans->state >= TRANS_STATE_BLOCKED &&
+	if (cur_trans->state >= TRANS_STATE_COMMIT_START &&
 	    may_wait_transaction(fs_info, type)) {
 		current->journal_info = h;
 		btrfs_commit_transaction(h);
@@ -797,7 +796,7 @@ int btrfs_should_end_transaction(struct btrfs_trans_handle *trans)
 	struct btrfs_transaction *cur_trans = trans->transaction;
 
 	smp_mb();
-	if (cur_trans->state >= TRANS_STATE_BLOCKED ||
+	if (cur_trans->state >= TRANS_STATE_COMMIT_START ||
 	    cur_trans->delayed_refs.flushing)
 		return 1;
 
@@ -830,7 +829,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 {
 	struct btrfs_fs_info *info = trans->fs_info;
 	struct btrfs_transaction *cur_trans = trans->transaction;
-	int lock = (trans->type != TRANS_JOIN_NOLOCK);
 	int err = 0;
 
 	if (refcount_read(&trans->use_count) > 1) {
@@ -846,13 +844,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
 
 	btrfs_trans_release_chunk_metadata(trans);
 
-	if (lock && READ_ONCE(cur_trans->state) == TRANS_STATE_BLOCKED) {
-		if (throttle)
-			return btrfs_commit_transaction(trans);
-		else
-			wake_up_process(info->transaction_kthread);
-	}
-
 	if (trans->type & __TRANS_FREEZABLE)
 		sb_end_intwrite(info->sb);
 
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7291a2a93075..761cc65a7264 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -13,7 +13,6 @@
 
 enum btrfs_trans_state {
 	TRANS_STATE_RUNNING,
-	TRANS_STATE_BLOCKED,
 	TRANS_STATE_COMMIT_START,
 	TRANS_STATE_COMMIT_DOING,
 	TRANS_STATE_UNBLOCKED,
-- 
2.31.1

