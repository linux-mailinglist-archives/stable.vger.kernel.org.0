Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6573A76E1
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 08:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhFOGJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 02:09:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhFOGJP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 02:09:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0303B60720;
        Tue, 15 Jun 2021 06:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623737230;
        bh=20yQ1jb0SRSpb5FoCfhwB0lLJkhjKrt+lAbNJU9/ZJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n0YlYeXaL3foIvvTek442u78F+TheoZMLEMZghWZgOwWrnvPQDwCd7r5EHNP1H+pt
         fRj++zx9Q1ZaHukaPy73wwzRxnRnYRKT2KQdb3tXBekSUfKQHmmZc86eegYBxD+huR
         j32BTgSQuaAKK/KHQ5yG+MomkhX/g6qSl+7DTx+g=
Date:   Tue, 15 Jun 2021 08:07:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.9 00/42] 4.9.273-rc1 review
Message-ID: <YMhDjLxGK4uR2esO@kroah.com>
References: <20210614102642.700712386@linuxfoundation.org>
 <f4eb8896-699b-1363-2d73-dde162375c6c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4eb8896-699b-1363-2d73-dde162375c6c@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 06:54:37PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 14/06/2021 11:26, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.273 release.
> > There are 42 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.273-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> > Pseudo-Shortlog of commits:
> 
> ...
> 
> > Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> >     regulator: core: resolve supply for boot-on/always-on regulators
> 
> 
> I am seeing a boot regression on one board with 4.9.273-rc1 and bisect
> is pointing to the above commit. Reverting this on top of 4.9.273-rc1
> fixes the problem.
> 
> Test results for stable-v4.9:
>     8 builds:	8 pass, 0 fail
>     18 boots:	16 pass, 2 fail
>     30 tests:	30 pass, 0 fail
> 
> Linux version:	4.9.273-rc1-gaf46d32b472e
> Boards tested:	tegra124-jetson-tk1, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 
> Boot failures:	tegra210-p2371-2180

Thanks for testing and letting me know.  I will go drop that commit and
push out a -rc2 with that change.

greg k-h
