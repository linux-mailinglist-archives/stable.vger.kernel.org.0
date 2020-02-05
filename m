Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 596371533B7
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 16:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbgBEPUr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 10:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbgBEPUq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 10:20:46 -0500
Received: from localhost (unknown [212.187.182.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EA01217BA;
        Wed,  5 Feb 2020 15:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580915640;
        bh=vyxN1+/HeuK9WI82c8rvGLHCY7yqdmRlYpk2cwL18ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WQxkgR65EJtvp2UAERT1iZ3q/UNiam1nBhKRZHZthcZ25m7kiL91/H/BclVHTT9qK
         iZBEokdQEwSEQmvo3sCUnn4NGbkRciQO0zbmPTX9sp5uqsW0q0xGSGO7xfrR2ph8Ej
         yNV9ZD91iiHzszTS0sMFICu1zzmcxWO91n24DRF0=
Date:   Wed, 5 Feb 2020 15:13:57 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
Message-ID: <20200205151357.GB1236691@kroah.com>
References: <20200203161917.612554987@linuxfoundation.org>
 <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 06:37:38AM -0800, Guenter Roeck wrote:
> On 2/3/20 8:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.18 release.
> > There are 90 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building i386:allyesconfig ... failed
> Building i386:allmodconfig ... failed
> --------------
> Error log:
> In file included from arch/x86/kernel/pci-dma.c:2:
> include/linux/dma-direct.h:29:20: error: conflicting types for 'dma_capable'
>    29 | static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
>       |                    ^~~~~~~~~~~
> In file included from include/linux/dma-direct.h:12,
>                  from arch/x86/kernel/pci-dma.c:2:
> arch/x86/include/asm/dma-direct.h:5:6: note: previous declaration of 'dma_capable' was here
>     5 | bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);

Ok, I think this is now resolved with a patch that Sasha added.

I have pushed out a -rc4 that _should_ build and boot properly.

Hopefully :)

thanks,

greg k-h
