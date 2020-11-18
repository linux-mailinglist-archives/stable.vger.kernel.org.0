Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32B52B822A
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 17:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbgKRQq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 11:46:27 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:50712 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726666AbgKRQq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 11:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605717982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SpZGa8W1NG1DXGhgmgVxgLh7EmsZJivNHg/AAI0VOYw=;
        b=KpEKphc+qTMT6/DzEOZdtM6KtKsgaGSWrV+5MkngCd7fhTuXcXjrE3WMXgP/da9O58m/Yd
        2p/t5j0+31tAyV6tEHL/VuA6sU5Lrt2qTriOLJBP9rGbkQ9hwAI3b6fM7+J+7Txt7Kq9Ok
        Kl534pMrweX6XfEiQHILVe268d89n64=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2059.outbound.protection.outlook.com [104.47.12.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-3-EuxnRHUmNiaVL_-ixMXXaw-1;
 Wed, 18 Nov 2020 17:46:20 +0100
X-MC-Unique: EuxnRHUmNiaVL_-ixMXXaw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Heo149skU0DSpOr1qPESPClHOf3E1nIoM9fAjzS/1jjCxniI3HLODJjSmE1aIS6Fw07DnLoWAEq4s6MosCGiSumrUCVqdRcgzuM3PKeYXmddpDYq8gDeHVUxCywdwwvpr+pLiU2J9bLi4/zSQytgVvihNIIFdB106IfGPmQu03Q8KfV3AgLN/6fLYwAK/D92vWvVHdb8sHANoDD11XpReDs5JjahS2M7wQ60PZ3GmGeP0t/Ggw4ApIrHdIwTX5SeBfPemYgkZXuVzKNm2hcBmaaWS+KG7rrKhrbacRedNuaPeM2cJik30vrdfhio18k0UholXRzFBbbN76JAJEyoUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpZGa8W1NG1DXGhgmgVxgLh7EmsZJivNHg/AAI0VOYw=;
 b=Xqv7t9dH+tJH/SHCBnahgSGpTWMgT5MQZhFU4e1DmoyMq12OQBJ8pduARaQ0xeW9QFl1+uWSp9rBd1wraNQumpCU7AGne0Lp1nzldC8khWu/deM79qoMJtToDRcQaQPOoEkPwvBeTGsTROkifaPnsINS+fT20NMJJMfHGVOMxkEMk7VnhwGhf1x1NWCtZSk3a5oW5plN9qlmppbvafxNZCAtbA62BIMkVwVoxWisyArFgohXS/1wKfAUSJC1wK5xgMVnJkitG2G5/6VkxlKwet9lxSz4OVp9V+DdFbsktSiCV//g6ws/qXgsw3/dWn/JqcgHMmceWmrn2zd6yFwzpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB5643.eurprd04.prod.outlook.com (2603:10a6:10:aa::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Wed, 18 Nov 2020 16:46:19 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 16:46:19 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de, stable@vger.kernel.org
Subject: [PATCH v4 2/2] md/cluster: fix deadlock when node is doing resync job
Date:   Thu, 19 Nov 2020 00:45:54 +0800
Message-Id: <1605717954-20173-3-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605717954-20173-1-git-send-email-heming.zhao@suse.com>
References: <1605717954-20173-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HK2PR04CA0078.apcprd04.prod.outlook.com
 (2603:1096:202:15::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HK2PR04CA0078.apcprd04.prod.outlook.com (2603:1096:202:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Wed, 18 Nov 2020 16:46:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 96b7f8ea-203b-4b52-bcb8-08d88be17904
X-MS-TrafficTypeDiagnostic: DB8PR04MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB564393A10CDE212B1F7FE69C97E10@DB8PR04MB5643.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NZgL4Yfg4jk0ZP47mp9v9C+t8rU/hfW4dy2osuQjxJ8oOk4hgf+PCjhSt0LiqYnVCgKgVGKomV6JyrScs0c4zrOBp1Ad3t7mLGTBAqltCbn8m/N+iFjummC+9K8xfVbwaN89WsrZbjNhxWy5mHXH3e61eYBv4mocxF39gowDheCeUoa4Pn7dxOvNxLs1k9f+FFmXhgn+/Kkzs89zV5wDraPdiQza5MXpkV/Hx07iV+lyRiikxdL4BlihmM/6H9t3KmXjRI8H6phSKT6YSnSYStnBEh0jVvXoh4a8SIgLryRgMahllYkwYUcFiIszgIv3LlY2gUo1Da7YjOf6ePr61iNDnGkk+4YWMEriHaFo9IX+DE9PYhqOI6UzgL1ucRFW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(6512007)(8676002)(6666004)(66556008)(66946007)(4326008)(16526019)(316002)(2906002)(478600001)(2616005)(5660300002)(956004)(66476007)(52116002)(186003)(8936002)(8886007)(86362001)(36756003)(83380400001)(26005)(6506007)(6486002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zd2/gZzhVWRisdfw4Bbo9Jo5DEMl1CAQ3BeFu4Kss7IejwsurKpM7vgmardHABFF4lLFC0cIbdmF8J1FwTXqnbRvhvS8TQRX/d98xIxpfyMda5HZQHQT+JwNXFl7ucK3xvl2+tMYPsVQEND6OeWeLFPzvaXTOQgyrk3z4z5zkfvRQ0T5G42RV99ZEmdNEN2bOsFC0xFW4ZGLQlua7ZV23q3U5UuYYn3CXitxCsAsYHYPytF/SB/p7/PfBzOJ7FYGyYoU3d872ADJ/f/F96MQGBl7Hz4/JrwjrkFzdqs/cls+12pF28l+S0CzVNxK9VM07HFPmdwYTiMCvR5n7Eu711DBhYLnQIgctGv+vdhsXbrVN+SEKwSFowwk8qKN7o8AM4El5evFV5kxmtqNu7koeF6OUTOiBN2D6v+HOI09RPK9KOy/eaU5D1lxd1lJFweJL+I7nZImNq9nYJREpPJxAf0+FxFF7GTi017nagT1mWEYdfRExKpDvIAMAnp1uBJh/SeFZhaSFvHeTatw3GhloKg5AgIY6Fwe6TCTZGgMZA0zmdHR6NT6Sw/p67lGh6005rJmSj0or50Z5bNXzSbwvZh7m3VXLznE2oSYyVVJhbYB7ZvnXDCnAOcaQeY5xmxK7mfMTGRibahqAJXHBzCvYA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96b7f8ea-203b-4b52-bcb8-08d88be17904
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2020 16:46:19.0719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 46yend3TvTvoVz8P+eYGy4WyrKjcbuexpl52nDYAN7I2vfvtjcs6EXQcXxrG/2IZ8KcLQtau+u4SN4C6O1lSWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5643
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

md-cluster uses MD_CLUSTER_SEND_LOCK to make node can exclusively send msg.
During sending msg, node can concurrently receive msg from another node.
When node does resync job, grab token_lockres:EX may trigger a deadlock:
```
nodeA                       nodeB
--------------------     --------------------
a.
send METADATA_UPDATED
held token_lockres:EX
                         b.
                         md_do_sync
                          resync_info_update
                            send RESYNCING
                             + set MD_CLUSTER_SEND_LOCK
                             + wait for holding token_lockres:EX

                         c.
                         mdadm /dev/md0 --remove /dev/sdg
                          + held reconfig_mutex
                          + send REMOVE
                             + wait_event(MD_CLUSTER_SEND_LOCK)

                         d.
                         recv_daemon //METADATA_UPDATED from A
                          process_metadata_update
                           + (mddev_trylock(mddev) ||
                              MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD)
                             //this time, both return false forever
```
Explaination:
a. A send METADATA_UPDATED
   This will block another node to send msg

b. B does sync jobs, which will send RESYNCING at intervals.
   This will be block for holding token_lockres:EX lock.

c. B do "mdadm --remove", which will send REMOVE.
   This will be blocked by step <b>: MD_CLUSTER_SEND_LOCK is 1.

d. B recv METADATA_UPDATED msg, which send from A in step <a>.
   This will be blocked by step <c>: holding mddev lock, it makes
   wait_event can't hold mddev lock. (btw,
   MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD keep ZERO in this scenario.)

There is a similar deadlock in commit 0ba959774e93
("md-cluster: use sync way to handle METADATA_UPDATED msg")
In that commit, step c is "update sb". This patch step c is
"mdadm --remove".

For fixing this issue, we can refer the solution of function:
metadata_update_start. Which does the same grab lock_token action.
lock_comm can use the same steps to avoid deadlock. By moving
MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD from lock_token to lock_comm.
It enlarge a little bit window of MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
but it is safe & can break deadlock.

Repro steps (I only triggered 3 times with hundreds tests):

two nodes share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB.
```
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh \
 --bitmap-chunk=1M
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mkfs.xfs /dev/md0
mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
mdadm --grow --raid-devices=2 /dev/md0
```

test script will hung when executing "mdadm --remove".

```
 # dump stacks by "echo t > /proc/sysrq-trigger"
md0_cluster_rec D    0  5329      2 0x80004000
Call Trace:
 __schedule+0x1f6/0x560
 ? _cond_resched+0x2d/0x40
 ? schedule+0x4a/0xb0
 ? process_metadata_update.isra.0+0xdb/0x140 [md_cluster]
 ? wait_woken+0x80/0x80
 ? process_recvd_msg+0x113/0x1d0 [md_cluster]
 ? recv_daemon+0x9e/0x120 [md_cluster]
 ? md_thread+0x94/0x160 [md_mod]
 ? wait_woken+0x80/0x80
 ? md_congested+0x30/0x30 [md_mod]
 ? kthread+0x115/0x140
 ? __kthread_bind_mask+0x60/0x60
 ? ret_from_fork+0x1f/0x40

mdadm           D    0  5423      1 0x00004004
Call Trace:
 __schedule+0x1f6/0x560
 ? __schedule+0x1fe/0x560
 ? schedule+0x4a/0xb0
 ? lock_comm.isra.0+0x7b/0xb0 [md_cluster]
 ? wait_woken+0x80/0x80
 ? remove_disk+0x4f/0x90 [md_cluster]
 ? hot_remove_disk+0xb1/0x1b0 [md_mod]
 ? md_ioctl+0x50c/0xba0 [md_mod]
 ? wait_woken+0x80/0x80
 ? blkdev_ioctl+0xa2/0x2a0
 ? block_ioctl+0x39/0x40
 ? ksys_ioctl+0x82/0xc0
 ? __x64_sys_ioctl+0x16/0x20
 ? do_syscall_64+0x5f/0x150
 ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

md0_resync      D    0  5425      2 0x80004000
Call Trace:
 __schedule+0x1f6/0x560
 ? schedule+0x4a/0xb0
 ? dlm_lock_sync+0xa1/0xd0 [md_cluster]
 ? wait_woken+0x80/0x80
 ? lock_token+0x2d/0x90 [md_cluster]
 ? resync_info_update+0x95/0x100 [md_cluster]
 ? raid1_sync_request+0x7d3/0xa40 [raid1]
 ? md_do_sync.cold+0x737/0xc8f [md_mod]
 ? md_thread+0x94/0x160 [md_mod]
 ? md_congested+0x30/0x30 [md_mod]
 ? kthread+0x115/0x140
 ? __kthread_bind_mask+0x60/0x60
 ? ret_from_fork+0x1f/0x40
```

At last, thanks for Xiao's solution.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
Suggested-by: Xiao Ni <xni@redhat.com>
Reviewed-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
 drivers/md/md.c         |  6 ++--
 2 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4aaf4820b6f6..405bcc5d513e 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -664,9 +664,27 @@ static void recv_daemon(struct md_thread *thread)
  * Takes the lock on the TOKEN lock resource so no other
  * node can communicate while the operation is underway.
  */
-static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
+static int lock_token(struct md_cluster_info *cinfo)
 {
-	int error, set_bit = 0;
+	int error;
+
+	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
+	if (error) {
+		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
+				__func__, __LINE__, error);
+	} else {
+		/* Lock the receive sequence */
+		mutex_lock(&cinfo->recv_mutex);
+	}
+	return error;
+}
+
+/* lock_comm()
+ * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
+ */
+static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
+{
+	int rv, set_bit = 0;
 	struct mddev *mddev = cinfo->mddev;
 
 	/*
@@ -677,34 +695,19 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
 	 */
 	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
 				      &cinfo->state)) {
-		error = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+		rv = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
 					      &cinfo->state);
-		WARN_ON_ONCE(error);
+		WARN_ON_ONCE(rv);
 		md_wakeup_thread(mddev->thread);
 		set_bit = 1;
 	}
