Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D13C2C8A5C
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 18:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgK3RDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 12:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbgK3RDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 12:03:15 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81436C0613D2
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:02:35 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id g14so17090875wrm.13
        for <stable@vger.kernel.org>; Mon, 30 Nov 2020 09:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CR59Zqn5k554svX8u33b3NzMbAg1mJSBzX9QwnwfhNs=;
        b=VPqgOStYwGQ+LDQCyYzgMQV6+ygGnYXC4TyozELPzPcQnQ9E0bdTrPvY20RbTiQT0q
         BAfrw1c+GVq+nfUw8uKyXd4/5bgz6NWJeA3Nk0CXGEULg21kh4AGAbxI3rJRFsHJisjU
         VcNwpnRssCptc0PGAqd9Sqr6XhNff0/hekp7SWZhg84i1fYBrn1qDiYyx26IjO9fjKlJ
         4TWlGBQYDW7dKW2lxOTpxfgsbcs+3eLDMHE+dbU/YoILgezBXhhCHM5G+J55q7jk5d8S
         Uxy1ZdQ1IU2eZUXiikEqGAHjOIYDLCgnvV2ek1UXdN/ap+Dt/4uK1TisJQRJC5Ovuhe5
         wkrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CR59Zqn5k554svX8u33b3NzMbAg1mJSBzX9QwnwfhNs=;
        b=t2wmqnnqsoeYaNCwht12bCNbcHqaV1oMUrqmC2a0nXz34VnE2b9MzvIFku7PSvjB0n
         oF4IrOFgsIrO1qDqkFFY2bY8EQfs+67BBKalR9VVjmDBz8GnBbNf3RgXcPnExBfnRYEf
         p+U7iDAdJ4L6Mu2A677kdladp79CL7Q7ZrCh29i3CshbQZGp4wDNr1OXjPl98sfv4bX/
         nUVeQ2UtDL7daxKwworYwe3fTE73Nx3W8TAFS5p3mmNjQR+NpCYrarun6JDAuwFbjhtr
         htg08sjggPUTilq/EadnV06tNSry4qFl2R+EL5kYMjlLtI6CZkDVLzuBuVonFyKTjK6K
         yvIw==
X-Gm-Message-State: AOAM5312IaVUumt4n9b9vC5CV7CIsrhBEDkdPxwBFDZq4p9jV5ZLML9z
        okWnkZbKOq6v1eldV52v4Tg=
X-Google-Smtp-Source: ABdhPJwl2OyvuSJrvmZs5+y4Gv3B8Ze1O9cZy/B10bOdQAY0TCuTyOcteLAclaQWFj4tym07lL4/tQ==
X-Received: by 2002:adf:94c3:: with SMTP id 61mr28663645wrr.143.1606755753277;
        Mon, 30 Nov 2020 09:02:33 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id e1sm6377466wma.17.2020.11.30.09.02.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Nov 2020 09:02:32 -0800 (PST)
Date:   Mon, 30 Nov 2020 17:02:30 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     fdmanana@suse.com, dsterba@suse.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: fix lockdep splat when reading
 qgroup config on mount" failed to apply to 4.4-stable tree
Message-ID: <20201130170230.qqlrytbd6yfsxukw@debian>
References: <16065665063666@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3ffvlrc2seyg5ewr"
Content-Disposition: inline
In-Reply-To: <16065665063666@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--3ffvlrc2seyg5ewr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Sat, Nov 28, 2020 at 01:28:26PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--3ffvlrc2seyg5ewr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-btrfs-fix-lockdep-splat-when-reading-qgroup-config-o.patch"

From 0e6f48fc8e03f2471a8839794ca1ea7c2f1bfe7b Mon Sep 17 00:00:00 2001
From: Filipe Manana <fdmanana@suse.com>
Date: Mon, 23 Nov 2020 14:28:44 +0000
Subject: [PATCH] btrfs: fix lockdep splat when reading qgroup config on mount

commit 3d05cad3c357a2b749912914356072b38435edfa upstream

