Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D4338AF7D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 15:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhETNDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 09:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243484AbhETNBG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 09:01:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BCE16101D;
        Thu, 20 May 2021 12:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621515584;
        bh=nQrRZHjWKNdXiBNX6cRGOnv29CYUBlwhspaneO1L6Jk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qxeawXU+83ZzmmNQDdFv/8/hnBMA9tU78vccYHSBHlY3ts4m2WMd1y+Bk7HXuORV3
         PBtV5nxV9hNpCeHd2d0XedjAfT1d/49B4/b3pRkLZ/N80yz11bvKHN4a/y/A3iTc91
         YKNH7BMUdBGntyoHbpX6pqNbUtuF74XeTN6sRZmE=
Date:   Thu, 20 May 2021 14:59:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Vidya Sagar <vidyas@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.10 00/47] 5.10.39-rc1 review
Message-ID: <YKZdPjqh7hFJslqA@kroah.com>
References: <20210520092053.559923764@linuxfoundation.org>
 <447d562a-248f-7e92-42de-4239a2c18fc0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <447d562a-248f-7e92-42de-4239a2c18fc0@nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 01:32:14PM +0100, Jon Hunter wrote:
> Hi Greg,
> 
> On 20/05/2021 10:21, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.39 release.
> > There are 47 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.39-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> ...
> 
> > Vidya Sagar <vidyas@nvidia.com>
> >     PCI: tegra: Add Tegra194 MCFG quirks for ECAM errata
> 
> 
> The above is causing some tests regressions for Tegra. We have a fix
> that is under review but not merged yet [0]. Please can you drop this
> for v5.10 and v5.12? Sorry about that.

Now dropped, thanks.  I'll wait a few hours to see if anything else
comes up before pushing a -rc2 out for both of these.

greg k-h
