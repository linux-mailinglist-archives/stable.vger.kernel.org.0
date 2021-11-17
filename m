Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DDF454242
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 09:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbhKQIEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 03:04:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:49660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229712AbhKQIEm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 03:04:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 749CB6128E;
        Wed, 17 Nov 2021 08:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637136103;
        bh=O2plNilAH1VT+kSmE6Pub4rva8E8VFegHw/+K2Hesv4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sEqExS+wo7n2YnCorXngT8dCSB2dn8Ov2MkvrOYBTSdcH010x4GFsoQauiiUq41XS
         KoSD5Ok4CNxtRguD0C1Ja215gimZx4NvBT4oOYSJVcMz4Y0655YJhfMTsaIL6lEqFl
         ByXXoY5gEjM5tJSPeflb0/z8zNV4dZbHCP3yf0Qk=
Date:   Wed, 17 Nov 2021 09:01:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/578] 5.10.80-rc2 review
Message-ID: <YZS25XVkCys8MwEU@kroah.com>
References: <20211116142545.607076484@linuxfoundation.org>
 <4ce78f7d-0735-5895-8995-84cef2bffc3e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ce78f7d-0735-5895-8995-84cef2bffc3e@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 12:20:38PM -0800, Guenter Roeck wrote:
> On 11/16/21 7:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.80 release.
> > There are 578 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building m68k:defconfig ... failed
> Building m68k:allmodconfig ... failed
> ------------
> drivers/block/ataflop.c: In function 'atari_cleanup_floppy_disk':
> drivers/block/ataflop.c:2066:17: error: implicit declaration of function 'blk_cleanup_disk'
> 
> drivers/block/ataflop.c: In function 'atari_floppy_init':
> drivers/block/ataflop.c:2133:15: error: implicit declaration of function '__register_blkdev'
> 

Thanks, will go drop the offending patch now.

greg k-h
