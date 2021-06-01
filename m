Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98FA63979BB
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 20:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhFASId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 14:08:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:57454 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234624AbhFASIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 14:08:32 -0400
IronPort-SDR: rsuB/CyQHFx+s5lCoOYr9jZX8moTJELD6SEm9IA9gpnZONNhreEsxpABeYFQYorymGQzLB6CF4
 /A/49z1nOd7A==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="201737660"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="201737660"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 11:06:27 -0700
IronPort-SDR: gbkuiIM/QQ0lpuoOt9sfUl2m5Cw0i4kmsm9POAuWPIhph2dJiDrfZHgY9YTdfkvRUqcpjHuJCM
 c8uRJlsTAB1w==
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="479384648"
Received: from pychiu-mobl.amr.corp.intel.com (HELO [10.209.21.197]) ([10.209.21.197])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 11:06:27 -0700
Subject: Re: [PATCH v3 3/5] x86/fpu: Clean up the fpu__clear() variants
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        the arch/x86 maintainers <x86@kernel.org>
Cc:     stable@vger.kernel.org,
        syzbot+2067e764dbcd10721e2e@syzkaller.appspotmail.com
References: <878s3u34iy.ffs@nanos.tec.linutronix.de>
 <603011b5-9479-3aac-78ee-74b9b5a5ef7c@kernel.org>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <aef37213-8bf1-ff89-9b41-417dcdfbe713@intel.com>
Date:   Tue, 1 Jun 2021 11:06:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <603011b5-9479-3aac-78ee-74b9b5a5ef7c@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On to patch 3:

> fpu__clear_all() and fpu__clear_user_states() share an implementation,
> and the resulting code is almost unreadable.  Clean it up.

Could we flesh this changelog out a bit?  I basically write these in the
process of understanding what the patch does, so this is less of "your
changelog needs help" and more of, "here's some more detail if you want it":

fpu__clear() currently resets both register state and kernel XSAVE
buffer state.  It has two modes: one for all state (supervisor and user)
and another for user state only.  fpu__clear_all() uses the "all state"
(user_only=0) mode, while a number of signal paths use the user_only=1 mode.

Make fpu__clear() work only for user state (user_only=1) and remove the
"all state" (user_only=0) code.  Rename it to match so it can be used by
the signal paths.

Replace the "all state" (user_only=0) fpu__clear() functionality.  Use
the TIF_NEED_FPU_LOAD functionality instead of making any actual
hardware registers changes in this path.

>  arch/x86/kernel/fpu/core.c | 63 +++++++++++++++++++++++++-------------
>  1 file changed, 42 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 571220ac8bea..a01cbb6a08bb 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -354,45 +354,66 @@ static inline void copy_init_fpstate_to_fpregs(u64 features_mask)
>  }
>  
>  /*
> - * Clear the FPU state back to init state.
> - *
> - * Called by sys_execve(), by the signal handler code and by various
> - * error paths.
> + * Reset current's user FPU states to the init states.  current's supervisor
> + * states, if any, are not modified by this function.  The XSTATE header
> + * in memory is assumed to be intact when this is called.
>   */
> -static void fpu__clear(struct fpu *fpu, bool user_only)
> +void fpu__clear_user_states(struct fpu *fpu)
>  {
>         WARN_ON_FPU(fpu != &current->thread.fpu);
>  
>         if (!static_cpu_has(X86_FEATURE_FPU)) {
> -               fpu__drop(fpu);
> -               fpu__initialize(fpu);
> +               fpu__clear_all(fpu);
>                 return;
>         }
>  
>         fpregs_lock();
>  
> -       if (user_only) {
> -               if (!fpregs_state_valid(fpu, smp_processor_id()) &&
> -                   xfeatures_mask_supervisor())
> -                       copy_kernel_to_xregs(&fpu->state.xsave,
> -                                            xfeatures_mask_supervisor());
> -               copy_init_fpstate_to_fpregs(xfeatures_mask_user());
> -       } else {
> -               copy_init_fpstate_to_fpregs(xfeatures_mask_all);
> -       }
> +       /*
> +        * Ensure that current's supervisor states are loaded into
> +        * their corresponding registers.
> +        */
> +       if (!fpregs_state_valid(fpu, smp_processor_id()) &&
> +           xfeatures_mask_supervisor())
> +               copy_kernel_to_xregs(&fpu->state.xsave,
> +                                    xfeatures_mask_supervisor());
>  
> +       /*
> +        * Reset user states in registers.
> +        */
> +       copy_init_fpstate_to_fpregs(xfeatures_mask_user());
> +
> +       /*
> +        * Now all FPU registers have their desired values.  Inform the
> +        * FPU state machine that current's FPU registers are in the
> +        * hardware registers.
> +        */
>         fpregs_mark_activate();
> +       
>         fpregs_unlock();
>  }
>  
> -void fpu__clear_user_states(struct fpu *fpu)
> -{
> -       fpu__clear(fpu, true);
> -}
> +/*
> + * Reset current's FPU registers (user and supervisor) to their INIT values.
> + * This is used by execve(); out of an abundance of caution, it completely
> + * wipes and resets the XSTATE buffer in memory.
> + *
> + * Note that XSAVE (unlike XSAVES) expects the XSTATE buffer in memory to
> + * be valid, so there are certain forms of corruption of the XSTATE buffer
> + * in memory that would survive initializing the FPU registers and XSAVEing
> + * them to memory.
> + *
> + * This does not change the actual hardware registers; when fpu__clear_all()
> + * returns, TIF_NEED_FPU_LOAD will be set, and a subsequent exit to user mode
> + * will reload the hardware registers from memory.
> + */
>  void fpu__clear_all(struct fpu *fpu)
>  {
> -       fpu__clear(fpu, false);
> +       fpregs_lock();
> +       fpu__drop(fpu);
> +       fpu__initialize(fpu);
> +       fpregs_unlock();
>  }

Nit: Could we move the detailed comments about TIF_NEED_FPU_LOAD right
next to the fpu__initialize() call?  It would make it painfully obvious
which call is responsible.  The naming isn't super helpful here.
