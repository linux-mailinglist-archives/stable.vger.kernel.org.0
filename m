Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80B6462F0B
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 09:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239959AbhK3I6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 03:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239965AbhK3I61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 03:58:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E948FC06175C;
        Tue, 30 Nov 2021 00:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 424FACE1831;
        Tue, 30 Nov 2021 08:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6232C53FC7;
        Tue, 30 Nov 2021 08:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638262493;
        bh=sBEt2AcVvLG8naQtZ3mlupqMlj28fXP2+3gyUGu24Xg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oduWQoYcqGFquvR4hBjel7rXYgrsK8MVlWSHDD0Zb2ovAwSrPeYbftNHlZc6ItwRK
         mhHcgzE9XMr9Lhjy6jhjyhXAEEZPhC8CBx8gzhfpJvHjaFd9BP302EeNJTi+HP3wtN
         J0irjiPzgXTim7+9R6UbQnGRjA976lqXl+AGs12I=
Date:   Tue, 30 Nov 2021 09:54:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
Message-ID: <YaXm25djaWxAerRm@kroah.com>
References: <20211129181718.913038547@linuxfoundation.org>
 <3210f340-f3a0-2cf1-8b3b-59db6e58e65e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3210f340-f3a0-2cf1-8b3b-59db6e58e65e@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 30, 2021 at 08:48:00AM +0000, Jon Hunter wrote:
> 
> On 29/11/2021 18:16, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.6 release.
> > There are 179 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> No new regressions.
> 
> Test results for stable-v5.15:
>     10 builds:	10 pass, 0 fail
>     28 boots:	28 pass, 0 fail
>     114 tests:	108 pass, 6 fail
> 
> Linux version:	5.15.6-rc1-ga6dab1fb6f7d
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py
>                 tegra194-p2972-0000: tegra-audio-boot-sanity.sh
>                 tegra194-p2972-0000: tegra-audio-hda-playback.sh
>                 tegra194-p3509-0000+p3668-0000: devices
>                 tegra194-p3509-0000+p3668-0000: tegra-audio-boot-sanity.sh
>                 tegra194-p3509-0000+p3668-0000: tegra-audio-hda-playback.sh

Any word on fixes for these failures?

thanks,

greg k-h
