Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F203695B3
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhDWPKq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 11:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhDWPKq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 23 Apr 2021 11:10:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E59E61468;
        Fri, 23 Apr 2021 15:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619190610;
        bh=gycymL6PxtYVqd+LZIxaZfPV+DTKuD5IU9+tHf7Mjkw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wQukPqnMffAcuVsoy2vDGawsNimVfsIWhkPem18XS86mgxmNNkHr7QIfNBdtSc6Gi
         qpAXjfZdep49MMM6Ov+z/ZEj9qM4LEK2QbvL1cuzUKXU2tCnFoTDIgTB0vkis1q38i
         pqcLdf2Lyi1FtU0ZkvGeeQhuThbydDI0LrmJbGPM=
Date:   Fri, 23 Apr 2021 17:10:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.11 000/122] 5.11.16-rc1 review
Message-ID: <YILjT+fp5m9FHC0v@kroah.com>
References: <20210419130530.166331793@linuxfoundation.org>
 <d862f52eb5dc4de5a1bb76c512b99d40@HQMAIL109.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d862f52eb5dc4de5a1bb76c512b99d40@HQMAIL109.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 19, 2021 at 11:13:37PM -0700, Jon Hunter wrote:
> On Mon, 19 Apr 2021 15:04:40 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.11.16 release.
> > There are 122 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 21 Apr 2021 13:05:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.16-rc1.gz
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
>     28 boots:	28 pass, 0 fail
>     70 tests:	70 pass, 0 fail
> 
> Linux version:	5.11.16-rc1-gf34f787f0e47
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>
> 
> Jon

Thanks for testing and letting me know.

greg k-h

