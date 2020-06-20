Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66A0202281
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 10:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgFTIAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Jun 2020 04:00:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFTIAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 20 Jun 2020 04:00:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8825123A33;
        Sat, 20 Jun 2020 08:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592640010;
        bh=589/oUwRbwHQ2Wtx/EzGGu6gy/0q2jv6lf4VXJk+V/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aIL0Ua5+86Och7v8avjrLFX1gKGa3ePO5vabXQUp06QToqx+5tgsLT5B2DYX5FDQz
         HIWP0fTJDKM5l2YY04Vq8yc0va7Lzp/24LHAq8OjjQun6nFU1Q8IAHBIEzZ78XWfQg
         /CJWnCLQHEygCgGUCRGdFIvMEpd7wCdVLUfpWkTI=
Date:   Sat, 20 Jun 2020 10:00:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/261] 5.4.48-rc1 review
Message-ID: <20200620080006.GA2302354@kroah.com>
References: <20200619141649.878808811@linuxfoundation.org>
 <20200619160118.GA105163@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619160118.GA105163@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 19, 2020 at 09:01:18AM -0700, Guenter Roeck wrote:
> On Fri, Jun 19, 2020 at 04:30:11PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.48 release.
> > There are 261 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 21 Jun 2020 14:15:50 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building mips:defconfig ... failed
> --------------
> Error log:
> arch/mips/mm/dma-noncoherent.c: In function 'cpu_needs_post_dma_flush':
> arch/mips/mm/dma-noncoherent.c:36:7: error: 'CPU_LOONGSON2EF' undeclared
> 
> Also affects v4.19.y.queue, and causes almost all mips builds to fail.

Thanks, I've dropped the offending patch from both trees now.

greg k-h
