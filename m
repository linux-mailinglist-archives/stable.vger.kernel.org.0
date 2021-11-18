Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC983455B50
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 13:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344587AbhKRMPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 07:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344592AbhKRMO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 07:14:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26AAC061570;
        Thu, 18 Nov 2021 04:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8XU+JTQyuLrmrcDDYMi0gdYp6JORLpPUXKSvpqYqu0g=; b=XMBVGJphAV0dcFNlkmdWcRlC7d
        gc5AZR18Km2/0rtMsqs+LlxswKzd2dJqzVraBCL1H5J6HMByRnnOywD8fl+xPNx3R4e5Pn9Vc/V5M
        R1LnNtF6h1uOSRzihuN0BYfHgFZOSCfDhr0iJod+xIvaB0MaeVj72jU4D1V4u8zopVJ1cvVm7/eAf
        tn9baABgZvFg0rxw7TqLYc/sL1bVavhYPirZCGoNteB/WDqNoTvklf45X5/FGV9C+CV6qsdx40UYm
        UvsreNemAe0EfnKPeciQTBgAnTvzd56fD9pSZu/15HmI/l36Kr83p5Hy4uogxdWxmAUmlimXw24O8
        Yl2TxatA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mngFz-008RkE-O3; Thu, 18 Nov 2021 12:11:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DFEFC3001FD;
        Thu, 18 Nov 2021 13:11:09 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CC4582D037847; Thu, 18 Nov 2021 13:11:09 +0100 (CET)
Date:   Thu, 18 Nov 2021 13:11:09 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
        <holger@applied-asynchrony.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        stable <stable@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZZC3Shc0XA/gHK9@hirez.programming.kicks-ass.net>
References: <20211117101657.463560063@linuxfoundation.org>
 <YZV02RCRVHIa144u@fedora64.linuxtx.org>
 <55c7b316-e03d-9e91-d74c-fea63c469b3b@applied-asynchrony.com>
 <CAHk-=wjHbKfck1Ws4Y0pUZ7bxdjU9eh2WK0EFsv65utfeVkT9Q@mail.gmail.com>
 <20211118080627.GH174703@worktop.programming.kicks-ass.net>
 <20211118081852.GM174730@worktop.programming.kicks-ass.net>
 <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZYfYOcqNqOyZ8Yo@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 10:39:44AM +0100, Peter Zijlstra wrote:
