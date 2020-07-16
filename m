Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5697B222210
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 13:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgGPL7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 07:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727844AbgGPL7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 07:59:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5981620739;
        Thu, 16 Jul 2020 11:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594900791;
        bh=ikXu4oZKrgzgUuocJpRo3Ozau2YlOtlMKUhcrYyuxTA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zRyABTV6OV/3PHZ4QZehQSEyzPhv83G79288vuY+JVUtwMudTAbnNByTlZzv0W9W7
         T7BaqJ2GkuJfm8Cb7kV5pcxVpMoA0xSxbPEPasKFl34Jseff4J5/18FRffaR/Gbp8U
         Y6Phbxyq650ZPMenLGD9ofcnhrT4RUN9t56fbGa0=
Date:   Thu, 16 Jul 2020 13:59:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     alexander.levin@microsoft.com, stable@vger.kernel.org,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH v2 for 5.4 1/2] crypto: atmel - Fix selection of
 CRYPTO_AUTHENC
Message-ID: <20200716115945.GC1668009@kroah.com>
References: <20200715125410.479112-1-tudor.ambarus@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715125410.479112-1-tudor.ambarus@microchip.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 15, 2020 at 03:54:09PM +0300, Tudor Ambarus wrote:
> Backport to 5.4.52-rc1:
> commit d158367682cd822aca811971e988be6a8d8f679f upstream.
> 
> The following error is raised when CONFIG_CRYPTO_DEV_ATMEL_AES=y and
> CONFIG_CRYPTO_DEV_ATMEL_AUTHENC=m:
> drivers/crypto/atmel-aes.o: In function `atmel_aes_authenc_setkey':
> atmel-aes.c:(.text+0x9bc): undefined reference to `crypto_authenc_extractkeys'
> Makefile:1094: recipe for target 'vmlinux' failed
> 
> Fix it by moving the selection of CRYPTO_AUTHENC under
> config CRYPTO_DEV_ATMEL_AES.
> 
> Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to...")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Both of these now queued up, thanks!

greg k-h
