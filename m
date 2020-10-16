Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049F82907D9
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 16:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409134AbgJPO7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 10:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407887AbgJPO7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 10:59:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23DD820723;
        Fri, 16 Oct 2020 14:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602860391;
        bh=GSZY6sHejgN8vNkkNjwxRDnRcllqsRJYfJxRW3MLcs4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R7zwmU34keOG9Bop567zYcDWJivxpTMy8Av9/Jx2CjMqa+i7zdSt7ImapcYoC2CXe
         /2dc9D7elIsxbgyJGhQIu9iPqlg0ho5K6jo5zrZWZkEa0c+rEpVMGeyNsPMFifzqzE
         RXqiVDnlYtvM+vRXrGgZnS0DjQqoL7bQmvSz/+Zs=
Date:   Fri, 16 Oct 2020 17:00:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.8 00/14] 5.8.16-rc1 review
Message-ID: <20201016150021.GA1807231@kroah.com>
References: <20201016090437.153175229@linuxfoundation.org>
 <7138d7bce8f8da009119f0107eeb7c85f67057b9.camel@rajagiritech.edu.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7138d7bce8f8da009119f0107eeb7c85f67057b9.camel@rajagiritech.edu.in>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 07:41:05PM +0530, Jeffrin Jose T wrote:
> On Fri, 2020-10-16 at 11:07 +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.8.16 release.
> > There are 14 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied,
> > please
> > let me know.
> > 
> > Responses should be made by Sun, 18 Oct 2020 09:04:25 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	
> > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.16-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> > stable-rc.git linux-5.8.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> hello,
> 
> Compiled and booted  5.8.16-rc1+ .Every thing looks clean except "dmesg
> -l warn"
> 
> ------x--------------x-----------------------------x-----------
> 
> $dmesg -l warn
> [    0.601699] MDS CPU bug present and SMT on, data leak possible. See 
> https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for
> more details.

Please see that link for more details :)

> [    0.603104]  #3

Odd.

> [    0.749457] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'

Why is this a warning?  Oh well.

> [   10.718252] i8042: PNP: PS/2 appears to have AUX port disabled, if
> this is incorrect please boot with i8042.nopnp

Is this incorrect?

> [   12.651483] sdhci-pci 0000:00:1e.6: failed to setup card detect gpio

Normal.

> [   14.398378] i2c_hid i2c-ELAN1300:00: supply vdd not found, using
> dummy regulator
> [   14.399033] i2c_hid i2c-ELAN1300:00: supply vddl not found, using
> dummy regulator

Both normal

> [   23.866580] systemd[1]: /lib/systemd/system/plymouth-
> start.service:16: Unit configured to use KillMode=none. This is unsafe,
> as it disables systemd's process lifecycle management for the service.
> Please update your service to use a safer KillMode=, such as 'mixed' or
> 'control-group'. Support for KillMode=none is deprecated and will
> eventually be removed.

Not the kernel.

> [   37.208082] uvcvideo 1-6:1.0: Entity type for entity Extension 4 was
> not initialized!
> [   37.208092] uvcvideo 1-6:1.0: Entity type for entity Processing 2
> was not initialized!
> [   37.208098] uvcvideo 1-6:1.0: Entity type for entity Camera 1 was
> not initialized!

Crummy device :(

> [   40.088516] FAT-fs (sda1): Volume was not properly unmounted. Some
> data may be corrupt. Please run fsck.

Please run fsck :)

thanks,

greg k-h
