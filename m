Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F9020D66
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbfEPQuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726853AbfEPQuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 12:50:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC80205ED;
        Thu, 16 May 2019 16:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558025409;
        bh=LmBKXiHfrotUexFa5IXxJZ0NgFBhp3cJw8uJBHpEHCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ab7tS6FeSRr0h/GQCkbVEYPabvb+6iqLdyHd7/UO1C9SLjUmxrvedqvNkvnFCHlB1
         LUaKQbg5BueZhU00/434WuUz6o1pf1M1qe5v4pwBY/3KTRVGKlCGhuS/MhjEigvJb2
         +mxHtnqG/SczCnuXq4GpNMrlQMBDjysO7oEbhQfM=
Date:   Thu, 16 May 2019 18:50:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 00/46] 5.1.3-stable review
Message-ID: <20190516165006.GC12641@kroah.com>
References: <20190515090616.670410738@linuxfoundation.org>
 <5b7b4163-f616-3cd8-ea45-3fd3f495ae7f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b7b4163-f616-3cd8-ea45-3fd3f495ae7f@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 12:04:32PM +0100, Jon Hunter wrote:
> 
> On 15/05/2019 11:56, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.3 release.
> > There are 46 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 17 May 2019 09:04:22 AM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.3-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.1:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	5.1.3-rc1-g6c9703a
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Thanks for testing all of these and letting me know.

greg k-h
