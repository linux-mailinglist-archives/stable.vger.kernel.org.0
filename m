Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5892E2E76
	for <lists+stable@lfdr.de>; Sat, 26 Dec 2020 16:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgLZPID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Dec 2020 10:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:32840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLZPIC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Dec 2020 10:08:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75250207CC;
        Sat, 26 Dec 2020 15:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608995242;
        bh=kUSGDulYXrnnzc0VMAVtcl+A2eZOjjt43/HS9ZCQgDk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a5DPY1PjgU1To8OnguSZKicw8MRn2Ev0Q4S8bhxGap4cRJqawLGV2Ph2075PWKyBG
         tqocEkPTBSoLYlzF2y/ao3Ugqduc+jtKIKLeBu1bCNmtUcGug2slWyNx7R85gdF+PH
         0lEQ/lwwCAYz7vljXwGS+/3kGVdaOal3+viOY/6o=
Date:   Sat, 26 Dec 2020 16:07:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
Message-ID: <X+dRp49IvCtHeDGf@kroah.com>
References: <20201223150515.553836647@linuxfoundation.org>
 <796530b145704445910cea10f27a4267@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <796530b145704445910cea10f27a4267@HQMAIL111.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 07:26:38PM +0000, Jon Hunter wrote:
> On Wed, 23 Dec 2020 16:33:01 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.3 release.
> > There are 40 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 25 Dec 2020 15:05:02 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
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
> Linux version:	5.10.3-rc1-ga5ba578b5228
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing and letting me know.

greg k-h
