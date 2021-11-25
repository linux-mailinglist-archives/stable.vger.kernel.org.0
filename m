Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24D4D45D8F6
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhKYLS0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:18:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235437AbhKYLQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:16:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30CB360FC1;
        Thu, 25 Nov 2021 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637838795;
        bh=TiPaDlIaJI4QBkssk+g1LhsEkDLmzCvQ6bPUb0AovtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UfvkYlFCu++VhvagJzNegqcMxi1YYx6/cUGheHn3KTzymBIOMW0OPbexRp9AHTJPT
         qmD91dycvkmLvPSrCa3VUvewzGGwsqvbhZE/Rp/I/Pbnz9ZD+u18zGdP1vF3XpJp2R
         J6D0eERnqcvfxie5jTehFLQVQTgxDp6AJNqwHT4c=
Date:   Thu, 25 Nov 2021 12:13:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/323] 4.19.218-rc1 review
Message-ID: <YZ9vxMTBUx6pieeh@kroah.com>
References: <20211124115718.822024889@linuxfoundation.org>
 <20211125014013.GC851427@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125014013.GC851427@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 05:40:13PM -0800, Guenter Roeck wrote:
> On Wed, Nov 24, 2021 at 12:53:10PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.218 release.
> > There are 323 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 155 pass: 147 fail: 8
> Failed builds:
> 	ia64:defconfig
> 	s390:defconfig
> 	s390:allmodconfig
> 	s390:performance_defconfig
> 	sh:defconfig
> 	sh:dreamcast_defconfig
> 	sh:microdev_defconfig
> 	sh:shx3_defconfig
> Qemu test results:
> 	total: 441 pass: 436 fail: 5
> Failed tests:
> 	s390:defconfig:nolocktests:smp2:net,default:initrd
> 	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
> 	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
> 	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
> 	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs
> 
> Again:
> 
> mm/hugetlb.c: In function '__unmap_hugepage_range':
> mm/hugetlb.c:3455:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Should now be fixed, will push out a -rc2 now.

thanks,

greg k-h
