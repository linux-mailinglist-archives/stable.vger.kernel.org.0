Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22B5107392
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 14:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKVNqr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 08:46:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfKVNqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 08:46:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B57A2071B;
        Fri, 22 Nov 2019 13:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574430405;
        bh=iAmo2lEFUVhmgTBOcCPE/v+ecRZuhmQraS5r2M3jAmQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qqwQzQyyHLGPzrWW9hej1yI5j9pV0/9vtVypkxot/HYuaD+Pw6CgTho5JJgMOi1Zq
         5pc/T9MRYG2khemekqClfpNXlDMywPi713uGueX2UNYNf/WrctgI5Ps1QYM55gLNjR
         rlAxBTVfFiNqlFL7kJ8bzQekzO4KC83Bd4zUYIQE=
Date:   Fri, 22 Nov 2019 14:46:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.3 0/6] 5.3.13-stable review
Message-ID: <20191122134642.GC2050590@kroah.com>
References: <20191122100320.878809004@linuxfoundation.org>
 <62565468-197e-b572-5123-157136937ff4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62565468-197e-b572-5123-157136937ff4@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 01:39:06PM +0000, Jon Hunter wrote:
> 
> On 22/11/2019 10:30, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.13 release.
> > There are 6 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.13-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.3:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.3.13-rc1-g6b14caa1dc57
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Great, thanks for testing all of these and letting me know.

greg k-h
