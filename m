Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15A5B2FCEC2
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 12:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732206AbhATLCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 06:02:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:52336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733250AbhATKjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 05:39:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 905C22333C;
        Wed, 20 Jan 2021 10:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611139067;
        bh=5iGEK/kG4KaSLogg5WoEU7hHAA1puwCOiLCBf8knfro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FrH27HwBrsk+wTAismg6KTIxV7x2bVoB8wmdHhrz6sXrewSY5eai4FBfOOFKRJeUD
         Hg9SWM4SloILa9f5ND3tkSH6sDoskmChEvolRLjWd3mkAqy9DIV6MQ7wORd9PO07s9
         +fbHISnUJlXqvI1/E7ZdEpGt569007pDsJmmwDZQ=
Date:   Wed, 20 Jan 2021 11:37:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/152] 5.10.9-rc1 review
Message-ID: <YAgH+GCd8KRYp3FW@kroah.com>
References: <20210118113352.764293297@linuxfoundation.org>
 <5ccd28b1256b45b18e8bdfade7f8e210@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ccd28b1256b45b18e8bdfade7f8e210@HQMAIL105.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 19, 2021 at 11:52:03AM +0000, Jon Hunter wrote:
> On Mon, 18 Jan 2021 12:32:55 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.9 release.
> > There are 152 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.9-rc1.gz
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
>     26 boots:	26 pass, 0 fail
>     64 tests:	64 pass, 0 fail
> 
> Linux version:	5.10.9-rc1-g293595df2bc4
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all.

greg k-h
