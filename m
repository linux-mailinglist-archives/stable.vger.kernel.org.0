Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2353EB50D
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234931AbhHMMNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:13:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:13180 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240259AbhHMMNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 08:13:16 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DC7GME026291;
        Fri, 13 Aug 2021 12:12:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=zVuw70JfTlM4/80WwpBxg2UKnZkr4fSJ14RmTv0NR0s=;
 b=LD7VyS8uMdcobOzNsv7RHhYgbDOVoTKpJFzq+0uWkOrQQHUVHR6hW0sczQqyZpDQlCoD
 L0F+sKxOd7YR6KIyvMDhXx10YvO3cJvvL9XalNCzzG8paxoa9816kmoMnCAwmL4FGTdZ
 9eKcClLgY83fxedNxG1ZNd7Q6anOkuYQQy0JE5FxWPLEFiHOeErfCZerQDWWNEB1S9HT
 7/GlQLl18hnREAcgiBQze51lgxIw86R+o+WTr7Ig8q+e2hK0nY42FDHLccPjCICWqGKp
 9IbqDhAMFATmxqgdUBbMpSQeOg8BTscoBD9ooQD5N6LA9y9YGN8BSh7qwOZVwGAZvCGN Tw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=zVuw70JfTlM4/80WwpBxg2UKnZkr4fSJ14RmTv0NR0s=;
 b=WTOGozE9GCmJl4ZA1YxmoaqtmhTFqLhG00HX0pNt400JLZmrZDCEf2cbtfVpdMCuMoYF
 K0kxss0eEsBY6A1OWZJuoW/JTrPifwChm4uuBx0IgyzeYcdrAoH9ICwC89YGPGJXb2D+
 caSEzUXc6IbQfKMRlRvRS/vU1YzAzcQyTFVyLCpSaVfLWH/A24NEYMT+eJmTKvGTpBxb
 wz+sIqbSmKY664OUsSxpioUZRWMypYeXmSjI59DQRM1mBXNbj/FVBI73M6aYyt33/9Zh
 DwNO+UmjRt3TkZYqFsTz/4ZBQPWDpwO3xeCWhrHyq7fyxZks0HscG9tZYnckRykGWI5Z ng== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3adq9g84dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DCAZX7038630;
        Fri, 13 Aug 2021 12:12:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3020.oracle.com with ESMTP id 3accrdx85v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LlJPc2O7WUiPvaakpCKBV/p7ulpruPcm5LqsdKzn6fepvlUVJ35dur8vH3R2MEJzAxcLNqOQFAplrYoMcLj95pacQFlnvu6omiqaSUXLIWVkGHRU1zmfI9WxTQkTwkIpytXncFfCbtPicTFyV6zuUgVvrt//v2c3RgVaegdZKcBq2mq0FGexBqslcLwwQ0p4h/bNY2mOLUlBK69+wGApK5t/mHEN7IpKE6OASB+onWGL53oqlcTeL2Kfn8bP3wh0SXgo+9uuqTXPEkRdh9/FqPmAN0k8+VfNsd+kEYnPySu8rjZCpXdgRXtGmx23XxfBJ3mzg7H3YJt1hok99bEUgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVuw70JfTlM4/80WwpBxg2UKnZkr4fSJ14RmTv0NR0s=;
 b=DrRCrTgJYpMSLQoJUnTYy3gvDhfJhyI486lol0H38eopAACIeyx6cgJ6d0OtdIOzLYuujyXApo6JCsTN+HKIJ/pq7/5xYZpOPrCqEo0I3fSJ0kxXb8bNnXJ+BWWUFFTMArO1QS0ypqDqGkCjf9uxuv/xCuhuDvacD4UtbCw+dLpS8kDlnUMWCUFRHzw5gRUkfBKOKS4IY2syovf1losbJCfclU9XuSSxp95/Dmzdcw/UEZiLi7bcra9aPG6iP91hB/2gXAek2awgchWu8Z/BAld45b6muX2u2dc3GVBSsoIvIAdh3AxXAqozD0n4BLbZdydxVXG7NaJ4ySMVgc/zYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zVuw70JfTlM4/80WwpBxg2UKnZkr4fSJ14RmTv0NR0s=;
 b=AGDPlbvaXcUaP58fWVTSuYifPFD5A5nL3poOZUKnUIO8sIv+zMyyUqhhQheWWuQi0Wa1Jqz5mtg0F3WO0IS5n9FVuYiHvOdnK0m1/YOUxu+eyLTFwvhSCYDgaHg+Bo8HTycZuTyO5JduEYl92WeCgZzppkYzUbOo+rJ6NNAfIh4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB3789.namprd10.prod.outlook.com (2603:10b6:208:181::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Fri, 13 Aug
 2021 12:12:43 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 12:12:43 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 1/3] btrfs: qgroup: don't commit transaction when we already hold the handle
