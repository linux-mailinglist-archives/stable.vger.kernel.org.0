Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A77102443
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfKSMY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:24:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbfKSMYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 07:24:21 -0500
Received: from localhost (unknown [89.205.136.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7D00222A0;
        Tue, 19 Nov 2019 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574166260;
        bh=SSH7vaJkbgV5ugiuRokCYx/zatWjKWwhP+0/2KTvfX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jM58IC6IPx6LnbGkZauR/YnYJqEcxwSm1zDA4hjoM3IR1YrFIdS+fEqh+GEcmneUo
         gv/keV1O3l7j+gLr6f0r6SU7uTxlBKci91wHnnixUYn+ri4ktrQJgcPyS7Zttz2+tx
         x2Q+tUGiB+3i0JRNj2Cz5YADamxtmg14W8dz2pNc=
Date:   Tue, 19 Nov 2019 13:24:17 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/422] 4.19.85-stable review
Message-ID: <20191119122417.GA1913916@kroah.com>
References: <20191119051400.261610025@linuxfoundation.org>
 <20468dbc-5b88-f86e-9d5d-5edca4e4be2b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20468dbc-5b88-f86e-9d5d-5edca4e4be2b@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 09:18:03AM +0000, Jon Hunter wrote:
> 
> On 19/11/2019 05:13, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.85 release.
> > There are 422 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.85-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> ...
> 
> > Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> >     ARM: dts: meson8b: odroidc1: enable the SAR ADC
> 
> This commit is generating the following compilation error for ARM ...
> 
> arch/arm/boot/dts/meson8b-odroidc1.dtb: ERROR (phandle_references): /soc/cbus@c1100000/adc@8680: Reference to non-existent node or label "vcc_1v8"
> 
> ERROR: Input tree has errors, aborting (use -f to force output)
> scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/meson8b-odroidc1.dtb' failed
> make[1]: *** [arch/arm/boot/dts/meson8b-odroidc1.dtb] Error 2
> arch/arm/Makefile:348: recipe for target 'dtbs' failed
> make: *** [dtbs] Error 2

Thanks, will go remove that patch.

greg k-h
