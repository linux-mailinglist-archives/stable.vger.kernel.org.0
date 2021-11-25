Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F9F45DABE
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:08:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349482AbhKYNL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:49000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351887AbhKYNKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 606A060E98;
        Thu, 25 Nov 2021 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637845660;
        bh=Lyze0CJuHLBnkzbtgXjCsnnaQHJlURAv53rdtQBXlCM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNMjKX9amEVPgYGwuo8dpErbjJYhgUZPzDVNJpYdnqUwziUWPx9D+qdPhMJd+u6JF
         jxJBm1txkOTWdiSK/UQpBra9dw6H7SfpoN4bnNeWrn4so9QKMzL3ZaJovFXDqCthcI
         Fnh1At/IKiMFf+SN/VKcP//6zSV0x03QN30e80sI=
Date:   Thu, 25 Nov 2021 14:07:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/251] 4.14.256-rc1 review
Message-ID: <YZ+KlwbKUJILMuBf@kroah.com>
References: <20211124115710.214900256@linuxfoundation.org>
 <20211125013850.GB851427@roeck-us.net>
 <YZ+HsDVL0sp0kPqr@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZ+HsDVL0sp0kPqr@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 01:55:12PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 24, 2021 at 05:38:50PM -0800, Guenter Roeck wrote:
> > On Wed, Nov 24, 2021 at 12:54:02PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.14.256 release.
> > > There are 251 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 168 pass: 161 fail: 7
> > Failed builds:
> > 	ia64:defconfig
> > 	s390:defconfig
> > 	s390:allmodconfig
> > 	s390:performance_defconfig
> > 	sh:dreamcast_defconfig
> > 	sh:microdev_defconfig
> > 	sh:shx3_defconfig
> > Qemu test results:
> > 	total: 423 pass: 418 fail: 5
> > Failed tests:
> > 	s390:defconfig:nolocktests:smp2:net,default:initrd
> > 	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
> > 	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
> > 	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
> > 	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs
> > 
> > mm/hugetlb.c: In function '__unmap_hugepage_range':
> > mm/hugetlb.c:3411:25: error: implicit declaration of function 'tlb_flush_pmd_range'
> 
> Should be fixed in -rc1.

{sigh}  -rc2 I mean.

thanks,

greg k-h
