Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9786285BA8
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 11:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgJGJMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 05:12:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgJGJMB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 05:12:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67EF6204EC;
        Wed,  7 Oct 2020 09:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602061920;
        bh=osYByLtBDpMOs1YNcRCYEpOPa7uW5uENulIzE5srqWs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZbN/CTKvoac6Q+124snHo7uH5cClGv65gFlvNr0qF4imRj4cXln44uzLBsEGp7iEv
         1iJX6QhwfKjN6JbmbcfOc9r7sW2CDTBCsok7iwhUdpU3U1Y+eaCJwzczh0gJVnP4Ew
         dA6Uwv4Dc2tZ/+7Qedv+J7w42J06uqaXNBhUzBZU=
Date:   Wed, 7 Oct 2020 11:12:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.8 00/85] 5.8.14-rc1 review
Message-ID: <20201007091245.GE614379@kroah.com>
References: <20201005142114.732094228@linuxfoundation.org>
 <6d5c5d01ce7c4108b8610141d8c8648d@HQMAIL109.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d5c5d01ce7c4108b8610141d8c8648d@HQMAIL109.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 05, 2020 at 05:50:43PM +0000, Jon Hunter wrote:
> On Mon, 05 Oct 2020 17:25:56 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.14 release.
> > There are 85 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.14-rc1.gz
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
>     15 builds:	15 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     60 tests:	60 pass, 0 fail
> 
> Linux version:	5.8.14-rc1-g8bb413de12d0
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing these so quickly and letting me know.

greg k-h
