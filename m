Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B39F23B745
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403873AbfFJOZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:25:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403856AbfFJOZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Jun 2019 10:25:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26A2B207E0;
        Mon, 10 Jun 2019 14:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560176747;
        bh=EHU+U6e5Cw/kl6IWPHzHeUl1AkftBJ8qbSPrssDP8uE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+nvLis80kiwWuIiGX7ZN9sFBPjAh4SY5KdpVtmvAgpTFyLcEdxRW/w1tcPNBO5d6
         jZ5zYStGnLqDelyRAOOA1ybTQmhNBrJ3GO04in6P3TFHTLZL326PCzWeXcPwc9S9cL
         z+cmXn+9lKmNCweFKDAw5GBaA/6RTRZQ4HYHUbq0=
Date:   Mon, 10 Jun 2019 16:25:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
Message-ID: <20190610142545.GE5937@kroah.com>
References: <20190609164127.541128197@linuxfoundation.org>
 <c767d39b-49b2-de5b-2527-a39fcd242bb6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c767d39b-49b2-de5b-2527-a39fcd242bb6@nvidia.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 09:52:18AM +0100, Jon Hunter wrote:
> 
> On 09/06/2019 17:41, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.9 release.
> > There are 70 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.1:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.1.9-rc1-g5b3d375b3838
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
