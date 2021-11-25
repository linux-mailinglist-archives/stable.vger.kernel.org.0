Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B4E45DA9A
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353928AbhKYND5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:47722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237495AbhKYNB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:01:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE5461074;
        Thu, 25 Nov 2021 12:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637845126;
        bh=UYCR0tASB8dUv3s1+0oj4OtCgNOMSymxHKXTIVtL5Mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TkD212Xh0U8lerEWbfi5hh0lhcsRfGLzYr10qroNGmGHrFIVzLDDyA3xwTG+hB+j2
         9yThdSkQmb+VeGp5PxxGGHwCF8hH2OiqZ8cCQxmB1o/ZKQtM5sj9hhmWetVskN/fjX
         hu3Xq86YocmoX+p5XPw5UkQa02SLGAn1NohEuKA0=
Date:   Thu, 25 Nov 2021 13:58:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/207] 4.9.291-rc1 review
Message-ID: <YZ+IcafCZMX8gj+9@kroah.com>
References: <20211124115703.941380739@linuxfoundation.org>
 <20211125015016.GG851427@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125015016.GG851427@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 05:50:16PM -0800, Guenter Roeck wrote:
> On Wed, Nov 24, 2021 at 12:54:31PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.291 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 163 pass: 134 fail: 29
> Failed builds:
> 	arm:allnoconfig
> 	arm:tinyconfig
> 	arm:efm32_defconfig
> 	blackfin:defconfig
> 	blackfin:BF561-EZKIT-SMP_defconfig
> 	c6x:dsk6455_defconfig
> 	c6x:evmc6457_defconfig
> 	c6x:evmc6678_defconfig
> 	h8300:allnoconfig
> 	h8300:tinyconfig
> 	h8300:edosk2674_defconfig
> 	h8300:h8300h-sim_defconfig
> 	h8300:h8s-sim_defconfig
> 	ia64:defconfig
> 	m68k:allnoconfig
> 	m68k:tinyconfig
> 	m68k_nommu:m5272c3_defconfig
> 	m68k_nommu:m5307c3_defconfig
> 	m68k_nommu:m5249evb_defconfig
> 	m68k_nommu:m5407c3_defconfig
> 	microblaze:nommu_defconfig
> 	microblaze:allnoconfig
> 	microblaze:tinyconfig
> 	s390:defconfig
> 	s390:allmodconfig
> 	s390:performance_defconfig
> 	sh:dreamcast_defconfig
> 	sh:microdev_defconfig
> 	sh:shx3_defconfig
> Qemu test results:
> 	total: 396 pass: 389 fail: 7
> Failed tests:
> 	arm:mps2-an385:mps2_defconfig:mps2-an385:initrd
> 	mcf5208evb:m5208:m5208evb_defconfig:initrd
> 	s390:defconfig:nolocktests:smp2:net,default:initrd
> 	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
> 	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
> 	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
> 	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs
> 
> include/asm-generic/tlb.h: In function 'tlb_flush_pmd_range':
> include/asm-generic/tlb.h:208:54: error: 'PMD_SIZE' undeclared
> 
> mm/hugetlb.c: In function '__unmap_hugepage_range':
> mm/hugetlb.c:3415:25: error: implicit declaration of function 'tlb_flush_pmd_range'
> 
> Guenter

Hopefully all now fixed in -rc2
