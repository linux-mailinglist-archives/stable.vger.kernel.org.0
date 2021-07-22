Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3A03D2C20
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 20:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhGVSIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 14:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229545AbhGVSIP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 14:08:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21BB660EB2;
        Thu, 22 Jul 2021 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626979729;
        bh=vTlLoa/WDToa1gbyQ50HnoiDPfOr9BoWi+Ir6ioBPVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mwZM5y9pw1lR0nx1LVm3RnI79TlByo7SkvDvJNttzEOY+hHwjZIgjxteZaNPxkK0V
         euNhfCaBn/DOhY0M0GJ5gmc2CLQGCuIvG/podz1XuBk8xRn+PYTZt7PtUeL0u5dvgq
         YH9wRkvtJLthxe3o568WvYVoRq9OKIqRDUV5ead8=
Date:   Thu, 22 Jul 2021 20:48:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, aford173@gmail.com
Subject: Re: [PATCH 5.10 000/125] 5.10.53-rc1 review
Message-ID: <YPm9j7KqcRPnr+dP@kroah.com>
References: <20210722155624.672583740@linuxfoundation.org>
 <beeb7568-388f-38e4-eb1f-28b1557bc191@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <beeb7568-388f-38e4-eb1f-28b1557bc191@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 12:00:34PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 7/22/21 11:29 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.53 release.
> > There are 125 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 24 Jul 2021 15:56:00 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.53-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Build regressions detected on Arm64:
> 
>   make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 'CC=sccache aarch64-linux-gnu-gcc' 'HOSTCC=sccache gcc' dtbs
>   Error: /builds/linux/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi:298.1-13 Label or path usb2_clksel not found
>   FATAL ERROR: Syntax error parsing input tree
>   make[3]: *** [scripts/Makefile.lib:326: arch/arm64/boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dtb] Error 1
>   make[3]: Target '__build' not remade because of errors.
>   make[2]: *** [/builds/linux/scripts/Makefile.build:497: arch/arm64/boot/dts/renesas] Error 2
>   make[2]: Target '__build' not remade because of errors.
>   make[1]: *** [/builds/linux/Makefile:1359: dtbs] Error 2
>   make: *** [Makefile:185: __sub-make] Error 2
>   make: Target 'dtbs' not remade because of errors.

2 patches dropped should now fix this.  I will push out a -rc2 now.

thanks,

greg k-h
