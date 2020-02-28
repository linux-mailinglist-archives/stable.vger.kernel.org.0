Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86795173677
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 12:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgB1LxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 06:53:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbgB1LxP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 06:53:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63712084E;
        Fri, 28 Feb 2020 11:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582890795;
        bh=wIBGmFyAq22lxQaE+5tiLvcF4if7zUYVjO/zo5SO50g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cokCTAxHZd1zY2RwGmHvnnR5kkLCdWz6JEwYN+fnetEtqbFoDYMM0oG/Su6rd4gXa
         +Os1gJAjB76mK63hYDWyeOl/D59Nse1gYkJrAj62FTZcsRlje0CWbPXWnVogi+TNVc
         fpq3LlPyldtz3JSdt/msU8vhCKgs+1Dn4VRmSReA=
Date:   Fri, 28 Feb 2020 12:53:12 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/165] 4.9.215-stable review
Message-ID: <20200228115312.GB2918666@kroah.com>
References: <20200227132230.840899170@linuxfoundation.org>
 <20200227184431.GA15944@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200227184431.GA15944@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 10:44:31AM -0800, Guenter Roeck wrote:
> On Thu, Feb 27, 2020 at 02:34:34PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.215 release.
> > There are 165 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building powerpc:defconfig ... failed
> --------------
> Error log:
> In file included from include/linux/bug.h:4:0,
>                  from include/linux/thread_info.h:11,
>                  from include/asm-generic/preempt.h:4,
>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
>                  from include/linux/preempt.h:59,
>                  from include/linux/spinlock.h:50,
>                  from include/linux/seqlock.h:35,
>                  from include/linux/time.h:5,
>                  from include/uapi/linux/timex.h:56,
>                  from include/linux/timex.h:56,
>                  from include/linux/sched.h:19,
>                  from arch/powerpc/kernel/signal_32.c:20:
> arch/powerpc/kernel/signal_32.c: In function ‘save_tm_user_regs’:
> arch/powerpc/kernel/signal_32.c:521:10: error: ‘tm_suspend_disabled’ undeclared
> 
> Also affects v4.14.y.

Thanks for letting me know, I've now dropped 3 powerpc patches from 4.14
and 4.9 and will push out a -rc2 for those trees in a few minutes.

greg k-h
