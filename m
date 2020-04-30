Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF061BF063
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 08:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgD3GkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 02:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgD3GkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 02:40:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2434F20784;
        Thu, 30 Apr 2020 06:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588228804;
        bh=kr+W+bJR5l7AuY+avNRNdmne9FDk79drbXaslTbNVd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=akqq9vZJur1/N/1aDY+yFOIBkxcvoElmXnoGWoq8dvNrwehSpaZWekTONdtGS9Bu3
         mClWCbUhd+jj7c4k8fHYDH+9TDA12N4xe8A9Vc3FBciGy0ecdkJRvaQgbphHfXOp86
         bN0OyMG5iw0wswFwXiBeWZpwnWtBzUeIJSnY8CqM=
Date:   Thu, 30 Apr 2020 08:40:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 000/167] 5.6.8-rc1 review
Message-ID: <20200430064002.GB2377651@kroah.com>
References: <20200428182225.451225420@linuxfoundation.org>
 <aa146242-b3f0-c7f8-9540-5f90e1473896@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa146242-b3f0-c7f8-9540-5f90e1473896@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 29, 2020 at 11:17:35AM +0100, Jon Hunter wrote:
> 
> On 28/04/2020 19:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.8 release.
> > There are 167 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Apr 2020 18:20:42 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.6:
>     13 builds:	13 pass, 0 fail
>     24 boots:	24 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.6.8-rc1-g853ae83af7cc
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
