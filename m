Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9CE92D27F4
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgLHJmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:42:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:48064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729048AbgLHJmk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:42:40 -0500
Date:   Tue, 8 Dec 2020 10:43:02 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607420514;
        bh=tvtbfrrR47jb6ZfkBFL79V+US5L4jdG2XyB7WAOqBNg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oq0cRkDpfopUklQEuLDxYi1r0kgq8BuOWwjF4/kNNiamkzJbgG8FTS6OfcZZi+B6O
         /Ry9lS5b+H4Q4jfER5yBzVXV3qRxfCDCCjeuQWC6lSfs1Z/PVPy/FukqZn8HV7hbLw
         xKiDpMhkO5CU16CnMlwGh6/yHQf5R1cZGqRVsRSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.9 00/46] 5.9.13-rc1 review
Message-ID: <X89KptUDfi0g7GhV@kroah.com>
References: <20201206111556.455533723@linuxfoundation.org>
 <c2df6c0f5b0249f781ba3f08bb98ec95@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2df6c0f5b0249f781ba3f08bb98ec95@HQMAIL101.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 03:04:07PM +0000, Jon Hunter wrote:
> On Sun, 06 Dec 2020 12:17:08 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.13 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.9:
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     64 tests:	64 pass, 0 fail
> 
> Linux version:	5.9.13-rc1-g1372e1af58d4
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
