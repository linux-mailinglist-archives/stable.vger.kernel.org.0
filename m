Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC50263536
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 20:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIISAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 14:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgIISAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Sep 2020 14:00:38 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEEAB21D7D;
        Wed,  9 Sep 2020 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599674437;
        bh=MWAfud2kNi/Tty1GPyaCTV1pW2bCQRmFqT2AAwVvnUQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nNpzTIqnilsQgLCL/iuqmCXAj/lVzvSB6JR7XzsCIW46xyGiRai/VTGS83LUeTomc
         eJZTVgZ7fTX20V+pe3016avwuol6aZm3zBR+yo4yepQP6yoj5rS064FinOd2OnqBEQ
         z3P8adgY+Q3bywyfUGm8lFVaOglsSGyXwcjA3qlE=
Date:   Wed, 9 Sep 2020 20:00:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 000/186] 5.8.8-rc1 review
Message-ID: <20200909180047.GC1003763@kroah.com>
References: <20200908152241.646390211@linuxfoundation.org>
 <71fefa0c8e26421ba1ae3619108bf836@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71fefa0c8e26421ba1ae3619108bf836@HQMAIL105.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 09, 2020 at 07:03:41AM +0000, Jon Hunter wrote:
> On Tue, 08 Sep 2020 17:22:22 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.8 release.
> > There are 186 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.8-rc1.gz
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
> Linux version:	5.8.8-rc1-g456fe9607f8f
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Great, thanks for testing and letting me know.

greg k-h
