Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6447BDB6
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 11:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbfGaJu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 05:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfGaJu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 31 Jul 2019 05:50:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5855E206A3;
        Wed, 31 Jul 2019 09:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564566626;
        bh=vrbRlMzlC4dHvznio07wq+yg6p9zQr7LuA+JFa0DvbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LWg7uq9jccRZy3xzJM6Gt5w7W/8UMEZLXZFYOZ+2pcZJQ7zJnIqqcMqnJdeXrKAPN
         O3o1i6VPXVnivYY81tl+PK/bDZSrXWWiOwV6tRZOAqlNqNdPQbK4+Gx9eEtI1j9xHa
         xERUB9A6AslFEbkM8tMDithWB/LIvKD/utheoOmk=
Date:   Wed, 31 Jul 2019 11:50:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/215] 5.2.5-stable review
Message-ID: <20190731095024.GA15283@kroah.com>
References: <20190729190739.971253303@linuxfoundation.org>
 <5247e345-d0b9-3b8e-9828-e45d0981a367@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5247e345-d0b9-3b8e-9828-e45d0981a367@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 31, 2019 at 10:36:58AM +0100, Jon Hunter wrote:
> 
> On 29/07/2019 20:19, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.5 release.
> > There are 215 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 31 Jul 2019 07:05:01 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.5-rc1.gz
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
> Linux version:	5.2.5-rc1-g0c4d120e771a
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
