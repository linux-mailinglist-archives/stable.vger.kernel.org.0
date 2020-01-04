Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01E013019B
	for <lists+stable@lfdr.de>; Sat,  4 Jan 2020 10:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgADJVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 04:21:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgADJVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 Jan 2020 04:21:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6464F215A4;
        Sat,  4 Jan 2020 09:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578129681;
        bh=t+7Mb394bXu9Sg7IaTe1iTOa0gvYL56M7fVIrBjE0Fc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCiECLNxPucz/5OIg0AKlczTKyhILC4vusdpKUDv4xhp9PN/HjmbPQaX7+xyWm5fP
         REN4q0aOltOkYm2dJbFcV3rVCQuz3yQUvaYoBVWDS5BmXeScgDRU43BottDhkfuRzi
         ybW+hxT9yS8azwTosS5Ix8mGig2ycQ2tp5MAMZGw=
Date:   Sat, 4 Jan 2020 10:21:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/191] 5.4.8-stable review
Message-ID: <20200104092119.GC1249964@kroah.com>
References: <20200102215829.911231638@linuxfoundation.org>
 <f709c06a-ce46-a235-e0d1-5b7331c80c66@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f709c06a-ce46-a235-e0d1-5b7331c80c66@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 03, 2020 at 05:51:33PM +0000, Jon Hunter wrote:
> 
> On 02/01/2020 22:04, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.8 release.
> > There are 191 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 04 Jan 2020 21:55:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.4.8-rc1-gb06e60adec89
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
