Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B4926DE48
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgIQObI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbgIQObD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:31:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90F0E20684;
        Thu, 17 Sep 2020 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353046;
        bh=oI259mpyrtE1FuIf0ohrhJ+YfhIrCCtcnhpQqYeYZBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVtyz10UpZJ5dti/zoEH1OaCzrpfv9R1u9sXrai4/fc6veUFG+APd4Enps0yvvOq+
         RC1CilRuvccrkZdyUpTqMMlABccv7u0QCqQ7DEbc7mn/vDehQa2TaMGJc6aq48rLIZ
         WDp4JxZw4zTS68BvjaqKmp5zN4jqFATcpWam3LZU=
Date:   Thu, 17 Sep 2020 16:31:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 000/177] 5.8.10-rc1 review
Message-ID: <20200917143118.GB3941575@kroah.com>
References: <20200915140653.610388773@linuxfoundation.org>
 <4784c765af9d4be98276fb717f77d756@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4784c765af9d4be98276fb717f77d756@HQMAIL105.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 08:17:36AM +0000, Jon Hunter wrote:
> On Tue, 15 Sep 2020 16:11:11 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.10 release.
> > There are 177 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.10-rc1.gz
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
> Linux version:	5.8.10-rc1-g337aafeeb4cd
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
