Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD712EBF14
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 14:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbhAFNpj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 08:45:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727191AbhAFNpj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 08:45:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FC0A2311B;
        Wed,  6 Jan 2021 13:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609940692;
        bh=jx+Th/540TzI1Dt37+nfh2PkC6QzOMvUCfOQD4tOcEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v7C429kYY1TMIKyPA1xDYuW4eqZw22sN2nbM8QxsKmBu2DBO3kRWP9X1dTNCbvC1w
         reHktTxA069tgPGMis8/iH/Nv3egcmm7rMha8sB2pM68K+IZ1owjNKGCpPBOpsH6y5
         pgh1JfaLxYXSbw2jpy7rWJUlIiKaO8AwINujwytY=
Date:   Wed, 6 Jan 2021 14:46:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.19 00/29] 4.19.165-rc2 review
Message-ID: <X/W/JObJgFTb/OXP@kroah.com>
References: <20210105090818.518271884@linuxfoundation.org>
 <edfc33725b9c477b9999d74f3004fcbc@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edfc33725b9c477b9999d74f3004fcbc@HQMAIL105.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 11:08:28AM +0000, Jon Hunter wrote:
> On Tue, 05 Jan 2021 10:28:46 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.165 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Jan 2021 09:08:03 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v4.19:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	4.19.165-rc2-g40a2b34effd3
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all.

greg k-h
