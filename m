Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD70231BC3
	for <lists+stable@lfdr.de>; Wed, 29 Jul 2020 11:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgG2JCD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jul 2020 05:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG2JCD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jul 2020 05:02:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5969A2075D;
        Wed, 29 Jul 2020 09:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596013321;
        bh=KpgUqO/w4j7jtnNriNGNyXY97pNY6tY1O0RPpW6nefA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fI/mqxWtw+dos6cMyiYzRWZAJW9TPdLhxWfCSl1laRwmiwLw5oN7DyrJG7sSKsbrP
         36HsQgpEeQecRRcBO3qcwbsoVz383OLT3qkpJfx3GBTy0YVEYWW1qaNdxo6daTV/Zm
         kJPINlHQIq5p54NlQVm4FZgrLhHmqrivsMgO/120=
Date:   Wed, 29 Jul 2020 11:01:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 00/86] 4.19.135-rc3 review
Message-ID: <20200729090153.GA1814488@kroah.com>
References: <20200728153252.881727078@linuxfoundation.org>
 <cf885605-8098-f2fd-262e-4502562d67da@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf885605-8098-f2fd-262e-4502562d67da@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 29, 2020 at 09:57:36AM +0100, Jon Hunter wrote:
> 
> On 28/07/2020 16:51, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.135 release.
> > There are 86 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Jul 2020 15:32:32 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.135-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v4.19:
>     11 builds:	11 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	4.19.135-rc3-ga2eeabffd1f3
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Great!
