Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3786537B916
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhELJZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:25:55 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:37263 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230310AbhELJZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 05:25:53 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 81EA81394;
        Wed, 12 May 2021 05:24:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 05:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VQKQhW
        fCp2zW02AQKi3k2Zg6N3MrHoR68qqcH9jAmhY=; b=jv5izjJeNW4EQKCuLbOAUP
        0Fkpm+P7IBa6aPKQavwRV3RTSgECnGxmpMv8qdMt400yfBeFJBa8b3PzPE0SSfVr
        qJKFi7ncx/GWHF9HEifCeWoJGu5cubSXDK7aBXyLepfEXmNyjgaPuCStP0C3eL/Z
        xUn5SdJ6NFZoK2B+5MvCCdv4w+sKoiU/WQiNpfijFug0H3/lTsBWK8WaPCHS/udY
        guAsDnxJzN2E/tO9XQVhawse76fpYOfRy1hgZqokMU5wcl6DPYXKi+ScKHz1P8l8
        T3ifq8sRcpzjeQaRmfi02Nc7izPzbb8xkG5kIAVdeFGdUA7jaJdePZygrHZg3QCw
        ==
X-ME-Sender: <xms:3J6bYNor6EzqrgP2OmbQ26fhWQ8eW8X5CWHg9Q9HtIweiIvxrfOxkQ>
    <xme:3J6bYPqjLhcsXPI9t3uzcsa65kuWGMrbZvCiegulsp5KdUxDDupTna2yN9sQcmlfr
    vXfg6n5VUgM4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:3J6bYKPFBrQcjZa8R0PUEnrTf6d0LZNchrUO0bCRLJeKEejGDCsZPQ>
    <xmx:3J6bYI4Emo2eR3YaZJPJkdHkifIK_Ml9NRViybPDyI0H78okKsDkvA>
    <xmx:3J6bYM5I1z3iczDHS968LZnP1jO9mB4XEol_OaE4NXrVjzQGhe8W-A>
    <xmx:3Z6bYKTTi98PmqNlHNCbRLnLwg3hXP3helyosHxnXaPcdxBHT8JK3fUa-9k>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 05:24:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] md: split mddev_find" failed to apply to 4.9-stable tree
To:     hch@lst.de, heming.zhao@suse.com, song@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 11:24:35 +0200
Message-ID: <16208114757343@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 65aa97c4d2bfd76677c211b9d03ef05a98c6d68e Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sat, 3 Apr 2021 18:15:29 +0200
Subject: [PATCH] md: split mddev_find

Split mddev_find into a simple mddev_find that just finds an existing
mddev by the unit number, and a more complicated mddev_find that deals
with find or allocating a mddev.

This turns out to fix this bug reported by Zhao Heming.

