Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86E33CBBB7
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 20:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhGPSRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 14:17:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGPSRs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Jul 2021 14:17:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 281BC613E8;
        Fri, 16 Jul 2021 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626459293;
        bh=SZfc+sdSOFegaE81x5f6nVJYG6futv/Q4DezfpI2gQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CAtDKmW2Ro6DrYpi7RZvEA32h78w7LDuAV+vFugEo+pytrxARWXCSWrtESLc3pCAj
         vAzlF58QhsO62egjJOqfZVaRK1VxvH0ywQGOjuaPr13arndDKijKn5eaywMM7kPpbA
         cPGPBbu7rIxl/F4JUn0PaO1N3okn3ruGT9CmWrcA=
Date:   Fri, 16 Jul 2021 20:14:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/215] 5.10.51-rc1 review
Message-ID: <YPHMm+fjen2Nvxlj@kroah.com>
References: <20210715182558.381078833@linuxfoundation.org>
 <53f95a72-996a-ace3-9d34-60f23f4813b3@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53f95a72-996a-ace3-9d34-60f23f4813b3@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 06:33:27AM -0700, Guenter Roeck wrote:
> On 7/15/21 11:36 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.51 release.
> > There are 215 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> > Anything received after that time might be too late.
> > 
> 
> 
> Building ia64:defconfig ... failed
> --------------
> Error log:
> <stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
> mm/page_alloc.c:6270:20: error: conflicting types for 'memmap_init'; have 'void(void)'
>  6270 | void __init __weak memmap_init(void)
>       |                    ^~~~~~~~~~~
> In file included from include/linux/pgtable.h:6,
>                  from include/linux/mm.h:33,
>                  from mm/page_alloc.c:19:
> arch/ia64/include/asm/pgtable.h:523:17: note: previous declaration of 'memmap_init' with type 'void(long unsigned int,  int,  long unsigned int,  long unsigned int)'
>   523 |     extern void memmap_init (unsigned long size, int nid, unsigned long zone,
>       |                 ^~~~~~~~~~~

Found the offending commit, now dropped.

Will push out -rc2 for all trees now, what a mess...

thanks,

greg k-h
