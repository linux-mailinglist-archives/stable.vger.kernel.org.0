Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7B12B91D4
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 12:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbgKSLsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 06:48:06 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:27545 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727156AbgKSLmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 06:42:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605786133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ujRyZUePYV92oS4mXIitKn+n4aNhawDG03BqV3avwrk=;
        b=TynaYas7rbhBTQAlknyLz4scS+eIgbu+kNNEBPC0/NbJSjkLw/wjx+SbIXvLAjLRCz4JIE
        bAO4WuyW2e2vOv0/se/vSfp5vxaJCygPFyu5rPuswJoT5XJtlyRlyIC2V1+v4Xfz9bp25Q
        sv7ix6ewXGJSvlHPWs7vpvTQM2/PZ6Y=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2054.outbound.protection.outlook.com [104.47.2.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-lbcUB6gZMVqm5_TquGLh9Q-1; Thu, 19 Nov 2020 12:42:11 +0100
X-MC-Unique: lbcUB6gZMVqm5_TquGLh9Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMuw+dhBqN1xEVC33Eh3zHSZJvskdNVWMExckEQvITwD6fvi9OcJEaGBsNK3vPOpX3c5Bq4rinoc1zcD/BWvnN8mOmst8ZB5S6IRq9Kr2SpT8O7VVSsHcijQA/FHv6iWbmLEoDRj2jEJ5FAESH+pqS8gJWZDlqQFerdcaHgJEF9ZPOA0xx3CqcJbvDJJn4GAFmZnyLCounHq06r0uUcunmab9OJuyptiVY1XAwFkZUTgDrvCnE4sSZMU2vPPw2gF3KrZfSXuovT027KqwJAGfQ5ZXovbkS9v2M9hEd8XiXzjCvzV3n9I2aV5PR4rwA3ve34JD9GWA0U/7Ur5Gh0u6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ujRyZUePYV92oS4mXIitKn+n4aNhawDG03BqV3avwrk=;
 b=XTJ+m0tLSa5X78kxzDHRcagybxdh6NeMxIpJQMtx9M2pt2R/DHF/AFfurABUA1b4F25py0mSh33ltw3uclBqbvXDQnnHLSDv5G6dogEH7h7c/CV0b5JD/hBNQ/CkQbO9gh9IkSNenURjx2y38CM1HDP2WKcc/FwozNE9o13IaKmZPpvA5yJ9ULnICVQrj29d7ca7FadXtPHPWByQcpseMuNqehHmm0lah3ii5rDeae6t6wa1yHCLPVi+T8/iTWO+xYmR31MH7dt4T5CM1SMhKX+jRFIuV8FA8vxhe/5enaSvH3tr6KRkGjAjwjRvdJ+/9U0kJz2d8bd+Ii7CwJmXww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3589.20; Thu, 19 Nov 2020 11:42:10 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.028; Thu, 19 Nov 2020
 11:42:10 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de, stable@vger.kernel.org
Subject: [PATCH v4 2/2] md/cluster: fix deadlock when node is doing resync job
Date:   Thu, 19 Nov 2020 19:41:34 +0800
Message-Id: <1605786094-5582-3-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
References: <1605786094-5582-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.130.58]
X-ClientProxiedBy: HKAPR03CA0033.apcprd03.prod.outlook.com
 (2603:1096:203:c9::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.58) by HKAPR03CA0033.apcprd03.prod.outlook.com (2603:1096:203:c9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Thu, 19 Nov 2020 11:42:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d2b0580-1931-424d-9a18-08d88c802601
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB28069928F56F72B892E77DD397E00@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:238;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9tfg97ear3s46CjBLkdoj/oP8VERaKjB9p9t4CHuU0jz7HXzsaJdjtsVux4zREWp+ECNV4uYD2Dp8tboZGI+4rEpTFW7mRqK76kbzNZRkc68r1tesXJ4ZiaSZQi4e/8838TH3FlKDxM3IRVzXuyhZaC5ImN7Fza5Nft17SN/XrJBYXQ7AWFQsoPnrHma3gs9ePRtABT7rw3FSxtkbtb8Uo9Y2fPBdHyeY4xYOPfZFSwhnrbEZ8CUfn453tC3bUin+e1DJlVnkIkDHSEuEJssMSQ6YDOhKQ6GjBO8OjLph9x30pgTv1PIQo3UxsXJumfgjfrIJoRAOMq7+e0rfKWLw+B7ytiG6J2IRnBtgU+Ug/6byPCOvFYhX0hS+lXLaeVY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(366004)(39860400002)(396003)(86362001)(2906002)(6512007)(478600001)(5660300002)(66946007)(8936002)(66556008)(52116002)(66476007)(6666004)(8886007)(4326008)(16526019)(186003)(8676002)(6506007)(316002)(6486002)(956004)(26005)(2616005)(83380400001)(36756003)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YHuDuBt+jzBb05azAo55PPaPvyYEEgvrm2PAY8pi2oXXlbOMxj4JX5yMxKddCdtmWqHjCMarklCyfBULUTCbvFW1xJ4qCC75fKx2Rv9BnlM3Zh0BXGfM395JReozArRoKoqKn9iRbIC4kyGE254k9b/rc0TQRftVmLgKCQTXVs+tgEHZeHD1WE+IaY96y+lfDc73h5tV/XNqF6rQEy5qW6F+eqR0CQ84ICVvY97uILA2oFE4NfL0BZhwH+0N9/EGSLV2YefKMNd9LZIHns7w07Sq5eOgjK3BMprG3IrM4wEbfSaAPz6Wmt8wITX5rqStlDAJWtuFJQlvpJOghC60Eq7O89OTEqustZqqcLmG4uTO6lNynlB/nsWfHK5EQW9ux8goN8RPrhh5VphJSQblZaSXe7ssGVqxIRy8JN8rMbNTZNwloOAiRx3UsFMa24tDh0jWcIat/JJiq2yZ9j18fSnR7gyecBhSYzu4iqVFvIh+ORQ4p2Ma+KICojYtMtXEKYv0nwUOs/i3niK+z/tnf22ef+IoCiCKtPLF3kf7k1JUn7Q33/q8FkfmW3tSUTF1JTpfelGoJZdI5G0birqHuHQN/x1WgE/TfgluRkcOnpflyWNICv6NDLEn8mgsBxh7S1X0XaDokcLlSDRx+O1GdQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d2b0580-1931-424d-9a18-08d88c802601
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2020 11:42:09.9513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fURqzbepxtQ8v6mW8eF+DgCEmm6IhfbvmNELw6HVz4S0rgTyQ/mnhfQzOzP57f4XizMBUBkUc0H+C8ANJEm7Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
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

Cc: stable@vger.kernel.org
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

