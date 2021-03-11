Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0B1337B19
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 18:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhCKRjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 12:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:45752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230011AbhCKRjZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 12:39:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB9AD64F97;
        Thu, 11 Mar 2021 17:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615484365;
        bh=TlKLoocWrAf+mcnp9qsVWdY3TBaeUf9aJbaJ39+J6z8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtH/zbCkOKstf4XiUOC85HEJkKRDX6YejxRrZSNq9il9X1VFovULtGaLExKeP+L1Q
         xl3pX62quqoDjFYEgaM7TNRJzweMU3Lz74CsGb1GR4Epy4h9isUiv2ayjTznSfAKWP
         tAsgItz03r5S5bb50H5xbEfI4hVJu0P4ANCE55Gc=
Date:   Thu, 11 Mar 2021 18:39:22 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
Message-ID: <YEpVysdRAC1P4GC1@kroah.com>
References: <20210310132320.510840709@linuxfoundation.org>
 <8b96ff67bd3d4e5ea9ea3d695eb5ba2d@HQMAIL107.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b96ff67bd3d4e5ea9ea3d695eb5ba2d@HQMAIL107.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 11, 2021 at 07:59:56AM +0000, Jon Hunter wrote:
> On Wed, 10 Mar 2021 14:23:13 +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.11.6 release.
> > There are 36 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.6-rc1.gz
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
> Linux version:	5.11.6-rc1-g4107fbb88ee5
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

thanks for testing them all.
