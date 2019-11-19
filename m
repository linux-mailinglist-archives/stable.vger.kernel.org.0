Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3856D10289D
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 16:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbfKSPtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 10:49:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbfKSPtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 10:49:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82D99222AB;
        Tue, 19 Nov 2019 15:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574178540;
        bh=juNhTd9haTmYXvVnfVW3uB/ECZSFWaFuh0zX+uFUGI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RnBPqm1DjMPWZyaH6FlQ2+QgeUNTh+ntwzcsX9xq+LGyZkvF6abTeWQ+t8DFw+R/m
         22HASuWc2qgzAdzOkmgWXaU/H3FkcYJw0ztsrnVjcgHwdiH+slpNlumUG5nDuDQGnq
         cUK4aaEiabxBqsK6/X4/xRHXZLSODQfKuOkokJrY=
Date:   Tue, 19 Nov 2019 16:48:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.19 000/422] 4.19.85-stable review
Message-ID: <20191119154857.GC1982025@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20468dbc-5b88-f86e-9d5d-5edca4e4be2b@nvidia.com>
 <20191119122417.GA1913916@kroah.com>
 <20191119123003.GA1948960@kroah.com>
 <5598bd6b-c08e-d6e2-c5c3-70b53c95298e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5598bd6b-c08e-d6e2-c5c3-70b53c95298e@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 03:07:30PM +0000, Jon Hunter wrote:
> 
> On 19/11/2019 12:30, Greg Kroah-Hartman wrote:
> > On Tue, Nov 19, 2019 at 01:24:17PM +0100, Greg Kroah-Hartman wrote:
> >> On Tue, Nov 19, 2019 at 09:18:03AM +0000, Jon Hunter wrote:
> >>>
> >>> On 19/11/2019 05:13, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 4.19.85 release.
> >>>> There are 422 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>> The whole patch series can be found in one patch at:
> >>>> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.85-rc1.gz
> >>>> or in the git tree and branch at:
> >>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> >>>> and the diffstat can be found below.
> >>>>
> >>>> thanks,
> >>>>
> >>>> greg k-h
> >>>>
> >>>> -------------
> >>>
> >>> ...
> >>>
> >>>> Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> >>>>     ARM: dts: meson8b: odroidc1: enable the SAR ADC
> >>>
> >>> This commit is generating the following compilation error for ARM ...
> >>>
> >>> arch/arm/boot/dts/meson8b-odroidc1.dtb: ERROR (phandle_references): /soc/cbus@c1100000/adc@8680: Reference to non-existent node or label "vcc_1v8"
> >>>
> >>> ERROR: Input tree has errors, aborting (use -f to force output)
> >>> scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/meson8b-odroidc1.dtb' failed
> >>> make[1]: *** [arch/arm/boot/dts/meson8b-odroidc1.dtb] Error 2
> >>> arch/arm/Makefile:348: recipe for target 'dtbs' failed
> >>> make: *** [dtbs] Error 2
> >>
> >> Thanks, will go remove that patch.
> > 
> > -rc2 is out with that patch removed.
> 
> All tests for Tegra are passing ...
> 
> Test results for stable-v4.19:
>     12 builds:	12 pass, 0 fail
>     22 boots:	22 pass, 0 fail
>     32 tests:	32 pass, 0 fail
> 
> Linux version:	4.19.85-rc2-gaf1bb7db3102
> Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
>                 tegra194-p2972-0000, tegra20-ventana,
>                 tegra210-p2371-2180, tegra30-cardhu-a04
> 

Great, thanks for testing this and 4.14.

greg k-h
