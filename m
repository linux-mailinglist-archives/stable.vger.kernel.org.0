Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A148632807D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 15:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbhCAOQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 09:16:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236217AbhCAOQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 09:16:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DC1D64D99;
        Mon,  1 Mar 2021 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614608129;
        bh=9mINMwSlE6Lx+Ht6ULSem8ouBs47qezztpHF+PAhhSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RCX7w0rroZjBI8wWRNDjIQ6u97soKDKpqx2MH4Ow+ELjyIAvn7gdp7gLdYXPCAoxb
         4dAU3od2y7UJwkyNEZRCHM0A5nL6iRyL/XoasmSWGzPoaIZ8phj3c///f6um+Y9WkW
         QW0o+YDkedxfj5hNqUO+q0y7Og2NNIhhRVZiQzkg=
Date:   Mon, 1 Mar 2021 15:15:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     lee.jones@linaro.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        cj.chengjian@huawei.com, judy.chenhui@huawei.com,
        zhangjinhao2@huawei.com
Subject: Re: [PATCH 4.9.y 1/1] futex: Fix OWNER_DEAD fixup
Message-ID: <YDz2/ratMYUR5SZV@kroah.com>
References: <20210223144151.916675-1-zhengyejian1@huawei.com>
 <20210223144151.916675-2-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223144151.916675-2-zhengyejian1@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 10:41:51PM +0800, Zheng Yejian wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit a97cb0e7b3f4c6297fd857055ae8e895f402f501 upstream.
> 
> Both Geert and DaveJ reported that the recent futex commit:
> 
>   c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> 
> introduced a problem with setting OWNER_DEAD. We set the bit on an
> uninitialized variable and then entirely optimize it away as a
> dead-store.
> 
> Move the setting of the bit to where it is more useful.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Reported-by: Dave Jones <davej@codemonkey.org.uk>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Paul E. McKenney <paulmck@us.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Fixes: c1e2f0eaf015 ("futex: Avoid violating the 10th rule of futex")
> Link: http://lkml.kernel.org/r/20180122103947.GD2228@hirez.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  kernel/futex.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Now queued up, thanks.

greg k-h
