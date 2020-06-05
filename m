Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B531EFA08
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgFEOKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgFEOKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:48 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94F002074B;
        Fri,  5 Jun 2020 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366247;
        bh=vYMgI5buYDVEDQEYr6QzeCZe8cquGkAR+my8IpFuReA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=QXgkXhL629xYnkIW7f5UOXuUDdYBeNLBc5IaMyTNORFCkA4tNDTkbBIsZFRT4+Ylc
         rUK0cjRo6pfEbxOpiJK5b8IufuEpwaDsf7KFTWreqQHgg+gh0jb832DQGEOkLIh48s
         ByTY0OzLGBQNKvXtE4eBQGJLB+FxlvZr+/c48SAs=
Date:   Fri, 05 Jun 2020 14:10:46 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 5/6] block: nr_sects_write(): Disable preemption on seqcount write
In-Reply-To: <20200603144949.1122421-6-a.darwish@linutronix.de>
References: <20200603144949.1122421-6-a.darwish@linutronix.de>
Message-Id: <20200605141047.94F002074B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c83f6bf98dc1 ("block: add partition resize function to blkpg ioctl").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Failed to apply! Possible dependencies:
    1a9fba3a77a5 ("block: unexport read_dev_sector and put_dev_sector")
    2b8bd423614c ("block/diskstats: more accurate approximation of io_ticks for slow disks")
    387048bf67ee ("block: merge partition-generic.c and check.c")
    3ad5cee5cd00 ("block: move sysfs methods shared by disks and partitions to genhd.c")
    581e26004a09 ("block: move block layer internals out of include/linux/genhd.h")
    74cc979c3c7f ("block: cleanup how md_autodetect_dev is called")
    f17c21c1ecb8 ("block: remove alloc_part_info and free_part_info")
    ffa9ed647aa4 ("block: remove warn_no_part")

v5.4.43: Failed to apply! Possible dependencies:
    387048bf67ee ("block: merge partition-generic.c and check.c")
    3ad5cee5cd00 ("block: move sysfs methods shared by disks and partitions to genhd.c")
    581e26004a09 ("block: move block layer internals out of include/linux/genhd.h")
    5eac3eb30c9a ("block: Remove partition support for zoned block devices")
    6c1b1da58f8c ("block: add zone open, close and finish operations")
    74cc979c3c7f ("block: cleanup how md_autodetect_dev is called")
    b68663186577 ("block: add iostat counters for flush requests")
    c7a1d926dc40 ("block: Simplify REQ_OP_ZONE_RESET_ALL handling")
    ceeb373aa6b9 ("block: Simplify report zones execution")
    f902b0260002 ("block: refactor rescan_partitions")

v4.19.125: Failed to apply! Possible dependencies:
    2268c0feb0ff ("blkcg: introduce common blkg association logic")
    27e6fa996c53 ("blkcg: fix ref count issue with bio_blkcg using task_css")
    43b729bfe9cf ("block: move integrity_req_gap_{back,front}_merge to blk.h")
    49f4c2dc2b50 ("blkcg: update blkg_lookup_create to do locking")
    581e26004a09 ("block: move block layer internals out of include/linux/genhd.h")
    5bf9a1f3b4ef ("blkcg: consolidate bio_issue_init to be a part of core")
    6f70fb66182b ("blkcg: remove bio_disassociate_task()")
    a7b39b4e961c ("blkcg: always associate a bio with a blkg")
    b5f2954d30c7 ("blkcg: revert blkcg cleanups series")
    bdc2491708c4 ("blkcg: associate writeback bios with a blkg")
    beea9da07d8a ("blkcg: convert blkg_lookup_create() to find closest blkg")
    c839e7a03f92 ("blkcg: remove bio->bi_css and instead use bio->bi_blkg")
    d459d853c2ed ("blkcg: reassociate bios when make_request() is called recursively")
    ece841abbed2 ("block: fix memleak of bio integrity data")

v4.14.182: Failed to apply! Possible dependencies:
    055f6e18e08f ("block: Make q_usage_counter also track legacy requests")
    1b6d65a0bfb5 ("block: Introduce BLK_MQ_REQ_PREEMPT")
    2268c0feb0ff ("blkcg: introduce common blkg association logic")
    359f642700f2 ("block: move bio_integrity_{intervals,bytes} into blkdev.h")
    37f9579f4c31 ("blk-mq: Avoid that submitting a bio concurrently with device removal triggers a crash")
    3a0a529971ec ("block, scsi: Make SCSI quiesce and resume work reliably")
    43b729bfe9cf ("block: move integrity_req_gap_{back,front}_merge to blk.h")
    581e26004a09 ("block: move block layer internals out of include/linux/genhd.h")
    6a15674d1e90 ("block: Introduce blk_get_request_flags()")
    6f70fb66182b ("blkcg: remove bio_disassociate_task()")
    9a95e4ef7095 ("block, nvme: Introduce blk_mq_req_flags_t")
    c9254f2ddb19 ("block: Add the QUEUE_FLAG_PREEMPT_ONLY request queue flag")
    d459d853c2ed ("blkcg: reassociate bios when make_request() is called recursively")
    ece841abbed2 ("block: fix memleak of bio integrity data")
    f421e1d9ade4 ("block: provide a direct_make_request helper")

v4.9.225: Failed to apply! Possible dependencies:
    297e3d854784 ("blk-throttle: make throtl_slice tunable")
    43b729bfe9cf ("block: move integrity_req_gap_{back,front}_merge to blk.h")
    4e4cbee93d56 ("block: switch bios to blk_status_t")
    581e26004a09 ("block: move block layer internals out of include/linux/genhd.h")
    7c20f11680a4 ("bio-integrity: stop abusing bi_end_io")
    87760e5eef35 ("block: hook up writeback throttling")
    9e234eeafbe1 ("blk-throttle: add a simple idle detection")
    cf43e6be865a ("block: add scalable completion tracking of requests")
    e806402130c9 ("block: split out request-only flags into a new namespace")
    fbbaf700e7b1 ("block: trace completion of all bios.")

v4.4.225: Failed to apply! Possible dependencies:
    005411ea7ee7 ("doc: update block/queue-sysfs.txt entries")
    27489a3c827b ("blk-mq: turn hctx->run_work into a regular work struct")
    297e3d854784 ("blk-throttle: make throtl_slice tunable")
    38f8baae8905 ("block: factor out chained bio completion")
    43b729bfe9cf ("block: move integrity_req_gap_{back,front}_merge to blk.h")
    4e4cbee93d56 ("block: switch bios to blk_status_t")
    511cbce2ff8b ("irq_poll: make blk-iopoll available outside the block layer")
    581e26004a09 ("block: move block layer internals out of include/linux/genhd.h")
    7c20f11680a4 ("bio-integrity: stop abusing bi_end_io")
    87760e5eef35 ("block: hook up writeback throttling")
    8d354f133e86 ("blk-mq: improve layout of blk_mq_hw_ctx")
    9467f85960a3 ("blk-mq/cpu-notif: Convert to new hotplug state machine")
    9e234eeafbe1 ("blk-throttle: add a simple idle detection")
    af3e3a5259e3 ("block: don't unecessarily clobber bi_error for chained bios")
    ba8c6967b739 ("block: cleanup bio_endio")
    cf43e6be865a ("block: add scalable completion tracking of requests")
    e57690fe009b ("blk-mq: don't overwrite rq->mq_ctx")
    e6a40b096e28 ("block: prepare request creation/destruction code to use REQ_OPs")
    e806402130c9 ("block: split out request-only flags into a new namespace")
    fbbaf700e7b1 ("block: trace completion of all bios.")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
