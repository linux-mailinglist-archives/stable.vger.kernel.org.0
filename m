Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10131C0C63
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgEACzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbgEACza (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:30 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D447A20836;
        Fri,  1 May 2020 02:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301730;
        bh=EJ8aoDFzKNv9sq3gvBCC3pOSDsXlq+pz29uU4+G/KDc=;
        h=Date:From:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=w9VHWVn4hFghdtPcOtle16pjfFBGQz0aNJJwJvLbBmnpCsGHZAfgojhCL023+mbUb
         7vBv2ATiGIktdujvXRzISI0B5NJ7lQMaJ1UZE4NI9+WQjeShlQR7j5/4Kkb9U5RmmG
         +Bvwn9mtOGXnA89aE/j3JiyJRne5ZQTe3XHEa4X4=
Date:   Fri, 01 May 2020 02:55:29 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Roman Penyaev <rpenyaev@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Khazhismel Kumykov <khazhy@google.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     Heiher <r@hev.cc>
Cc:     Jason Baron <jbaron@akamai.com>
Cc:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] epoll: atomically remove wait entry on wake up
In-Reply-To: <20200430130326.1368509-2-rpenyaev@suse.de>
References: <20200430130326.1368509-2-rpenyaev@suse.de>
Message-Id: <20200501025529.D447A20836@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.

v5.6.7: Build OK!
v5.4.35: Build OK!
v4.19.118: Failed to apply! Possible dependencies:
    1b53734bd0b2 ("epoll: fix possible lost wakeup on epoll_ctl() path")
    35cff1a6e023 ("fs/epoll: rename check_events label to send_events")
    86c051793b4c ("fs/epoll: deal with wait_queue only once")
    abc610e01c66 ("fs/epoll: avoid barrier after an epoll_wait(2) timeout")
    c5a282e9635e ("fs/epoll: reduce the scope of wq lock in epoll_wait()")

v4.14.177: Failed to apply! Possible dependencies:
    002b343669c4 ("fs/epoll: loosen irq safety in ep_scan_ready_list()")
    35cff1a6e023 ("fs/epoll: rename check_events label to send_events")
    37b5e5212a44 ("epoll: remove ep_call_nested() from ep_eventpoll_poll()")
    679abf381a18 ("fs/eventpoll.c: loosen irq safety in ep_poll()")
    69112736e2f0 ("eventpoll: no need to mask the result of epi_item_poll() again")
    86c051793b4c ("fs/epoll: deal with wait_queue only once")
    bec1a502d34d ("eventpoll: constify struct epoll_event pointers")
    c5a282e9635e ("fs/epoll: reduce the scope of wq lock in epoll_wait()")
    d85e2aa2e34d ("annotate ep_scan_ready_list()")
    ee8ef0a4b167 ("epoll: use the waitqueue lock to protect ep->wq")

v4.9.220: Failed to apply! Possible dependencies:
    86c051793b4c ("fs/epoll: deal with wait_queue only once")
    89d947561077 ("sd: Implement support for ZBC devices")
    ac6424b981bc ("sched/wait: Rename wait_queue_t => wait_queue_entry_t")
    bd166ef183c2 ("blk-mq-sched: add framework for MQ capable IO schedulers")
    cf43e6be865a ("block: add scalable completion tracking of requests")
    e806402130c9 ("block: split out request-only flags into a new namespace")

v4.4.220: Failed to apply! Possible dependencies:
    27489a3c827b ("blk-mq: turn hctx->run_work into a regular work struct")
    511cbce2ff8b ("irq_poll: make blk-iopoll available outside the block layer")
    86c051793b4c ("fs/epoll: deal with wait_queue only once")
    8d354f133e86 ("blk-mq: improve layout of blk_mq_hw_ctx")
    9467f85960a3 ("blk-mq/cpu-notif: Convert to new hotplug state machine")
    ac6424b981bc ("sched/wait: Rename wait_queue_t => wait_queue_entry_t")
    bd166ef183c2 ("blk-mq-sched: add framework for MQ capable IO schedulers")
    cf43e6be865a ("block: add scalable completion tracking of requests")
    d9d8c5c489f4 ("block: convert is_sync helpers to use REQ_OPs.")
    da8b44d5a9f8 ("timer: convert timer_slack_ns from unsigned long to u64")
    e57690fe009b ("blk-mq: don't overwrite rq->mq_ctx")
    e6a40b096e28 ("block: prepare request creation/destruction code to use REQ_OPs")
    e806402130c9 ("block: split out request-only flags into a new namespace")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
