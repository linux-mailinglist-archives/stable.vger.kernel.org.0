Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2693519A8B7
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 11:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgDAJeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 05:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDAJeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 05:34:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEC52077D;
        Wed,  1 Apr 2020 09:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585733647;
        bh=ygn69CFIGLehSFM4Xy0zGpVwdoajAhY/hL9FFPbt0lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i+K+mEhg28YPwIosrGBMkhDSyyPqqvEw6WedSnnyJDscvEqhp6E93PemYZw8WygxQ
         naaLmczIieJ8yw16gMF2ArztsQhin1aTuW7WSeW4053ZRZKpfiuF+bwapwEiBFWB0L
         ZFGWwhJApQOT3uzT0uM7tAT9I4/G2fPOudZsmDVg=
Date:   Wed, 1 Apr 2020 11:33:59 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
Message-ID: <20200401093359.GD2055942@kroah.com>
References: <20200331085308.098696461@linuxfoundation.org>
 <d0744ad0-40b4-3bea-4d4f-1faf562126ec@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0744ad0-40b4-3bea-4d4f-1faf562126ec@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 09:57:37AM +0100, Jon Hunter wrote:
> 
> On 31/03/2020 09:59, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.1 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.1-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.6:
>     13 builds:	13 pass, 0 fail
>     24 boots:	24 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.6.1-rc1-g579bffceae01
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
