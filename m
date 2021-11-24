Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F0745C998
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 17:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241929AbhKXQO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 11:14:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhKXQOz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 11:14:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A84B60C3F;
        Wed, 24 Nov 2021 16:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637770305;
        bh=USFeZV28Xq2t1uNJPsCTQ3agCxkQa3LOCoMk8M+8K3w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EHTcBr3b6IPQjy8hnIfacV2jNgtZyXuUCLJ1199oBHQZWTBlX+erGdXvrn3GcgM7U
         ZKxAsCK10A93Fmwr9Sq7++8RH7ixQlGOPBN0OsJ9jRm01dNKiVO/Bnp8buzLy74Tpz
         u8eJPNRpSdKe/LSJPz8pLy4LsxExUwR5yxNlPp/8=
Date:   Wed, 24 Nov 2021 17:11:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
Message-ID: <YZ5kP+zKBE7wGyoV@kroah.com>
References: <20211124115702.361983534@linuxfoundation.org>
 <20211124135311.GA29193@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124135311.GA29193@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 02:53:11PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.82 release.
> > There are 154 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> CIP is running tests here:
> 
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/tree/linux-5.10.y
> 
> And there's a build failure in CIP testing there:
> 
>   CC      drivers/mmc/core/sdio_ops.o
> 5040drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
> 5041drivers/cpuidle/cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY' undeclared (first use in this function); did you mean 'TEGRA_SUSPEND_NONE'?
> 5042  if (tegra_pmc_get_suspend_mode() == TEGRA_SUSPEND_NOT_READY)
> 5043                                      ^~~~~~~~~~~~~~~~~~~~~~~
> 5044                                      TEGRA_SUSPEND_NONE
> 5045drivers/cpuidle/cpuidle-tegra.c:349:38: note: each undeclared identifier is reported only once for each function it appears in
> 5046  CC      drivers/gpu/drm/drm_dma.o
> 5047scripts/Makefile.build:280: recipe for target 'drivers/cpuidle/cpuidle-tegra.o' failed
> 5048scripts/Makefile.build:497: recipe for target 'drivers/cpuidle' failed
> 5049make[2]: *** [drivers/cpuidle/cpuidle-tegra.o] Error 1
> 5050make[1]: *** [drivers/cpuidle] Error 2
> 5051make[1]: *** Waiting for unfinished jobs....
> 5052  CC      drivers/cpufreq/raspberrypi-cpufreq.o

Will go drop that patch, thanks.

greg k-h
