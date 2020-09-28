Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB4227B34D
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 19:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgI1RdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 13:33:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgI1RdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 13:33:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79752208D5;
        Mon, 28 Sep 2020 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601314398;
        bh=BbQZ8tSywDvWbFN1YnGF4w/TGPoQxXgrd1ElwxGdbhw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ui+5Zb8BG0wPdwgKuFLqBb2T6Ra/vU/91TsjiQyGm7mjfxUaLlq81YISb4lrkqGhd
         nidheQn98Uhe+DmTnV2ty+Mp0iZmQuVKtnLIFRxSWJgGA0paHFa8kdAArBGVJe/pUT
         UiOFnQZf7twe3VHVqc8dLU1zKUi7dHPVqUS/WMd4=
Date:   Mon, 28 Sep 2020 19:33:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     stable@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 5.8] io_uring: ensure open/openat2 name is cleaned on
 cancelation
Message-ID: <20200928173325.GB2042505@kroah.com>
References: <20200928153507.27420-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928153507.27420-1-sgarzare@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 05:35:07PM +0200, Stefano Garzarella wrote:
> From: Jens Axboe <axboe@kernel.dk>
> 
> [ Upstream commit f3cd4850504ff612d0ea77a0aaf29b66c98fcefe ]
> 
> If we cancel these requests, we'll leak the memory associated with the
> filename. Add them to the table of ops that need cleaning, if
> REQ_F_NEED_CLEANUP is set.
> 
> Cc: stable@vger.kernel.org
> Fixes: e62753e4e292 ("io_uring: call statx directly")
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  fs/io_uring.c | 2 ++
>  1 file changed, 2 insertions(+)

Thanks, now queued up.

greg k-h
