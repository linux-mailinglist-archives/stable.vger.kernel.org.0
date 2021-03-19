Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0993418CB
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 10:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhCSJvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 05:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhCSJux (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 05:50:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4FCF64F6A;
        Fri, 19 Mar 2021 09:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616147453;
        bh=FYYYNInJl6zjZGIuOHvR83+aRKI03nHHM4FPaVgoqtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LSGpqYw22CldxG5UmEUx1rD39oW87IzweD+N30MMWhCNRBzuGdKt7eV4QmhUIX9cp
         WOOu8bgELTYHZhafD8/t3Lc5u4FYVE9m4rXaL4Ki4DIx7yLPyRmIEGfW0VgRhkt4nH
         eixVAtnClywFSetquYTwUauKji/kAjjkqFCb1nQI=
Date:   Fri, 19 Mar 2021 10:50:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/290] 5.10.24-rc1 review
Message-ID: <YFRz+td+mTTaxfuc@kroah.com>
References: <20210315135541.921894249@linuxfoundation.org>
 <7dd43a2e2146425c8ee0d5be7c0b6715@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dd43a2e2146425c8ee0d5be7c0b6715@HQMAIL111.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 05:07:11PM +0000, Jon Hunter wrote:
> On Mon, 15 Mar 2021 14:51:33 +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.10.24 release.
> > There are 290 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 17 Mar 2021 13:55:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.24-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.10:
>     12 builds:	12 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     65 tests:	65 pass, 0 fail
> 
> Linux version:	5.10.24-rc1-g1dc88c1d74df
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
