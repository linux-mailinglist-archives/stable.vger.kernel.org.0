Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F5B267A6D
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 14:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgILMre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Sep 2020 08:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbgILMoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Sep 2020 08:44:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88DCC21531;
        Sat, 12 Sep 2020 12:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599914654;
        bh=VRhwAS/2FRcEuULVPJn9puKyWuAphKcqtltQGw6JQI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UA5p+yfv91jwwY5zLIN+NOjN8fVBBSM9KB6ZrBBQEzIbBjCZBGqdpsNFi+UjdDRsj
         kugiq0W3SEkI7FgqpBVqkbSIaSu7mfQDFulfw7aikbasje5XezNJYOFIxjRQLCau7F
         gNXEMlrGVQHnuBqP8rTzoeZm5jut0rAyxHy2ju1w=
Date:   Sat, 12 Sep 2020 14:44:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 00/16] 5.8.9-rc1 review
Message-ID: <20200912124417.GA539446@kroah.com>
References: <20200911122459.585735377@linuxfoundation.org>
 <c50c8dedeb4e4a78948add3df21b3aaf@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c50c8dedeb4e4a78948add3df21b3aaf@HQMAIL105.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 05:10:32PM +0000, Jon Hunter wrote:
> On Fri, 11 Sep 2020 14:47:17 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.9 release.
> > There are 16 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.9-rc1.gz
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
>     14 builds:	14 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.9-rc1-gdcdaabfe3cea
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing and letting me know.

greg k-h
