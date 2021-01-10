Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113DA2F069E
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbhAJLaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbhAJLaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 06:30:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C05A22EBF;
        Sun, 10 Jan 2021 11:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610278161;
        bh=ck+7w93CukyhSlhD4+ZVxjqnYj/lgjNuppqHlI8alt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BvvBHVM4tEXdZbXRW3vtCED0qai3Hdlp+Vnd3ba8OQ9qeXWyxtqh0LIbbnwpy1Or6
         MvNWGX96GI3FgoPDjmakjWyp5dxzjSphi7p4s+BXsB1GWyBMKjLdB05u9H2aFpDTWc
         Ol7hno9kCEqLAKZTIw81e3bDNar8hVJ/smUs0xBE=
Date:   Sun, 10 Jan 2021 12:30:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.10 00/20] 5.10.6-rc1 review
Message-ID: <X/rlW1dh89bJ5G1V@kroah.com>
References: <20210107143052.392839477@linuxfoundation.org>
 <a9a73fda0e4647138b0054fe03f20546@HQMAIL107.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9a73fda0e4647138b0054fe03f20546@HQMAIL107.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 08:20:42PM +0000, Jon Hunter wrote:
> On Thu, 07 Jan 2021 15:33:55 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.6 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.6-rc1.gz
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
> Linux version:	5.10.6-rc1-g208f314c03c5
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
