Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856FE2F1A95
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 17:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732480AbhAKQKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 11:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728173AbhAKQKc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 11:10:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E66C22211;
        Mon, 11 Jan 2021 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610381392;
        bh=O3KkggcTR993pzuXy38vTCRE06aeOpM/+lPk5MMIqos=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bpbSXEYDSZ190PG7WW6/gt85Hv9QCsCVVmhqoPhOijmIDTOAXbbtbnDoDN9oSSsX3
         Vszyu7Cus5DRq6L9KTNtf4FaSjANE67aMRkqTObawAPIBtW+zQeLTnFLYr6d4HZCwB
         Xl0YJtPuuf0G0kXJCtRJtGcPy2z09nrppiKU9Nbo=
Date:   Mon, 11 Jan 2021 17:11:03 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/145] 5.10.7-rc1 review
Message-ID: <X/x4lwaZri3jkczr@kroah.com>
References: <20210111130048.499958175@linuxfoundation.org>
 <37e4ce34-0779-fee9-4575-051a85b2dbb2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37e4ce34-0779-fee9-4575-051a85b2dbb2@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 11, 2021 at 07:15:17AM -0800, Guenter Roeck wrote:
> On 1/11/21 5:00 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.7 release.
> > There are 145 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 13 Jan 2021 13:00:19 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building powerpc:ppc6xx_defconfig ... failed
> --------------
> Error log:
> arch/powerpc/kernel/head_book3s_32.S: Assembler messages:
> arch/powerpc/kernel/head_book3s_32.S:266: Error: unsupported relocation against SPRN_SPRG_SCRATCH2
> arch/powerpc/kernel/head_book3s_32.S:271: Error: unsupported relocation against SPRN_SPRG_SCRATCH2
> make[3]: *** [arch/powerpc/kernel/head_book3s_32.o] Error 1
> 
> Commit 90cd4bdd2bc0 ("powerpc/32s: Fix RTAS machine check with VMAP stack")
> is missing some context commits (and at least one of the patches it presumably fixes
> isn't even v5.10.y in the first place). Looking through Fixes: tags, it seems that ppc
> support in v5.10.y may be a bit of a mess, at least for 32-bit systems.

Thanks, will go drop that one now and push out a -rc2.

greg k-h
