Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1387A45DE2B
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 16:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356264AbhKYQCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 11:02:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356149AbhKYQAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 11:00:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 353D661028;
        Thu, 25 Nov 2021 15:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637855819;
        bh=s0i3ezSE1IxuveYY+JQMFSCwcdblj9+81E0vhnTv7EE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BaKTbQ95gIfgHvQ50d09qzP6jo+5girSZzd6Hhfvk7Pc5RYmOv/4o+JjFM16Xx/SN
         K/h+47rRmFT2f+UDW+YfSeksWuZtayLWcN3PJ2FkEfrJy4odyD6OxNI3DpqbPm1xTJ
         Msb8QjL1FEp+WlVKsQtcSFsB+ppHGhv76xWhxIwA=
Date:   Thu, 25 Nov 2021 16:56:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>, Nadav Amit <namit@vmware.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/206] 4.9.291-rc2 review
Message-ID: <YZ+yNK3TOXNg+Q5k@kroah.com>
References: <20211125125641.226524689@linuxfoundation.org>
 <dd620210-af02-189c-f972-e31bd21008b4@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd620210-af02-189c-f972-e31bd21008b4@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 07:45:22AM -0800, Guenter Roeck wrote:
> On 11/25/21 4:57 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.291 release.
> > There are 206 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 27 Nov 2021 12:56:08 +0000.
> > Anything received after that time might be too late.
> > 
> 
> In file included from arch/sh/mm/init.c:25:
> arch/sh/include/asm/tlb.h:118:15: error: return type defaults to 'int' [-Werror=return-type]
>   118 | static inline tlb_flush_pmd_range(struct mmu_gather *tlb, unsigned long address,
> 
> The problem affects v4.9.y, v4.14.y, and v4.19.y.
> 
> Commit aca917cb287ba99c5 ("hugetlbfs: flush TLBs correctly after huge_pmd_unshare")
> doesn't really match the upstream commit and obviously was not even build tested
> on sh (and I would suspect it was not tested on other architectures either).
> It seems to me that it may do more harm than good.

Ok, at this point in time, I think this needs more work, especially over
a holliday weekend for parts of the world.

I'll go drop this, and the other hugetlb patch from 4.4, 4.9, 4.14, and
4.19 queues and wait for a new version from Nadav.

thanks,

greg k-h
