Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA31588D0
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 04:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbgBKDbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 22:31:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:57990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbgBKDbu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 22:31:50 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D99620842;
        Tue, 11 Feb 2020 03:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581391909;
        bh=iNXDlgkd/JRgLcFz0UdkzTCt5W3pNMNWg/GOggPqS9Q=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=P/gqeAN2KvnpyB6fiEQe5cxAr7rMhs0xnabQuXiA5lhutwGEill23mHubLb+LLSJY
         py+35eYEwKdBi20bL6JsWW0ygvrPWHyqtPihf/F9cQ51uuDiVVnOtkS/QdfeH94xUv
         8I2PpwZZAhJ0oqJjruE+bFqsc4Rfk5X8rRyjQZxU=
Date:   Tue, 11 Feb 2020 03:31:48 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/3] io_uring: grab ->fs as part of async preparation
In-Reply-To: <20200209171113.14270-3-axboe@kernel.dk>
References: <20200209171113.14270-3-axboe@kernel.dk>
Message-Id: <20200211033149.4D99620842@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 5.3+

The bot has tested the following trees: v5.5.2, v5.4.18.

v5.5.2: Failed to apply! Possible dependencies:
    05f3fb3c5397 ("io_uring: avoid ring quiesce for fixed file set unregister and update")
    15b71abe7b52 ("io_uring: add support for IORING_OP_OPENAT")
    3a6820f2bb8a ("io_uring: add non-vectored read/write commands")
    3e4827b05d2a ("io_uring: add support for epoll_ctl(2)")
    4840e418c2fc ("io_uring: add IORING_OP_FADVISE")
    b5dba59e0cf7 ("io_uring: add support for IORING_OP_CLOSE")
    d3656344fea0 ("io_uring: add lookup table for various opcode needs")
    d63d1b5edb7b ("io_uring: add support for fallocate()")
    eddc7ef52a6b ("io_uring: add support for IORING_OP_STATX")

v5.4.18: Failed to apply! Possible dependencies:
    15b71abe7b52 ("io_uring: add support for IORING_OP_OPENAT")
    2665abfd757f ("io_uring: add support for linked SQE timeouts")
    3e4827b05d2a ("io_uring: add support for epoll_ctl(2)")
    3fbb51c18f5c ("io_uring: move all prep state for IORING_OP_CONNECT to prep handler")
    4840e418c2fc ("io_uring: add IORING_OP_FADVISE")
    561fb04a6a22 ("io_uring: replace workqueue usage with io-wq")
    771b53d033e8 ("io-wq: small threadpool implementation for io_uring")
    8ed8d3c3bc32 ("io_uring: any deferred command must have stable sqe data")
    9adbd45d6d32 ("io_uring: add and use struct io_rw for read/writes")
    ad8a48acc23c ("io_uring: make req->timeout be dynamically allocated")
    b29472ee7b53 ("io_uring: make IORING_OP_TIMEOUT_REMOVE deferrable")
    ba5290ccb6b5 ("io_uring: replace s->needs_lock with s->in_async")
    ba816ad61fdf ("io_uring: run dependent links inline if possible")
    c826bd7a743f ("io_uring: add set of tracing events")
    e47293fdf989 ("io_uring: move all prep state for IORING_OP_{SEND,RECV}_MGS to prep handler")
    fbf23849b172 ("io_uring: make IORING_OP_CANCEL_ASYNC deferrable")
    fcb323cc53e2 ("io_uring: io_uring: add support for async work inheriting files")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
