Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2936150284
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 08:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFXGuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 02:50:10 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:64856 "EHLO smtp3-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbfFXGuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 02:50:10 -0400
Received: from anisse-station (unknown [213.36.7.13])
        by smtp3-g21.free.fr (Postfix) with ESMTPS id 71CA413F879;
        Mon, 24 Jun 2019 08:50:03 +0200 (CEST)
Date:   Mon, 24 Jun 2019 08:50:02 +0200
From:   Anisse Astier <aastier@freebox.fr>
To:     gregkh@linuxfoundation.org
Cc:     will.deacon@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: ssbd: explicitly depend on
 <linux/prctl.h>" failed to apply to 4.9-stable tree
Message-ID: <20190624065002.GA59442@anisse-station>
References: <156132161022460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156132161022460@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Sun, Jun 23, 2019 at 10:26:50PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 

That's OK, it's not needed on 4.9-stable because the include was already
added when ssbd was backported. Ditto for 4.14.

Regards,

Anisse

> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From adeaa21a4b6954e878f3f7d1c5659ed9c1fe567a Mon Sep 17 00:00:00 2001
> From: Anisse Astier <aastier@freebox.fr>
> Date: Mon, 17 Jun 2019 15:22:21 +0200
> Subject: [PATCH] arm64: ssbd: explicitly depend on <linux/prctl.h>
> 
> Fix ssbd.c which depends implicitly on asm/ptrace.h including
> linux/prctl.h (through for example linux/compat.h, then linux/time.h,
> linux/seqlock.h, linux/spinlock.h and linux/irqflags.h), and uses
> PR_SPEC* defines.
> 
> This is an issue since we'll soon be removing the include from
> asm/ptrace.h.
> 
> Fixes: 9cdc0108baa8 ("arm64: ssbd: Add prctl interface for per-thread mitigation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Anisse Astier <aastier@freebox.fr>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> 
> diff --git a/arch/arm64/kernel/ssbd.c b/arch/arm64/kernel/ssbd.c
> index 885f13e58708..52cfc6148355 100644
> --- a/arch/arm64/kernel/ssbd.c
> +++ b/arch/arm64/kernel/ssbd.c
> @@ -5,6 +5,7 @@
>  
>  #include <linux/compat.h>
>  #include <linux/errno.h>
> +#include <linux/prctl.h>
>  #include <linux/sched.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/thread_info.h>
> 
