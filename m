Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A71102450
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfKSMZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:25:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfKSMZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 07:25:39 -0500
Received: from localhost (unknown [89.205.136.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C2B20730;
        Tue, 19 Nov 2019 12:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574166338;
        bh=J+SzVvZ2+0zMFsSFLLMumu9PACqhfdbEv9L05QqiNZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mic8M8rEdYATHdtFuUKGJLWkJBKkKF1q2pExTxUM+gSUUkzO9xpjcB3mXky2gtETk
         S/g+7tz3aTTokDdpT2ASGvkgwvFqh7q9D0kEDKm2FPO9i0comLFGoTAIL0GBND1HLQ
         C7bbHaiiU84rOXFOyupALwXDyYQDAyyFFpcwSmd8=
Date:   Tue, 19 Nov 2019 13:25:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/239] 4.14.155-stable review
Message-ID: <20191119122535.GB1913916@kroah.com>
References: <20191119051255.850204959@linuxfoundation.org>
 <cc1129c8-797d-7a1d-e59b-16c826270fad@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc1129c8-797d-7a1d-e59b-16c826270fad@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 09:12:48AM +0000, Jon Hunter wrote:
> 
> On 19/11/2019 05:16, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.155 release.
> > There are 239 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.155-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> ...
> 
> > Heiko Stuebner <heiko@sntech.de>
> >     arm64: dts: rockchip: enable display nodes on rk3328-rock64
> The above commit is causing the following build error for ARM64 ...
> 
> Error: arch/arm64/boot/dts/rockchip/rk3328-rock64.dts:149.1-6 Label or path hdmi not found
> Error: arch/arm64/boot/dts/rockchip/rk3328-rock64.dts:153.1-9 Label or path hdmiphy not found
> Error: arch/arm64/boot/dts/rockchip/rk3328-rock64.dts:345.1-5 Label or path vop not found
> FATAL ERROR: Syntax error parsing input tree
> scripts/Makefile.lib:317: recipe for target 'arch/arm64/boot/dts/rockchip/rk3328-rock64.dtb' failed
> make[2]: *** [arch/arm64/boot/dts/rockchip/rk3328-rock64.dtb] Error 1
> scripts/Makefile.build:585: recipe for target 'arch/arm64/boot/dts/rockchip' failed
> make[1]: *** [arch/arm64/boot/dts/rockchip] Error 2
> arch/arm64/Makefile:138: recipe for target 'dtbs' failed
> make: *** [dtbs] Error 2

Will go drop this, thanks.

greg k-h