> On Thu, Nov 18, 2021 at 09:18:52AM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 18, 2021 at 09:06:27AM +0100, Peter Zijlstra wrote:
> > > On Wed, Nov 17, 2021 at 03:50:17PM -0800, Linus Torvalds wrote:
> > > 
> > > > I really don't think the WCHAN code should use unwinders at all. It's
> > > > too damn fragile, and it's too easily triggered from user space.
> > > 
> > > On x86, esp. with ORC, it pretty much has to. The thing is, the ORC
> > > unwinder has been very stable so far. I'm guessing there's some really
> > > stupid thing going on, like for example trying to unwind a freed stack.
> > > 
> > > I *just* managed to reproduce, so let me go have a poke.
> > 
> > Confirmed, with the below it no longer reproduces. Now, let me go undo
> > that and fix the unwinder to not explode while trying to unwind nothing.
> 
> OK, so the bug is firmly with 5d1ceb3969b6 ("x86: Fix __get_wchan() for
> !STACKTRACE") which lost the try_get_task_stack() that stack_trace_*()
> does.
> 
> We can ofc trivially re-instate that, but I'm now running with the
> below which I suppose is a better fix, hmm?
> 
> (obv I still need to look a the other two unwinders)

I now have the below, the only thing missing is that there's a
user_mode() call on a stack based regs. Now on x86_64 we can
__get_kernel_nofault() regs->cs and call it a day, but on i386 we have
to also fetch regs->flags.

Is this really the way to go?

The thing is, we're already very careful about making sure the addresses
are within the stack range before touching them, it's just that when we
free the task stack we end up with trivially dodgy state.

---
 arch/x86/kernel/unwind_frame.c | 31 ++++++++++++++++++------
 arch/x86/kernel/unwind_guess.c | 18 ++++++++++++--
 arch/x86/kernel/unwind_orc.c   | 54 +++++++++++++++++++++++++++++++++---------
 3 files changed, 83 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/unwind_frame.c b/arch/x86/kernel/unwind_frame.c
index 8e1c50c86e5d..0c5cbc8ee300 100644
--- a/arch/x86/kernel/unwind_frame.c
+++ b/arch/x86/kernel/unwind_frame.c
@@ -215,10 +215,11 @@ static bool update_stack_state(struct unwind_state *state,
 	 * that info->next_sp could point to an empty stack and the next bp
 	 * could be on a subsequent stack.
 	 */
-	while (!on_stack(info, frame, len))
+	while (!on_stack(info, frame, len)) {
 		if (get_stack_info(info->next_sp, state->task, info,
 				   &state->stack_mask))
 			return false;
+	}
 
 	/* Make sure it only unwinds up and doesn't overlap the prev frame: */
 	if (state->orig_sp && state->stack_info.type == prev_type &&
@@ -235,11 +236,16 @@ static bool update_stack_state(struct unwind_state *state,
 	}
 
 	/* Save the return address: */
-	if (state->regs && user_mode(state->regs))
+	// regs deref
+	if (state->regs && user_mode(state->regs)) {
 		state->ip = 0;
-	else {
+	} else {
 		addr_p = unwind_get_return_address_ptr(state);
-		addr = READ_ONCE_TASK_STACK(state->task, *addr_p);
+
+		pagefault_disable();
+		__get_kernel_nofault(&addr, addr_p, unsigned long, Efault);
+		pagefault_enable();
+
 		state->ip = unwind_recover_ret_addr(state, addr, addr_p);
 	}
 
@@ -248,6 +254,10 @@ static bool update_stack_state(struct unwind_state *state,
 		state->orig_sp = frame;
 
 	return true;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 bool unwind_next_frame(struct unwind_state *state)
@@ -259,6 +269,7 @@ bool unwind_next_frame(struct unwind_state *state)
 		return false;
 
 	/* Have we reached the end? */
+	// regs deref
 	if (state->regs && user_mode(state->regs))
 		goto the_end;
 
@@ -295,9 +306,13 @@ bool unwind_next_frame(struct unwind_state *state)
 		next_bp = state->next_bp;
 		state->next_bp = NULL;
 	} else if (state->regs) {
-		next_bp = (unsigned long *)state->regs->bp;
+		pagefault_disable();
+		__get_kernel_nofault(&next_bp, &state->regs->bp, unsigned long, Efault);
+		pagefault_enable();
 	} else {
-		next_bp = (unsigned long *)READ_ONCE_TASK_STACK(state->task, *state->bp);
+		pagefault_disable();
+		__get_kernel_nofault(&next_bp, state->bp, unsigned long, Efault);
+		pagefault_enable();
 	}
 
 	/* Move to the next frame if it's safe: */
@@ -306,6 +321,8 @@ bool unwind_next_frame(struct unwind_state *state)
 
 	return true;
 
+Efault:
+	pagefault_enable();
 bad_address:
 	state->error = true;
 
@@ -402,7 +419,7 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 	 */
 	while (!unwind_done(state) &&
 	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
-			(state->next_bp == NULL && state->bp < first_frame)))
+		(state->next_bp == NULL && state->bp < first_frame)))
 		unwind_next_frame(state);
 }
 EXPORT_SYMBOL_GPL(__unwind_start);
diff --git a/arch/x86/kernel/unwind_guess.c b/arch/x86/kernel/unwind_guess.c
index 884d68a6e714..22153d91e868 100644
--- a/arch/x86/kernel/unwind_guess.c
+++ b/arch/x86/kernel/unwind_guess.c
@@ -13,9 +13,15 @@ unsigned long unwind_get_return_address(struct unwind_state *state)
 	if (unwind_done(state))
 		return 0;
 
-	addr = READ_ONCE_NOCHECK(*state->sp);
+	pagefault_disable();
+	__get_kernel_nofault(&addr, state->sp, unsigned long, Efault);
+	pagefault_enable();
 
 	return unwind_recover_ret_addr(state, addr, state->sp);
+
+Efault:
+	pagefault_enable();
+	return 0;
 }
 EXPORT_SYMBOL_GPL(unwind_get_return_address);
 
