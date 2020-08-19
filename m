Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF2024AA32
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgHSX5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbgHSX5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:57:04 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA48120B1F;
        Wed, 19 Aug 2020 23:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881423;
        bh=jDqF9CMmZPNJlY7lel/jIhNxcCVrzETqpbxcqQEBNdk=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=op6cUvhx9Dh72Yz7IHfiEfyLMQURoCJPhe2WHVLBlBk9bgcaGsMk9tGHa1lLySml/
         XLB8y5Ehosc0BJIaUSTzyvMzZL7AF+g+nPNE0bJg0Q1n721sOP8/2XLs3dSYpNjqDh
         7qnqo9WBD/E4tLoBJ6C+kYaMT85Df8/8X5mZ217c=
Date:   Wed, 19 Aug 2020 23:57:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org, Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task isn't running
In-Reply-To: <20200808183439.342243-3-axboe@kernel.dk>
References: <20200808183439.342243-3-axboe@kernel.dk>
Message-Id: <20200819235703.AA48120B1F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 5.7+

The bot has tested the following trees: v5.8.1, v5.7.15.

v5.8.1: Failed to apply! Possible dependencies:
    3fa5e0f33128 ("io_uring: optimise io_req_find_next() fast check")
    4503b7676a2e ("io_uring: catch -EIO from buffered issue request failure")
    7c86ffeeed30 ("io_uring: deduplicate freeing linked timeouts")
    9b0d911acce0 ("io_uring: kill REQ_F_LINK_NEXT")
    9b5f7bd93272 ("io_uring: replace find_next() out param with ret")
    a1d7c393c471 ("io_uring: enable READ/WRITE to use deferred completions")
    b63534c41e20 ("io_uring: re-issue block requests that failed because of resources")
    bcf5a06304d6 ("io_uring: support true async buffered reads, if file provides it")
    c2c4c83c58cb ("io_uring: use new io_req_task_work_add() helper throughout")
    c40f63790ec9 ("io_uring: use task_work for links if possible")
    e1e16097e265 ("io_uring: provide generic io_req_complete() helper")

v5.7.15: Failed to apply! Possible dependencies:
    0cdaf760f42e ("io_uring: remove req->needs_fixed_files")
    310672552f4a ("io_uring: async task poll trigger cleanup")
    3fa5e0f33128 ("io_uring: optimise io_req_find_next() fast check")
    405a5d2b2762 ("io_uring: avoid unnecessary io_wq_work copy for fast poll feature")
    4a38aed2a0a7 ("io_uring: batch reap of dead file registrations")
    4dd2824d6d59 ("io_uring: lazy get task")
    7c86ffeeed30 ("io_uring: deduplicate freeing linked timeouts")
    7cdaf587de7c ("io_uring: avoid whole io_wq_work copy for requests completed inline")
    7d01bd745a8f ("io_uring: remove obsolete 'state' parameter")
    9b0d911acce0 ("io_uring: kill REQ_F_LINK_NEXT")
    9b5f7bd93272 ("io_uring: replace find_next() out param with ret")
    c2c4c83c58cb ("io_uring: use new io_req_task_work_add() helper throughout")
    c40f63790ec9 ("io_uring: use task_work for links if possible")
    d4c81f38522f ("io_uring: don't arm a timeout through work.func")
    f5fa38c59cb0 ("io_wq: add per-wq work handler instead of per work")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