Lockdep reported the following splat when running test btrfs/190 from
fstests:

  [ 9482.126098] ======================================================
  [ 9482.126184] WARNING: possible circular locking dependency detected
  [ 9482.126281] 5.10.0-rc4-btrfs-next-73 #1 Not tainted
  [ 9482.126365] ------------------------------------------------------
  [ 9482.126456] mount/24187 is trying to acquire lock:
  [ 9482.126534] ffffa0c869a7dac0 (&fs_info->qgroup_rescan_lock){+.+.}-{3:3}, at: qgroup_rescan_init+0x43/0xf0 [btrfs]
  [ 9482.126647]
		 but task is already holding lock:
  [ 9482.126777] ffffa0c892ebd3a0 (btrfs-quota-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x27/0x120 [btrfs]
  [ 9482.126886]
		 which lock already depends on the new lock.

  [ 9482.127078]
		 the existing dependency chain (in reverse order) is:
  [ 9482.127213]
		 -> #1 (btrfs-quota-00){++++}-{3:3}:
  [ 9482.127366]        lock_acquire+0xd8/0x490
  [ 9482.127436]        down_read_nested+0x45/0x220
  [ 9482.127528]        __btrfs_tree_read_lock+0x27/0x120 [btrfs]
  [ 9482.127613]        btrfs_read_lock_root_node+0x41/0x130 [btrfs]
  [ 9482.127702]        btrfs_search_slot+0x514/0xc30 [btrfs]
  [ 9482.127788]        update_qgroup_status_item+0x72/0x140 [btrfs]
  [ 9482.127877]        btrfs_qgroup_rescan_worker+0xde/0x680 [btrfs]
  [ 9482.127964]        btrfs_work_helper+0xf1/0x600 [btrfs]
  [ 9482.128039]        process_one_work+0x24e/0x5e0
  [ 9482.128110]        worker_thread+0x50/0x3b0
  [ 9482.128181]        kthread+0x153/0x170
  [ 9482.128256]        ret_from_fork+0x22/0x30
  [ 9482.128327]
		 -> #0 (&fs_info->qgroup_rescan_lock){+.+.}-{3:3}:
  [ 9482.128464]        check_prev_add+0x91/0xc60
  [ 9482.128551]        __lock_acquire+0x1740/0x3110
  [ 9482.128623]        lock_acquire+0xd8/0x490
  [ 9482.130029]        __mutex_lock+0xa3/0xb30
  [ 9482.130590]        qgroup_rescan_init+0x43/0xf0 [btrfs]
  [ 9482.131577]        btrfs_read_qgroup_config+0x43a/0x550 [btrfs]
  [ 9482.132175]        open_ctree+0x1228/0x18a0 [btrfs]
  [ 9482.132756]        btrfs_mount_root.cold+0x13/0xed [btrfs]
  [ 9482.133325]        legacy_get_tree+0x30/0x60
  [ 9482.133866]        vfs_get_tree+0x28/0xe0
  [ 9482.134392]        fc_mount+0xe/0x40
  [ 9482.134908]        vfs_kern_mount.part.0+0x71/0x90
  [ 9482.135428]        btrfs_mount+0x13b/0x3e0 [btrfs]
  [ 9482.135942]        legacy_get_tree+0x30/0x60
  [ 9482.136444]        vfs_get_tree+0x28/0xe0
  [ 9482.136949]        path_mount+0x2d7/0xa70
  [ 9482.137438]        do_mount+0x75/0x90
  [ 9482.137923]        __x64_sys_mount+0x8e/0xd0
  [ 9482.138400]        do_syscall_64+0x33/0x80
  [ 9482.138873]        entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [ 9482.139346]
		 other info that might help us debug this:

  [ 9482.140735]  Possible unsafe locking scenario:

  [ 9482.141594]        CPU0                    CPU1
  [ 9482.142011]        ----                    ----
  [ 9482.142411]   lock(btrfs-quota-00);
  [ 9482.142806]                                lock(&fs_info->qgroup_rescan_lock);
  [ 9482.143216]                                lock(btrfs-quota-00);
  [ 9482.143629]   lock(&fs_info->qgroup_rescan_lock);
  [ 9482.144056]
		  *** DEADLOCK ***

  [ 9482.145242] 2 locks held by mount/24187:
  [ 9482.145637]  #0: ffffa0c8411c40e8 (&type->s_umount_key#44/1){+.+.}-{3:3}, at: alloc_super+0xb9/0x400
  [ 9482.146061]  #1: ffffa0c892ebd3a0 (btrfs-quota-00){++++}-{3:3}, at: __btrfs_tree_read_lock+0x27/0x120 [btrfs]
  [ 9482.146509]
		 stack backtrace:
  [ 9482.147350] CPU: 1 PID: 24187 Comm: mount Not tainted 5.10.0-rc4-btrfs-next-73 #1
  [ 9482.147788] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  [ 9482.148709] Call Trace:
  [ 9482.149169]  dump_stack+0x8d/0xb5
  [ 9482.149628]  check_noncircular+0xff/0x110
  [ 9482.150090]  check_prev_add+0x91/0xc60
  [ 9482.150561]  ? kvm_clock_read+0x14/0x30
  [ 9482.151017]  ? kvm_sched_clock_read+0x5/0x10
  [ 9482.151470]  __lock_acquire+0x1740/0x3110
  [ 9482.151941]  ? __btrfs_tree_read_lock+0x27/0x120 [btrfs]
  [ 9482.152402]  lock_acquire+0xd8/0x490
  [ 9482.152887]  ? qgroup_rescan_init+0x43/0xf0 [btrfs]
  [ 9482.153354]  __mutex_lock+0xa3/0xb30
  [ 9482.153826]  ? qgroup_rescan_init+0x43/0xf0 [btrfs]
  [ 9482.154301]  ? qgroup_rescan_init+0x43/0xf0 [btrfs]
  [ 9482.154768]  ? qgroup_rescan_init+0x43/0xf0 [btrfs]
  [ 9482.155226]  qgroup_rescan_init+0x43/0xf0 [btrfs]
  [ 9482.155690]  btrfs_read_qgroup_config+0x43a/0x550 [btrfs]
  [ 9482.156160]  open_ctree+0x1228/0x18a0 [btrfs]
  [ 9482.156643]  btrfs_mount_root.cold+0x13/0xed [btrfs]
  [ 9482.157108]  ? rcu_read_lock_sched_held+0x5d/0x90
  [ 9482.157567]  ? kfree+0x31f/0x3e0
  [ 9482.158030]  legacy_get_tree+0x30/0x60
  [ 9482.158489]  vfs_get_tree+0x28/0xe0
  [ 9482.158947]  fc_mount+0xe/0x40
  [ 9482.159403]  vfs_kern_mount.part.0+0x71/0x90
  [ 9482.159875]  btrfs_mount+0x13b/0x3e0 [btrfs]
  [ 9482.160335]  ? rcu_read_lock_sched_held+0x5d/0x90
  [ 9482.160805]  ? kfree+0x31f/0x3e0
  [ 9482.161260]  ? legacy_get_tree+0x30/0x60
  [ 9482.161714]  legacy_get_tree+0x30/0x60
  [ 9482.162166]  vfs_get_tree+0x28/0xe0
  [ 9482.162616]  path_mount+0x2d7/0xa70
  [ 9482.163070]  do_mount+0x75/0x90
  [ 9482.163525]  __x64_sys_mount+0x8e/0xd0
  [ 9482.163986]  do_syscall_64+0x33/0x80
  [ 9482.164437]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [ 9482.164902] RIP: 0033:0x7f51e907caaa

This happens because at btrfs_read_qgroup_config() we can call
qgroup_rescan_init() while holding a read lock on a quota btree leaf,
acquired by the previous call to btrfs_search_slot_for_read(), and
qgroup_rescan_init() acquires the mutex qgroup_rescan_lock.

A qgroup rescan worker does the opposite: it acquires the mutex
qgroup_rescan_lock, at btrfs_qgroup_rescan_worker(), and then tries to
update the qgroup status item in the quota btree through the call to
update_qgroup_status_item(). This inversion of locking order
between the qgroup_rescan_lock mutex and quota btree locks causes the
splat.

Fix this simply by releasing and freeing the path before calling
qgroup_rescan_init() at btrfs_read_qgroup_config().

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/qgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 734babb6626c..18e667fbd054 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -462,6 +462,7 @@ next2:
 			break;
 	}
 out:
+	btrfs_free_path(path);
 	fs_info->qgroup_flags |= flags;
 	if (!(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_ON)) {
 		fs_info->quota_enabled = 0;
@@ -470,7 +471,6 @@ out:
 		   ret >= 0) {
 		ret = qgroup_rescan_init(fs_info, rescan_progress, 0);
 	}
-	btrfs_free_path(path);
 
 	if (ret < 0) {
 		ulist_free(fs_info->qgroup_ulist);
-- 
2.11.0


--3ffvlrc2seyg5ewr--
