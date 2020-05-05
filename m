Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA31C51B7
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 11:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgEEJSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 05:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgEEJSL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 05:18:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E805206B9;
        Tue,  5 May 2020 09:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588670290;
        bh=48jgJui8qvyIj0UaaRObokznR4S8ZMnbXp+v+J4To0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d3mPqOAVXCy+VmVix/b5D+jqi4EmHVOYPveduzgOtjVF7/Ly6mdn7vcWRUdcaFCDu
         0bMvHy315E0n67kuSerIo6utYeOI9Rs1mM6cbAvTREh0/XpGHviEx8ftRp7WCXun06
         l+pgv72/ystYBjHMr0UYWjnWWZ10DwJArDHSvNL4=
Date:   Tue, 5 May 2020 11:18:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.6 00/73] 5.6.11-rc1 review
Message-ID: <20200505091808.GB4172718@kroah.com>
References: <20200504165501.781878940@linuxfoundation.org>
 <f3d40fc3-1c82-5395-e96b-65e7ba9cbfc9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f3d40fc3-1c82-5395-e96b-65e7ba9cbfc9@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 05, 2020 at 09:38:43AM +0100, Jon Hunter wrote:
> 
> On 04/05/2020 18:57, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.6.11 release.
> > There are 73 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 06 May 2020 16:52:55 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.11-rc1.gz
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
> Linux version:	5.6.11-rc1-g6cd4bcd666cd
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
