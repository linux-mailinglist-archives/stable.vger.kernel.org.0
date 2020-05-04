Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912D21C341C
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 10:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgEDION (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 04:14:13 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44915 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728052AbgEDIOM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 04:14:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B709559B;
        Mon,  4 May 2020 04:14:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 04 May 2020 04:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=f0mCJa
        +N5D0/gen6ny9dGgtdYc0KqDZ3IJArbqAo8EE=; b=tLViSluKtU31mEHYhSCcgp
        aU7njSg0SGcLPAsF8I+dyGI5Wlt7dNp/0tUKcfM4KBhhsa3QavvzRfVDXNu8n5TD
        TTROGHO4P0Y7zqi8ZJvWAG4h6NO77OWlMOsiCuYpL84IYAtXE35fvcWa/UXfYxOj
        WsjCiY4M4iwAqqnuoxuoPgBFW6vLjF1YIX48EnbUxOQjXIVkREV/d1JHkpXgnQJZ
        95nuHL2sQgQGxYdKzr/fI/xi+XSWAvhXHuSgUqA/Ef1z02dnPEfrizjgv7xDt2GR
        8AEKZWHLo6VG7H3fHC9O/ojaGMLVLEyOwWEqaHr/bh66AUvICy4x3ImVh0sEQD1g
        ==
X-ME-Sender: <xms:0s6vXhyADQVc7r6UN5FLqz4R2yBhKupehxqV2nMwolFOUrVyDhZdOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrjeegucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttddtlfenuc
    fhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhrgheqnecu
    ggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejudetveeuve
    eludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:0s6vXnvvKe_uP0-ZvX9PxdD2qJ92YFKEzRZx40UDC_8Ly-BGanfn8w>
    <xmx:0s6vXkKMAdx5DXKqjE6Z3zT_9wYnXQjxeuBmB6EZgX513R9LCaAc9A>
    <xmx:0s6vXmbp752g7vvz_k70Hsj6s2w9ly3XL3v8rmWlXo63R97sC9jrDQ>
    <xmx:086vXuQBfEulmJ0Es-ckVWnrdyONNmcNaDadJWs6UVkTNBX12uzpO1C3riw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0E1553065FFD;
        Mon,  4 May 2020 04:14:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: fix transaction leak in btrfs_recover_relocation" failed to apply to 4.19-stable tree
To:     xiyuyang19@fudan.edu.cn, dsterba@suse.com, fdmanana@suse.com,
        tanxin.ctf@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 May 2020 10:14:08 +0200
Message-ID: <158858004882150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 1402d17dfd9657be0da8458b2079d03c2d61c86a Mon Sep 17 00:00:00 2001
From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Mon, 20 Apr 2020 13:39:39 +0800
Subject: [PATCH] btrfs: fix transaction leak in btrfs_recover_relocation

btrfs_recover_relocation() invokes btrfs_join_transaction(), which joins
a btrfs_trans_handle object into transactions and returns a reference of
it with increased refcount to "trans".

When btrfs_recover_relocation() returns, "trans" becomes invalid, so the
refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one exception handling path of
btrfs_recover_relocation(). When read_fs_root() failed, the refcnt
increased by btrfs_join_transaction() is not decreased, causing a refcnt
leak.

Fix this issue by calling btrfs_end_transaction() on this error path
when read_fs_root() failed.

Fixes: 79787eaab461 ("btrfs: replace many BUG_ONs with proper error handling")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index d35936c934ab..03bc7134e8cb 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4559,6 +4559,7 @@ int btrfs_recover_relocation(struct btrfs_root *root)
 		if (IS_ERR(fs_root)) {
 			err = PTR_ERR(fs_root);
 			list_add_tail(&reloc_root->root_list, &reloc_roots);
+			btrfs_end_transaction(trans);
 			goto out_unset;
 		}
 

