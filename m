Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637B51588D1
	for <lists+stable@lfdr.de>; Tue, 11 Feb 2020 04:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgBKDbv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 22:31:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727530AbgBKDbv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 22:31:51 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60A3120661;
        Tue, 11 Feb 2020 03:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581391910;
        bh=eOvycwphIyRjMfSieKeF20TAJ8mEhjy8tyhbSaFRjOU=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=bbJ99t0nXatNPUaHopDH7Rw3iz+nw/DdI8LvDAHJ6b97rsXTXGpm1eH5FZESoL5xe
         I5qVZ25DFVwHu9MOufzaQCMSH6YBKTg2Wl1rKBMiCpmFUY8guIrgf7zwkT4g4qCDCq
         /rhY4v9yI8wcZoQBTKCwNGMTG+bkFOW9oViT3t40=
Date:   Tue, 11 Feb 2020 03:31:49 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/3] io-wq: add support for inheriting ->fs
In-Reply-To: <20200209171113.14270-2-axboe@kernel.dk>
References: <20200209171113.14270-2-axboe@kernel.dk>
Message-Id: <20200211033150.60A3120661@mail.kernel.org>
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
    66f4af93da57 ("io_uring: add support for probing opcodes")
    b5dba59e0cf7 ("io_uring: add support for IORING_OP_CLOSE")
    d3656344fea0 ("io_uring: add lookup table for various opcode needs")
    d63d1b5edb7b ("io_uring: add support for fallocate()")
    eddc7ef52a6b ("io_uring: add support for IORING_OP_STATX")
    f86cd20c9454 ("io_uring: fix linked command file table usage")

v5.4.18: Failed to apply! Possible dependencies:
    561fb04a6a22 ("io_uring: replace workqueue usage with io-wq")
    771b53d033e8 ("io-wq: small threadpool implementation for io_uring")
    ba5290ccb6b5 ("io_uring: replace s->needs_lock with s->in_async")
    ba816ad61fdf ("io_uring: run dependent links inline if possible")
    c5def4ab8494 ("io-wq: add support for bounded vs unbunded work")
    c826bd7a743f ("io_uring: add set of tracing events")
    fcb323cc53e2 ("io_uring: io_uring: add support for async work inheriting files")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
