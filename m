Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743DC2DAA1E
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 10:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgLOJ3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 04:29:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726901AbgLOJ25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 04:28:57 -0500
Date:   Tue, 15 Dec 2020 10:29:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608024495;
        bh=4db6rhH1u24ZEgfMyj0jqs+mCmiFfyetZ+tSyhoTcdc=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=uNSrTGjOxMdsPE5HyNBe/xi0pujkUPYLIB5WGHAOdac/ga6cLQ4hhYNTc1CEb5dek
         tpxS4/Hm58aGU+3ilwPATiBdrcCZvpxfu+Rl2SGKzNWzZobBxAhY05JVWKVlzS2Aru
         e9oY60D5EMtadt/c4dejaTOqJPPmEDlVKtb484CA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
Message-ID: <X9iB76jgh/WeLVDI@kroah.com>
References: <20201214170452.563016590@linuxfoundation.org>
 <a1bff7f4-f6e9-506c-2c9f-5e7feba90acb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a1bff7f4-f6e9-506c-2c9f-5e7feba90acb@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 09:20:26AM +0000, Jon Hunter wrote:
> Hi Greg,
> 
> On 14/12/2020 17:06, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.1 release.
> > There are 2 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.1-rc1.gz
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
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     64 tests:	63 pass, 1 fail
> 
> Linux version:	5.10.1-g841fca5a32cc
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Test failures:	tegra194-p2972-0000: boot.py
> 
> 
> Some changes in v5.10 exposed a minor issue in the kernel that can cause
> a blank line warning to be seen. The above test is failing due to this
> blank warning. Thierry has posted a fix for this [0] and should be
> merged for v5.11. It was not tagged for stable, but if you OK to pull
> this in once in the mainline I can send a request. Otherwise all looks
> good, so ...
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing this, and yes, I'll be glad to take this once it hits
Linus's tree, just let me know the git commit id of it there.

thanks,

greg k-h
