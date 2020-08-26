Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5DEC252AAD
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 11:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgHZJtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 05:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:48764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbgHZJtc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 05:49:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D802075E;
        Wed, 26 Aug 2020 09:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598435371;
        bh=wLI/xzMKZEq+6BTMS/1q5FM6TMsaSvzW0vR7P2KfPuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UwkXCaT5xZ28BAUwA2Q7peqBTU5iEtHxlXhRGnli8CnhF0vsE9aHgd99daByc+nyq
         1gLNduxIcDoKFrhAeOfc8zSxKRH4x8WxRKroHgVBrrASWIiocACfN6mf23qJGdlwfE
         Yld3G9J5dTxfLI/+00LSC42G6j1doiIXdpVN7Q5M=
Date:   Wed, 26 Aug 2020 11:49:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 000/149] 5.8.4-rc2 review
Message-ID: <20200826094947.GA2047935@kroah.com>
References: <20200824164745.715432380@linuxfoundation.org>
 <0d2ab7718bfb4123ab6b26ba7cc99eab@HQMAIL101.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d2ab7718bfb4123ab6b26ba7cc99eab@HQMAIL101.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:09:03PM +0000, Jon Hunter wrote:
> On Mon, 24 Aug 2020 18:48:20 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.4 release.
> > There are 149 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.4-rc2.gz
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
> Linux version:	5.8.4-rc2-gff3effda97ba
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing all of these and letting me know.

greg k-h
