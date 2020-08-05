Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FDB23D1B4
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgHEUFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727800AbgHEQge (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Aug 2020 12:36:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6728E23341;
        Wed,  5 Aug 2020 16:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596643515;
        bh=yWtbMl/+wThLYSS2Eldoo0aEn85CUrWVhJCY9Zb7LI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bxg5nXr619K4cYXb6QIZQAHb+pIQxqg99jzmCoZ5MiWUhkHnt+A7IOqq1t5v+A7uK
         c3j5WXuGZFnYe/zOv1GyQxCU3yeTc7VGGwLLXzk6LY4O5ZtATMfKT+v1TaBLLt2ZCJ
         Rk9ZfREnJd6DqYDJSED30gVufG+AOJt/zdXnnups=
Date:   Wed, 5 Aug 2020 18:05:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
Message-ID: <20200805160532.GA2421796@kroah.com>
References: <20200804085233.484875373@linuxfoundation.org>
 <42f62b34e93b43a58ec90b6f8b973bae@HQMAIL107.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42f62b34e93b43a58ec90b6f8b973bae@HQMAIL107.nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 03:52:46PM +0000, Jon Hunter wrote:
> On Tue, 04 Aug 2020 10:53:53 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.7.13 release.
> > There are 116 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc3.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> All tests passing for Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.7.13-rc3-gd3223abaf6fd
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Thanks for testing all of these and letting me know.

greg k-h