@@ -33,7 +39,11 @@ bool unwind_next_frame(struct unwind_state *state)
 
 	do {
 		for (state->sp++; state->sp < info->end; state->sp++) {
-			unsigned long addr = READ_ONCE_NOCHECK(*state->sp);
+			unsigned long addr;
+
+			pagefault_disable();
+			__get_kernel_nofault(&addr, state->sp, unsigned long, Efault);
+			pagefault_enable();
 
 			if (__kernel_text_address(addr))
 				return true;
@@ -45,6 +55,10 @@ bool unwind_next_frame(struct unwind_state *state)
 				 &state->stack_mask));
 
 	return false;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 EXPORT_SYMBOL_GPL(unwind_next_frame);
 
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index e6f7592790af..b0b5ac530450 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -352,8 +352,14 @@ static bool deref_stack_reg(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(long)))
 		return false;
 
-	*val = READ_ONCE_NOCHECK(*(unsigned long *)addr);
+	pagefault_disable();
+	__get_kernel_nofault(val, addr, unsigned long, Efault);
+	pagefault_enable();
 	return true;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
@@ -367,9 +373,16 @@ static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
 		return false;
 
-	*ip = READ_ONCE_NOCHECK(regs->ip);
-	*sp = READ_ONCE_NOCHECK(regs->sp);
+	pagefault_disable();
+	__get_kernel_nofault(ip, &regs->ip, unsigned long, Efault);
+	__get_kernel_nofault(sp, &regs->sp, unsigned long, Efault);
+	pagefault_enable();
+
 	return true;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr,
@@ -380,9 +393,16 @@ static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr
 	if (!stack_access_ok(state, addr, IRET_FRAME_SIZE))
 		return false;
 
-	*ip = READ_ONCE_NOCHECK(regs->ip);
-	*sp = READ_ONCE_NOCHECK(regs->sp);
+	pagefault_disable();
+	__get_kernel_nofault(ip, &regs->ip, unsigned long, Efault);
+	__get_kernel_nofault(sp, &regs->sp, unsigned long, Efault);
+	pagefault_enable();
+
 	return true;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 /*
@@ -396,22 +416,27 @@ static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr
 static bool get_reg(struct unwind_state *state, unsigned int reg_off,
 		    unsigned long *val)
 {
-	unsigned int reg = reg_off/8;
-
 	if (!state->regs)
 		return false;
 
+	pagefault_disable();
 	if (state->full_regs) {
-		*val = READ_ONCE_NOCHECK(((unsigned long *)state->regs)[reg]);
+		__get_kernel_nofault(val, (void *)state->regs + reg_off, unsigned long, Efault);
+		pagefault_enable();
 		return true;
 	}
 
 	if (state->prev_regs) {
-		*val = READ_ONCE_NOCHECK(((unsigned long *)state->prev_regs)[reg]);
+		__get_kernel_nofault(val, (void *)state->prev_regs + reg_off, unsigned long, Efault);
+		pagefault_enable();
 		return true;
 	}
 
 	return false;
+
+Efault:
+	pagefault_enable();
+	return false;
 }
 
 bool unwind_next_frame(struct unwind_state *state)
@@ -428,6 +453,7 @@ bool unwind_next_frame(struct unwind_state *state)
 	preempt_disable();
 
 	/* End-of-stack check for user tasks: */
+	// regs deref
 	if (state->regs && user_mode(state->regs))
 		goto the_end;
 
@@ -673,8 +699,12 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		struct inactive_task_frame *frame = (void *)task->thread.sp;
 
 		state->sp = task->thread.sp + sizeof(*frame);
-		state->bp = READ_ONCE_NOCHECK(frame->bp);
-		state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
+
+		pagefault_disable();
+		__get_kernel_nofault(&state->bp, &frame->bp, unsigned long, Efault);
+		__get_kernel_nofault(&state->ip, &frame->ret_addr, unsigned long, Efault);
+		pagefault_enable();
+
 		state->signal = (void *)state->ip == ret_from_fork;
 	}
 
@@ -713,6 +743,8 @@ void __unwind_start(struct unwind_state *state, struct task_struct *task,
 
 	return;
 
+Efault:
+	pagefault_enable();
 err:
 	state->error = true;
 the_end:
