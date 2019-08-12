Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C558A0E7
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfHLOXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Aug 2019 10:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbfHLOXU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Aug 2019 10:23:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 941B8206DF;
        Mon, 12 Aug 2019 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565619799;
        bh=8AlBzaLTBUeMaPF+z5eAFEPn04v1rCfb+CInk+uno2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1wJdlEeqHv6g/8l7H/+leKevtKgFe4G3bPF6vMlNaCQAfAfdQEZpEda9Iix/p9FDL
         0zs4WVj+nO+lO4b+E1HQHs+51hyLceU7AXjAUuZDQKz7N3rvpIOYJ7IKQxxhyieDVY
         DRQcfx2ccDsfEWQKJIPBmYMSpjSEriGSw6KhxeIg=
Date:   Mon, 12 Aug 2019 16:23:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alessio Balsini <balsini@android.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH 4.9.y 4.14.y] IB/mlx5: Fix leaking stack memory to
 userspace
Message-ID: <20190812142316.GA12869@kroah.com>
References: <20190812105136.151840-1-balsini@android.com>
 <20190812105503.153253-1-balsini@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812105503.153253-1-balsini@android.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 11:55:03AM +0100, Alessio Balsini wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> commit 0625b4ba1a5d4703c7fb01c497bd6c156908af00 upstream.
> 
> mlx5_ib_create_qp_resp was never initialized and only the first 4 bytes
> were written.
> 
> Fixes: 41d902cb7c32 ("RDMA/mlx5: Fix definition of mlx5_ib_create_qp_resp")

This commit only showed up in the following kernel releases:
	4.17 4.18.7 4.19

so why is this "fix" commit needed in anything older than 4.17?

That's why I did not backport it to older kernels, as I do not think it
is needed there.  Do you?

thanks,

greg k-h
