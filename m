Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299332F92BD
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbhAQOFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:05:42 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:38877 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727480AbhAQOFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:05:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C729519528C9;
        Sun, 17 Jan 2021 09:04:30 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:04:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xsJy7K
        nJKIVv1+apatlXYgY3MZePFts04BdcruyrN5I=; b=pTTUxCymRPiq6A+RPaZs3E
        M2ccPNDzDd88yihQ9T8i6uL66ZvdY9VfKNqbox6gLb6F2ZY3kMLhrmgb32SH34GZ
        cAf+BU4qaM0JzbxrvOFalXeQrS579plH0K0Z2x1lg4H7pftsVEYMHLboYkAIsEZa
        UHp6Fq5UjDDGwYTXy2M12/ZJAOZKaQEu3hrNmJREM4JM4lwkRsg0pbP2lqOEVLPi
        fMAGX0NVWtzoJCE6wm7hIe1Eg53dwIFdiGztLtUU0uh5z3plITjo42kV70eVbSFQ
        LsAH1pTAUC98/lRs2pzhKFad+H8hwF42qC6akiBo9Ua7e9yhhNhFgPLtcWkaa/TQ
        ==
X-ME-Sender: <xms:7kMEYC6DmuVD4yPUVGJK48NOp1uG2SAZPqzoFrb01GnVOKH7_XjaCA>
    <xme:7kMEYJ13544nLs5F7u0_H6PMPr-l6GbVVG0CL4L0C95BdTxFn4ow_IuyxpcTiPH7a
    scbq3O1TxT4WQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:7kMEYJB5hyIeqs_-2CKIjFxnkREFE6AaJBwAFPzl8_cQCZmg0Dkxbg>
    <xmx:7kMEYL0NPvkNXQHnJJwqjJr_R9EZl4vG9FxEg_6z711al-31OJ3eKA>
    <xmx:7kMEYDtalEvrf_NqdP8XK61tCuKPwQsPKwbfykn7Ybxy8_Z-7eWkpQ>
    <xmx:7kMEYJySf2zesOY6ZLlGjFFkujGk9hBhQXAyRuYtLTMiM5CobpGQbA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 873EA24005A;
        Sun, 17 Jan 2021 09:04:30 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: tree-checker: check if chunk item end overflows" failed to apply to 4.19-stable tree
To:     l@damenly.su, anand.jain@oracle.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:04:29 +0100
Message-ID: <161089226952164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 347fb0cfc9bab5195c6701e62eda488310d7938f Mon Sep 17 00:00:00 2001
From: Su Yue <l@damenly.su>
Date: Sun, 3 Jan 2021 17:28:04 +0800
Subject: [PATCH] btrfs: tree-checker: check if chunk item end overflows

