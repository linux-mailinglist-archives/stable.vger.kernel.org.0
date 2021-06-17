Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84B93AB166
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 12:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhFQKfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 06:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229868AbhFQKfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Jun 2021 06:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A88AD613C1;
        Thu, 17 Jun 2021 10:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623925976;
        bh=5LFrWKKnZzvh/4r7zdfHzAVLWRjA2NAS61Xo1SiDMzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AOCrY5pGzfLkyz4h4F84W9YSr/0KuhYp1X/v/mxaY2Hy5HcyNwhpNjuFt7pbjjDcQ
         J+JCu2P6VyaatyRM6QXSOQDuGs8lsj3LAh+atXDFv5iaab5ONSkJo5jQ1SVwgg3kAj
         2TGwsiaN9+pAg55Ls3zmKq+dghYhO5bp9IxjyPcA=
Date:   Thu, 17 Jun 2021 12:32:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sherry Yang <sherry.yang@oracle.com>
Cc:     "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "bp@alien8.de" <bp@alien8.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5.4 0/2] Backports "x86, sched: Treat Intel SNC topology
 as default, COD as exception"
Message-ID: <YMsk1Yg9kzqwymUv@kroah.com>
References: <20210608003715.66882-1-sherry.yang@oracle.com>
 <A969D4BF-D21B-4AB0-97AE-5C881C6F187D@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <A969D4BF-D21B-4AB0-97AE-5C881C6F187D@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 10:59:46PM +0000, Sherry Yang wrote:
> 
> > On Jun 7, 2021, at 5:37 PM, Sherry Yang <sherry.yang@oracle.com> wrote:
> > 
> > Could you also backport these two commits
> > adefe55e7258 ("x86/kernel: Convert to new CPU match macros")
> > 2c88d45edbb8 ("x86, sched: Treat Intel SNC topology as default,
> > COD as exception") to 5.4.y?
> > 
> > Commit adefe55e7258 ("x86/kernel: Convert to new CPU match macros")
> > is a prerequisite of the second commit. There are conflicts while
> > cherry-picking commit adefe55e7258 ("x86/kernel: Convert to new
> > CPU match macros"), which are caused by a later commit
> > c84cb3735fd5 ("x86/apic: Move TSC deadline timer debug printk").
> > Keep the later code base.
> > 
> > Alison Schofield (1):
> >  x86, sched: Treat Intel SNC topology as default, COD as exception
> > 
> > Thomas Gleixner (1):
> >  x86/kernel: Convert to new CPU match macros
> > 
> > arch/x86/kernel/apic/apic.c | 32 ++++++-------
> > arch/x86/kernel/smpboot.c   | 90 +++++++++++++++++++------------------
> > arch/x86/kernel/tsc_msr.c   | 14 +++---
> > arch/x86/power/cpu.c        | 16 +------
> > 4 files changed, 68 insertions(+), 84 deletions(-)
> > 
> > -- 
> > 2.27.0
> > 
> 
> Hi,
>  
> We have seen that the warning “sched: CPU #20's llc-sibling CPU #0 is not on 
> the same node! [node: 1 != 0]. Ignoring dependency. ” applies to 5.4 but we don’t 
> observe the fix in 5.4. I'm sending this email to apply the fix from upstream 
> 2c88d45edbb8 ("x86, sched: Treat Intel SNC topology as default, COD as 
> exception") to 5.4 and also resolve the dependency conflict caused by 
> prerequisite commit adefe55e7258 ("x86/kernel: Convert to new CPU match 
> macros”) by keeping the later code base, please refer to the
> previous two patches for the detail.
>  

I have no idea what you want me to do here, sorry.

Please provide a working, tested, set of patches backported to the
relevant stable trees you want to see them applied to, and I will be
glad to review and queue them up if they look good.  No one here is in
the position to "resolve the dependency conflict" of anything here for
you, sorry, you will need to do this yourself as you are in the best
position to do so.

thanks!

greg k-h
