Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4B530163E
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 16:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbhAWPUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 10:20:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:43354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725765AbhAWPUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 10:20:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1706E23331;
        Sat, 23 Jan 2021 15:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611415193;
        bh=P/L4d2yOsgyqZk8TFlUgEOvOQSOdv+W/b8YOPk1MMwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OOKAmQXD0WBehM7XlkPfcB52gla89oTjvSfEIr30vcNr2r/+7yxM68vyiPJTCSZh1
         9/0flX8i1tL9WFENfGXnB0shVd/+pDvltS7rqO0VGXV3bAMZrIfSdwYYmE05Lt7fYo
         hjgWo+8xHW6wD432dheXkrzX1MuAXt4QSZ6rTLoM=
Date:   Sat, 23 Jan 2021 16:19:51 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 00/43] 5.10.10-rc1 review
Message-ID: <YAw+lzjQhsSuQRcq@kroah.com>
References: <20210122135735.652681690@linuxfoundation.org>
 <49a6e4c24f834bcb926c2ea2573ea6b4@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a6e4c24f834bcb926c2ea2573ea6b4@HQMAIL111.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 23, 2021 at 09:59:10AM +0000, Jon Hunter wrote:
> On Fri, 22 Jan 2021 15:12:16 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.10 release.
> > There are 43 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Jan 2021 13:57:23 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.10-rc1.gz
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
>     64 tests:	64 pass, 0 fail
> 
> Linux version:	5.10.10-rc1-g402284178c91
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
