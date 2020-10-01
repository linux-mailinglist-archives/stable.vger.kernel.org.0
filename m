Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531C02807A8
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 21:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732522AbgJATXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 15:23:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729990AbgJATXP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Oct 2020 15:23:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 071D320759;
        Thu,  1 Oct 2020 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601580194;
        bh=uNYUf7cpoE2gYOFJzvkE9Pd4k+B/rTnyzrcHuRXFIHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i++thLLW/lixv75h/O54vNVgDXQKB0b6bluP1QtAUwRBW+S5c6YO0GwSCtfPTqJIx
         YpJGIsaaFUFX1++OYBA6ctKqEggeO1KeYvuQw7yIBvAX7Kcf11+/jydR+RrVkBYitI
         LACakEAr11nhg70QNZbrgN/y4i/w1HfR8pBDM7Bk=
Date:   Thu, 1 Oct 2020 21:23:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 00/99] 5.8.13-rc1 review
Message-ID: <20201001192314.GB3873962@kroah.com>
References: <20200929105929.719230296@linuxfoundation.org>
 <284adc47a1ab424eb6b574322f89e768@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <284adc47a1ab424eb6b574322f89e768@HQMAIL111.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 29, 2020 at 03:15:38PM +0000, Jon Hunter wrote:
> On Tue, 29 Sep 2020 13:00:43 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.13 release.
> > There are 99 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.8:
>     14 builds:	14 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.13-rc1-g2bea8b771966
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
