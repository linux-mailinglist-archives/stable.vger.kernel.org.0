Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38AF322FB51
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgG0VYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726858AbgG0VYn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:43 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E679208E4;
        Mon, 27 Jul 2020 21:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885082;
        bh=EWps0S6EbZwduop5kOlhiWEEhgt7u1l+thckoIBrrrk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=chJ+hwVwNsw4fSBBc25hTMHJr3eKIznH9wucbcJl2hh1mO4DVVhRDH/11yvg4QV3R
         B2ymtF1X9O6bb92Y/wS+MX6+rKaBj8AMbrna9jidLsc2VAXEWUe4dn0TsdrnQazd1R
         RH2byExFuWd66UgD3cENm9AbgtxJ0XyAyxoxTbhM=
Date:   Mon, 27 Jul 2020 21:24:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 08/25] bcache: fix overflow in offset_to_stripe()
In-Reply-To: <20200725120039.91071-9-colyli@suse.de>
References: <20200725120039.91071-9-colyli@suse.de>
Message-Id: <20200727212442.8E679208E4@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231, v4.4.231.

v5.7.10: Build OK!
v5.4.53: Build OK!
v4.19.134: Build OK!
v4.14.189: Failed to apply! Possible dependencies:
    1d316e658374 ("bcache: implement PI controller for writeback rate")
    25d8be77e192 ("block: move bio_alloc_pages() to bcache")
    27a40ab9269e ("bcache: add backing_request_endio() for bi_end_io")
    3b304d24a718 ("bcache: convert cached_dev.count from atomic_t to refcount_t")
    3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
    5138ac6748e3 ("bcache: fix misleading error message in bch_count_io_errors()")
    539d39eb2708 ("bcache: fix wrong return value in bch_debug_init()")
    6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
    771f393e8ffc ("bcache: add CACHE_SET_IO_DISABLE to struct cache_set flags")
    804f3c6981f5 ("bcache: fix cached_dev->count usage for bch_cache_set_error()")
    b1092c9af9ed ("bcache: allow quick writeback when backing idle")
    d19936a26658 ("bcache: convert to bioset_init()/mempool_init()")
    d44c2f9e7cc0 ("bcache: update bucket_in_use in real time")

v4.9.231: Failed to apply! Possible dependencies:
    1d316e658374 ("bcache: implement PI controller for writeback rate")
    3a83f4677539 ("block: bio: pass bvec table to bio_init()")
    3b304d24a718 ("bcache: convert cached_dev.count from atomic_t to refcount_t")
    3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
    6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
    70fd76140a6c ("block,fs: use REQ_* flags directly")
    804f3c6981f5 ("bcache: fix cached_dev->count usage for bch_cache_set_error()")
    d19936a26658 ("bcache: convert to bioset_init()/mempool_init()")
    e806402130c9 ("block: split out request-only flags into a new namespace")
    ef295ecf090d ("block: better op and flags encoding")

v4.4.231: Failed to apply! Possible dependencies:
    1d316e658374 ("bcache: implement PI controller for writeback rate")
    3a83f4677539 ("block: bio: pass bvec table to bio_init()")
    3b304d24a718 ("bcache: convert cached_dev.count from atomic_t to refcount_t")
    3fd47bfe55b0 ("bcache: stop dc->writeback_rate_update properly")
    4e49ea4a3d27 ("block/fs/drivers: remove rw argument from submit_bio")
    6f10f7d1b02b ("bcache: style fix to replace 'unsigned' by 'unsigned int'")
    804f3c6981f5 ("bcache: fix cached_dev->count usage for bch_cache_set_error()")
    9082e87bfbf8 ("block: remove struct bio_batch")
    ad0d9e76a412 ("bcache: use bio op accessors")
    d19936a26658 ("bcache: convert to bioset_init()/mempool_init()")
    d57d611505d9 ("kernel/fs: fix I/O wait not accounted for RW O_DSYNC")
    ed996a52c868 ("block: simplify and cleanup bvec pool handling")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