Date:   Fri, 13 Aug 2021 20:12:23 +0800
Message-Id: <387bbbec5e040ec46f5d15b6a754b7a7af57b302.1628854236.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1628854236.git.anand.jain@oracle.com>
References: <cover.1628854236.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17)
 To MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 12:12:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1380493a-8fd4-4d30-abb1-08d95e53a70e
X-MS-TrafficTypeDiagnostic: MN2PR10MB3789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3789FF034948102864310E69E5FA9@MN2PR10MB3789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W8S7mE47HEd/Luhu4UFMlFx4VCnR0rnAzQ7J7gt5734mb49ptPviUamB/217WOFggoxBQYE6RIjuV8yBtPUXR1a6lRT3TBQxPxmSCfwSvaq0emrwVjJES2bMbterMVkgMVnzyfJPOwqPQ5jysrdt2eI3D5Bb6R4KL0Kfk4WaFb/BlAH5UsS+Cwb9IeJeVh1bkpUJ8IcdPr801JU3D4wLg1l6qDBxzyleFuf7RTH8x7CRCw7w5wU8VlCbNMq01ICyZN4mAj8kR/31wldwni4sT9tsVeiIsGKGnEUsL+bkD50xlGV+C70YP5iYWlRljezFFzU7NYtWJBM5twsERkORJIwFof+Z9jzULvZmqYzQx5LUqsjqhwfAfSuMufu5O1QyWqjx05/fYjeRP3x/4E6/7n+kJRV19z0fXHvBhBQ3RzmsHcmQ35ojkG68xOmu/ObpWocZ65QiiKw8qLabbUhx/bH1YceCN9Ystd0Eb3j2RkxLMHz94zM3UfOm+O9u9oi1tEOUbNK2mNWsZ7OqFyFvLlwtDmFkHGCUOd+WegYAYzVOjJ9NpWDiZIqOiVyz6HbsXiJEV7of4ZAEj4I+aQm6HtR22zoQQm66EV3Yz3OJiTz2uDE46JsD8QD4U/0n0S/yUJ3/0u46L735HBw7TB1kh3Eq0yPm4i8kAHYw3IDw5RSZTEMFdgjhrfCvxHnI50hEDtC+vrce14eAtQw6ScWmi+UHyG61WMC1tQnsbgzMvdulOtlUNfvVGowh+tbqqLhhW//fMGZIDTnjjSGDJxweGNUrV5ZlFpU9SR8+0ezwcZ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(376002)(39860400002)(26005)(54906003)(44832011)(5660300002)(52116002)(966005)(107886003)(316002)(6506007)(83380400001)(36756003)(956004)(6666004)(8936002)(4326008)(2616005)(6512007)(38350700002)(38100700002)(86362001)(8676002)(66476007)(66556008)(66946007)(2906002)(6486002)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FLAjAjwVtn5yYKFy5UrRcu8EvkZQEcmZsaXiwZhBymOtKbt/u6WaBp68se/k?=
 =?us-ascii?Q?U5c/0xTp3qJvQG3H0iD0GEEZEf/s2a+kaMyNGuflq0zCf7/+t4N85q50ZCrn?=
 =?us-ascii?Q?HA232USCzTkmPTUAkIa/uiZ1R/ZqKpkoqBTIp236McJB525bZUG3W6tOUGwe?=
 =?us-ascii?Q?0QAj1oWAfG0XKvURx2KrXcCFHgwTcIUVHMgbTzoxRbxndy0oBo1+IGTfW8hP?=
 =?us-ascii?Q?P1zCnxwD4lsbgBqmZQRCN1XoOwNdQSRCD0ohs1PBeKuTRDQFMcnnzEwLxmoV?=
 =?us-ascii?Q?0vPxHhR5E/aZkyV3u7IjADWRPSsOqaYXNU3C6TH7llVuaiBFA/4CcK1ga4CY?=
 =?us-ascii?Q?9/0/9/IBQNdoBV9HUt+Xkm2GHzYe60jiHJfl71MPQ+Nkgs6xLqIVdPAzN4RT?=
 =?us-ascii?Q?vgPtgOQca/Ukb4QDrROpw+6SenKVEN/eW8ZME1TJmRXDSgDAqeG2WpVB8UKb?=
 =?us-ascii?Q?kdzpwhkjC/1Ff+0Z6t8o686V8lzVJ6bSO4ComEAqrm3ilwojI1Mnsgc5BJBC?=
 =?us-ascii?Q?t54n+6o3xgqxSkDCkx9JipeHu2hQ0lI1Xe+jNKNstz3BYmPwYUkew8/ul2Re?=
 =?us-ascii?Q?txyB+Xt2O4/o29wF0GelGfGqy2stqNeXJzqF/t4z6pn6DAoGU+jq8rSE2ekS?=
 =?us-ascii?Q?rVv2XMV2dg8ASOcSQWmISoar23GG1/OEENxWUP1LKGP5kT17hOHShOusY8wW?=
 =?us-ascii?Q?XzGq4erN0ZshdAGFSMOOSs63AEPReGf6WTkHQsfZybv2+zOCIhv54sIMegaC?=
 =?us-ascii?Q?OpwHnRxbMVa/Qgi3LtiNU5jsoU6DKvW/YTTxHYJz5MOxxU+Z7M7RM0tPnbIW?=
 =?us-ascii?Q?mEMCvB+HghTWWxAFRKDP7wsEHUZDgBYHDXG4Wxsnw/YMgNy8+KngE3mLV24X?=
 =?us-ascii?Q?tQ2CjPrejMQSvJ/PuZlIN1D9Rd+iy/jo8ubIPqokCBQlvEcFJAhto6FTfRvm?=
 =?us-ascii?Q?2V66TebsaGfPzVuOe2Rd5bJ/J6Fkvvy6+NaRO1y1IDnmASuAVNL7z9uEEuwn?=
 =?us-ascii?Q?DGkLA+3GsnXtRjFAAiOIkkoZEOtEG7QQlgIiLq4+QhNnH1Z6U5UuT9A559+r?=
 =?us-ascii?Q?m2wCzPxoESj+VujShBbegtIFqTSVdhggRmIsB7Urr3b35mVUy78dQshM8hbm?=
 =?us-ascii?Q?irWPeXyhc1ndE7E+tlAYzJwiVZIusrztWUTl241wpnI7hzchHiVERCuBy7GT?=
 =?us-ascii?Q?64GsVADr9XYQKVeyLYjXsDDJkJT+ZpIHXxhC6z04BjPtY9OBVPI9QmRv2LFp?=
 =?us-ascii?Q?tuL39yXzsuuubhLzOAvkkR/xb53uZtmHcjPEDUW05MC9eKCBIPf23aYN48N8?=
 =?us-ascii?Q?p8IdtFGVC8FyAtjxVh9j29cw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1380493a-8fd4-4d30-abb1-08d95e53a70e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 12:12:43.0536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UwMF34leFLP3XLxxlXUfu1eD8KECvAM6R7wBtGUh3y+S7THiKsHIpcvNgTOIrODVqYy9wNUGRTDHnqDwznqvgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3789
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130074
X-Proofpoint-ORIG-GUID: jCejqUD1mbJoyY3P-EHZRNpS-SxGaOIq
X-Proofpoint-GUID: jCejqUD1mbJoyY3P-EHZRNpS-SxGaOIq
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 6f23277a49e68f8a9355385c846939ad0b1261e7 upstream

