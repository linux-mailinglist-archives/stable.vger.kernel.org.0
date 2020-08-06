Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0631D23DF26
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730412AbgHFRis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:38:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729797AbgHFRbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Aug 2020 13:31:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 621EE22CA1;
        Thu,  6 Aug 2020 11:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596712210;
        bh=hyKCuLswWkb/pY/lN2LjImaCtKgtFYObNfTpDJ2/zkM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RtMFGzIXm57iKoTgFoTBzTxWGVox3PRRAiGOpTXtY4P/Bxt0p2P6vuSkSk/2vgrb1
         Ja7PCDZk42sHtYzSg+eRrScR13RTx6L3aoSkj8Vtl5UE3V4RSR8zhsKQZr/7s35QkR
         pxNrWLGoO0MIUOUfDZUaQl/vPrwTY8pOs3SamKUc=
Date:   Thu, 6 Aug 2020 09:05:52 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.7 0/7] 5.7.14-rc2 review
Message-ID: <20200806070552.GD2582961@kroah.com>
References: <20200805195916.183355405@linuxfoundation.org>
 <fb74b2c119a047e2933b5d375f0fe703@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb74b2c119a047e2933b5d375f0fe703@HQMAIL101.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 06:24:28AM +0000, Jon Hunter wrote:
> On Wed, 05 Aug 2020 21:59:33 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.14 release.
> > There are 7 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 07 Aug 2020 19:59:06 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.14-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.7.14-rc2-g0ceaad177e51
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks so much for testing all of these and letting me know.

greg k-h
