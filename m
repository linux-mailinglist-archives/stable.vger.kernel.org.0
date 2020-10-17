Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527AC2911AD
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 13:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436599AbgJQLdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 07:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408479AbgJQLdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 07:33:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACC8E206E5;
        Sat, 17 Oct 2020 11:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602934420;
        bh=zQKLuJ8TXh8dTql8ERGuclACMtp7hVWAVTD4YP+RCro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e2iGdpeLBjSgwlYEvLYEyM4EzhLMWQVN3InMAGH4AycEEgDbIroAGB6HlYR0raXI7
         9+u/dVRrnyKhv377cViUjTbwvOOyZTaHDC5kH3pjfutvoZWjiCcx9Dr5R+ljIxvGnB
         V+vIijfOCFsxVa8sGNqNL8PUCtxTBR1lOq/esxtQ=
Date:   Sat, 17 Oct 2020 13:34:30 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.9 00/15] 5.9.1-rc1 review
Message-ID: <20201017113430.GC2978968@kroah.com>
References: <20201016090437.170032996@linuxfoundation.org>
 <49d8a1d6-ca91-bc8f-2fe5-7189a9ad8ca7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49d8a1d6-ca91-bc8f-2fe5-7189a9ad8ca7@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 05:45:56PM +0100, Jon Hunter wrote:
> 
> On 16/10/2020 10:08, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.1 release.
> > There are 15 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> There is one test failure (new warning) for Tegra194 but this is a known
> issue for v5.9 and is fixed by Viresh's change [0]. Maybe we can pull
> into stable once it is merged to the mainline?	

Please let me know if this hits Linus's tree and I don't pick it up.

> 
> That said everything else looks good ...
> 
> Test results for stable-v5.9:
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     61 tests:	60 pass, 1 fail
> 
> Linux version:	5.9.1-rc1-g1cbc5f2d0eac
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
