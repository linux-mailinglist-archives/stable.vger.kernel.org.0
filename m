Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90027241E0C
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 18:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgHKQTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 12:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728797AbgHKQTg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Aug 2020 12:19:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6B3320825;
        Tue, 11 Aug 2020 16:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597162776;
        bh=ZjhXjuqTJvAJKZfY2SXDlo4Upz8smnPmMdDcD0scrEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQ5Qnf7eFPYRlnkq3gbEnk0bUIFlhGpVbR8U7RM89mnNDr2Ub0NWbzBuNJqGJwR20
         O8JeZQFY34KsbqTGLLUKziJDKV2OYxmnyrrtVP3uV1NooUr1vBN6kPScVQKOpSeLXR
         vf2ZEt6kc0h3Udog58lqAYnx9Cslr6ubPWbIlF2A=
Date:   Tue, 11 Aug 2020 18:19:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 00/38] 5.8.1-rc1 review
Message-ID: <20200811161945.GB440280@kroah.com>
References: <20200810151803.920113428@linuxfoundation.org>
 <5b30f340682c4ce09c64fc857cff5603@HQMAIL107.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b30f340682c4ce09c64fc857cff5603@HQMAIL107.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 11, 2020 at 07:57:52AM +0000, Jon Hunter wrote:
> On Mon, 10 Aug 2020 17:18:50 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.1 release.
> > There are 38 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.1-rc1.gz
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
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.1-rc1-gb30c8c9d4260
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing them all and letting me know.

greg k-h
