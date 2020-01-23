Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C770146AA0
	for <lists+stable@lfdr.de>; Thu, 23 Jan 2020 15:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgAWOC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jan 2020 09:02:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:44708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgAWOC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Jan 2020 09:02:57 -0500
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D28720684;
        Thu, 23 Jan 2020 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579788176;
        bh=YNhkXbKH0ZBYm+0YcRN+cs+ftBfjelU5JmfSAxQOMkc=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=LaKAXgRXJpz4VylzxTWEQbXAHaHEINEWQNEfIIcCMte9Ui24gK8mEQkf751RlACEq
         P/iTpjRd3RQRCCCJdLLNFiX6HKDfkez1uo9McZZWV6sW9LI/TvpivJl1B8d78YpCbM
         v7o/NXNnudT5V9JURe7ycB66ECQ4I/tNjA45Vg4E=
Date:   Thu, 23 Jan 2020 14:02:55 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix race between adding and putting tree mod seq elements and nodes
In-Reply-To: <20200122122320.30073-1-fdmanana@kernel.org>
References: <20200122122320.30073-1-fdmanana@kernel.org>
Message-Id: <20200123140256.6D28720684@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: bd989ba359f2 ("Btrfs: add tree modification log functions").

The bot has tested the following trees: v5.4.13, v4.19.97, v4.14.166, v4.9.210, v4.4.210.

v5.4.13: Build OK!
v4.19.97: Build OK!
v4.14.166: Failed to apply! Possible dependencies:
    3ac6de1abd7a ("btrfs: drop fs_info parameter from tree_mod_log_set_node_key")
    6074d45f6076 ("btrfs: drop fs_info parameter from tree_mod_log_insert_move")
    b1a09f1ec540 ("btrfs: remove trivial locking wrappers of tree mod log")
    db7279a20b09 ("btrfs: drop fs_info parameter from tree_mod_log_free_eb")
    e09c2efe7eba ("btrfs: drop fs_info parameter from tree_mod_log_insert_key")

v4.9.210: Failed to apply! Possible dependencies:
    0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    3ac6de1abd7a ("btrfs: drop fs_info parameter from tree_mod_log_set_node_key")
    62d1f9fe97dd ("btrfs: remove trivial helper btrfs_find_tree_block")
    b1a09f1ec540 ("btrfs: remove trivial locking wrappers of tree mod log")
    cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    da17066c4047 ("btrfs: pull node/sector/stripe sizes out of root and into fs_info")
    de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")
    e09c2efe7eba ("btrfs: drop fs_info parameter from tree_mod_log_insert_key")
    fb456252d3d9 ("btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere")

v4.4.210: Failed to apply! Possible dependencies:
    0132761017e0 ("btrfs: fix string and comment grammatical issues and typos")
    09cbfeaf1a5a ("mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release} macros")
    0b246afa62b0 ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    0e749e54244e ("dax: increase granularity of dax_clear_blocks() operations")
    3ac6de1abd7a ("btrfs: drop fs_info parameter from tree_mod_log_set_node_key")
    4420cfd3f51c ("staging: lustre: format properly all comment blocks for LNet core")
    52db400fcd50 ("pmem, dax: clean up clear_pmem()")
    5fd88337d209 ("staging: lustre: fix all conditional comparison to zero in LNet layer")
    b1a09f1ec540 ("btrfs: remove trivial locking wrappers of tree mod log")
    b2e0d1625e19 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    bb7ab3b92e46 ("btrfs: Fix misspellings in comments.")
    cf8cddd38bab ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    d1a5f2b4d8a1 ("block: use DAX for partition table reads")
    de143792253e ("btrfs: struct btrfsic_state->root should be an fs_info")
    e09c2efe7eba ("btrfs: drop fs_info parameter from tree_mod_log_insert_key")
    e10624f8c097 ("pmem: fail io-requests to known bad blocks")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
