Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720F33072E9
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 10:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbhA1Jj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 04:39:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231561AbhA1Jfb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 Jan 2021 04:35:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12FF060C3D;
        Thu, 28 Jan 2021 09:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611826491;
        bh=uBf9wG5WIjmuGoa3jRdeISfU7YHOD2GcgT3b1zVeQ50=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X8YX0t3qIynspfZT5taR4Z0XXri1Ma7P/1pKLfXWf+viaYnLBaZraWso1YbKomBs7
         g8Upb0P2G+ppndL12j6/E9gDd/7cwEfgtR+phyuk8CqfWqPhokeGv/DO9Cia2m+F/Z
         YQBUNpCSl2gb90Xz9dwR7MaqPu4JGyzA8IKhqC2g=
Date:   Thu, 28 Jan 2021 10:34:45 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Chris Clayton <chris2553@googlemail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: linux-5.10.11 build failure
Message-ID: <YBKFNUp5WYtdg9pE@kroah.com>
References: <f141f12d-a5b9-1e60-2740-388bf350b631@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f141f12d-a5b9-1e60-2740-388bf350b631@googlemail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 28, 2021 at 09:17:10AM +0000, Chris Clayton wrote:
> Hi,
> 
> Building 5.10.11 fails on my (x86-64) laptop thusly:
> 
> ..
> 
>  AS      arch/x86/entry/thunk_64.o
>   CC      arch/x86/entry/vsyscall/vsyscall_64.o
>   AS      arch/x86/realmode/rm/header.o
>   CC      arch/x86/mm/pat/set_memory.o
>   CC      arch/x86/events/amd/core.o
>   CC      arch/x86/kernel/fpu/init.o
>   CC      arch/x86/entry/vdso/vma.o
>   CC      kernel/sched/core.o
> arch/x86/entry/thunk_64.o: warning: objtool: missing symbol for insn at offset 0x3e
> 
>   AS      arch/x86/realmode/rm/trampoline_64.o
> make[2]: *** [scripts/Makefile.build:360: arch/x86/entry/thunk_64.o] Error 255
> make[2]: *** Deleting file 'arch/x86/entry/thunk_64.o'
> make[2]: *** Waiting for unfinished jobs....
> 
> ..
> 
> Compiler is latest snapshot of gcc-10.
> 
> Happy to test the fix but please cc me as I'm not subscribed

Can you do 'git bisect' to track down the offending commit?

And what exact gcc version are you using?

thanks,

greg k-h