[BUG]
When running the following script, btrfs will trigger an ASSERT():

  #/bin/bash
  mkfs.btrfs -f $dev
  mount $dev $mnt
  xfs_io -f -c "pwrite 0 1G" $mnt/file
  sync
  btrfs quota enable $mnt
  btrfs quota rescan -w $mnt

  # Manually set the limit below current usage
  btrfs qgroup limit 512M $mnt $mnt

  # Crash happens
  touch $mnt/file

The dmesg looks like this:

  assertion failed: refcount_read(&trans->use_count) == 1, in fs/btrfs/transaction.c:2022
  ------------[ cut here ]------------
  kernel BUG at fs/btrfs/ctree.h:3230!
  invalid opcode: 0000 [#1] SMP PTI
  RIP: 0010:assertfail.constprop.0+0x18/0x1a [btrfs]
   btrfs_commit_transaction.cold+0x11/0x5d [btrfs]
   try_flush_qgroup+0x67/0x100 [btrfs]
   __btrfs_qgroup_reserve_meta+0x3a/0x60 [btrfs]
   btrfs_delayed_update_inode+0xaa/0x350 [btrfs]
   btrfs_update_inode+0x9d/0x110 [btrfs]
   btrfs_dirty_inode+0x5d/0xd0 [btrfs]
   touch_atime+0xb5/0x100
   iterate_dir+0xf1/0x1b0
   __x64_sys_getdents64+0x78/0x110
   do_syscall_64+0x33/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xa9
  RIP: 0033:0x7fb5afe588db

[CAUSE]
In try_flush_qgroup(), we assume we don't hold a transaction handle at
all.  This is true for data reservation and mostly true for metadata.
Since data space reservation always happens before we start a
transaction, and for most metadata operation we reserve space in
start_transaction().

But there is an exception, btrfs_delayed_inode_reserve_metadata().
It holds a transaction handle, while still trying to reserve extra
metadata space.

When we hit EDQUOT inside btrfs_delayed_inode_reserve_metadata(), we
will join current transaction and commit, while we still have
transaction handle from qgroup code.

[FIX]
Let's check current->journal before we join the transaction.

If current->journal is unset or BTRFS_SEND_TRANS_STUB, it means
we are not holding a transaction, thus are able to join and then commit
transaction.

If current->journal is a valid transaction handle, we avoid committing
transaction and just end it

This is less effective than committing current transaction, as it won't
free metadata reserved space, but we may still free some data space
before new data writes.

Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1178634
Fixes: c53e9653605d ("btrfs: qgroup: try to flush qgroup space when we get -EDQUOT")
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/qgroup.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 2f119adbc808..78146501c665 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3502,6 +3502,7 @@ static int try_flush_qgroup(struct btrfs_root *root)
 {
 	struct btrfs_trans_handle *trans;
 	int ret;
+	bool can_commit = true;
 
 	/*
 	 * We don't want to run flush again and again, so if there is a running
@@ -3513,6 +3514,20 @@ static int try_flush_qgroup(struct btrfs_root *root)
 		return 0;
 	}
 
+	/*
+	 * If current process holds a transaction, we shouldn't flush, as we
+	 * assume all space reservation happens before a transaction handle is
+	 * held.
+	 *
+	 * But there are cases like btrfs_delayed_item_reserve_metadata() where
+	 * we try to reserve space with one transction handle already held.
+	 * In that case we can't commit transaction, but at least try to end it
+	 * and hope the started data writes can free some space.
+	 */
+	if (current->journal_info &&
+	    current->journal_info != BTRFS_SEND_TRANS_STUB)
+		can_commit = false;
+
 	ret = btrfs_start_delalloc_snapshot(root);
 	if (ret < 0)
 		goto out;
@@ -3524,7 +3539,10 @@ static int try_flush_qgroup(struct btrfs_root *root)
 		goto out;
 	}
 
-	ret = btrfs_commit_transaction(trans);
+	if (can_commit)
+		ret = btrfs_commit_transaction(trans);
+	else
+		ret = btrfs_end_transaction(trans);
 out:
 	clear_bit(BTRFS_ROOT_QGROUP_FLUSHING, &root->state);
 	wake_up(&root->qgroup_flush_wait);
-- 
2.31.1

