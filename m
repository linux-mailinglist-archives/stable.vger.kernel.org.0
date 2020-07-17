Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A979E22417E
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 19:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgGQRIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 13:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727034AbgGQRIu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 13:08:50 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03B6520737;
        Fri, 17 Jul 2020 17:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595005729;
        bh=GEziDP5HiD3f/2kmMiC8OrJXv3eCmwGtVsBzNMZsU+w=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=NXBxutFpzKrVf8bCMLUQk6hFTMpS/czW4yt9hBFG+YW/5rfP35PJ7IwthcE9E7Wf0
         oRHkRxnWcBylkMYtjfeRCosbMD2CVVeznl2ebdA3UHekyZNrlYF38SHC01C6ZZ+YdA
         OpJzyM1OxkFai3BlESeZSDJYeFYBb4cZt4mE5QYk=
Date:   Fri, 17 Jul 2020 17:08:48 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: add missing check for nocow and compression inode flags
In-Reply-To: <20200713103349.22448-1-dsterba@suse.com>
References: <20200713103349.22448-1-dsterba@suse.com>
Message-Id: <20200717170849.03B6520737@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Build OK!
v4.19.132: Failed to apply! Possible dependencies:
    04e6863b19c72 ("btrfs: split btrfs_setxattr calls regarding transaction")
    262c96a3c3670 ("btrfs: refactor btrfs_set_prop and add btrfs_set_prop_trans")
    7715da84f74d5 ("btrfs: merge _btrfs_set_prop helpers")
    8b4d1efc9e6c3 ("btrfs: prop: open code btrfs_set_prop in inherit_prop")
    cac237ae095f6 ("btrfs: rename btrfs_setxattr to btrfs_setxattr_trans")
    d2b8fcfe43155 ("btrfs: modify local copy of btrfs_inode flags")
    f22125e5d8ae1 ("btrfs: refactor btrfs_set_props to validate externally")
    ff9fef559babe ("btrfs: start transaction in btrfs_ioctl_setflags()")

v4.14.188: Failed to apply! Possible dependencies:
    04e6863b19c72 ("btrfs: split btrfs_setxattr calls regarding transaction")
    1905a0f7c7de3 ("btrfs: rename btrfs_mask_flags to reflect which flags it touches")
    262c96a3c3670 ("btrfs: refactor btrfs_set_prop and add btrfs_set_prop_trans")
    38e82de8ccd18 ("btrfs: user proper type for btrfs_mask_flags flags")
    5ba76abfb2336 ("btrfs: rename check_flags to reflect which flags it touches")
    5c57b8b6a4966 ("btrfs: unify naming of flags variables for SETFLAGS and XFLAGS")
    7715da84f74d5 ("btrfs: merge _btrfs_set_prop helpers")
    7852781d94b30 ("btrfs: drop underscores from exported xattr functions")
    7b6a221e5b21f ("btrfs: rename btrfs_update_iflags to reflect which flags it touches")
    8b4d1efc9e6c3 ("btrfs: prop: open code btrfs_set_prop in inherit_prop")
    93370509c24cc ("btrfs: SETFLAGS ioctl: use helper for compression type conversion")
    a157d4fd81dc7 ("btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches")
    ab0d09361662b ("btrfs: drop extern from function declarations")
    cac237ae095f6 ("btrfs: rename btrfs_setxattr to btrfs_setxattr_trans")
    d2b8fcfe43155 ("btrfs: modify local copy of btrfs_inode flags")
    f22125e5d8ae1 ("btrfs: refactor btrfs_set_props to validate externally")
    ff9fef559babe ("btrfs: start transaction in btrfs_ioctl_setflags()")

v4.9.230: Failed to apply! Possible dependencies:
    0b246afa62b0c ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    1905a0f7c7de3 ("btrfs: rename btrfs_mask_flags to reflect which flags it touches")
    38e82de8ccd18 ("btrfs: user proper type for btrfs_mask_flags flags")
    5ba76abfb2336 ("btrfs: rename check_flags to reflect which flags it touches")
    5c57b8b6a4966 ("btrfs: unify naming of flags variables for SETFLAGS and XFLAGS")
    62d1f9fe97dd2 ("btrfs: remove trivial helper btrfs_find_tree_block")
    a157d4fd81dc7 ("btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches")
    cf8cddd38bab3 ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    da17066c40472 ("btrfs: pull node/sector/stripe sizes out of root and into fs_info")
    de143792253e2 ("btrfs: struct btrfsic_state->root should be an fs_info")
    fb456252d3d9c ("btrfs: root->fs_info cleanup, use fs_info->dev_root everywhere")
    ff9fef559babe ("btrfs: start transaction in btrfs_ioctl_setflags()")

v4.4.230: Failed to apply! Possible dependencies:
    0132761017e01 ("btrfs: fix string and comment grammatical issues and typos")
    09cbfeaf1a5a6 ("mm, fs: get rid of PAGE_CACHE_* and page_cache_{get,release} macros")
    0b246afa62b0c ("btrfs: root->fs_info cleanup, add fs_info convenience variables")
    0e749e54244ee ("dax: increase granularity of dax_clear_blocks() operations")
    1905a0f7c7de3 ("btrfs: rename btrfs_mask_flags to reflect which flags it touches")
    38e82de8ccd18 ("btrfs: user proper type for btrfs_mask_flags flags")
    4420cfd3f51cf ("staging: lustre: format properly all comment blocks for LNet core")
    52db400fcd502 ("pmem, dax: clean up clear_pmem()")
    5ba76abfb2336 ("btrfs: rename check_flags to reflect which flags it touches")
    5c57b8b6a4966 ("btrfs: unify naming of flags variables for SETFLAGS and XFLAGS")
    5fd88337d209d ("staging: lustre: fix all conditional comparison to zero in LNet layer")
    a157d4fd81dc7 ("btrfs: rename btrfs_flags_to_ioctl to reflect which flags it touches")
    b2e0d1625e193 ("dax: fix lifetime of in-kernel dax mappings with dax_map_atomic()")
    bb7ab3b92e46d ("btrfs: Fix misspellings in comments.")
    cf8cddd38bab3 ("btrfs: don't abuse REQ_OP_* flags for btrfs_map_block")
    d1a5f2b4d8a12 ("block: use DAX for partition table reads")
    de143792253e2 ("btrfs: struct btrfsic_state->root should be an fs_info")
    e10624f8c0971 ("pmem: fail io-requests to known bad blocks")
    ff9fef559babe ("btrfs: start transaction in btrfs_ioctl_setflags()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