While mounting a crafted image provided by user, kernel panics due to
the invalid chunk item whose end is less than start.

  [66.387422] loop: module loaded
  [66.389773] loop0: detected capacity change from 262144 to 0
  [66.427708] BTRFS: device fsid a62e00e8-e94e-4200-8217-12444de93c2e devid 1 transid 12 /dev/loop0 scanned by mount (613)
  [66.431061] BTRFS info (device loop0): disk space caching is enabled
  [66.431078] BTRFS info (device loop0): has skinny extents
  [66.437101] BTRFS error: insert state: end < start 29360127 37748736
  [66.437136] ------------[ cut here ]------------
  [66.437140] WARNING: CPU: 16 PID: 613 at fs/btrfs/extent_io.c:557 insert_state.cold+0x1a/0x46 [btrfs]
  [66.437369] CPU: 16 PID: 613 Comm: mount Tainted: G           O      5.11.0-rc1-custom #45
  [66.437374] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
  [66.437378] RIP: 0010:insert_state.cold+0x1a/0x46 [btrfs]
  [66.437420] RSP: 0018:ffff93e5414c3908 EFLAGS: 00010286
  [66.437427] RAX: 0000000000000000 RBX: 0000000001bfffff RCX: 0000000000000000
  [66.437431] RDX: 0000000000000000 RSI: ffffffffb90d4660 RDI: 00000000ffffffff
  [66.437434] RBP: ffff93e5414c3938 R08: 0000000000000001 R09: 0000000000000001
  [66.437438] R10: ffff93e5414c3658 R11: 0000000000000000 R12: ffff8ec782d72aa0
  [66.437441] R13: ffff8ec78bc71628 R14: 0000000000000000 R15: 0000000002400000
  [66.437447] FS:  00007f01386a8580(0000) GS:ffff8ec809000000(0000) knlGS:0000000000000000
  [66.437451] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [66.437455] CR2: 00007f01382fa000 CR3: 0000000109a34000 CR4: 0000000000750ee0
  [66.437460] PKRU: 55555554
  [66.437464] Call Trace:
  [66.437475]  set_extent_bit+0x652/0x740 [btrfs]
  [66.437539]  set_extent_bits_nowait+0x1d/0x20 [btrfs]
  [66.437576]  add_extent_mapping+0x1e0/0x2f0 [btrfs]
  [66.437621]  read_one_chunk+0x33c/0x420 [btrfs]
  [66.437674]  btrfs_read_chunk_tree+0x6a4/0x870 [btrfs]
  [66.437708]  ? kvm_sched_clock_read+0x18/0x40
  [66.437739]  open_ctree+0xb32/0x1734 [btrfs]
  [66.437781]  ? bdi_register_va+0x1b/0x20
  [66.437788]  ? super_setup_bdi_name+0x79/0xd0
  [66.437810]  btrfs_mount_root.cold+0x12/0xeb [btrfs]
  [66.437854]  ? __kmalloc_track_caller+0x217/0x3b0
  [66.437873]  legacy_get_tree+0x34/0x60
  [66.437880]  vfs_get_tree+0x2d/0xc0
  [66.437888]  vfs_kern_mount.part.0+0x78/0xc0
  [66.437897]  vfs_kern_mount+0x13/0x20
  [66.437902]  btrfs_mount+0x11f/0x3c0 [btrfs]
  [66.437940]  ? kfree+0x5ff/0x670
  [66.437944]  ? __kmalloc_track_caller+0x217/0x3b0
  [66.437962]  legacy_get_tree+0x34/0x60
  [66.437974]  vfs_get_tree+0x2d/0xc0
  [66.437983]  path_mount+0x48c/0xd30
  [66.437998]  __x64_sys_mount+0x108/0x140
  [66.438011]  do_syscall_64+0x38/0x50
  [66.438018]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [66.438023] RIP: 0033:0x7f0138827f6e
  [66.438033] RSP: 002b:00007ffecd79edf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
  [66.438040] RAX: ffffffffffffffda RBX: 00007f013894c264 RCX: 00007f0138827f6e
  [66.438044] RDX: 00005593a4a41360 RSI: 00005593a4a33690 RDI: 00005593a4a3a6c0
  [66.438047] RBP: 00005593a4a33440 R08: 0000000000000000 R09: 0000000000000001
  [66.438050] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  [66.438054] R13: 00005593a4a3a6c0 R14: 00005593a4a41360 R15: 00005593a4a33440
  [66.438078] irq event stamp: 18169
  [66.438082] hardirqs last  enabled at (18175): [<ffffffffb81154bf>] console_unlock+0x4ff/0x5f0
  [66.438088] hardirqs last disabled at (18180): [<ffffffffb8115427>] console_unlock+0x467/0x5f0
  [66.438092] softirqs last  enabled at (16910): [<ffffffffb8a00fe2>] asm_call_irq_on_stack+0x12/0x20
  [66.438097] softirqs last disabled at (16905): [<ffffffffb8a00fe2>] asm_call_irq_on_stack+0x12/0x20
  [66.438103] ---[ end trace e114b111db64298b ]---
  [66.438107] BTRFS error: found node 12582912 29360127 on insert of 37748736 29360127
  [66.438127] BTRFS critical: panic in extent_io_tree_panic:679: locking error: extent tree was modified by another thread while locked (errno=-17 Object already exists)
  [66.441069] ------------[ cut here ]------------
  [66.441072] kernel BUG at fs/btrfs/extent_io.c:679!
  [66.442064] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  [66.443018] CPU: 16 PID: 613 Comm: mount Tainted: G        W  O      5.11.0-rc1-custom #45
  [66.444538] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ArchLinux 1.14.0-1 04/01/2014
  [66.446223] RIP: 0010:extent_io_tree_panic.isra.0+0x23/0x25 [btrfs]
  [66.450878] RSP: 0018:ffff93e5414c3948 EFLAGS: 00010246
  [66.451840] RAX: 0000000000000000 RBX: 0000000001bfffff RCX: 0000000000000000
  [66.453141] RDX: 0000000000000000 RSI: ffffffffb90d4660 RDI: 00000000ffffffff
  [66.454445] RBP: ffff93e5414c3948 R08: 0000000000000001 R09: 0000000000000001
  [66.455743] R10: ffff93e5414c3658 R11: 0000000000000000 R12: ffff8ec782d728c0
  [66.457055] R13: ffff8ec78bc71628 R14: ffff8ec782d72aa0 R15: 0000000002400000
  [66.458356] FS:  00007f01386a8580(0000) GS:ffff8ec809000000(0000) knlGS:0000000000000000
  [66.459841] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [66.460895] CR2: 00007f01382fa000 CR3: 0000000109a34000 CR4: 0000000000750ee0
  [66.462196] PKRU: 55555554
  [66.462692] Call Trace:
  [66.463139]  set_extent_bit.cold+0x30/0x98 [btrfs]
  [66.464049]  set_extent_bits_nowait+0x1d/0x20 [btrfs]
  [66.490466]  add_extent_mapping+0x1e0/0x2f0 [btrfs]
  [66.514097]  read_one_chunk+0x33c/0x420 [btrfs]
  [66.534976]  btrfs_read_chunk_tree+0x6a4/0x870 [btrfs]
  [66.555718]  ? kvm_sched_clock_read+0x18/0x40
  [66.575758]  open_ctree+0xb32/0x1734 [btrfs]
  [66.595272]  ? bdi_register_va+0x1b/0x20
  [66.614638]  ? super_setup_bdi_name+0x79/0xd0
  [66.633809]  btrfs_mount_root.cold+0x12/0xeb [btrfs]
  [66.652938]  ? __kmalloc_track_caller+0x217/0x3b0
  [66.671925]  legacy_get_tree+0x34/0x60
  [66.690300]  vfs_get_tree+0x2d/0xc0
  [66.708221]  vfs_kern_mount.part.0+0x78/0xc0
  [66.725808]  vfs_kern_mount+0x13/0x20
  [66.742730]  btrfs_mount+0x11f/0x3c0 [btrfs]
  [66.759350]  ? kfree+0x5ff/0x670
  [66.775441]  ? __kmalloc_track_caller+0x217/0x3b0
  [66.791750]  legacy_get_tree+0x34/0x60
  [66.807494]  vfs_get_tree+0x2d/0xc0
  [66.823349]  path_mount+0x48c/0xd30
  [66.838753]  __x64_sys_mount+0x108/0x140
  [66.854412]  do_syscall_64+0x38/0x50
  [66.869673]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [66.885093] RIP: 0033:0x7f0138827f6e
  [66.945613] RSP: 002b:00007ffecd79edf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
  [66.977214] RAX: ffffffffffffffda RBX: 00007f013894c264 RCX: 00007f0138827f6e
  [66.994266] RDX: 00005593a4a41360 RSI: 00005593a4a33690 RDI: 00005593a4a3a6c0
  [67.011544] RBP: 00005593a4a33440 R08: 0000000000000000 R09: 0000000000000001
  [67.028836] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
  [67.045812] R13: 00005593a4a3a6c0 R14: 00005593a4a41360 R15: 00005593a4a33440
  [67.216138] ---[ end trace e114b111db64298c ]---
  [67.237089] RIP: 0010:extent_io_tree_panic.isra.0+0x23/0x25 [btrfs]
  [67.325317] RSP: 0018:ffff93e5414c3948 EFLAGS: 00010246
  [67.347946] RAX: 0000000000000000 RBX: 0000000001bfffff RCX: 0000000000000000
  [67.371343] RDX: 0000000000000000 RSI: ffffffffb90d4660 RDI: 00000000ffffffff
  [67.394757] RBP: ffff93e5414c3948 R08: 0000000000000001 R09: 0000000000000001
  [67.418409] R10: ffff93e5414c3658 R11: 0000000000000000 R12: ffff8ec782d728c0
  [67.441906] R13: ffff8ec78bc71628 R14: ffff8ec782d72aa0 R15: 0000000002400000
  [67.465436] FS:  00007f01386a8580(0000) GS:ffff8ec809000000(0000) knlGS:0000000000000000
  [67.511660] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [67.535047] CR2: 00007f01382fa000 CR3: 0000000109a34000 CR4: 0000000000750ee0
  [67.558449] PKRU: 55555554
  [67.581146] note: mount[613] exited with preempt_count 2

The image has a chunk item which has a logical start 37748736 and length
18446744073701163008 (-8M). The calculated end 29360127 overflows.
EEXIST was caught by insert_state() because of the duplicate end and
extent_io_tree_panic() was called.

Add overflow check of chunk item end to tree checker so it can be
detected early at mount time.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=208929
CC: stable@vger.kernel.org # 4.19+
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 028e733e42f3..582061c7b547 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -760,6 +760,7 @@ int btrfs_check_chunk_valid(struct extent_buffer *leaf,
 {
 	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	u64 length;
+	u64 chunk_end;
 	u64 stripe_len;
 	u16 num_stripes;
 	u16 sub_stripes;
@@ -814,6 +815,12 @@ int btrfs_check_chunk_valid(struct extent_buffer *leaf,
 			  "invalid chunk length, have %llu", length);
 		return -EUCLEAN;
 	}
+	if (unlikely(check_add_overflow(logical, length, &chunk_end))) {
+		chunk_err(leaf, chunk, logical,
+"invalid chunk logical start and length, have logical start %llu length %llu",
+			  logical, length);
+		return -EUCLEAN;
+	}
 	if (unlikely(!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN)) {
 		chunk_err(leaf, chunk, logical,
 			  "invalid chunk stripe length: %llu",

