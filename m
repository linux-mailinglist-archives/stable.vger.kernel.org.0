Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C552A7C45
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 11:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgKEKwk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 05:52:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgKEKwk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Nov 2020 05:52:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49AA321734;
        Thu,  5 Nov 2020 10:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604573559;
        bh=55+dmYNSA4RJNAuski7QzZJVEG3oCdkANHEesZBTeIA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l8KAnzVVBHxSqrPJRo+K6WXIk62igcBMBy4re5IgHbsWN5F4zWu3rLREO0YSeAq2H
         RFfKEwKCVumuIU7XEKPeeVoYkjVg39tTbA1V/iX1AVYgOVVsZs4hK7xXOXc5isf2FA
         bBvvHGCQ1Z2gC4IOAntSCpwHylawoTRpBCnxFx/s=
Date:   Thu, 5 Nov 2020 11:53:28 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.9 000/391] 5.9.4-rc1 review
Message-ID: <20201105105328.GB4038994@kroah.com>
References: <20201103203348.153465465@linuxfoundation.org>
 <4796280b881e4246a6ad2ae268744c37@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4796280b881e4246a6ad2ae268744c37@HQMAIL105.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 09:03:46AM +0000, Jon Hunter wrote:
> On Tue, 03 Nov 2020 21:30:51 +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.9.4 release.
> > There are 391 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 05 Nov 2020 20:29:58 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.4-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.9.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.9:
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     61 tests:	61 pass, 0 fail
> 
> Linux version:	5.9.4-rc1-g53574a4c558e
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Great, thanks for testing and letting me know.

greg k-h
