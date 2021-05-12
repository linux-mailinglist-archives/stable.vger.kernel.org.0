Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7B037B911
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhELJZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:25:06 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:55119 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230181AbhELJZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:25:05 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E1A511356;
        Wed, 12 May 2021 05:23:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 12 May 2021 05:23:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=rED/i/
        YkJ/+/zlbnZfOx6ApOKuF5reG7kz1XY7MUg1c=; b=Oct8LnxFBK7vdgX5IWWT+6
        32RyisuXkYQ81+Sdv4y1fOLbtvzaCSwL6mBwzuSJSWQGqhkwb6aXpVO4ycoXGTTD
        8VRVTXpymy+IK6FmqNLPAWItOYE2GHLfVAcQKN/e3enkaO713aCYqwKH47BnS8FF
        iw0AZfNoAD5FGOdPjICVQ1/aMCyMer6ZdRI6icS/hJ2tRwmxDbtxIq/LEVRzIHTm
        VeCQclNLUtMNhBtpqSrNjgLW8MdHSpk0A/nzmMLxr5JrnZ983QLZgl9NlS54TVOd
        olfs211hjpI1bJgGMtxWHYRNuJxZGVjda8iJ1k4aVca0GacnFWBIA0DwcyyJfNOQ
        ==
X-ME-Sender: <xms:rJ6bYKgfAahVAXVZcGCHsne8gkiizCE4u-UxGqJ7Vyyc-7IeHcDLmw>
    <xme:rJ6bYLCGwbFNHQDLK7Ukl0fzCHIxBNCIvNqch-Mj0FdDgvdEwgZZo7weXDfDvnlfi
    1wHcuR-GBULnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:rJ6bYCHRCFCLhn3GyUXk_pDohP3V7lnLLuY4NmZYMPeK5silz8Mf-g>
    <xmx:rJ6bYDQd9Kxin9n_6StKQIo0w3T5ot36dVF3Aw76oUMAPTw4ffWs5w>
    <xmx:rJ6bYHzrYDaUF4v0RG-DKCekvmx7UttvxJIX8d_gDyzytBB2k2-2hg>
    <xmx:rJ6bYAobdonde8iowauYcMSfDXo0E4jhsCyQM44t0BrxsFyqenpJ4lwL99U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:23:56 -0400 (EDT)
Subject: FAILED: patch "[PATCH] md-cluster: fix use-after-free issue when removing rdev" failed to apply to 4.4-stable tree
To:     heming.zhao@suse.com, ghe@suse.com, song@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:23:54 +0200
Message-ID: <1620811434199173@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f7c7a2f9a23e5b6e0f5251f29648d0238bb7757e Mon Sep 17 00:00:00 2001
From: Heming Zhao <heming.zhao@suse.com>
Date: Thu, 8 Apr 2021 15:44:15 +0800
Subject: [PATCH] md-cluster: fix use-after-free issue when removing rdev

md_kick_rdev_from_array will remove rdev, so we should
use rdev_for_each_safe to search list.

How to trigger:

env: Two nodes on kvm-qemu x86_64 VMs (2C2G with 2 iscsi luns).

```
node2=192.168.0.3

for i in {1..20}; do
    echo ==== $i `date` ====;

    mdadm -Ss && ssh ${node2} "mdadm -Ss"
    wipefs -a /dev/sda /dev/sdb

    mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l 1 /dev/sda \
       /dev/sdb --assume-clean
    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
    mdadm --wait /dev/md0
    ssh ${node2} "mdadm --wait /dev/md0"

    mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
    sleep 1
done
```

Crash stack:

```
stack segment: 0000 [#1] SMP
... ...
RIP: 0010:md_check_recovery+0x1e8/0x570 [md_mod]
... ...
RSP: 0018:ffffb149807a7d68 EFLAGS: 00010207
RAX: 0000000000000000 RBX: ffff9d494c180800 RCX: ffff9d490fc01e50
RDX: fffff047c0ed8308 RSI: 0000000000000246 RDI: 0000000000000246
RBP: 6b6b6b6b6b6b6b6b R08: ffff9d490fc01e40 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: ffff9d494c180818 R14: ffff9d493399ef38 R15: ffff9d4933a1d800
FS:  0000000000000000(0000) GS:ffff9d494f700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe68cab9010 CR3: 000000004c6be001 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 raid1d+0x5c/0xd40 [raid1]
 ? finish_task_switch+0x75/0x2a0
 ? lock_timer_base+0x67/0x80
 ? try_to_del_timer_sync+0x4d/0x80
 ? del_timer_sync+0x41/0x50
 ? schedule_timeout+0x254/0x2d0
 ? md_start_sync+0xe0/0xe0 [md_mod]
 ? md_thread+0x127/0x160 [md_mod]
 md_thread+0x127/0x160 [md_mod]
 ? wait_woken+0x80/0x80
 kthread+0x10d/0x130
 ? kthread_park+0xa0/0xa0
 ret_from_fork+0x1f/0x40
```

Fixes: dbb64f8635f5d ("md-cluster: Fix adding of new disk with new reload code")
Fixes: 659b254fa7392 ("md-cluster: remove a disk asynchronously from cluster environment")
Cc: stable@vger.kernel.org
Reviewed-by: Gang He <ghe@suse.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Song Liu <song@kernel.org>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index af9bdb907b2b..49f897fbb89b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9289,11 +9289,11 @@ void md_check_recovery(struct mddev *mddev)
 		}
 
 		if (mddev_is_clustered(mddev)) {
-			struct md_rdev *rdev;
+			struct md_rdev *rdev, *tmp;
 			/* kick the device if another node issued a
 			 * remove disk.
 			 */
-			rdev_for_each(rdev, mddev) {
+			rdev_for_each_safe(rdev, tmp, mddev) {
 				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
 						rdev->raid_disk < 0)
 					md_kick_rdev_from_array(rdev);
@@ -9607,7 +9607,7 @@ static int __init md_init(void)
 static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
-	struct md_rdev *rdev2;
+	struct md_rdev *rdev2, *tmp;
 	int role, ret;
 	char b[BDEVNAME_SIZE];
 
@@ -9624,7 +9624,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 	}
 
 	/* Check for change of roles in the active devices */
-	rdev_for_each(rdev2, mddev) {
+	rdev_for_each_safe(rdev2, tmp, mddev) {
 		if (test_bit(Faulty, &rdev2->flags))
 			continue;
 

