Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B43F28DE0A
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgJNJ43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgJNJ43 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 05:56:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0FFE207C3;
        Wed, 14 Oct 2020 09:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602669387;
        bh=ArdEYEPSrfYQJ7LMYgSAMwiBf6SrTBuQ7WCExj3/izo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xrYEKpLND8NpYca+YsiIVX3saJMzIXAlDepcILoeYAStLRzUBmboRDNeoLSPMpgTa
         Mzo5OgJNorwIo0ECrihIWSk3DzIlRK10DQ1TrzEM/Uq1R4/P1B8nU92hmQS6U/ix4T
         JivgJC0wF9dKqAcKRVtQtzO7k2E0dELBGUW2OyoE=
Date:   Wed, 14 Oct 2020 11:57:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 000/124] 5.8.15-rc1 review
Message-ID: <20201014095702.GB3599360@kroah.com>
References: <20201012133146.834528783@linuxfoundation.org>
 <a4e7bd965ed842e8b6e9564abc2c4ffc@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4e7bd965ed842e8b6e9564abc2c4ffc@HQMAIL105.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 06:27:49PM +0000, Jon Hunter wrote:
> On Mon, 12 Oct 2020 15:30:04 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.15 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Oct 2020 13:31:22 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.15-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.8:
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.15-rc1-gf4ed6fb8f168
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
