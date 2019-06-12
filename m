Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51C0C42BE0
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbfFLQPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 12:15:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbfFLQPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Jun 2019 12:15:41 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 605C42064A;
        Wed, 12 Jun 2019 16:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560356141;
        bh=e3BRvgbCZiqcWycKpjk1xu6EJg19DVf82d/qsR99Lvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a4MQ5LRIOL0fds8KSwHcT6yCz3xi35Tu/AIRjosA39K6xMOoxrqAV4dBSLdfGrTCM
         outtDFZqSHZYw8gjVgjESr+7VsFdZrdqIeWmZexPvtPqQ+w6WJFphGtDdRkaPnDfRl
         vfcHp0s+fY5CCMvJbrkBLFVdfKfRu4eR9BATncLc=
Date:   Wed, 12 Jun 2019 19:15:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/odp: Fix missed unlock in non-blocking
 invalidate_start
Message-ID: <20190612161536.GS6369@mtr-leonro.mtl.com>
References: <20190611160951.23135-1-jgg@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611160951.23135-1-jgg@ziepe.ca>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 01:09:51PM -0300, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
>
> If invalidate_start returns with EAGAIN then the umem_rwsem needs to be
> unlocked as no invalidate_end will be called.
>
> Cc: <stable@vger.kernel.org>
> Fixes: ca748c39ea3f ("RDMA/umem: Get rid of per_mm->notifier_count")
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> ---
>  drivers/infiniband/core/umem_odp.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
