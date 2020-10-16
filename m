Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11D528FFA4
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 10:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404970AbgJPIBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 04:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404892AbgJPIBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 04:01:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358F020829;
        Fri, 16 Oct 2020 08:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602835290;
        bh=Gs+eAf+oEcGnGfdqLx2+MWqTU0Eoyu+owpgoUcsc8N4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PIhmrDoIhMDRPJ1pkfcNgBqmCin/B36+grkP0Sjrysu4UijjVLlyG9igQl2U3T2LF
         A1o6544PnNXw5nlD+Hsa2wWKHIJmnzzG6w/0Ra0mFhbrH0KJ0pgMj0OEgFQMjfDu9P
         t4v59M5YI64BIK8Bu9kleutVpVkBv5BSYScKZ+lk=
Date:   Fri, 16 Oct 2020 10:02:01 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     sashal@kernel.org, broonie@kernel.org, linux-spi@vger.kernel.org,
        stable@vger.kernel.org, yi.zhang@huawei.com,
        chenwenyong2@huawei.com
Subject: Re: [PATCH 4.4.y] spi: unbinding slave before calling
 spi_destroy_queue
Message-ID: <20201016080201.GB1355531@kroah.com>
References: <20201015143834.1136778-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015143834.1136778-1-yangerkun@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 15, 2020 at 10:38:34PM +0800, yangerkun wrote:
> We make a mistake while backport 'commit 84855678add8 ("spi: Fix
> controller unregister order")'. What we should do is call __unreigster
> for each device before spi_destroy_queue. This problem exist in
> linux-4.4.y/linux-4.9.y.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  drivers/spi/spi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks, now applied.

greg k-h
