Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD559349192
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCYMIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:56678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhCYMIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 08:08:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31C6661A1B;
        Thu, 25 Mar 2021 12:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616674080;
        bh=UU3ECMAN5S3QxAfiQZRTUqVRCzvxrpa1/MZ6PjHvyEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RhlVzKzCejxh728OA9WMoFfOvqHHxv84Gzqp7JirwjtPaBwod/YYDeW9OYelco6E9
         Vw5EOrR82yPQ/E4V9keiJaIdydAoOQEAo61XE2FYcWUsR73rztK5F+cC7RURuGyXol
         gd5bwKjRbDIDIi2KCTtvDQnKrjdAG2XSp61/bCgI=
Date:   Thu, 25 Mar 2021 13:07:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/150] 5.10.26-rc3 review
Message-ID: <YFx9HmmDU67fKieW@kroah.com>
References: <20210324093435.962321672@linuxfoundation.org>
 <13fdb47de47d4b5984f1cee069fe99e6@HQMAIL109.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13fdb47de47d4b5984f1cee069fe99e6@HQMAIL109.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 04:51:06AM -0700, Jon Hunter wrote:
> On Wed, 24 Mar 2021 10:40:21 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Mar 2021 09:33:54 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.26-rc3.gz
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
>     28 boots:	28 pass, 0 fail
>     70 tests:	70 pass, 0 fail
> 
> Linux version:	5.10.26-rc3-gf6bd595b6fda
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
>                 tegra20-ventana, tegra210-p2371-2180,
>                 tegra210-p3450-0000, tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for all the testing.

greg k-h
