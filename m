Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9211C2364
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 07:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgEBFzY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 01:55:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgEBFzY (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 01:55:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94024208DB;
        Sat,  2 May 2020 05:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588398924;
        bh=sLWenKTlhPHQOEAoClbYSP7NR1pbio/GG4OtmtFK84Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BrfAqXMZ/Rvm1SPYQ7ODd5Y/GWijixkWmyJdms7X7916j0+bpqtWkG7zgLoetECFb
         JGIMP1+P38x49ZUCEqwtckf1gpG/Wd0Rwh14uZgxqNuhgkDgGcxcXTD7CBo6NQuCgh
         ihrXrFNVNrs6VctxUBX+mk4HdP2xg9PQkViB5GVE=
Date:   Sat, 2 May 2020 07:55:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/117] 4.14.178-rc1 review
Message-ID: <20200502055521.GA2516731@kroah.com>
References: <20200501131544.291247695@linuxfoundation.org>
 <20200501215936.GC44185@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501215936.GC44185@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 02:59:36PM -0700, Guenter Roeck wrote:
> On Fri, May 01, 2020 at 03:20:36PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.178 release.
> > There are 117 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> > Anything received after that time might be too late.
> > 
> Build results:
> 	total: 171 pass: 171 fail: 0
> Qemu test results:
> 	total: 405 pass: 394 fail: 11
> Failed tests:
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:initrd
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:ide:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:sdhci:mmc:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
> 	ppc64:mac99:ppc64_book3s_defconfig:smp:scsi[DC395]:rootfs
> 	ppc64:pseries:pseries_defconfig:initrd
> 	ppc64:pseries:pseries_defconfig:scsi:rootfs
> 	ppc64:pseries:pseries_defconfig:usb:rootfs
> 	ppc64:pseries:pseries_defconfig:sdhci:mmc:rootfs
> 	ppc64:pseries:pseries_defconfig:nvme:rootfs
> 	ppc64:pseries:pseries_defconfig:sata-sii3112:rootfs
> 
> Again, please drop "of: unittest: kmemleak on changeset destroy".

Now dropped from all trees, thanks.

greg k-h
