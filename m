Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4C22FB4F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgG0VYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbgG0VYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:44 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77B4620A8B;
        Mon, 27 Jul 2020 21:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885083;
        bh=Jkej5hTuT8wUPO2QxOTs/AV6JefaRokjUvxxqW5U/5s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=pwsvxqwmmRVhWRjQV8ZN8cTf6yvuN88nH6rBr2L2M0BpXetrMJG243s0usJz/OTdh
         LrCCd6NqsgfjPIEiwTg15mwUR5rnKy6bBPpMzd3OUaXGHKkmxzK6vOK7mojW5Mz31L
         HuOIeMIv7b89497XrzOSJqlv3u3M4Xq1IW7hDhM8=
Date:   Mon, 27 Jul 2020 21:24:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 07/25] bcache: avoid nr_stripes overflow in bcache_device_init()
In-Reply-To: <20200725120039.91071-8-colyli@suse.de>
References: <20200725120039.91071-8-colyli@suse.de>
Message-Id: <20200727212443.77B4620A8B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

v5.7.10: Failed to apply! Possible dependencies:
    46f5aa8806e3 ("bcache: Convert pr_<level> uses to a more typical style")

v5.4.53: Failed to apply! Possible dependencies:
    253a99d95d5b ("bcache: move macro btree() and btree_root() into btree.h")
    46f5aa8806e3 ("bcache: Convert pr_<level> uses to a more typical style")
    49d08d596e85 ("bcache: check return value of prio_read()")
    8e7102273f59 ("bcache: make bch_btree_check() to be multithreaded")
    aaf8dbeab586 ("bcache: add more accurate error messages in read_super()")
    b144e45fc576 ("bcache: make bch_sectors_dirty_init() to be multithreaded")
    feac1a70b806 ("bcache: add bcache_ prefix to btree_root() and btree() macros")

v4.19.134: Failed to apply! Possible dependencies:
    0b13efecf5f2 ("bcache: add return value check to bch_cached_dev_run()")
    253a99d95d5b ("bcache: move macro btree() and btree_root() into btree.h")
    2aa8c529387c ("bcache: avoid unnecessary btree nodes flushing in btree_flush_write()")
    46f5aa8806e3 ("bcache: Convert pr_<level> uses to a more typical style")
    49d08d596e85 ("bcache: check return value of prio_read()")
    4b6efb4bdbce ("bcache: more detailed error message to bcache_device_link()")
    4e361e020e72 ("bcache: update comment in sysfs.c")
    5d9e06d60eee ("bcache: fix possible memory leak in bch_cached_dev_run()")
    792732d9852c ("bcache: use kmemdup_nul for CACHED_LABEL buffer")
    88c12d42d2bb ("bcache: add error check for calling register_bdev()")
    89e0341af082 ("bcache: use sysfs_match_string() instead of __sysfs_match_string()")
    8e7102273f59 ("bcache: make bch_btree_check() to be multithreaded")
    91be66e1318f ("bcache: performance improvement for btree_flush_write()")
    aaf8dbeab586 ("bcache: add more accurate error messages in read_super()")
    cb07ad63682f ("bcache: introduce force_wake_up_gc()")
    e0faa3d7f79f ("bcache: improve error message in bch_cached_dev_run()")
    f54478c6e226 ("bcache: fix input integer overflow of congested threshold")
    feac1a70b806 ("bcache: add bcache_ prefix to btree_root() and btree() macros")

v4.14.189: Failed to apply! Possible dependencies:
    1d316e658374 ("bcache: implement PI controller for writeback rate")
    1dbe32ad0a82 ("bcache: rewrite multiple partitions support")
    25d8be77e192 ("block: move bio_alloc_pages() to bcache")
    27a40ab9269e ("bcache: add backing_request_endio() for bi_end_io")
    3b304d24a718 ("bcache: convert cached_dev.count from atomic_t to refcount_t")
    3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
    46f5aa8806e3 ("bcache: Convert pr_<level> uses to a more typical style")
    5138ac6748e3 ("bcache: fix misleading error message in bch_count_io_errors()")
    539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
    5f2b18ec8e16 ("bcache: Fix a compiler warning in bcache_device_init()")
    6ae63e3501c4 ("bcache: replace printk() by pr_*() routines")
    6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
    771f393e8ffc ("bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags")
    804f3c6981f5 ("bcache: fix cached_dev->count usage for bch_cache_set_error()")
    b1092c9af9ed ("bcache: allow quick writeback when backing idle")
    d19936a26658 ("bcache: convert to bioset_init()/mempool_init()")
    d44c2f9e7cc0 ("bcache: update bucket_in_use in real time")

v4.9.231: Failed to apply! Possible dependencies:
    011067b05668 ("blk: replace bioset_create_nobvec() with a flags arg to bioset_create()")
    10273170fd56 ("md: fail if mddev->bio_set can't be created")
    109e37653033 ("md: add block tracing for bio_remapping")
    1dbe32ad0a82 ("bcache: rewrite multiple partitions support")
    2e52d449bcec ("md/raid1: add failfast handling for reads.")
    3b046a97cbd3 ("md/raid1: Refactor raid1_make_request")
    47e0fb461fca ("blk: make the bioset rescue_workqueue optional.")
    578b54ade8a5 ("md/raid1, raid10: add blktrace records when IO is delayed")
    5e2c7a361197 ("md/raid1: abort delayed writes when device fails.")
    5f2b18ec8e16 ("bcache: Fix a compiler warning in bcache_device_init()")
    b8c0d911ac52 ("bcache: partition support: add 16 minors per bcacheN device")
    c230e7e53526 ("md/raid1: simplify the splitting of requests.")
    f2c771a65504 ("md/raid1: fix: IO can block resync indefinitely")
    fd76863e37fe ("RAID1: a new I/O barrier implementation to remove resync window")

v4.4.231: Failed to apply! Possible dependencies:
    011067b05668 ("blk: replace bioset_create_nobvec() with a flags arg to bioset_create()")
    0e5313e2d4ef ("raid10: improve random reads performance")
    10273170fd56 ("md: fail if mddev->bio_set can't be created")
    1dbe32ad0a82 ("bcache: rewrite multiple partitions support")
    2c97cf138527 ("md-cluser: make resync_finish only called after pers->sync_request")
    41a9a0dcf895 ("md-cluster: change resync lock from asynchronous to synchronous")
    47e0fb461fca ("blk: make the bioset rescue_workqueue optional.")
    578b54ade8a5 ("md/raid1, raid10: add blktrace records when IO is delayed")
    5f2b18ec8e16 ("bcache: Fix a compiler warning in bcache_device_init()")
    81baf90af2dc ("bcache: Remove deprecated create_workqueue")
    85ad1d13ee9b ("md: set MD_CHANGE_PENDING in a atomic region")
    b8c0d911ac52 ("bcache: partition support: add 16 minors per bcacheN device")
    c230e7e53526 ("md/raid1: simplify the splitting of requests.")
    fc974ee2bffd ("md: convert to use the generic badblocks code")
    fd76863e37fe ("RAID1: a new I/O barrier implementation to remove resync window")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
