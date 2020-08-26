Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3072530B3
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730397AbgHZNzN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:55:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730383AbgHZNxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:53:55 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A3B022B43;
        Wed, 26 Aug 2020 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450034;
        bh=LBQCui/CC2CnVxkz3uprAHZKHFvXAyeXS2ZI6SOp2LI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=xzhr/5c5S2ZFveFO82S+ikbBleBK+nWoJ/lab7JAroLK0z4r5/CABKpeX0BPw/3X3
         E9uL2c1iKyUjIPOpqnorjze22j9wzmqdNc6I3x1kNvVE2Rm6Pzm4ms0MOaHyGwLMoD
         Vkl+grhf1tDPyesWZqtZc+75OmT8YN2fzXdB0PuE=
Date:   Wed, 26 Aug 2020 13:53:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>
Cc:     David Jeffery <djeffery@redhat.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH RESEND] blk-mq: order adding requests to hctx->dispatch and checking SCHED_RESTART
In-Reply-To: <20200817100115.2495988-1-ming.lei@redhat.com>
References: <20200817100115.2495988-1-ming.lei@redhat.com>
Message-Id: <20200826135354.3A3B022B43@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140, v4.14.193, v4.9.232, v4.4.232.

v5.8.2: Build OK!
v5.7.16: Build OK!
v5.4.59: Build OK!
v4.19.140: Build OK!
v4.14.193: Failed to apply! Possible dependencies:
    1f460b63d4b3 ("blk-mq: don't restart queue when .get_budget returns BLK_STS_RESOURCE")
    358a3a6bccb7 ("blk-mq: don't handle TAG_SHARED in restart")
    97889f9ac24f ("blk-mq: remove synchronize_rcu() from blk_mq_del_queue_tag_set()")
    b347689ffbca ("blk-mq-sched: improve dispatching from sw queue")
    caf8eb0d604a ("blk-mq-sched: move actual dispatching into one helper")
    de1482974080 ("blk-mq: introduce .get_budget and .put_budget in blk_mq_ops")

v4.9.232: Failed to apply! Possible dependencies:
    8e8320c9315c ("blk-mq: fix performance regression with shared tags")
    97889f9ac24f ("blk-mq: remove synchronize_rcu() from blk_mq_del_queue_tag_set()")
    bd166ef183c2 ("blk-mq-sched: add framework for MQ capable IO schedulers")
    cf43e6be865a ("block: add scalable completion tracking of requests")
    e806402130c9 ("block: split out request-only flags into a new namespace")
    f1ba82616c33 ("blk-mq: pass bio to blk_mq_sched_get_rq_priv")

v4.4.232: Failed to apply! Possible dependencies:
    511cbce2ff8b ("irq_poll: make blk-iopoll available outside the block layer")
    6f3b0e8bcf3c ("blk-mq: add a flags parameter to blk_mq_alloc_request")
    88459642cba4 ("blk-mq: abstract tag allocation out into sbitmap library")
    8e8320c9315c ("blk-mq: fix performance regression with shared tags")
    9467f85960a3 ("blk-mq/cpu-notif: Convert to new hotplug state machine")
    97889f9ac24f ("blk-mq: remove synchronize_rcu() from blk_mq_del_queue_tag_set()")
    9e0e252a048b ("badblocks: Add core badblock management code")
    bd166ef183c2 ("blk-mq-sched: add framework for MQ capable IO schedulers")
    cf43e6be865a ("block: add scalable completion tracking of requests")
    e57690fe009b ("blk-mq: don't overwrite rq->mq_ctx")
    f1ba82616c33 ("blk-mq: pass bio to blk_mq_sched_get_rq_priv")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
