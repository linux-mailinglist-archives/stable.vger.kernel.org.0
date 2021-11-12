Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A9544E7C1
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhKLNss (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:43744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231553AbhKLNss (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:48:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F13AB60F46;
        Fri, 12 Nov 2021 13:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636724757;
        bh=L5n8w70FnPbZodQEzdyGElpmeBfhZdnmYhzUlbHhoVQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hU/d/fXt0OQDfeG9JnGg2E1R/gOBockH9mBAvG0YIhmfB5fqGaB3b5HjAwhbnM3gE
         TahG+QuHbwdIS9Uhy8Igj9vGhj3KuIa7etMMks8nPQ4w9UqdquMaNor70ezgZ36MCj
         ljLpelYcE/m0KAeLwYUEEjO61QkhToCDVLxlyt+k=
Date:   Fri, 12 Nov 2021 14:45:54 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <YY5wEkw4hpvOclcS@kroah.com>
References: <20211110182002.964190708@linuxfoundation.org>
 <20211112011501.GA2588851@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211112011501.GA2588851@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 05:15:01PM -0800, Guenter Roeck wrote:
> On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.79 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 159 fail: 0
> Qemu test results:
> 	total: 474 pass: 469 fail: 5
> Failed tests:
> 	ppc64:powernv:powernv_defconfig:smp2:nvme:net,i82559a:rootfs
> 	ppc64:powernv:powernv_defconfig:usb-xhci:net,i82562:rootfs
> 	ppc64:powernv:powernv_defconfig:scsi[MEGASAS]:net,i82557a:rootfs
> 	ppc64:powernv:powernv_defconfig:smp2:sdhci:mmc:net,i82801:rootfs
> 	ppc64:powernv:powernv_defconfig:mtd32:net,rtl8139:rootfs
> 
> Reverting commit 8615ff6dd1ac ("mm: filemap: check if THP has hwpoisoned
> subpage for PMD page fault") fixes the problem.

Ugh, ok, I'm going to drop this patch (and the one before it) again.

thanks for the testing.

greg k-h
