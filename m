Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCFD14CB9E
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 14:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgA2NnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 08:43:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgA2NnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 Jan 2020 08:43:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C311520716;
        Wed, 29 Jan 2020 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580305395;
        bh=mPG2NT4cUEbzhyg1YZWahjafjI8KXDXQcAkUMLuZv+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rkCR60Q0DM8LOsd5T2dxkonCoozN3jfvsANgsd+MG0eZv18mmhU4FOI4hXC+AWeDb
         izx8PzQT7yXsAuJXcPok1ErOGOEAXt/YGmwLNGzAHkCnrasG2M09fyANDMhmxKiX0A
         OT4fy98l/5ynGfzNKpRuupLDpv5Pby8tOfmffGys=
Date:   Wed, 29 Jan 2020 14:43:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 000/104] 5.4.16-stable review
Message-ID: <20200129134313.GB21979@kroah.com>
References: <20200128135817.238524998@linuxfoundation.org>
 <6e27f82c-1804-8041-dd93-7c9e7b5b6c0b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e27f82c-1804-8041-dd93-7c9e7b5b6c0b@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 29, 2020 at 01:16:44PM +0000, Jon Hunter wrote:
> 
> On 28/01/2020 13:59, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.16 release.
> > There are 104 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.4:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.4.16-rc1-g4acf9f18a8fe
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
