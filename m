Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB363243DF
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 19:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBXSmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 13:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhBXSmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 13:42:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EB1E64F0A;
        Wed, 24 Feb 2021 18:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614192089;
        bh=qK9cBJPeBguUEFK39sRXoqL7yHhb+vKcwJvAMrS3PH4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=suAbYDPtq9h3oWNRez1vNrg7aoUK4knN4VAUZJ9bcGbyI4cOqC9yeFzpaYrCji3xU
         XcLCbmFQkUBn3pzU41W8JRNNluamxXGwAdt+LfQXfqoqkMBwycwQ31deS8ok9CngL/
         XC7C0AGbaVM9WnPshykK3WcNDF6wRHa3YPrkTpcU=
Date:   Wed, 24 Feb 2021 19:41:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.18-rc1 review
Message-ID: <YDad1miYwhy5OM0H@kroah.com>
References: <20210222121019.444399883@linuxfoundation.org>
 <cf54c3f403cb4355bac81437c44d34a0@HQMAIL107.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf54c3f403cb4355bac81437c44d34a0@HQMAIL107.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 02:49:53PM +0000, Jon Hunter wrote:
> On Mon, 22 Feb 2021 13:12:54 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.18 release.
> > There are 29 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.18-rc1.gz
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
> Linux version:	5.10.18-rc1-g905cc0ddef72
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
