Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530A44E2665
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 13:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242273AbiCUMb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 08:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240660AbiCUMb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 08:31:56 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445F475E6F;
        Mon, 21 Mar 2022 05:30:30 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 5CC083201591;
        Mon, 21 Mar 2022 08:30:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 21 Mar 2022 08:30:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=JJMfuBoFnvWKDblRkaoF0d5MXxvDGH4Dq+XkI9
        pTAk4=; b=IuB1jLg8vQnh48pgHjJPU6kYmwHa4/iXFp9+dZovXSKVCQ34BqLb/C
        ubxYM1Sn890wq8NkNhz5FrBIC8AqkbDnvViDsRYTSiqupas4U0ga9Kv0YXtS8X1Q
        L73v1eSNbFJYcNnNua/N0RJQyXjevsTNyxjpz4qLRTvjv8Ew6u45ZicfrfHpraxm
        /SFXtaI4khgUtjKcgJ6CkgAW+5h+qUcEiTIEa0kNVlT2jyTJy9YIKCkxnsCbiiFa
        UFjBfgQXcRa0CJkGpXu294QvfOhSkUlRdjjROmXNp2hAdYuhlhbD3NLkJSNfc751
        C9NZO4F7rv0pQl/w++cH4yaWwieY8idw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JJMfuBoFnvWKDblRk
        aoF0d5MXxvDGH4Dq+XkI9pTAk4=; b=Qc6SD88Hv/me/Ai9cJHxhJhNUjscuNZCL
        fH+oHibapMZhdTaDoLByvcg0Gxt8qEe1rVJ6ioNMkUNsbx/hTF2d0O7yocudlWTB
        V2OXuqQoE6SjK0v9ORG8CGFmxBKAO+e5exTWfe5oXKvyJbY8fJ5B5bUlNBvFJ/IR
        SLSUVYMTDXEHXTd7wIqG/7VKpa0+z3qJxnw5bdWef9ZPdWPBNXNJJdYQmJ4eytTC
        zdr3GPbw1CuhLuWWtMGtlsNjBxVqvTdhZozLpCNtvR8YTGGU9Z2uGgf3kSqvKI94
        +FkjvvCt0Kc1wmWcXCEMQlCgZ26xBIK6oBy7++ONt4HtOa/wkix7Q==
X-ME-Sender: <xms:4m84YpwDjG4FdM9Al34lLwQ0A7_JWGIDj903RLkN5b6D-OMrJJ5__g>
    <xme:4m84YpTNocBHgd9W94dcZqqfIqs5EAQLGSl0eeBayj6DmoVWqCKHbHX_1964MG7hx
    vPpACUjsvQkKw>
X-ME-Received: <xmr:4m84YjXYZzf-kGawxJ6cyQdB95yLjjrhlij5yhxsapqAgLDCjYV7yEbsptAk4RPiEjxF_zA4GSrOeJwPTrB0V3nH1wx1zYM7>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudegfedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedttedute
    eggeekvddtvdekjeevtdeguefgtefgiefgteelfeegffdutdehleevueenucffohhmrghi
    nhepqhgvmhhurdhorhhgpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4m84YrgYNm-LLyv2aoDNJFhvRDKFQgQWzAphdlwyiazj_cpqawXriQ>
    <xmx:4m84YrCaIYqu6JGrSOEao5nqdMXt1MrBNTUKSEeC5mS8RBR95IL5rA>
    <xmx:4m84YkKZb7zXpcPAKLgnCLQ5aGhG-VpwzA4vAXwMwI7TqLsVjdRzdQ>
    <xmx:4m84Yv03wfBFZdbguGh-H52f1jua4zdKu_qwIm5V_vcP7wHmLBJiyg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Mar 2022 08:30:26 -0400 (EDT)
Date:   Mon, 21 Mar 2022 13:30:24 +0100
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH stable-5.15.y, stable-5.16.y] btrfs: skip reserved bytes
 warning on unmount after log cleanup failure
