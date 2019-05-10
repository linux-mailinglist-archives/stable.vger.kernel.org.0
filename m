Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567D01A07E
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 17:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfEJPuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 11:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbfEJPuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 May 2019 11:50:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68DCE20881;
        Fri, 10 May 2019 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557503406;
        bh=6XS/y2LKTwwMVGJpYHLxVhWCXM3Xq7pp41eNi9G9N80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mzp0Zt8iwgLqZ1HYwx1OThinelOYT1jr20WmnK6gdofKkY7sifjhvd49XXpqr/lnP
         DwLxisnaB36JjBW7n7s+XUBUIRoBaiZsnaiKHOMbIeu1sd174s69SORKwlUDlb3Rb/
         9S6KVnCD1UZ7Zqc5UuMaZRx1AQU/anZWLzBSP7A8=
Date:   Fri, 10 May 2019 17:50:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.1 00/30] 5.1.1-stable review
Message-ID: <20190510155004.GB2209@kroah.com>
References: <20190509181250.417203112@linuxfoundation.org>
 <61c05635-32ea-cb62-cf3a-44d9c57836d7@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61c05635-32ea-cb62-cf3a-44d9c57836d7@nvidia.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 11:18:07AM +0100, Jon Hunter wrote:
> 
> On 09/05/2019 19:42, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.1.1 release.
> > There are 30 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 11 May 2019 06:11:35 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.1-rc1.gz
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
> Linux version:	5.1.1-rc1-ge4f05f7
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Wonderful, thanks for testing all of these and letting me know.

greg k-h
