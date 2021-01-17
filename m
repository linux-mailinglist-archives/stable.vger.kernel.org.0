Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2F22F927D
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 14:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbhAQNVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 08:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728538AbhAQNV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Jan 2021 08:21:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E6262222A;
        Sun, 17 Jan 2021 13:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610889648;
        bh=9P16Qc1fDjEpHvys6GdWgaFdY2+VGQav+DW/Ke2p3oU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AUzpFoxXCU+ZWal3396Lr99WF0MXcZFtQAKnLQU6MPCBave6RF8KXzkqvqkmSAouz
         AAXB9g/6lS64rR/sJKRuiZMlSGmRGilqkuSLBJe79mUrEMMEg3nPkXNOeueoM766/O
         cGQdjZYflxN1KwfbTEZH5swaPyR3GUaK15BBxI18=
Date:   Sun, 17 Jan 2021 14:20:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.8-rc1 review
Message-ID: <YAQ5r4QRVv4zjnQR@kroah.com>
References: <20210115122006.047132306@linuxfoundation.org>
 <a9195879679a4280b4c666be8d573617@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9195879679a4280b4c666be8d573617@HQMAIL105.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 04:19:46PM +0000, Jon Hunter wrote:
> On Fri, 15 Jan 2021 13:26:53 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.8 release.
> > There are 103 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 17 Jan 2021 12:19:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.8-rc1.gz
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
> Linux version:	5.10.8-rc1-gc6e710bf849b
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
