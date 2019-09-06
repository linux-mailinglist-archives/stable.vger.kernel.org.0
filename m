Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9002EAB3CD
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 10:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389589AbfIFIQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 04:16:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726263AbfIFIQR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Sep 2019 04:16:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8531A207FC;
        Fri,  6 Sep 2019 08:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567757777;
        bh=3sLnj+Tc/pqn6UjHEL984J9vKbqhCcz5DUtjg/ZN+mI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H96/XIXwAJXCZ4TEg3+RTUF+UoXZibCrPywG72fFDkMwvXQLkxnFoz4C0gW7zj3ce
         UpSREKPGQti/Hzzc4dq44MM/9X8NeAppnQwIoWytZbBq7qpNz9XLCUS/SHiBtfL+TH
         CEUh3wW1S4+wQ7cy2fO7SzAbDDHZVMKIP1yOTS2w=
Date:   Fri, 6 Sep 2019 10:16:14 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.2 000/143] 5.2.12-stable review
Message-ID: <20190906081614.GA32667@kroah.com>
References: <20190904175314.206239922@linuxfoundation.org>
 <5b19ac14-31c8-227d-c0c5-741abb65b7d6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b19ac14-31c8-227d-c0c5-741abb65b7d6@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 06, 2019 at 08:37:33AM +0100, Jon Hunter wrote:
> 
> On 04/09/2019 18:52, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.2.12 release.
> > There are 143 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.12-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.2.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests are passing for Tegra ...
> 
> Test results for stable-v5.2:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     38 tests:	38 pass, 0 fail
> 
> Linux version:	5.2.12-rc1-gb6eedcb8cf66
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
