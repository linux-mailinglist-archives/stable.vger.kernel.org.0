Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7E620785F
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 18:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404641AbgFXQFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 12:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404503AbgFXQFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 12:05:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80B66206F7;
        Wed, 24 Jun 2020 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593014740;
        bh=AWZteoRvB+bV0L1jEfUdGppba27IOiPJkLjir5C2LwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nDubSH1hcmIHhxBkrJCbAtFInAjaZVP0xAhFeA6PxLTBeQf/86p7360IzPRZquAFb
         bDJnaPpjo3UVWKv+AP0p3VGoXimYzY6IXnw8ZEGQW06MICo9UUR6LK93eL4Wy3qH1Y
         d/cWydLMBC4LVwmGMWP5I/3FkG0dwSRSlBNFMM6k=
Date:   Wed, 24 Jun 2020 18:05:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.7 000/474] 5.7.6-rc2 review
Message-ID: <20200624160536.GA2097866@kroah.com>
References: <20200624055938.609070954@linuxfoundation.org>
 <f21cfef6-78a6-af8b-86a0-f278f5e5eda8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f21cfef6-78a6-af8b-86a0-f278f5e5eda8@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 11:32:40AM +0100, Jon Hunter wrote:
> 
> On 24/06/2020 07:10, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.6 release.
> > There are 474 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Jun 2020 05:58:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.6-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.7.6-rc2-ga5e7ca280376
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
