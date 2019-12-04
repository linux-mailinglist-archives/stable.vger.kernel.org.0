Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B14A01130A4
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfLDRSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:18:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfLDRSW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:18:22 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66F622064B;
        Wed,  4 Dec 2019 17:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575479901;
        bh=dEMb+VVPBIAIGBDAsgEQgpSLLBrYItHfqL/OySsZkUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pd8pH20A4x0UvWGanCmL8j9siUgnP4y1cfNyzvC8sVhQCMxjjJdFhGhKyFYlKz38L
         V1ajbW5UVPDikPnHSJ/jnznxynaiedRX6zyIvn2BFNdAjKt7s0wdFjJrR1bNMVidwA
         YcoWsPNqL99BOYnwlfuY5746jnr6MMMpYHWLzcAk=
Date:   Wed, 4 Dec 2019 18:18:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/321] 4.19.88-stable review
Message-ID: <20191204171819.GC3627415@kroah.com>
References: <20191203223427.103571230@linuxfoundation.org>
 <79c636e7-145b-3062-04a3-f03c78d51318@nvidia.com>
 <20191204112936.GA3565947@kroah.com>
 <4f1552b1-ff6b-7342-b66e-04685aacf6ea@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f1552b1-ff6b-7342-b66e-04685aacf6ea@nvidia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 04, 2019 at 02:53:24PM +0000, Jon Hunter wrote:
> 
> On 04/12/2019 11:29, Greg Kroah-Hartman wrote:
> > On Wed, Dec 04, 2019 at 09:45:31AM +0000, Jon Hunter wrote:
> >>
> >> On 03/12/2019 22:31, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 4.19.88 release.
> >>> There are 321 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Thu, 05 Dec 2019 22:30:32 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.88-rc1.gz
> >>> or in the git tree and branch at:
> >>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> >>> and the diffstat can be found below.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>>
> >>> -------------
> >>> Pseudo-Shortlog of commits:
> >>
> >> ...
> >>
> >>> Ding Tao <miyatsu@qq.com>
> >>>     arm64: dts: marvell: armada-37xx: Enable emmc on espressobin
> >>
> >> The above commit is causing the following build failure for ARM64 ...
> >>
> >>   DTC     arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb
> >> arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb: ERROR
> >> (phandle_references): /soc/internal-regs@d0000000/sdhci@d0000: Reference
> >> to non-existent node or label "sdio_pins"
> >>
> >> arch/arm64/boot/dts/marvell/armada-3720-espressobin.dtb: ERROR
> >> (phandle_references): /soc/internal-regs@d0000000/sdhci@d8000: Reference
> >> to non-existent node or label "mmc_pins"
> > 
> > Thanks for letting me know, I'll go drop this one and push out a -rc2
> > with that removed.
> 
> 
> Great! All tests now passing for Tegra ...
> 
> Test results for stable-v4.19:
>     13 builds:	13 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	4.19.88-rc2-gba731ec12c66
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04

Wonderful, thanks for testing all of these and letting me know.

greg k-h
