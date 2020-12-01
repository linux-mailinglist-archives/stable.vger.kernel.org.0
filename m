Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1267B2CA954
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 18:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388037AbgLARL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 12:11:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387997AbgLARL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 12:11:57 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64E54C0613CF
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 09:11:17 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id v14so4738185wml.1
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 09:11:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gGzFaD03Xhm5e8i1ABvKtEAHvDNnBiaLIfgYSOZazeg=;
        b=STrT7DS/3G/3SoFCXtuz6dMYOw2yCc58dTl/bJ3Gd1xnO8JG9/geheEQWQQfBrsIJE
         +RRruBMpvEJba048/E6rlZwLnmDFIFfsae7nTAU2zhHMOXR6d+6coMAhB5b4P194TFJS
         ZHFOiQALnGEUGcCUB+F3oendc+l5h7/LPEmd/hW+WmKIkgtrz9iP2A3x5rZQy28cbNcI
         078wlVOGCC2w8F54dSDJTriHt/8tlXbBgrVk/OY6UST4AzyA83ol84Na53eB38L6Z6Wz
         V4z22L1j52ezC4R9p2I9lyaStcUwhjXa779ZSqBWGFWPGRhs1Qq2MSE3D0nYBDUq+O/3
         Ln5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gGzFaD03Xhm5e8i1ABvKtEAHvDNnBiaLIfgYSOZazeg=;
        b=smYegsSo2XjcujLEs8lgNSaqY9R/MOzXEUm1H0T1YRdJ33n+SwC5VofqyDzY2/trdu
         FlMiVosl9I2ttwryVgumE3qjj2jjw7JuYW7c/gpDsYQoVmz1cePdZrcBs2dHJAi1G3zg
         M2Y3J0rYijP8jmAPj5/HEijN1lUWJMh/7NbkeOoVFJ+H5JJ2b1hReLn/cNohAFmQhk10
         rzCUJIGe1JuLkEIeOaPzHCVCLD7BApG60Qir1recraYaqjGp2lhLMnK5b40IUbIo4ddG
         d+RlrYnkkfGvrm/i+A09OfGc/WcGcf7kH9U51dSHLfFnxXvc4oK3wXbJOb5mHOcci94k
         7LsQ==
X-Gm-Message-State: AOAM533rpRWV91rlzNmC3159r9GvTcFNgk34rsUZtZzQyQle17J9BSho
        RGmenAWV9UiFdjAZ4m3VrDaAtu87kMgraA==
X-Google-Smtp-Source: ABdhPJxWiff0ys0MmTXA3VZXl/Pwe9fRtQzJgjc+1aAtTh9l1HDGDjnPIf9No5P20pIoGFXJQe0E1g==
X-Received: by 2002:a1c:7f81:: with SMTP id a123mr3751532wmd.6.1606842675989;
        Tue, 01 Dec 2020 09:11:15 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id b14sm298743wrq.47.2020.12.01.09.11.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 01 Dec 2020 09:11:15 -0800 (PST)
Date:   Tue, 1 Dec 2020 17:11:13 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] btrfs: cleanup cow block on error" failed
 to apply to 4.4-stable tree
Message-ID: <20201201171113.cvycv34hlpd2d22p@debian>
References: <1604411844243166@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="umc76imemoawu3x4"
Content-Disposition: inline
In-Reply-To: <1604411844243166@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--umc76imemoawu3x4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Tue, Nov 03, 2020 at 02:57:24PM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport.

--
Regards
Sudip

--umc76imemoawu3x4
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-btrfs-cleanup-cow-block-on-error.patch"

From e9bc6c9aaf654f91bda1cd5742a875a3307908d5 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Tue, 29 Sep 2020 08:53:54 -0400
Subject: [PATCH] btrfs: cleanup cow block on error

commit 572c83acdcdafeb04e70aa46be1fa539310be20c upstream

In fstest btrfs/064 a transaction abort in __btrfs_cow_block could lead
to a system lockup. It gets stuck trying to write back inodes, and the
write back thread was trying to lock an extent buffer:

  $ cat /proc/2143497/stack
  [<0>] __btrfs_tree_lock+0x108/0x250
  [<0>] lock_extent_buffer_for_io+0x35e/0x3a0
  [<0>] btree_write_cache_pages+0x15a/0x3b0
  [<0>] do_writepages+0x28/0xb0
  [<0>] __writeback_single_inode+0x54/0x5c0
  [<0>] writeback_sb_inodes+0x1e8/0x510
  [<0>] wb_writeback+0xcc/0x440
  [<0>] wb_workfn+0xd7/0x650
  [<0>] process_one_work+0x236/0x560
  [<0>] worker_thread+0x55/0x3c0
  [<0>] kthread+0x13a/0x150
  [<0>] ret_from_fork+0x1f/0x30

