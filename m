Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4503CA48C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 19:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbhGORfo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 13:35:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhGORfn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 13:35:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81F9261357;
        Thu, 15 Jul 2021 17:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626370370;
        bh=TspSQrdYsvKt5G7QcaVoQ0OF/C4arsn9rMRe1c/kxyM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dDCAiTXJG4zAADbDB2J1ySxzdNnRW27h0jNcySNLpkzYbZ93gpsuku0T3b2y1SlaF
         uLoTTvqABrxpbHXPq+idioHuJF6aHCDEVErVy3mhwdIelvp+1pe+ovuUMcu8Z1pMZ0
         b2jtsmqQkjxTBPo9XGCUR73zBkawS4WdchelHsNI=
Date:   Thu, 15 Jul 2021 19:32:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH stable-5.10] io_uring: fix clear IORING_SETUP_R_DISABLED
 in wrong function
Message-ID: <YPBxP6kNmTKLrxKI@kroah.com>
References: <20210715131825.2410912-1-yangyingliang@huawei.com>
 <YPA2kfnTb5VtSTMm@kroah.com>
 <2d9aa268-fd78-17ec-df0f-00daa1138a72@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9aa268-fd78-17ec-df0f-00daa1138a72@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 09:27:53AM -0600, Jens Axboe wrote:
> On 7/15/21 7:22 AM, Greg KH wrote:
> > On Thu, Jul 15, 2021 at 09:18:25PM +0800, Yang Yingliang wrote:
> >> In commit 3ebba796fa25 ("io_uring: ensure that SQPOLL thread is started for exit"),
> >> the IORING_SETUP_R_DISABLED is cleared in io_sq_offload_start(), but when backport
> >> it to stable-5.10, IORING_SETUP_R_DISABLED is cleared in __io_req_task_submit(),
> >> move clearing IORING_SETUP_R_DISABLED to io_sq_offload_start() to fix this.
> >>
> >> Fixes: 6cae8095490ca ("io_uring: ensure that SQPOLL thread is started for exit")
> >> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> >> ---
> >>  fs/io_uring.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > I need an ack from Jens before I can take this...
> 
> Ack, that looks like a bad merge. Fine to apply this patch, thanks.

THanks, now queued up.

greg k-h
