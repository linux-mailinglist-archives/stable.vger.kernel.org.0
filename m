Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E9B30E6DB
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 00:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhBCXMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 18:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232473AbhBCXEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Feb 2021 18:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81B0F64F55;
        Wed,  3 Feb 2021 23:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612393411;
        bh=WcsVP62D0utPXxiPyP7Ao/oNZEB18vDBJnm/rdRNFRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mQnWNifh9YxzrwKc4WZrtCW0h9v6L4850asSQhD9qQ8hLEhLmDIF3oR+QLBH8anJv
         cdBq9dhvZH8ZFHwwI4uy2mYnVSw9J3iCdL9aVNlEWoqODch4CVW2Rd2ixn3AvYSf7B
         h6tjfck6U87y1TbGEpunjTkzH8iNGtSkE6gSkX14=
Date:   Thu, 4 Feb 2021 00:03:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/142] 5.10.13-rc1 review
Message-ID: <YBsrwITQbYrqTaxI@kroah.com>
References: <20210202132957.692094111@linuxfoundation.org>
 <e2e3eb187c7d4f1fb530b2b4ddb5aade@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e3eb187c7d4f1fb530b2b4ddb5aade@HQMAIL101.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 08:21:43PM +0000, Jon Hunter wrote:
> On Tue, 02 Feb 2021 14:36:03 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.13 release.
> > There are 142 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.13-rc1.gz
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
> Linux version:	5.10.13-rc1-gb34e59747fbb
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
