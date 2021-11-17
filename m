Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F1C454251
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 09:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhKQIIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 03:08:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:52308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234324AbhKQIIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 03:08:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ADBF61BD2;
        Wed, 17 Nov 2021 08:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637136332;
        bh=NaHR9zzS2USAJRGDGDzXTiLfS5jNHqwZBKYkvUY9uuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HXPDm18nKrE47Ab7fnOeuRZIYalpENJThj6FSKn2rC9UKMplmAxhX7LcSgG+GNzvm
         jtccdG6eM4x1Xm3HfOOY+iMKSE/kjQ2k9SBM79QVvD6Qk+PMdyPZY1bwn3L19hoITp
         OkFqaECtGMmY2Yl1RYzYMqwSxWYxYR7N4BaoFdrY=
Date:   Wed, 17 Nov 2021 09:05:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/857] 5.14.19-rc2 review
Message-ID: <YZS3yUlicDhwq8LP@kroah.com>
References: <20211116142622.081299270@linuxfoundation.org>
 <af1e8687-7e6b-1599-a4f0-116d0da616f5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af1e8687-7e6b-1599-a4f0-116d0da616f5@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 08:40:32PM +0000, Jon Hunter wrote:
> 
> On 16/11/2021 15:01, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.14.19 release.
> > There are 857 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Mark Brown <broonie@kernel.org>
> >      spi: Check we have a spi_device_id for each DT compatible
> 
> 
> The above commit generates some new warnings ...
> 
>  WARNING KERN SPI driver mtd_dataflash has no spi_device_id for atmel,at45
>  WARNING KERN SPI driver mtd_dataflash has no spi_device_id for atmel,dataflash
>  WARNING KERN SPI driver mmc_spi has no spi_device_id for mmc-spi-slot
> 
> This is causing a boot test to fail on Tegra. I have posted
> fixes for these [0][1], but they are yet to be picked up for
> mainline.

Those warnings are good, I'll leave this patch in.  Thanks for the
report :)

greg k-h
