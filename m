Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BAD45DACA
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355091AbhKYNRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:17:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352149AbhKYNPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:15:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23CB60F5B;
        Thu, 25 Nov 2021 13:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637845921;
        bh=ujQHkI/fTsWp3LkZ6LuLZaKOMXrVwil7X8K69Jv+MXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h78FDQikAi9QY1TlInMQduqcZJL8xjBXSBTwwg51CdmRX79JcqyWWStugG1GdDRyH
         VnwTv5xTubWcGODTMuImXMDgSGHx+oz3yEZ1Kt+rxulmKIRL11IjjvkZPvZKaYhae0
         eCZrcKAybG2VZzjNVaJO409oxMABzJhrn2ZI+2U4=
Date:   Thu, 25 Nov 2021 14:11:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/162] 4.4.293-rc1 review
Message-ID: <YZ+LlWx15bButJe8@kroah.com>
References: <20211124115658.328640564@linuxfoundation.org>
 <20211125013604.GA851427@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125013604.GA851427@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 05:36:04PM -0800, Guenter Roeck wrote:
> On Wed, Nov 24, 2021 at 12:55:03PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.4.293 release.
> > There are 162 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 160 pass: 153 fail: 7
> Failed builds:
> 	ia64:defconfig
> 	s390:defconfig
> 	s390:allmodconfig
> 	s390:performance_defconfig
> 	sh:dreamcast_defconfig
> 	sh:microdev_defconfig
> 	sh:shx3_defconfig
> Qemu test results:
> 	total: 341 pass: 336 fail: 5
> Failed tests:
> 	s390:defconfig:nolocktests:smp2:net,default:initrd
> 	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
> 	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
> 	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
> 	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs
> 
> Unlike there are secondary issues, the errors are all due to:
> 
> mm/hugetlb.c: In function '__unmap_hugepage_range':
> mm/hugetlb.c:3294:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Hopefully all now resolved in -rc2.

thanks,

greg k-h
