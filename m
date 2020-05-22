Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21881DDBDB
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730548AbgEVAMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730105AbgEVAMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:12:25 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33362206BE;
        Fri, 22 May 2020 00:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106344;
        bh=2tf/mswqhMMElFcAmWBF6JiRDa4bM2vbEH9H/YaNKKY=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=IybsHagqfoPCfh6TiUuSViecnh1+bnXQOAKI0mQZHh5yLQdt1RXMqkYUheLN5YXzQ
         g7iX8NCBt9Z1vVOCrHeRmTDYSCyXeYVj7gDDGf65zWhXDiD8lcaS6d3haNStptjUqI
         bBcpSgYRO0UM/o0N14mnjDuqK3jbgDA3MIMkoGiY=
Date:   Fri, 22 May 2020 00:12:23 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/4] Btrfs: fix corrupt log due to concurrent fsync of inodes with shared extents
In-Reply-To: <20200518111450.30771-1-fdmanana@kernel.org>
References: <20200518111450.30771-1-fdmanana@kernel.org>
Message-Id: <20200522001224.33362206BE@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Failed to apply! Possible dependencies:
    0024652895e3 ("btrfs: rename btrfs_put_fs_root and btrfs_grab_fs_root")
    02162a0265eb ("btrfs: hold a ref on the root in __btrfs_run_defrag_inode")
    04734e844894 ("btrfs: hold a ref on the root in btrfs_ioctl_get_subvol_info")
    0b530bc5e11f ("btrfs: hold a ref on the root in build_backref_tree")
    0d4b0463011d ("btrfs: export and rename free_fs_info")
    2a2b5d620266 ("btrfs: hold ref on root in btrfs_ioctl_default_subvol")
    3ca35e839e94 ("btrfs: hold a ref on the root in search_ioctl")
    3d7babdcf2cc ("btrfs: hold a ref on the root in find_data_references")
    41a2ee75aab0 ("btrfs: introduce per-inode file extent tree")
    442b1ac5244e ("btrfs: hold a ref on the root in record_reloc_root_in_trans")
    4c78e9f59632 ("btrfs: hold a ref on the root in open_ctree")
    76deacf02387 ("btrfs: hold a ref on the root in create_reloc_inode")
    81f096edf047 ("btrfs: use btrfs_put_fs_root to free roots always")
    8727002f7909 ("btrfs: hold a ref on the root in fixup_tree_root_location")
    88234012beaa ("btrfs: hold a ref on the root in btrfs_search_path_in_tree")
    9326f76f4bc4 ("btrfs: hold a ref on the root in resolve_indirect_ref")
    9f583209f20a ("btrfs: push grab_fs_root into read_fs_root")
    ab9737bd7597 ("btrfs: hold a ref on the root in merge_reloc_roots")
    b8a49ae1913f ("btrfs: hold a ref on the root in btrfs_search_path_in_tree_user")
    bc44d7c4b2b1 ("btrfs: push btrfs_grab_fs_root into btrfs_get_fs_root")
    bdf70b9e75f5 ("btrfs: hold a root ref in btrfs_get_dentry")
    db2c2ca2db44 ("btrfs: hold a ref on the root in prepare_to_merge")
    fc92f79856aa ("btrfs: hold a ref on the root in create_subvol")

v5.4.41: Failed to apply! Possible dependencies:
    0024652895e3 ("btrfs: rename btrfs_put_fs_root and btrfs_grab_fs_root")
    0d4b0463011d ("btrfs: export and rename free_fs_info")
    33ca832fefa5 ("btrfs: separate out the extent leak code")
    41a2ee75aab0 ("btrfs: introduce per-inode file extent tree")
    6f0d04f8e72e ("btrfs: separate out the extent io init function")
    81f096edf047 ("btrfs: use btrfs_put_fs_root to free roots always")
    9326f76f4bc4 ("btrfs: hold a ref on the root in resolve_indirect_ref")
    9c7d3a548331 ("btrfs: move extent_io_tree defs to their own header")

