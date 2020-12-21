Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20992DFC1D
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 14:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgLUNAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 08:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgLUNAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Dec 2020 08:00:05 -0500
Date:   Mon, 21 Dec 2020 14:00:40 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608555565;
        bh=z9P8YVXTXze/aeKnrHmkfv8VNspdBjfwJOyG2QiGD/Y=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wk2hqzivRPjRCrY5AsLatS+ExE50rDr8qDKNOAAfMRtTAIyM+3K1xqzhMOctr152i
         3Zn+YkqSc4iNJGC4xs/6Z2WWpzOMaZVoGgefINrbP1uNb+kVdtrG7fQ+8E2eTB8rk4
         tQcM/ibTD34vPKFNlxOfEy/A3BPN+afnmbjGYG40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/16] 5.10.2-rc1 review
Message-ID: <X+CceNyxGMD8nnzc@kroah.com>
References: <20201219125339.066340030@linuxfoundation.org>
 <cf66826d-0de4-da22-da2b-809856d3cfb2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf66826d-0de4-da22-da2b-809856d3cfb2@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 20, 2020 at 01:41:15PM +0000, Jon Hunter wrote:
> 
> On 19/12/2020 12:57, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.2 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 21 Dec 2020 12:53:29 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.2-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> Test results for stable-v5.10:
>     12 builds:	12 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     64 tests:	63 pass, 1 fail
> 
> Linux version:	5.10.2-rc1-gc96cfd687a3f
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py
> 
> 
> Same warning failure as before. The fix for this is now in the mainline
> if you would like to pick it up ...
> 
> commit c9f64d1fc101c64ea2be1b2e562b4395127befc9
> Author: Thierry Reding <treding@nvidia.com>
> Date:   Tue Nov 10 08:37:57 2020 +0100
> 
>     net: ipconfig: Avoid spurious blank lines in boot log
> 
> 
> Otherwise ...
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

I've now queued this up for the next release, thanks for testing these
and letting me know.

greg k-h
