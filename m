Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140BD3168B4
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 15:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBJOKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 09:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:60290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229610AbhBJOKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 09:10:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE7CE64E28;
        Wed, 10 Feb 2021 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612966181;
        bh=663FjPnEul4ObP1OEfJ+OgGVXmtuEZH0BQ+wT+8wXL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tHovXOEy1lZZo7KN/AP7PN3rTLajEojMHh9Dj3wghdyEMwnbQqV70i4AtAlgsO5HN
         ZfqB/2gR9GifRlYV0ANgZJK68pVQwZcV2qGvifxuLK4J9oZtynzbxBZskSAkfqA0D9
         s+owBENk60bNfhdulxvorkV8LAr8Hflt+jGVFxDA=
Date:   Wed, 10 Feb 2021 15:09:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable 5.10 00/16] stable 5.10 backports
Message-ID: <YCPpIn9S2Kcs5H0i@kroah.com>
References: <cover.1612845821.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1612845821.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 09, 2021 at 04:47:34AM +0000, Pavel Begunkov wrote:
> A bit more than expected because apart from 9 failed-to-apply patches
> there are lots of dependencies to them, but for the most part
> automatically merged.
> 
> Hao Xu (1):
>   io_uring: fix flush cqring overflow list while TASK_INTERRUPTIBLE
> 
> Jens Axboe (2):
>   io_uring: account io_uring internal files as REQ_F_INFLIGHT
>   io_uring: if we see flush on exit, cancel related tasks
> 
> Pavel Begunkov (13):
>   io_uring: simplify io_task_match()
>   io_uring: add a {task,files} pair matching helper
>   io_uring: don't iterate io_uring_cancel_files()
>   io_uring: pass files into kill timeouts/poll
>   io_uring: always batch cancel in *cancel_files()
>   io_uring: fix files cancellation
>   io_uring: fix __io_uring_files_cancel() with TASK_UNINTERRUPTIBLE
>   io_uring: replace inflight_wait with tctx->wait
>   io_uring: fix cancellation taking mutex while TASK_UNINTERRUPTIBLE
>   io_uring: fix list corruption for splice file_get
>   io_uring: fix sqo ownership false positive warning
>   io_uring: reinforce cancel on flush during exit
>   io_uring: drop mm/files between task_work_submit
> 
>  fs/io-wq.c    |  10 --
>  fs/io-wq.h    |   1 -
>  fs/io_uring.c | 360 ++++++++++++++++++++------------------------------
>  3 files changed, 141 insertions(+), 230 deletions(-)

All now queued up, thanks!

greg k-h
