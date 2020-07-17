Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C75224174
	for <lists+stable@lfdr.de>; Fri, 17 Jul 2020 19:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbgGQRIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jul 2020 13:08:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgGQRIo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Jul 2020 13:08:44 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDC5020717;
        Fri, 17 Jul 2020 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595005724;
        bh=iszOuuRFn0grWAUjNr1O+f5aLxO1F5cAvHJyL0IRrX0=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=j65yTO6VC/N6CizIUMdmLQpOElnJz20fK3fWfiRPCFgb1FqgutmAO1OtBPYmG2ZEi
         rfkduxC+dAFVdh1VKwY7kixJROlVO42pRrrg+vOVNz5RPqTwuoww2Iw4LP3YqJfDD+
         GqDoW1SZgWUBu3GL8q8xbVskkLux+osyzcqvjmCk=
Date:   Fri, 17 Jul 2020 17:08:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Coly Li <colyli@suse.de>
To:     linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] bcche: fix overflow in offset_to_stripe()
In-Reply-To: <20200713111501.19061-2-colyli@suse.de>
References: <20200713111501.19061-2-colyli@suse.de>
Message-Id: <20200717170843.CDC5020717@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.8, v5.4.51, v4.19.132, v4.14.188, v4.9.230, v4.4.230.

v5.7.8: Build OK!
v5.4.51: Build OK!
v4.19.132: Build OK!
v4.14.188: Failed to apply! Possible dependencies:
    1d316e658374f ("bcache: implement PI controller for writeback rate")
    25d8be77e1922 ("block: move bio_alloc_pages() to bcache")
    27a40ab9269e7 ("bcache: add backing_request_endio() for bi_end_io")
    2831231d4c3f9 ("bcache: reduce cache_set devices iteration by devices_max_used")
    3b304d24a718a ("bcache: convert cached_dev.count from atomic_t to refcount_t")
    3fd47bfe55b00 ("bcache: stop dc->writeback_rate_update properly")
    5138ac6748e38 ("bcache: fix misleading error message in bch_count_io_errors()")
    539d39eb27083 ("bcache: fix wrong return value in bch_debug_init()")
    5fa89fb9a86bc ("bcache: don't write back data if reading it failed")
    6f10f7d1b02b1 ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
    771f393e8ffc9 ("bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags")
    7ba0d830dc0e4 ("bcache: set error_limit correctly")
    7e027ca4b534b ("bcache: add stop_when_cache_set_failed option to backing device")
    804f3c6981f5e ("bcache: fix cached_dev->count usage for bch_cache_set_error()")
    a8500fc816b19 ("bcache: rearrange writeback main thread ratelimit")
    b1092c9af9ed8 ("bcache: allow quick writeback when backing idle")
    bc082a55d25c8 ("bcache: fix inaccurate io state for detached bcache devices")
    c7b7bd07404c5 ("bcache: add io_disable to struct cached_dev")

v4.9.230: Failed to apply! Possible dependencies:
    1d316e658374f ("bcache: implement PI controller for writeback rate")
    2831231d4c3f9 ("bcache: reduce cache_set devices iteration by devices_max_used")
    297e3d8547848 ("blk-throttle: make throtl_slice tunable")
    3fd47bfe55b00 ("bcache: stop dc->writeback_rate_update properly")
    4e4cbee93d561 ("block: switch bios to blk_status_t")
    5138ac6748e38 ("bcache: fix misleading error message in bch_count_io_errors()")
    6f10f7d1b02b1 ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
    7e027ca4b534b ("bcache: add stop_when_cache_set_failed option to backing device")
    87760e5eef359 ("block: hook up writeback throttling")
    9e234eeafbe17 ("blk-throttle: add a simple idle detection")
    c7b7bd07404c5 ("bcache: add io_disable to struct cached_dev")
    cf43e6be865a5 ("block: add scalable completion tracking of requests")
    e806402130c9c ("block: split out request-only flags into a new namespace")
    fbbaf700e7b16 ("block: trace completion of all bios.")

v4.4.230: Failed to apply! Possible dependencies:
    005411ea7ee77 ("doc: update block/queue-sysfs.txt entries")
    1d316e658374f ("bcache: implement PI controller for writeback rate")
    2831231d4c3f9 ("bcache: reduce cache_set devices iteration by devices_max_used")
    297e3d8547848 ("blk-throttle: make throtl_slice tunable")
    38f8baae89056 ("block: factor out chained bio completion")
    3fd47bfe55b00 ("bcache: stop dc->writeback_rate_update properly")
    4e4cbee93d561 ("block: switch bios to blk_status_t")
    511cbce2ff8b9 ("irq_poll: make blk-iopoll available outside the block layer")
    5138ac6748e38 ("bcache: fix misleading error message in bch_count_io_errors()")
    6f10f7d1b02b1 ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
    7e027ca4b534b ("bcache: add stop_when_cache_set_failed option to backing device")
    87760e5eef359 ("block: hook up writeback throttling")
    9467f85960a31 ("blk-mq/cpu-notif: Convert to new hotplug state machine")
    9e234eeafbe17 ("blk-throttle: add a simple idle detection")
    af3e3a5259e35 ("block: don't unecessarily clobber bi_error for chained bios")
    ba8c6967b7391 ("block: cleanup bio_endio")
    c7b7bd07404c5 ("bcache: add io_disable to struct cached_dev")
    cf43e6be865a5 ("block: add scalable completion tracking of requests")
    e57690fe009b2 ("blk-mq: don't overwrite rq->mq_ctx")
    fbbaf700e7b16 ("block: trace completion of all bios.")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
