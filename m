Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13F9108B13
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 10:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKYJlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 04:41:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbfKYJlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 04:41:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E61207FD;
        Mon, 25 Nov 2019 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574674878;
        bh=+Y6FIMc4+xqo5D5vbmeoa59aQM+tiG4yrw3isimy21M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdZ/Ar69kyQ4p7MLxhA2LWC/rkl+WJhM0vwykksYnDs8Mf+E1RCYSNzCma8THvDOF
         LWrRk4mMf07uylhXs1X60LCbztuv8Qzq9B7rei6FCUQEtD8qauGpuU4gXlUiNKPs78
         gL28Gwxp4rxEgUuDXS1LwRzkc5EkMRIuNPV2yAXI=
Date:   Mon, 25 Nov 2019 10:41:16 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jon Hunter <jonathanh@nvidia.com>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
Message-ID: <20191125094116.GA2340170@kroah.com>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
 <20191122133931.GA2033651@kroah.com>
 <20191122134131.GA2050590@kroah.com>
 <20191122134627.GB2050590@kroah.com>
 <9f976044-2dbc-6c19-11e7-210cd7ab35ea@nvidia.com>
 <a5d68f07-5f9a-2809-404d-bcd8ca593d70@roeck-us.net>
 <7edc9531-347e-9ac7-2583-5efb49acffdb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7edc9531-347e-9ac7-2583-5efb49acffdb@nvidia.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 24, 2019 at 08:31:46PM +0000, Jon Hunter wrote:
> 
> On 23/11/2019 15:46, Guenter Roeck wrote:
> > On 11/22/19 6:48 AM, Jon Hunter wrote:
> > 
> > [ ... ]
> > 
> >> Error: arch/arm/boot/dts/omap5-board-common.dtsi:636.1-6 Label or path
> >> dwc3 not found
> >> FATAL ERROR: Syntax error parsing input tree
> >> scripts/Makefile.lib:293: recipe for target
> >> 'arch/arm/boot/dts/omap5-igep0050.dtb' failed
> >> make[1]: *** [arch/arm/boot/dts/omap5-igep0050.dtb] Error 1
> >> arch/arm/Makefile:338: recipe for target 'dtbs' failed
> >> make: *** [dtbs] Error 2
> >>
> >>
> >> This is caused by the following commit ...
> >>
> >> commit d0abc07b3d752cbe2a8d315f662c53c772caed0f
> >> Author: H. Nikolaus Schaller <hns@goldelico.com>
> >> Date:   Fri Sep 28 17:54:00 2018 +0200
> >>
> >>      ARM: dts: omap5: enable OTG role for DWC3 controller
> >>
> > 
> > On top of the breakage caused by this patch, I would also argue
> > that it is not a bug fix and should not have been included
> > in the first place.
> > 
> > The dwc3 label was added with commit 4c387984618fe ("ARM: dts: omap5:
> > Add l4 interconnect hierarchy and ti-sysc data"). Given the size of
> > that patch, I highly doubt that a backport to 4.4 would work.

Good catch, I have now dropped both of these patches and pushed out a
-rc3

> FYI ... I am still seeing a build failure because of this with -rc2 ...

Can you see if -rc3 is also giving you problems?

thanks,

greg k-h
