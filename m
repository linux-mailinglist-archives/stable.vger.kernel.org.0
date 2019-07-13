Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0015D67A93
	for <lists+stable@lfdr.de>; Sat, 13 Jul 2019 16:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfGMOb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Jul 2019 10:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbfGMOb6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Jul 2019 10:31:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43C1420838;
        Sat, 13 Jul 2019 14:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563028316;
        bh=33zF0ftnIcvi6tcgUYR8fLfscOhnI8m8JzTBy8gi8bM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TAKCe0bDJT35XVZYtaZ9IkAzritYLPBDtA3/wA5Q0gF9d6EynHkpzIKXTn5BJ+HOm
         01gcufq+XuibiAckKkCe+Iw3bo8aCf6cX2xt1o9iAFCsrGkJd7I+yku75OjoMZp3g+
         C1w5B/GIqABs41SLiefg8iORbKSPkL/I9GCqyEOM=
Date:   Sat, 13 Jul 2019 16:31:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-tegra <linux-tegra@vger.kernel.org>, j-keerthy@ti.com
Subject: Re: [PATCH 5.1 000/138] 5.1.18-stable review
Message-ID: <20190713143154.GB7695@kroah.com>
References: <20190712121628.731888964@linuxfoundation.org>
 <4dae64c8-046e-3647-52d6-43362e986d21@nvidia.com>
 <20190712153035.GC13940@kroah.com>
 <5f897de4-b423-c8a2-6823-d0227eb7bd38@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f897de4-b423-c8a2-6823-d0227eb7bd38@nvidia.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 13, 2019 at 10:16:58AM +0100, Jon Hunter wrote:
> 
> On 12/07/2019 16:30, Greg Kroah-Hartman wrote:
> > On Fri, Jul 12, 2019 at 02:26:57PM +0100, Jon Hunter wrote:
> >> Hi Greg,
> >>
> >> On 12/07/2019 13:17, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 5.1.18 release.
> >>> There are 138 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, please
> >>> let me know.
> >>>
> >>> Responses should be made by Sun 14 Jul 2019 12:14:36 PM UTC.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.18-rc1.gz
> >>> or in the git tree and branch at:
> >>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
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
> >>> Keerthy <j-keerthy@ti.com>
> >>>     ARM: dts: dra71x: Disable usb4_tm target module
> >>
> >> ...
> >>
> >>> Keerthy <j-keerthy@ti.com>
> >>>     ARM: dts: dra76x: Disable usb4_tm target module
> >>
> >> The above commits are generating the following compilation errors for
> >> ARM ...
> >>
> >> Error:
> >> /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra71x.dtsi:15.1-9
> >> Label or path usb4_tm not found
> >>
> >> Error:
> >> /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra76x.dtsi:89.1-9
> >> Label or path usb4_tm not found
> >>
> >> After reverting these two, I no longer see these errors.
> > 
> > Both are now dropped, thanks.  I'll push out a -rc2 with that changed.
> 
> Hmmm ... -rc2 still not building ...
> 
> Error:
> /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra71x.dtsi:11.1-11
> Label or path rtctarget not found
> Error:
> /dvs/git/dirty/git-master_l4t-upstream/kernel/arch/arm/boot/dts/dra71x.dtsi:15.1-9
> Label or path usb4_tm not found
> 
> I still see the following commit in -rc2 ...
> 
> commit 0caa574b3244cd863dd74bde680a6309cb8803ad
> Author: Keerthy <j-keerthy@ti.com>
> Date:   Fri May 17 06:44:09 2019 +0530
> 
>     ARM: dts: dra71x: Disable usb4_tm target module
> 
> In -rc1 I see there were 4 changes from Keerthy, any chance you reverted
> one of the rtc patches and not the above? Looks like the following is
> missing from -rc2 ...
> 
> Keerthy <j-keerthy@ti.com>
>     ARM: dts: dra76x: Disable rtc target module

Sorry, I dropped one, but not the other.  Both now gone.

thanks,

greg k-h
