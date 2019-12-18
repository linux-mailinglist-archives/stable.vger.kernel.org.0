Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D62B1249CA
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfLROeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:34:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbfLROeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 09:34:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7431D21582;
        Wed, 18 Dec 2019 14:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576679689;
        bh=+kiBjXCYTKlNThCpuJsw524K5bztl5tghYfwt2X23I4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nPgKwLNOW2aW2uHjNjUkSVycegyjLY6ssU9+tzohwtLLm9Tw5nRUCZFZcC6fBRq3o
         wL7rj1TsEqu9nQsU+rJL0TEbGPYZBewdXfKrSHkPyLfX2B0LIcAcjzompUe67NCNDG
         3nmpHmWFJ6Bzd3mVAeUrdt5Vrc40LDNSDwFZjnS0=
Date:   Wed, 18 Dec 2019 15:34:47 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
Message-ID: <20191218143447.GA259271@kroah.com>
References: <20191217200721.741054904@linuxfoundation.org>
 <778e872e-0eb4-a888-f0a3-e6ba79eba569@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <778e872e-0eb4-a888-f0a3-e6ba79eba569@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 18, 2019 at 10:24:29AM +0000, Jon Hunter wrote:
> 
> On 17/12/2019 20:09, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.5 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Dec 2019 20:06:21 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.5-rc1.gz
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
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.4.5-rc1-g3400efb6b47c
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing both of these and letting me know.

greg k-h
