Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A9F3322F6
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 11:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbhCIK0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 05:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbhCIK0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 05:26:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4001265268;
        Tue,  9 Mar 2021 10:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615285572;
        bh=FJOJh+a4KsEIpSu9f2mvUj9VhUwHYafoF3hxt5lplFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qyQrCEMnZ9EUAvHNU+TEoTGlm2+Ee1Ev4+M6gAV72fkREvQySCvtTYOHrcqE0Tjk+
         QwpZAa3mpSl/2YoDRNn7d5iVpHlf8Be3zM9DdRCYa/Dvx1b1l+pWS3ATkbKOxiHDzg
         M84WQkJNidY0zFk73u5NeRPN8n+K16wnpkS6dvwE=
Date:   Tue, 9 Mar 2021 11:26:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.11 00/44] 5.11.5-rc1 review
Message-ID: <YEdNQh3H9O4WpQF0@kroah.com>
References: <20210308122718.586629218@linuxfoundation.org>
 <76e87d7a575a48389a952e5b035d0da4@HQMAIL111.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76e87d7a575a48389a952e5b035d0da4@HQMAIL111.nvidia.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 05:18:55PM +0000, Jon Hunter wrote:
> On Mon, 08 Mar 2021 13:34:38 +0100, gregkh@linuxfoundation.org wrote:
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > This is the start of the stable review cycle for the 5.11.5 release.
> > There are 44 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.5-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.11:
>     12 builds:	12 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     65 tests:	65 pass, 0 fail
> 
> Linux version:	5.11.5-rc1-g89449ac6c715
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 
> Tested-by: Jon Hunter <jonathanh@nvidia.com>

Thanks for testing them all and letting me know.

greg k-h
