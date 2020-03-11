Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09286181938
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729354AbgCKNJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbgCKNJE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:09:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAC6E22464;
        Wed, 11 Mar 2020 13:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583932142;
        bh=6ca9lA8jh4w8D6Pag4DBz2MdpAPLBlItf7WOD0hTDI0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tC3pKbkHDAzIpNGPXe9tCgxbGPWh3fcrZLcYFPcjqwC32CM5WPSbo7LK7vsqN8rM6
         DK7lUEK3riFoZkssrOlCLrp5jpucuqJ3YVLzGyuOZOhaeTaCaFDxeqv5Dto3UT6Mnx
         BWeYdMQgnynX2fRWPiUyKmFeZviBslGmMlDNtiRo=
Date:   Wed, 11 Mar 2020 14:09:00 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/189] 5.5.9-stable review
Message-ID: <20200311130900.GC3833342@kroah.com>
References: <20200310123639.608886314@linuxfoundation.org>
 <d5975b9f-e97b-2cf4-9c1a-c52b4fed7191@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5975b9f-e97b-2cf4-9c1a-c52b4fed7191@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 08:08:58PM +0000, Jon Hunter wrote:
> 
> On 10/03/2020 12:37, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.9 release.
> > There are 189 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.9-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.5:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.5.9-rc1-g11e07aec0780
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
