Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8FD219C4B
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 11:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgGIJaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 05:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:34990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgGIJaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Jul 2020 05:30:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB9F20663;
        Thu,  9 Jul 2020 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594287005;
        bh=ty0qNkQb+mQZVOrqCFXZLCcTcwuD2qX6+r/mjdgtvss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0XezFJWdt8TX5AKXsCYPtKd4Mbqc6+K1SQGPJCabkV0wgzanLVbsqTJac9JtmblwL
         fOpdX0CZSwSgr1NRmUEjZPUfVSSoX0j4rzL2HnIz+VKinMU0MCazWveO59bczXTBue
         vduNcNlN/gFA2/ID6tXitgwC2pbgIDPDRKYIp1ZI=
Date:   Thu, 9 Jul 2020 11:30:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/65] 5.4.51-rc1 review
Message-ID: <20200709093012.GB46127@kroah.com>
References: <20200707145752.417212219@linuxfoundation.org>
 <6fbcdd30-68d3-e8c5-d762-7b8a8c48d112@nvidia.com>
 <20200708151500.GA710412@kroah.com>
 <14d23282-c871-3f9d-372c-06da693666e1@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14d23282-c871-3f9d-372c-06da693666e1@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 08, 2020 at 05:58:27PM +0100, Jon Hunter wrote:
> 
> On 08/07/2020 16:15, Greg Kroah-Hartman wrote:
> > On Wed, Jul 08, 2020 at 09:41:33AM +0100, Jon Hunter wrote:
> >>
> >> On 07/07/2020 16:16, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 5.4.51 release.
> >>> There are 65 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.51-rc1.gz
> >>> or in the git tree and branch at:
> >>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> >>> and the diffstat can be found below.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>
> >> All tests are passing for Tegra ...
> >>
> >> Test results for stable-v5.4:
> >>     11 builds:	11 pass, 0 fail
> >>     26 boots:	26 pass, 0 fail
> >>     56 tests:	56 pass, 0 fail
> >>
> >> Linux version:	5.4.51-rc1-g47d410b54275
> >> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
> >>                 tegra194-p2972-0000, tegra20-ventana,
> >>                 tegra210-p2371-2180, tegra210-p3450-0000,
> >>                 tegra30-cardhu-a04
> > 
> > Thanks for testing all of these and letting me know.
> 
> No problem. For some reason the v5.7 review email never made it to my
> inbox AFAICT. Who knows if it will show up tomorrow, but anyway it all
> looks good to Tegra ...
> 
> Test results for stable-v5.7:
>     11 builds:	11 pass, 0 fail
>     26 boots:	26 pass, 0 fail
>     56 tests:	56 pass, 0 fail
> 
> Linux version:	5.7.8-rc1-gb371afd12a48
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra210-p3450-0000,
>                 tegra30-cardhu-a04

Oh, nice, I was wondering why you didn't respond for that.

thanks for letting me know.

greg k-h
