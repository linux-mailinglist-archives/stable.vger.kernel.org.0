Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB951CC14C
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728420AbgEIMav (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 08:30:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:60064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726782AbgEIMau (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 08:30:50 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22BE1218AC;
        Sat,  9 May 2020 12:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589027449;
        bh=sgeZRy05/q3hE24fl+OkO7CEGk/FtbbZGKZdpNs//QI=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=N9sX+SbZu7UD4T+lGiawgKe4O3AyMAiZbb5YCjDdqaMviZfwoPmqUk9EL0fGpSPun
         qM3AdHFO9gEB2Dnxdcb2Q1FrmsRXmZI4UCUU+6x2C2XfQJk8/IRZp47BggGMsRl5Cz
         LvkD7ZMVwhGQU2QXXuTGVKnhEamZTe4WAygeuSmY=
Date:   Sat, 09 May 2020 12:30:48 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: fix a race between scrub and block group removal/allocation
In-Reply-To: <20200508100110.6965-1-fdmanana@kernel.org>
References: <20200508100110.6965-1-fdmanana@kernel.org>
Message-Id: <20200509123049.22BE1218AC@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222, v4.4.222.

v5.6.11: Build OK!
v5.4.39: Build failed! Errors:
    fs/btrfs/scrub.c:3291:20: error: dereferencing pointer to incomplete type ‘struct btrfs_block_group’
    fs/btrfs/scrub.c:3472:31: error: passing argument 7 of ‘scrub_stripe’ from incompatible pointer type [-Werror=incompatible-pointer-types]

v4.19.121: Build failed! Errors:
    fs/btrfs/scrub.c:3289:20: error: dereferencing pointer to incomplete type ‘struct btrfs_block_group’
    fs/btrfs/scrub.c:3470:31: error: passing argument 7 of ‘scrub_stripe’ from incompatible pointer type [-Werror=incompatible-pointer-types]

v4.14.179: Failed to apply! Possible dependencies:
    32934280967d ("Btrfs: clean up scrub is_dev_replace parameter")
    c83488afc5a7 ("btrfs: Remove fs_info from btrfs_inc_block_group_ro")

v4.9.222: Failed to apply! Possible dependencies:
    0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    32934280967d ("Btrfs: clean up scrub is_dev_replace parameter")
    5e00f1939f6e ("btrfs: convert btrfs_inc_block_group_ro to accept fs_info")
    62d1f9fe97dd ("btrfs: remove trivial helper btrfs_find_tree_block")
    c83488afc5a7 ("btrfs: Remove fs_info from btrfs_inc_block_group_ro")
    cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    da17066c4047 ("btrfs: pull node/sector/stripe sizes out of root and into fs_info")
    de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")
    fb456252d3d9 ("btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere")

v4.4.222: Failed to apply! Possible dependencies:
    0132761017e0 ("btrfs: fix string and comment grammatical issues and typos")
    09cbfeaf1a5a ("mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release} macros")
    0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    32934280967d ("Btrfs: clean up scrub is_dev_replace parameter")
    4420cfd3f51c ("staging: lustre: format properly all comment blocks for LNet core")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    5e00f1939f6e ("btrfs: convert btrfs_inc_block_group_ro to accept fs_info")
    5fd88337d209 ("staging: lustre: fix all conditional comparison to zero in LNet layer")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    bb7ab3b92e46 ("btrfs: Fix misspellings in comments.")
    c83488afc5a7 ("btrfs: Remove fs_info from btrfs_inc_block_group_ro")
    cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    d1a5f2b4d8a1 ("block: use DAX for partition table reads")
    de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")
    e10624f8c097 ("pmem: fail io-requests to known bad blocks")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
