Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B0932D101
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 11:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbhCDKkb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 05:40:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238894AbhCDKk1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Mar 2021 05:40:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D04BC64F35;
        Thu,  4 Mar 2021 10:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614854387;
        bh=8SVNf6+Gl5F0uGhS3+7OLgPoX6iqUp+18NxkLc1jxrA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zYkC7mBosWGKQBOzyA4f/v7zMhXdS5swY+mUeQovFuT6M8eAHKMbM0EdGU3xtFeCx
         fR/dEpV5nboRBYJ3WibjERYyO/uLi1YWtdqn6gaBowK1/7MKXFerUpwAeNaWqXYwC1
         ticne9Apt3MSiw5zWklJ7O80CNQzMBl0f2oSSnRw=
Date:   Thu, 4 Mar 2021 11:39:44 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/661] 5.10.20-rc2 review
Message-ID: <YEC48IB+li1aGlyN@kroah.com>
References: <20210301193642.707301430@linuxfoundation.org>
 <8f6b387f2a8f490e8bd062805cf936cd@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f6b387f2a8f490e8bd062805cf936cd@HQMAIL101.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 09:21:24AM +0000, Jon Hunter wrote:
> On Mon, 01 Mar 2021 20:37:55 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.20 release.
> > There are 661 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Mar 2021 19:34:53 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.20-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.10:
>     12 builds:	12 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     65 tests:	65 pass, 0 fail
> 
> Linux version:	5.10.20-rc2-g92929e15cdc0
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
