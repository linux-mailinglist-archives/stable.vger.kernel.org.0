Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C4E2DC117
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 14:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgLPNUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 08:20:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbgLPNUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Dec 2020 08:20:44 -0500
Date:   Wed, 16 Dec 2020 14:21:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608124803;
        bh=nyo9OHlE/aQcAEt2GOtdJN8qfLuhAC960meqw9u/YnI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=PUk8i0kFXflgeIf1TntTTiXpl9VYMzw4T9ayhrVmfaKjquAdJjwMHmUiSMwNGxayN
         UCje2lFpxPeobzd65DsFWfJyAy3V5RU9vUxD3EehlwfuJgIUlXYwvBxJpMAL776j2z
         Uup2JOfJqD4LXLLRWA8NNoWZGTV+mIUvMglc2Uk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
Message-ID: <X9oJwEY0K9sLCWo7@kroah.com>
References: <20201214172555.280929671@linuxfoundation.org>
 <c9257d9dd7a74ae1ba4cb25d4c1e7050@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9257d9dd7a74ae1ba4cb25d4c1e7050@HQMAIL101.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 09:06:09AM +0000, Jon Hunter wrote:
> On Mon, 14 Dec 2020 18:27:34 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.15 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.15-rc1.gz
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
> Linux version:	5.9.15-rc1-g609d95a95925
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