This is because we got an error while COWing a block, specifically here

        if (test_bit(BTRFS_ROOT_SHAREABLE, &root->state)) {
                ret = btrfs_reloc_cow_block(trans, root, buf, cow);
                if (ret) {
                        btrfs_abort_transaction(trans, ret);
                        return ret;
                }
        }

  [16402.241552] BTRFS: Transaction aborted (error -2)
  [16402.242362] WARNING: CPU: 1 PID: 2563188 at fs/btrfs/ctree.c:1074 __btrfs_cow_block+0x376/0x540
  [16402.249469] CPU: 1 PID: 2563188 Comm: fsstress Not tainted 5.9.0-rc6+ #8
  [16402.249936] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-2.fc32 04/01/2014
  [16402.250525] RIP: 0010:__btrfs_cow_block+0x376/0x540
  [16402.252417] RSP: 0018:ffff9cca40e578b0 EFLAGS: 00010282
  [16402.252787] RAX: 0000000000000025 RBX: 0000000000000002 RCX: ffff9132bbd19388
  [16402.253278] RDX: 00000000ffffffd8 RSI: 0000000000000027 RDI: ffff9132bbd19380
  [16402.254063] RBP: ffff9132b41a49c0 R08: 0000000000000000 R09: 0000000000000000
  [16402.254887] R10: 0000000000000000 R11: ffff91324758b080 R12: ffff91326ef17ce0
  [16402.255694] R13: ffff91325fc0f000 R14: ffff91326ef176b0 R15: ffff9132815e2000
  [16402.256321] FS:  00007f542c6d7b80(0000) GS:ffff9132bbd00000(0000) knlGS:0000000000000000
  [16402.256973] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [16402.257374] CR2: 00007f127b83f250 CR3: 0000000133480002 CR4: 0000000000370ee0
  [16402.257867] Call Trace:
  [16402.258072]  btrfs_cow_block+0x109/0x230
  [16402.258356]  btrfs_search_slot+0x530/0x9d0
  [16402.258655]  btrfs_lookup_file_extent+0x37/0x40
  [16402.259155]  __btrfs_drop_extents+0x13c/0xd60
  [16402.259628]  ? btrfs_block_rsv_migrate+0x4f/0xb0
  [16402.259949]  btrfs_replace_file_extents+0x190/0x820
  [16402.260873]  btrfs_clone+0x9ae/0xc00
  [16402.261139]  btrfs_extent_same_range+0x66/0x90
  [16402.261771]  btrfs_remap_file_range+0x353/0x3b1
  [16402.262333]  vfs_dedupe_file_range_one.part.0+0xd5/0x140
  [16402.262821]  vfs_dedupe_file_range+0x189/0x220
  [16402.263150]  do_vfs_ioctl+0x552/0x700
  [16402.263662]  __x64_sys_ioctl+0x62/0xb0
  [16402.264023]  do_syscall_64+0x33/0x40
  [16402.264364]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
  [16402.264862] RIP: 0033:0x7f542c7d15cb
  [16402.266901] RSP: 002b:00007ffd35944ea8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
  [16402.267627] RAX: ffffffffffffffda RBX: 00000000009d1968 RCX: 00007f542c7d15cb
  [16402.268298] RDX: 00000000009d2490 RSI: 00000000c0189436 RDI: 0000000000000003
  [16402.268958] RBP: 00000000009d2520 R08: 0000000000000036 R09: 00000000009d2e64
  [16402.269726] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
  [16402.270659] R13: 000000000001f000 R14: 00000000009d1970 R15: 00000000009d2e80
  [16402.271498] irq event stamp: 0
  [16402.271846] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
  [16402.272497] hardirqs last disabled at (0): [<ffffffff910dbf59>] copy_process+0x6b9/0x1ba0
  [16402.273343] softirqs last  enabled at (0): [<ffffffff910dbf59>] copy_process+0x6b9/0x1ba0
  [16402.273905] softirqs last disabled at (0): [<0000000000000000>] 0x0
  [16402.274338] ---[ end trace 737874a5a41a8236 ]---
  [16402.274669] BTRFS: error (device dm-9) in __btrfs_cow_block:1074: errno=-2 No such entry
  [16402.276179] BTRFS info (device dm-9): forced readonly
  [16402.277046] BTRFS: error (device dm-9) in btrfs_replace_file_extents:2723: errno=-2 No such entry
  [16402.278744] BTRFS: error (device dm-9) in __btrfs_cow_block:1074: errno=-2 No such entry
  [16402.279968] BTRFS: error (device dm-9) in __btrfs_cow_block:1074: errno=-2 No such entry
  [16402.280582] BTRFS info (device dm-9): balance: ended with status: -30

The problem here is that as soon as we allocate the new block it is
locked and marked dirty in the btree inode.  This means that we could
attempt to writeback this block and need to lock the extent buffer.
However we're not unlocking it here and thus we deadlock.

Fix this by unlocking the cow block if we have any errors inside of
__btrfs_cow_block, and also free it so we do not leak it.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
[sudip: use old btrfs_abort_transaction()]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 fs/btrfs/ctree.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 3fa0515d7685..85b64475d808 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1129,6 +1129,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 
 	ret = update_ref_for_cow(trans, root, buf, cow, &last_ref);
 	if (ret) {
+		btrfs_tree_unlock(cow);
+		free_extent_buffer(cow);
 		btrfs_abort_transaction(trans, root, ret);
 		return ret;
 	}
@@ -1136,6 +1138,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 	if (test_bit(BTRFS_ROOT_REF_COWS, &root->state)) {
 		ret = btrfs_reloc_cow_block(trans, root, buf, cow);
 		if (ret) {
+			btrfs_tree_unlock(cow);
+			free_extent_buffer(cow);
 			btrfs_abort_transaction(trans, root, ret);
 			return ret;
 		}
@@ -1174,6 +1178,8 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
 		if (last_ref) {
 			ret = tree_mod_log_free_eb(root->fs_info, buf);
 			if (ret) {
+				btrfs_tree_unlock(cow);
+				free_extent_buffer(cow);
 				btrfs_abort_transaction(trans, root, ret);
 				return ret;
 			}
-- 
2.11.0


--umc76imemoawu3x4--