Message-ID: <Yjhv4KWV9zAS2IF1@kroah.com>
References: <25358f0838c5a22923a8163e38415acaca94b01d.1647741632.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25358f0838c5a22923a8163e38415acaca94b01d.1647741632.git.anand.jain@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 20, 2022 at 10:03:17AM +0800, Anand Jain wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Commit 40cdc509877bacb438213b83c7541c5e24a1d9ec upstream
> 
> After the recent changes made by commit c2e39305299f01 ("btrfs: clear
> extent buffer uptodate when we fail to write it") and its followup fix,
> commit 651740a5024117 ("btrfs: check WRITE_ERR when trying to read an
> extent buffer"), we can now end up not cleaning up space reservations of
> log tree extent buffers after a transaction abort happens, as well as not
> cleaning up still dirty extent buffers.
> 
> This happens because if writeback for a log tree extent buffer failed,
> then we have cleared the bit EXTENT_BUFFER_UPTODATE from the extent buffer
> and we have also set the bit EXTENT_BUFFER_WRITE_ERR on it. Later on,
> when trying to free the log tree with free_log_tree(), which iterates
> over the tree, we can end up getting an -EIO error when trying to read
> a node or a leaf, since read_extent_buffer_pages() returns -EIO if an
> extent buffer does not have EXTENT_BUFFER_UPTODATE set and has the
> EXTENT_BUFFER_WRITE_ERR bit set. Getting that -EIO means that we return
> immediately as we can not iterate over the entire tree.
> 
> In that case we never update the reserved space for an extent buffer in
> the respective block group and space_info object.
> 
> When this happens we get the following traces when unmounting the fs:
> 
> [174957.284509] BTRFS: error (device dm-0) in cleanup_transaction:1913: errno=-5 IO failure
> [174957.286497] BTRFS: error (device dm-0) in free_log_tree:3420: errno=-5 IO failure
> [174957.399379] ------------[ cut here ]------------
> [174957.402497] WARNING: CPU: 2 PID: 3206883 at fs/btrfs/block-group.c:127 btrfs_put_block_group+0x77/0xb0 [btrfs]
> [174957.407523] Modules linked in: btrfs overlay dm_zero (...)
> [174957.424917] CPU: 2 PID: 3206883 Comm: umount Tainted: G        W         5.16.0-rc5-btrfs-next-109 #1
> [174957.426689] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> [174957.428716] RIP: 0010:btrfs_put_block_group+0x77/0xb0 [btrfs]
> [174957.429717] Code: 21 48 8b bd (...)
> [174957.432867] RSP: 0018:ffffb70d41cffdd0 EFLAGS: 00010206
> [174957.433632] RAX: 0000000000000001 RBX: ffff8b09c3848000 RCX: ffff8b0758edd1c8
> [174957.434689] RDX: 0000000000000001 RSI: ffffffffc0b467e7 RDI: ffff8b0758edd000
> [174957.436068] RBP: ffff8b0758edd000 R08: 0000000000000000 R09: 0000000000000000
> [174957.437114] R10: 0000000000000246 R11: 0000000000000000 R12: ffff8b09c3848148
> [174957.438140] R13: ffff8b09c3848198 R14: ffff8b0758edd188 R15: dead000000000100
> [174957.439317] FS:  00007f328fb82800(0000) GS:ffff8b0a2d200000(0000) knlGS:0000000000000000
> [174957.440402] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [174957.441164] CR2: 00007fff13563e98 CR3: 0000000404f4e005 CR4: 0000000000370ee0
> [174957.442117] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [174957.443076] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [174957.443948] Call Trace:
> [174957.444264]  <TASK>
> [174957.444538]  btrfs_free_block_groups+0x255/0x3c0 [btrfs]
> [174957.445238]  close_ctree+0x301/0x357 [btrfs]
> [174957.445803]  ? call_rcu+0x16c/0x290
> [174957.446250]  generic_shutdown_super+0x74/0x120
> [174957.446832]  kill_anon_super+0x14/0x30
> [174957.447305]  btrfs_kill_super+0x12/0x20 [btrfs]
> [174957.447890]  deactivate_locked_super+0x31/0xa0
> [174957.448440]  cleanup_mnt+0x147/0x1c0
> [174957.448888]  task_work_run+0x5c/0xa0
> [174957.449336]  exit_to_user_mode_prepare+0x1e5/0x1f0
> [174957.449934]  syscall_exit_to_user_mode+0x16/0x40
> [174957.450512]  do_syscall_64+0x48/0xc0
> [174957.450980]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [174957.451605] RIP: 0033:0x7f328fdc4a97
> [174957.452059] Code: 03 0c 00 f7 (...)
> [174957.454320] RSP: 002b:00007fff13564ec8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> [174957.455262] RAX: 0000000000000000 RBX: 00007f328feea264 RCX: 00007f328fdc4a97
> [174957.456131] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000560b8ae51dd0
> [174957.457118] RBP: 0000560b8ae51ba0 R08: 0000000000000000 R09: 00007fff13563c40
> [174957.458005] R10: 00007f328fe49fc0 R11: 0000000000000246 R12: 0000000000000000
> [174957.459113] R13: 0000560b8ae51dd0 R14: 0000560b8ae51cb0 R15: 0000000000000000
> [174957.460193]  </TASK>
> [174957.460534] irq event stamp: 0
> [174957.461003] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [174957.461947] hardirqs last disabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
> [174957.463147] softirqs last  enabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
> [174957.465116] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [174957.466323] ---[ end trace bc7ee0c490bce3af ]---
> [174957.467282] ------------[ cut here ]------------
> [174957.468184] WARNING: CPU: 2 PID: 3206883 at fs/btrfs/block-group.c:3976 btrfs_free_block_groups+0x330/0x3c0 [btrfs]
> [174957.470066] Modules linked in: btrfs overlay dm_zero (...)
> [174957.483137] CPU: 2 PID: 3206883 Comm: umount Tainted: G        W         5.16.0-rc5-btrfs-next-109 #1
> [174957.484691] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
> [174957.486853] RIP: 0010:btrfs_free_block_groups+0x330/0x3c0 [btrfs]
> [174957.488050] Code: 00 00 00 ad de (...)
> [174957.491479] RSP: 0018:ffffb70d41cffde0 EFLAGS: 00010206
> [174957.492520] RAX: ffff8b08d79310b0 RBX: ffff8b09c3848000 RCX: 0000000000000000
> [174957.493868] RDX: 0000000000000001 RSI: fffff443055ee600 RDI: ffffffffb1131846
> [174957.495183] RBP: ffff8b08d79310b0 R08: 0000000000000000 R09: 0000000000000000
> [174957.496580] R10: 0000000000000001 R11: 0000000000000000 R12: ffff8b08d7931000
> [174957.498027] R13: ffff8b09c38492b0 R14: dead000000000122 R15: dead000000000100
> [174957.499438] FS:  00007f328fb82800(0000) GS:ffff8b0a2d200000(0000) knlGS:0000000000000000
> [174957.500990] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [174957.502117] CR2: 00007fff13563e98 CR3: 0000000404f4e005 CR4: 0000000000370ee0
> [174957.503513] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [174957.504864] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [174957.506167] Call Trace:
> [174957.506654]  <TASK>
> [174957.507047]  close_ctree+0x301/0x357 [btrfs]
> [174957.507867]  ? call_rcu+0x16c/0x290
> [174957.508567]  generic_shutdown_super+0x74/0x120
> [174957.509447]  kill_anon_super+0x14/0x30
> [174957.510194]  btrfs_kill_super+0x12/0x20 [btrfs]
> [174957.511123]  deactivate_locked_super+0x31/0xa0
> [174957.511976]  cleanup_mnt+0x147/0x1c0
> [174957.512610]  task_work_run+0x5c/0xa0
> [174957.513309]  exit_to_user_mode_prepare+0x1e5/0x1f0
> [174957.514231]  syscall_exit_to_user_mode+0x16/0x40
> [174957.515069]  do_syscall_64+0x48/0xc0
> [174957.515718]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [174957.516688] RIP: 0033:0x7f328fdc4a97
> [174957.517413] Code: 03 0c 00 f7 d8 (...)
> [174957.521052] RSP: 002b:00007fff13564ec8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
> [174957.522514] RAX: 0000000000000000 RBX: 00007f328feea264 RCX: 00007f328fdc4a97
> [174957.523950] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000560b8ae51dd0
> [174957.525375] RBP: 0000560b8ae51ba0 R08: 0000000000000000 R09: 00007fff13563c40
> [174957.526763] R10: 00007f328fe49fc0 R11: 0000000000000246 R12: 0000000000000000
> [174957.528058] R13: 0000560b8ae51dd0 R14: 0000560b8ae51cb0 R15: 0000000000000000
> [174957.529404]  </TASK>
> [174957.529843] irq event stamp: 0
> [174957.530256] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [174957.531061] hardirqs last disabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
> [174957.532075] softirqs last  enabled at (0): [<ffffffffb0e94214>] copy_process+0x934/0x2040
> [174957.533083] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [174957.533865] ---[ end trace bc7ee0c490bce3b0 ]---
> [174957.534452] BTRFS info (device dm-0): space_info 4 has 1070841856 free, is not full
> [174957.535404] BTRFS info (device dm-0): space_info total=1073741824, used=2785280, pinned=0, reserved=49152, may_use=0, readonly=65536 zone_unusable=0
> [174957.537029] BTRFS info (device dm-0): global_block_rsv: size 0 reserved 0
> [174957.537859] BTRFS info (device dm-0): trans_block_rsv: size 0 reserved 0
> [174957.538697] BTRFS info (device dm-0): chunk_block_rsv: size 0 reserved 0
> [174957.539552] BTRFS info (device dm-0): delayed_block_rsv: size 0 reserved 0
> [174957.540403] BTRFS info (device dm-0): delayed_refs_rsv: size 0 reserved 0
> 
> This also means that in case we have log tree extent buffers that are
> still dirty, we can end up not cleaning them up in case we find an
> extent buffer with EXTENT_BUFFER_WRITE_ERR set on it, as in that case
> we have no way for iterating over the rest of the tree.
> 
> This issue is very often triggered with test cases generic/475 and
> generic/648 from fstests.
> 
> The issue could almost be fixed by iterating over the io tree attached to
> each log root which keeps tracks of the range of allocated extent buffers,
> log_root->dirty_log_pages, however that does not work and has some
> inconveniences:
> 
> 1) After we sync the log, we clear the range of the extent buffers from
>    the io tree, so we can't find them after writeback. We could keep the
>    ranges in the io tree, with a separate bit to signal they represent
>    extent buffers already written, but that means we need to hold into
>    more memory until the transaction commits.
> 
>    How much more memory is used depends a lot on whether we are able to
>    allocate contiguous extent buffers on disk (and how often) for a log
>    tree - if we are able to, then a single extent state record can
>    represent multiple extent buffers, otherwise we need multiple extent
>    state record structures to track each extent buffer.
>    In fact, my earlier approach did that:
> 
>    https://lore.kernel.org/linux-btrfs/3aae7c6728257c7ce2279d6660ee2797e5e34bbd.1641300250.git.fdmanana@suse.com/
> 
>    However that can cause a very significant negative impact on
>    performance, not only due to the extra memory usage but also because
>    we get a larger and deeper dirty_log_pages io tree.
>    We got a report that, on beefy machines at least, we can get such
>    performance drop with fsmark for example:
> 
>    https://lore.kernel.org/linux-btrfs/20220117082426.GE32491@xsang-OptiPlex-9020/
> 
> 2) We would be doing it only to deal with an unexpected and exceptional
>    case, which is basically failure to read an extent buffer from disk
>    due to IO failures. On a healthy system we don't expect transaction
>    aborts to happen after all;
> 
> 3) Instead of relying on iterating the log tree or tracking the ranges
>    of extent buffers in the dirty_log_pages io tree, using the radix
>    tree that tracks extent buffers (fs_info->buffer_radix) to find all
>    log tree extent buffers is not reliable either, because after writeback
>    of an extent buffer it can be evicted from memory by the release page
>    callback of the btree inode (btree_releasepage()).
> 
> Since there's no way to be able to properly cleanup a log tree without
> being able to read its extent buffers from disk and without using more
> memory to track the logical ranges of the allocated extent buffers do
> the following:
> 
> 1) When we fail to cleanup a log tree, setup a flag that indicates that
>    failure;
> 
> 2) Trigger writeback of all log tree extent buffers that are still dirty,
>    and wait for the writeback to complete. This is just to cleanup their
>    state, page states, page leaks, etc;
> 
> 3) When unmounting the fs, ignore if the number of bytes reserved in a
>    block group and in a space_info is not 0 if, and only if, we failed to
>    cleanup a log tree. Also ignore only for metadata block groups and the
>    metadata space_info object.
> 
> This is far from a perfect solution, but it serves to silence test
> failures such as those from generic/475 and generic/648. However having
> a non-zero value for the reserved bytes counters on unmount after a
> transaction abort, is not such a terrible thing and it's completely
> harmless, it does not affect the filesystem integrity in any way.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> Unrelated conflict fix in
>   fs/btrfs/ctree.h
> 
>  fs/btrfs/block-group.c | 26 ++++++++++++++++++++++++--
>  fs/btrfs/ctree.h       |  7 +++++++
>  fs/btrfs/tree-log.c    | 23 +++++++++++++++++++++++
>  3 files changed, 54 insertions(+), 2 deletions(-)
> 

Now queued up, thanks,.

greg k-h
