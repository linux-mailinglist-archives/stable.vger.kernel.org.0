Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33042EA6E0
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbhAEJFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:05:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbhAEJFo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:05:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEDED22525;
        Tue,  5 Jan 2021 09:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609837503;
        bh=9ILBRlpQgEWJtJmL8YlGbIKf63DtLi3G/jDj6qgI+Jg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=19eVbm1WvooXF6V+cMZXGxkiJkmNQe1qxq90K6efotzbKwfPfW+jPC/6YAaR5suzE
         57B3ztGEmjGmhXdnrKDPns6r8Y4yfEC8oXn6IguK4nSL1CtlFvfAQlZQmw7i/0ZX8Q
         oSamBjUp2jbumyrPJIzRQ3H+TexRX263Rj5uJlD4=
Date:   Tue, 5 Jan 2021 10:06:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/35] 4.19.165-rc1 review
Message-ID: <X/QsE8gVbjudp2t6@kroah.com>
References: <20210104155703.375788488@linuxfoundation.org>
 <cff87cd2-8cd5-241e-3a05-a817b1a56b8c@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cff87cd2-8cd5-241e-3a05-a817b1a56b8c@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 05:58:25PM -0800, Guenter Roeck wrote:
> On 1/4/21 7:57 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.165 release.
> > There are 35 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v4.19.164-36-g32d98dff91da:
> 
> arm:axm55xx_defconfig, arm:keystone_defconfig:
> 
> mm/memory.c: In function 'tlb_table_invalidate':
> mm/memory.c:342:6: error: implicit declaration of function 'tlb_needs_table_invalidate'
> 
> All c6x, all h8300, m68k:allnoconfig, arm:allnoconfig, microblaze:nommu_defconfig
> and others:
> 
>   CC      mm/oom_kill.o
> In file included from ./arch/c6x/include/asm/tlb.h:7,
>                  from mm/oom_kill.c:45:
> ./include/asm-generic/tlb.h: In function 'tlb_get_unmap_shift':
> ./include/asm-generic/tlb.h:237:10: error: 'PMD_SHIFT' undeclared
> ./include/asm-generic/4level-fixup.h:8:21: error: 'PGDIR_SHIFT' undeclared

Thanks, will drop the series that caused this.

greg k-h
