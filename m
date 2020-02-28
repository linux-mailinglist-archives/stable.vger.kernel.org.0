Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA441738E6
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 14:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgB1Nvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 08:51:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgB1Nvj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 08:51:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E6D424677;
        Fri, 28 Feb 2020 13:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582897899;
        bh=05G0EB9j/ZFmhrVZSw2GIEfjI/gkXq5k0N1duTX8tUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VEVzyR/PXiSWkFweAWzDi5EwdKX8ovSxdqp6swQbtEFrsVR+58JzejAr9jIiRQQLr
         UG5CHNFpkM/ZBhEJuTsKBuK8FWHnWeru8N3/JObZl9Sh5oi4ZjNQSJo7DqFhBawTev
         90eON7vqJ3eASD9z2FFlP6fheqNkRVhLY/C0Haw8=
Date:   Fri, 28 Feb 2020 14:51:37 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.5 000/150] 5.5.7-stable review
Message-ID: <20200228135137.GB3049877@kroah.com>
References: <20200227132232.815448360@linuxfoundation.org>
 <7cb3b57b-6a56-7b64-c572-a6f77e7f43b4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cb3b57b-6a56-7b64-c572-a6f77e7f43b4@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 06:53:01PM +0000, Jon Hunter wrote:
> 
> On 27/02/2020 13:35, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.7 release.
> > There are 150 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.5:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     40 tests:	40 pass, 0 fail
> 
> Linux version:	5.5.7-rc1-g986ea77a7c44
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
