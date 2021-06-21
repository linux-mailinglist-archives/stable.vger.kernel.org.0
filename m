Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA38A3AEB49
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 16:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFUObv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 10:31:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:51672 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbhFUObv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 10:31:51 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 435AB1FD3D;
        Mon, 21 Jun 2021 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624285776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPaT3IOkb2sunrGVTVfN8VJ/vllj6Qah6tRHyuYa/Z0=;
        b=r5yICesIwXbWBwU2CLBGKaoI+osdQb99EK3rcXh34JiNDy6xH9atd8C9SvLE9uHyAS8X1j
        V2ac5rasSFabMc8K4GEcCFhuv91jueeb4denjeyVNqX/0Ya2VffcIqdD6ueF2aaQEApcTL
        CHfk4A+idcGbcf0Pi2eDkMxtp6nT2EU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624285776;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPaT3IOkb2sunrGVTVfN8VJ/vllj6Qah6tRHyuYa/Z0=;
        b=pvEXhobogfNKSF05nvywHryCmVJb3fuunEQLxQxUUDr7Y2WNgkghOpWGubuuxU0WmLhj92
        OUlVwz3qF2SaEkCw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 2CD8D118DD;
        Mon, 21 Jun 2021 14:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624285776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPaT3IOkb2sunrGVTVfN8VJ/vllj6Qah6tRHyuYa/Z0=;
        b=r5yICesIwXbWBwU2CLBGKaoI+osdQb99EK3rcXh34JiNDy6xH9atd8C9SvLE9uHyAS8X1j
        V2ac5rasSFabMc8K4GEcCFhuv91jueeb4denjeyVNqX/0Ya2VffcIqdD6ueF2aaQEApcTL
        CHfk4A+idcGbcf0Pi2eDkMxtp6nT2EU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624285776;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TPaT3IOkb2sunrGVTVfN8VJ/vllj6Qah6tRHyuYa/Z0=;
        b=pvEXhobogfNKSF05nvywHryCmVJb3fuunEQLxQxUUDr7Y2WNgkghOpWGubuuxU0WmLhj92
        OUlVwz3qF2SaEkCw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id YDI3C1Ci0GAncAAALh3uQQ
        (envelope-from <bp@suse.de>); Mon, 21 Jun 2021 14:29:36 +0000
Date:   Mon, 21 Jun 2021 16:29:21 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org, luto@kernel.org
Cc:     dave.hansen@linux.intel.com, riel@surriel.com, tglx@linutronix.de,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/fpu: Invalidate FPU state after a
 failed XRSTOR from a" failed to apply to 5.4-stable tree
Message-ID: <YNCiQRPD9iox9g/v@zn.tnic>
References: <162427270623162@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <162427270623162@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 21, 2021 at 12:51:46PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From d8778e393afa421f1f117471144f8ce6deb6953a Mon Sep 17 00:00:00 2001
> From: Andy Lutomirski <luto@kernel.org>
> Date: Tue, 8 Jun 2021 16:36:19 +0200
> Subject: [PATCH] x86/fpu: Invalidate FPU state after a failed XRSTOR from a
>  user buffer
> 
> Both Intel and AMD consider it to be architecturally valid for XRSTOR to
> fail with #PF but nonetheless change the register state.  The actual
> conditions under which this might occur are unclear [1], but it seems
> plausible that this might be triggered if one sibling thread unmaps a page
> and invalidates the shared TLB while another sibling thread is executing
> XRSTOR on the page in question.
> 
> __fpu__restore_sig() can execute XRSTOR while the hardware registers
> are preserved on behalf of a different victim task (using the
> fpu_fpregs_owner_ctx mechanism), and, in theory, XRSTOR could fail but
> modify the registers.
> 
> If this happens, then there is a window in which __fpu__restore_sig()
> could schedule out and the victim task could schedule back in without
> reloading its own FPU registers. This would result in part of the FPU
> state that __fpu__restore_sig() was attempting to load leaking into the
> victim task's user-visible state.
> 
> Invalidate preserved FPU registers on XRSTOR failure to prevent this
> situation from corrupting any state.
> 
> [1] Frequent readers of the errata lists might imagine "complex
>     microarchitectural conditions".
> 
> Fixes: 1d731e731c4c ("x86/fpu: Add a fastpath to __fpu__restore_sig()")
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Acked-by: Rik van Riel <riel@surriel.com>
> Cc: stable@vger.kernel.org
> Link: https://lkml.kernel.org/r/20210608144345.758116583@linutronix.de
> 
> diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
> index d5bc96a536c2..4ab9aeb9a963 100644
> --- a/arch/x86/kernel/fpu/signal.c
> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -369,6 +369,25 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
>  			fpregs_unlock();
>  			return 0;
>  		}
> +
> +		/*
> +		 * The above did an FPU restore operation, restricted to
> +		 * the user portion of the registers, and failed, but the
> +		 * microcode might have modified the FPU registers
> +		 * nevertheless.
> +		 *
> +		 * If the FPU registers do not belong to current, then
> +		 * invalidate the FPU register state otherwise the task might
> +		 * preempt current and return to user space with corrupted
> +		 * FPU registers.
> +		 *
> +		 * In case current owns the FPU registers then no further
> +		 * action is required. The fixup below will handle it
> +		 * correctly.
> +		 */
> +		if (test_thread_flag(TIF_NEED_FPU_LOAD))
> +			__cpu_invalidate_fpregs_state();
> +
>  		fpregs_unlock();
>  	} else {

So I'm looking at this and 5.4.127 has:

                if (!ret) {
                        fpregs_mark_activate();
                        fpregs_unlock();
                        return 0;
                }
                fpregs_deactivate(fpu);		<---
                fpregs_unlock();

i.e., an unconditional fpu invalidation there. Which got removed by:

98265c17efa9 ("x86/fpu/xstate: Preserve supervisor states for the slow path in __fpu__restore_sig()")

in 5.7.

so that Fixes: commit above which points to a 5.1 kernel is probably wrong-ish.

amluto?

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
