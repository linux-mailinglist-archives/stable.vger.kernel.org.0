Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BB9247E17
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 07:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgHRFt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 01:49:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726381AbgHRFt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Aug 2020 01:49:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41E7F20738;
        Tue, 18 Aug 2020 05:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597729798;
        bh=a0lLWzGCnUkYwpwPuDSChXcYwVgQLa97w9Zac8SeYL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mG1cKW6vVDHhqAb2euca3fasOwiGIwDP52oQfnWKNpfSe2vGrv5BGuPDt3CQZda+o
         K26DVTjoy6UwwyA58ngIue8wNJN8+/FuW/DA1zCeLIIYzjWsleZmHLwktclEd2kq/e
         WPFKmlyWw+t+pllwIfJ6jY81ckX/qHRQNlNGT01M=
Date:   Tue, 18 Aug 2020 07:49:55 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 000/464] 5.8.2-rc1 review
Message-ID: <20200818054955.GA1741937@kroah.com>
References: <20200817143833.737102804@linuxfoundation.org>
 <f865d474bc8248228a23673edf84f6be@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f865d474bc8248228a23673edf84f6be@HQMAIL105.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 08:55:57PM +0000, Jon Hunter wrote:
> On Mon, 17 Aug 2020 17:09:13 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.2 release.
> > There are 464 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 19 Aug 2020 14:36:49 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.2-rc1.gz
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
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.2-rc1-gd74026bb5bef
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
