Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F28221D939
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729659AbgGMOw1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729523AbgGMOw0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 10:52:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 298CE2065F;
        Mon, 13 Jul 2020 14:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594651946;
        bh=3tAV/Gm1bOYj99talTu6G8ccZjmj0wsmRHxaP4sLGAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ay9ZUm+qYVomO8TcN7hulIdZk8zPheN2MgBitctWXWdR5MUY39j0EXoHNbKvEc0+i
         zqSmCBICBE3XnsTFHbtrOJ9/L9xZjhusCr20d8S43qeguNixrVZtnMur74GMJc7rKg
         M27LsRpEGytB9bQPCy5RAyFMLfybrwmthOxEdulg=
Date:   Mon, 13 Jul 2020 16:52:26 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     stable@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH 4.19] IB/umem: fix reference count leak in
 ib_umem_odp_get()
Message-ID: <20200713145226.GA3767483@kroah.com>
References: <20200619160307.1601016-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619160307.1601016-1-yangyingliang@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 04:03:07PM +0000, Yang Yingliang wrote:
> Add missing mmput() on error path to avoid ref-count leak.
> 
> This problem has already been resolved in mainline by
> f27a0d50a4bc ("RDMA/umem: Use umem->owning_mm inside ODP").
> 
> Fixes: 79bb5b7ee177 ("RDMA/umem: Fix missing mmap_sem in get umem ODP call")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

We need an ack by the owner/maintainer of this code, please get the IB
developers/maintainers to do that first.

Any reason why you didn't cc: them also?

thanks,

greg k-h