----------------------------- snip ------------------------------
commit d3374825ce57 ("md: make devices disappear when they are no longer
needed.") introduced protection between mddev creating & removing. The
md_open shouldn't create mddev when all_mddevs list doesn't contain
mddev. With currently code logic, there will be very easy to trigger
soft lockup in non-preempt env.

*** env ***
kvm-qemu VM 2C1G with 2 iscsi luns
kernel should be non-preempt

*** script ***

about trigger 1 time with 10 tests

`1  node1="15sp3-mdcluster1"
2  node2="15sp3-mdcluster2"
3
4  mdadm -Ss
5  ssh ${node2} "mdadm -Ss"
6  wipefs -a /dev/sda /dev/sdb
7  mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda \
   /dev/sdb --assume-clean
8
9  for i in {1..100}; do
10    echo ==== $i ====;
11
12    echo "test  ...."
13    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
14    sleep 1
15
16    echo "clean  ....."
17    ssh ${node2} "mdadm -Ss"
18 done
`
I use mdcluster env to trigger soft lockup, but it isn't mdcluster
speical bug. To stop md array in mdcluster env will do more jobs than
non-cluster array, which will leave enough time/gap to allow kernel to
run md_open.

*** stack ***

`ID: 2831   TASK: ffff8dd7223b5040  CPU: 0   COMMAND: "mdadm"
 #0 [ffffa15d00a13b90] __schedule at ffffffffb8f1935f
 #1 [ffffa15d00a13ba8] exact_lock at ffffffffb8a4a66d
 #2 [ffffa15d00a13bb0] kobj_lookup at ffffffffb8c62fe3
 #3 [ffffa15d00a13c28] __blkdev_get at ffffffffb89273b9
 #4 [ffffa15d00a13c98] blkdev_get at ffffffffb8927964
 #5 [ffffa15d00a13cb0] do_dentry_open at ffffffffb88dc4b4
 #6 [ffffa15d00a13ce0] path_openat at ffffffffb88f0ccc
 #7 [ffffa15d00a13db8] do_filp_open at ffffffffb88f32bb
 #8 [ffffa15d00a13ee0] do_sys_open at ffffffffb88ddc7d
 #9 [ffffa15d00a13f38] do_syscall_64 at ffffffffb86053cb ffffffffb900008c

or:
[  884.226509]  mddev_put+0x1c/0xe0 [md_mod]
[  884.226515]  md_open+0x3c/0xe0 [md_mod]
[  884.226518]  __blkdev_get+0x30d/0x710
[  884.226520]  ? bd_acquire+0xd0/0xd0
[  884.226522]  blkdev_get+0x14/0x30
[  884.226524]  do_dentry_open+0x204/0x3a0
[  884.226531]  path_openat+0x2fc/0x1520
[  884.226534]  ? seq_printf+0x4e/0x70
[  884.226536]  do_filp_open+0x9b/0x110
[  884.226542]  ? md_release+0x20/0x20 [md_mod]
[  884.226543]  ? seq_read+0x1d8/0x3e0
[  884.226545]  ? kmem_cache_alloc+0x18a/0x270
[  884.226547]  ? do_sys_open+0x1bd/0x260
[  884.226548]  do_sys_open+0x1bd/0x260
[  884.226551]  do_syscall_64+0x5b/0x1e0
[  884.226554]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
`
*** rootcause ***

"mdadm -A" (or other array assemble commands) will start a daemon "mdadm
--monitor" by default. When "mdadm -Ss" is running, the stop action will
wakeup "mdadm --monitor". The "--monitor" daemon will immediately get
info from /proc/mdstat. This time mddev in kernel still exist, so
/proc/mdstat still show md device, which makes "mdadm --monitor" to open
/dev/md0.

The previously "mdadm -Ss" is removing action, the "mdadm --monitor"
open action will trigger md_open which is creating action. Racing is
happening.

`<thread 1>: "mdadm -Ss"
md_release
  mddev_put deletes mddev from all_mddevs
  queue_work for mddev_delayed_delete
  at this time, "/dev/md0" is still available for opening

<thread 2>: "mdadm --monitor ..."
md_open
 + mddev_find can't find mddev of /dev/md0, and create a new mddev and
 |    return.
 + trigger "if (mddev->gendisk != bdev->bd_disk)" and return
      -ERESTARTSYS.
`
In non-preempt kernel, <thread 2> is occupying on current CPU. and
mddev_delayed_delete which was created in <thread 1> also can't be
schedule.

In preempt kernel, it can also trigger above racing. But kernel doesn't
allow one thread running on a CPU all the time. after <thread 2> running
some time, the later "mdadm -A" (refer above script line 13) will call
md_alloc to alloc a new gendisk for mddev. it will break md_open
statement "if (mddev->gendisk != bdev->bd_disk)" and return 0 to caller,
the soft lockup is broken.
------------------------------ snip ------------------------------

Cc: stable@vger.kernel.org
Fixes: d3374825ce57 ("md: make devices disappear when they are no longer needed.")
Reported-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Song Liu <song@kernel.org>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e10d91122483..3ce5f4e0f431 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -746,6 +746,22 @@ static struct mddev *mddev_find_locked(dev_t unit)
 }
 
 static struct mddev *mddev_find(dev_t unit)
+{
+	struct mddev *mddev;
+
+	if (MAJOR(unit) != MD_MAJOR)
+		unit &= ~((1 << MdpMinorShift) - 1);
+
+	spin_lock(&all_mddevs_lock);
+	mddev = mddev_find_locked(unit);
+	if (mddev)
+		mddev_get(mddev);
+	spin_unlock(&all_mddevs_lock);
+
+	return mddev;
+}
+
+static struct mddev *mddev_find_or_alloc(dev_t unit)
 {
 	struct mddev *mddev, *new = NULL;
 
@@ -5650,7 +5666,7 @@ static int md_alloc(dev_t dev, char *name)
 	 * writing to /sys/module/md_mod/parameters/new_array.
 	 */
 	static DEFINE_MUTEX(disks_mutex);
-	struct mddev *mddev = mddev_find(dev);
+	struct mddev *mddev = mddev_find_or_alloc(dev);
 	struct gendisk *disk;
 	int partitioned;
 	int shift;
@@ -6530,11 +6546,9 @@ static void autorun_devices(int part)
 
 		md_probe(dev);
 		mddev = mddev_find(dev);
-		if (!mddev || !mddev->gendisk) {
-			if (mddev)
-				mddev_put(mddev);
+		if (!mddev)
 			break;
-		}
+
 		if (mddev_lock(mddev))
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version

