Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BF6B0983
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 09:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbfILHas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 03:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfILHar (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 03:30:47 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47C2020830;
        Thu, 12 Sep 2019 07:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568273446;
        bh=SLb56/wc9e67mCk6uQXq9HjK5V8W2cfzFl+bufVz/70=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=HkGtsiDW35cDE7cHEZ0C9Em1262DZbCbUiJmTluku/XAzWf6I9X4L/47hzKWnbgy3
         86aCdAyt9naKCGv64xZhCAvC6nPpcHJwkgXdbWhS+PxOGHGFoLxAbYJWR/m6RWdOOu
         5eVz3E7vhng0/KD36zPtpvBI01nQYLNyLBYza5tQ=
Date:   Thu, 12 Sep 2019 07:30:45 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix assertion failure during fsync and use of stale transaction
In-Reply-To: <20190910142649.19808-1-fdmanana@kernel.org>
References: <20190910142649.19808-1-fdmanana@kernel.org>
Message-Id: <20190912073046.47C2020830@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143, v4.9.192, v4.4.192.

v5.2.14: Build OK!
v4.19.72: Failed to apply! Possible dependencies:
    6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
    a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
    b8aa330d2acb ("Btrfs: improve performance on fsync of files with multiple hardlinks")

v4.14.143: Failed to apply! Possible dependencies:
    0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link recreation")
    1f250e929a9c ("Btrfs: fix log replay failure after unlink and link combination")
    6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
    8d9e220ca084 ("btrfs: simplify IS_ERR/PTR_ERR checks")
    a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
    b8aa330d2acb ("Btrfs: improve performance on fsync of files with multiple hardlinks")

v4.9.192: Failed to apply! Possible dependencies:
    0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link recreation")
    1f250e929a9c ("Btrfs: fix log replay failure after unlink and link combination")
    4791c8f19c45 ("btrfs: Make btrfs_check_ref_name_override take btrfs_inode")
    6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
    a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
    cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    da17066c4047 ("btrfs: pull node/sector/stripe sizes out of root and into fs_info")
    db0a669fb002 ("btrfs: Make btrfs_add_link take btrfs_inode")
    de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")
    fb456252d3d9 ("btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere")

v4.4.192: Failed to apply! Possible dependencies:
    0132761017e0 ("btrfs: fix string and comment grammatical issues and typos")
    09cbfeaf1a5a ("mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release} macros")
    0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    0d836392cadd ("Btrfs: fix mount failure after fsync due to hard link recreation")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    1f250e929a9c ("Btrfs: fix log replay failure after unlink and link combination")
    44f714dae50a ("Btrfs: improve performance on fsync against new inode after rename/unlink")
    4791c8f19c45 ("btrfs: Make btrfs_check_ref_name_override take btrfs_inode")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    6b5fc433a7ad ("Btrfs: fix fsync after succession of renames of different files")
    781feef7e6be ("Btrfs: fix lockdep warning about log_mutex")
    a3baaf0d786e ("Btrfs: fix fsync after succession of renames and unlink/rmdir")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    bb7ab3b92e46 ("btrfs: Fix misspellings in comments.")
    cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    d1a5f2b4d8a1 ("block: use DAX for partition table reads")
    db0a669fb002 ("btrfs: Make btrfs_add_link take btrfs_inode")
    de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
