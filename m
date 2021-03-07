Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5763F330068
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhCGLjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:39:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:60968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230403AbhCGLi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:38:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957BB64FF2;
        Sun,  7 Mar 2021 11:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615117103;
        bh=dtnzCe0JkDEEt2JnU6RZ4bIufLKfA93lfard6fmHAQ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b4Erc/6Q+WZNyi5s1Td+BhmSAwFb0IixrXa9VmvRmbEMsfwApwZSBA0UmL4gUe8l6
         MECydqM0am/kYPguMo6TpFKOIcV8u++arpT/az5gbrABSNgtgapaDN3RcxsGllg2p7
         MMSoFC+OrLo/utntx3AMTNzLfiTvsIwcQtxzi8pQ=
Date:   Sun, 7 Mar 2021 12:38:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.11 000/104] 5.11.4-rc1 review
Message-ID: <YES7LLyYDM2fTZCx@kroah.com>
References: <20210305120903.166929741@linuxfoundation.org>
 <6831ce864b9249c69fac4828b545bdb0@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6831ce864b9249c69fac4828b545bdb0@HQMAIL111.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 05:51:12PM +0000, Jon Hunter wrote:
> On Fri, 05 Mar 2021 13:20:05 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.11.4 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.11:
>     12 builds:	12 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     65 tests:	65 pass, 0 fail
> 
> Linux version:	5.11.4-rc1-gf598f183ed0a
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all.

greg k-h