-	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
-	if (set_bit)
-		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 
-	if (error)
-		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
-				__func__, __LINE__, error);
-
-	/* Lock the receive sequence */
-	mutex_lock(&cinfo->recv_mutex);
-	return error;
-}
-
-/* lock_comm()
- * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
- */
-static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
-{
 	wait_event(cinfo->wait,
-		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
-
-	return lock_token(cinfo, mddev_locked);
+			   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
+	rv = lock_token(cinfo);
+	if (set_bit)
+		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
+	return rv;
 }
 
 static void unlock_comm(struct md_cluster_info *cinfo)
@@ -784,9 +787,11 @@ static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
 {
 	int ret;
 
-	lock_comm(cinfo, mddev_locked);
-	ret = __sendmsg(cinfo, cmsg);
-	unlock_comm(cinfo);
+	ret = lock_comm(cinfo, mddev_locked);
+	if (!ret) {
+		ret = __sendmsg(cinfo, cmsg);
+		unlock_comm(cinfo);
+	}
 	return ret;
 }
 
@@ -1061,7 +1066,7 @@ static int metadata_update_start(struct mddev *mddev)
 		return 0;
 	}
 
-	ret = lock_token(cinfo, 1);
+	ret = lock_token(cinfo);
 	clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 	return ret;
 }
@@ -1255,7 +1260,10 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 	int raid_slot = -1;
 
 	md_update_sb(mddev, 1);
-	lock_comm(cinfo, 1);
+	if (lock_comm(cinfo, 1)) {
+		pr_err("%s: lock_comm failed\n", __func__);
+		return;
+	}
 
 	memset(&cmsg, 0, sizeof(cmsg));
 	cmsg.type = cpu_to_le32(METADATA_UPDATED);
@@ -1407,7 +1415,8 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 	cmsg.type = cpu_to_le32(NEWDISK);
 	memcpy(cmsg.uuid, uuid, 16);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
-	lock_comm(cinfo, 1);
+	if (lock_comm(cinfo, 1))
+		return -EAGAIN;
 	ret = __sendmsg(cinfo, &cmsg);
 	if (ret) {
 		unlock_comm(cinfo);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 74280e353b8f..46da165afde2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6948,8 +6948,10 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto busy;
 
 kick_rdev:
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->remove_disk(mddev, rdev);
+	if (mddev_is_clustered(mddev)) {
+		if (md_cluster_ops->remove_disk(mddev, rdev))
+			goto busy;
+	}
 
 	md_kick_rdev_from_array(rdev);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-- 
2.27.0