v4.19.123: Failed to apply! Possible dependencies:
    370a11b8114b ("btrfs: qgroup: Introduce per-root swapped blocks infrastructure")
    43eb5f297584 ("btrfs: Introduce extent_io_tree::owner to distinguish different io_trees")
    57ec5fb478a3 ("btrfs: tests: move testing members of struct btrfs_root to the end")
    7b4397386fbd ("btrfs: switch extent_io_tree::track_uptodate to bool")
    c258d6e36442 ("btrfs: Introduce fs_info to extent_io_tree")
    e06a1fc99cc7 ("btrfs: Remove extent_io_ops::set_bit_hook extent_io callback")
    eede2bf34f4f ("Btrfs: prevent ioctls from interfering with a swap file")

v4.14.180: Failed to apply! Possible dependencies:
    370a11b8114b ("btrfs: qgroup: Introduce per-root swapped blocks infrastructure")
    429d6275d501 ("btrfs: qgroup: Fix wrong qgroup reservation update for relationship modification")
    57ec5fb478a3 ("btrfs: tests: move testing members of struct btrfs_root to the end")
    64cfaef6362f ("btrfs: qgroup: Introduce function to convert META_PREALLOC into META_PERTRANS")
    64ee4e751a1c ("btrfs: qgroup: Update trace events to use new separate rsv types")
    733e03a0b26a ("btrfs: qgroup: Split meta rsv type into meta_prealloc and meta_pertrans")
    8287475a2055 ("btrfs: qgroup: Use root::qgroup_meta_rsv_* to record qgroup meta reserved space")
    d4e5c92055d8 ("btrfs: qgroup: Skeleton to support separate qgroup reservation type")
    dba213242fbc ("btrfs: qgroup: Make qgroup_reserve and its callers to use separate reservation type")
    e1211d0e896b ("btrfs: qgroup: Don't use root->qgroup_meta_rsv for qgroup")
    eede2bf34f4f ("Btrfs: prevent ioctls from interfering with a swap file")
    f59c0347d4be ("btrfs: qgroup: Introduce helpers to update and access new qgroup rsv")
    fd708b81d972 ("Btrfs: add a extent ref verify tool")

v4.9.223: Failed to apply! Possible dependencies:
    0c476a5d7f63 ("btrfs: Ensure proper sector alignment for btrfs_free_reserved_data_space")
    370a11b8114b ("btrfs: qgroup: Introduce per-root swapped blocks infrastructure")
    4989d277eb4b ("btrfs: refactor __btrfs_lookup_bio_sums to use bio_for_each_segment_all")
    62d1f9fe97dd ("btrfs: remove trivial helper btrfs_find_tree_block")
    da17066c4047 ("btrfs: pull node/sector/stripe sizes out of root and into fs_info")
    eede2bf34f4f ("Btrfs: prevent ioctls from interfering with a swap file")
    fd708b81d972 ("Btrfs: add a extent ref verify tool")

v4.4.223: Failed to apply! Possible dependencies:
    2f3165ecf103 ("btrfs: don't force mounts to wait for cleaner_kthread to delete one or more subvolumes")
    370a11b8114b ("btrfs: qgroup: Introduce per-root swapped blocks infrastructure")
    511711af91f2 ("btrfs: don't run delayed references while we are creating the free space tree")
    70f6d82ec73c ("Btrfs: add free space tree mount option")
    87241c2e6845 ("Btrfs: use root when checking need_async_flush")
    90c711ab380d ("btrfs: avoid blocking open_ctree from cleaner_kthread")
    9e7cc91a6d18 ("btrfs: fix fsfreeze hang caused by delayed iputs deal")
    a5ed91828518 ("Btrfs: implement the free space B-tree")
    afcdd129e05a ("Btrfs: add a flags field to btrfs_fs_info")
    d38b349c39a9 ("Btrfs: don't bother kicking async if there's nothing to reclaim")
    eede2bf34f4f ("Btrfs: prevent ioctls from interfering with a swap file")
    f376df2b7da3 ("Btrfs: add tracepoints for flush events")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
