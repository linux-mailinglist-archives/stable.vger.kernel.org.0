Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9020887E76
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 17:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436836AbfHIPtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 11:49:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436655AbfHIPtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 11:49:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10D6A214C6;
        Fri,  9 Aug 2019 15:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565365743;
        bh=L0lHJ8jW+AhQXl+lJraOaNnNIWVCBRVByQboI5E+1XM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aCIUvessXBGskz8SabBb4lbM/+KCk2PRNSnHsSeOwyXbdlh/oDCGC0W3sKvq2G/YB
         yPktEkI1OKxmRhc2mJqa70JzZeEfa9aOBbxlJ/D0+rZnMKjwo1mA17qoh4NgMQ/AhS
         0xK23T5p3Dzi+saC7bUvIiJf2qfHK81uV8zlxwaM=
Date:   Fri, 9 Aug 2019 17:49:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thierry Reding <treding@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.2 00/56] 5.2.8-stable review
Message-ID: <20190809154901.GC22879@kroah.com>
References: <20190808190452.867062037@linuxfoundation.org>
 <20190809144846.25144-1-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809144846.25144-1-treding@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 04:48:46PM +0200, Thierry Reding wrote:
> On Thu, 08 Aug 2019 21:04:26 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.8 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 10 Aug 2019 07:03:19 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.8-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.8-rc1-gbd703501e2df
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Great!  Thanks for testing these and letting me know.

greg k-h
