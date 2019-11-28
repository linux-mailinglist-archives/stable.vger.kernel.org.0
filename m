Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2A310C6CF
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 11:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbfK1KgJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 05:36:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbfK1KgJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Nov 2019 05:36:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55B9921774;
        Thu, 28 Nov 2019 10:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574937366;
        bh=0LqZo1Ue9uKr6TnWQN58wFAQwI492H+XmI66XuoUXv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uu4Dt/cwxfe0UblNon7Q0gUYwIJUbVNCqx+Wp9KeoSJRRHFINsfVqbEfUNT6S402Y
         w1zwd55vqBYGCRMbvFRj84n9aRKsiDAK90n2ywqUdy/KUdtzW8H7/hGVibnzuFqPUz
         nlCxftMVP2U1mYfFQLEnE2HYIXWWQoA+vQTQu9nw=
Date:   Thu, 28 Nov 2019 11:36:04 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 00/95] 5.3.14-stable review
Message-ID: <20191128103604.GB3399855@kroah.com>
References: <20191127202845.651587549@linuxfoundation.org>
 <0c65f759-f22c-1b15-1f71-929def8ac43e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c65f759-f22c-1b15-1f71-929def8ac43e@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 09:15:45AM +0000, Jon Hunter wrote:
> 
> On 27/11/2019 20:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.14 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.14-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> ...
> 
> > Jouni Hogander <jouni.hogander@unikie.com>
> >     net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> 
> The above commit is causing a boot regression (NULL pointer deference
> crash) on Tegra210 for v5.3. Reverting this on top of 5.3.14-rc1 fixes
> the problem. Complete results for Tegra are here ...
> 
> Test results for stable-v5.3:
>     13 builds:	13 pass, 0 fail
>     24 boots:	18 pass, 6 fail
>     34 tests:	34 pass, 0 fail
> 
> Linux version:	5.3.14-rc1-g7173a2d18fa6
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

I've pushed out a -rc2 that should resolve this now.  If not, please let
me know.

thansk,

greg k-h
