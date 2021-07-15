Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2599B3C9F62
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhGONZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:25:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232558AbhGONZV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 09:25:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 384D061004;
        Thu, 15 Jul 2021 13:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626355347;
        bh=lH5ymrz8JU9jyVhq1Q6mGkPbDZRW2fukd22yPSeuGGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EkmNC0uj0cKZq4UxSGJMkRqeliaWb5nZqbssyDMBwsAZAhr7eb2PgqLk8iPOuUdwd
         4cs1EFw0Q8NqdaNVRzxkjrVIAoqyb7grZx6VB05wp7wZfO3lnQKh+7KHf1a10WQxMM
         ZttAGDNK4bXi/1FVcEUJqV+3nPHYTz+b4IW134tI=
Date:   Thu, 15 Jul 2021 15:22:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH stable-5.10] io_uring: fix clear IORING_SETUP_R_DISABLED
 in wrong function
Message-ID: <YPA2kfnTb5VtSTMm@kroah.com>
References: <20210715131825.2410912-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715131825.2410912-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 09:18:25PM +0800, Yang Yingliang wrote:
> In commit 3ebba796fa25 ("io_uring: ensure that SQPOLL thread is started for exit"),
> the IORING_SETUP_R_DISABLED is cleared in io_sq_offload_start(), but when backport
> it to stable-5.10, IORING_SETUP_R_DISABLED is cleared in __io_req_task_submit(),
> move clearing IORING_SETUP_R_DISABLED to io_sq_offload_start() to fix this.
> 
> Fixes: 6cae8095490ca ("io_uring: ensure that SQPOLL thread is started for exit")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

I need an ack from Jens before I can take this...
