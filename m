Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9159F31328F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 13:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhBHMlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 07:41:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhBHMkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 07:40:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CF1464E7E;
        Mon,  8 Feb 2021 12:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612787970;
        bh=8pLDrf/AeZOIez/HX1MNFZLMmTZuKOF7ggdyqS1IatM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ezONN6xeMQy71/KvSw1R9GRiDOrA1kQ8hvxT97x1Kt1u699jgfx1HApD/G6/AwV1V
         U27UHtTZHuKutJjWU/JJ2WpbU7zzNM12CjnVtWtd/zhA4y0jt3LewBldzC7lIRYc7+
         tEG4ZlVUFr0GGZo3Tr69uFK3BcXPlEC0AomJ2hTQ=
Date:   Mon, 8 Feb 2021 13:39:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 00/57] 5.10.14-rc1 review
Message-ID: <YCEw/8pqE5WhG97g@kroah.com>
References: <20210205140655.982616732@linuxfoundation.org>
 <361dc1da83e64a4d89e5c81487890f4e@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <361dc1da83e64a4d89e5c81487890f4e@HQMAIL101.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 07, 2021 at 01:26:20PM +0000, Jon Hunter wrote:
> On Fri, 05 Feb 2021 15:06:26 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.14 release.
> > There are 57 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Feb 2021 14:06:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.14-rc1.gz
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
>     65 tests:	65 pass, 0 fail
> 
> Linux version:	5.10.14-rc1-g58d18d6d116a
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
