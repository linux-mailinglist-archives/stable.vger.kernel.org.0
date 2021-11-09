Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7F144B333
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 20:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243250AbhKITcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 14:32:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:60421 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243216AbhKITcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 14:32:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10163"; a="293362635"
X-IronPort-AV: E=Sophos;i="5.87,221,1631602800"; 
   d="scan'208";a="293362635"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 11:29:16 -0800
X-IronPort-AV: E=Sophos;i="5.87,221,1631602800"; 
   d="scan'208";a="533799542"
Received: from yushengo-mobl.amr.corp.intel.com (HELO [10.212.187.24]) ([10.212.187.24])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2021 11:29:15 -0800
Subject: Re: XSAVE / RDPKRU on Intel 11th Gen Core CPUs
To:     Brian Geffon <bgeffon@google.com>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Guenter Roeck <groeck@google.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CADyq12yY25-LS8cV5LY-C=6_0HLPVZbSJCKtCDJm+wyHQSeVTg@mail.gmail.com>
 <cb682c8a-255e-28e5-d4e0-0981c2ab6ffd@intel.com>
 <85925a39-37c3-a79a-a084-51f2f291ca9c@intel.com>
 <CADyq12y0o=Y1MOMe7pCghy2ZEV2Y0Dd7jm5e=3o2N4-i088MWw@mail.gmail.com>
 <472b8dbf-2c55-98c9-39ad-2db32a649a20@intel.com>
 <CADyq12whSxPdJhf4qg_w-7YXgEKWx4SDHByNBNZbfWDOeEY-8w@mail.gmail.com>
 <649f4de7-3c91-4974-9af7-d981a2bf6224@www.fastmail.com>
 <CADyq12wXzitT4y38fUjiWq_Rq4AWQX4Z05Qpyuu-dNBzQc8Gmg@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <f8488b73-0211-16e9-084f-482aa43178d9@intel.com>
Date:   Tue, 9 Nov 2021 11:29:13 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CADyq12wXzitT4y38fUjiWq_Rq4AWQX4Z05Qpyuu-dNBzQc8Gmg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/9/21 10:58 AM, Brian Geffon wrote:
> Hi Andy,
> 
> On Tue, Nov 9, 2021 at 9:58 AM Andy Lutomirski <luto@kernel.org> wrote:
>> Here's an excerpt from an old email that I, perhaps unwisely, sent to Dave but not to a public list:
>>
>> static inline void write_pkru(u32 pkru)
>> {
>>         struct pkru_state *pk;
>>
>>         if (!boot_cpu_has(X86_FEATURE_OSPKE))
>>                 return;
>>
>>         pk = get_xsave_addr(&current->thread.fpu.state.xsave,
>> XFEATURE_PKRU);
>>
>>         /*
>>          * The PKRU value in xstate needs to be in sync with the value
>> that is
>>          * written to the CPU. The FPU restore on return to userland would
>>          * otherwise load the previous value again.
>>          */
>>         fpregs_lock();
>>         if (pk)
>>                 pk->pkru = pkru;
>>
>> ^^^
>> else we just write to the PKRU register but leave XINUSE[PKRU] clear on
>> return to usermode?  That seems... unwise.
>>
>>         __write_pkru(pkru);
>>         fpregs_unlock();
>> }
>>
>> I bet you're hitting exactly this bug.  The fix ended up being a whole series of patches, but the gist of it is that the write_pkru() slow path needs to set the xfeature bit in the xsave buffer and then do the write.  It should be possible to make a little patch to do just this in a couple lines of code.
> 
> I think you've got the right idea, the following patch does seem to
> fix the problem on this CPU, this is based on 5.13. It seems the
> changes to asm/pgtable.h were not enough, I also had to modify
> fpu/internal.h to get it working properly.
> 
>>From e5e184d68ac6ca93c3cd2cc88d61af3260d1c014 Mon Sep 17 00:00:00 2001
> From: Brian Geffon <bgeffon@google.com>
> Date: Tue, 9 Nov 2021 17:08:25 +0000
> Subject: [PATCH] x86/fpu: Set XFEATURE_PKRU when writing to pkru
> 
> On kernels prior to 5.14 the write_pkru path could
> end up writing to the pkru register without updating
> the corresponding state.
> 
> Signed-off-by: Brian Geffon <bgeffon@google.com>
> ---
>  arch/x86/include/asm/fpu/internal.h | 22 ++++++++++------------
>  arch/x86/include/asm/pgtable.h      |  5 +++--
>  2 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fpu/internal.h
> b/arch/x86/include/asm/fpu/internal.h
> index 16bf4d4a8159..ed2ce7d1afeb 100644
> --- a/arch/x86/include/asm/fpu/internal.h
> +++ b/arch/x86/include/asm/fpu/internal.h
> @@ -564,18 +564,16 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
>          * PKRU state is switched eagerly because it needs to be valid before we
>          * return to userland e.g. for a copy_to_user() operation.
>          */
> -       if (!(current->flags & PF_KTHREAD)) {
> -               /*
> -                * If the PKRU bit in xsave.header.xfeatures is not set,
> -                * then the PKRU component was in init state, which means
> -                * XRSTOR will set PKRU to 0. If the bit is not set then
> -                * get_xsave_addr() will return NULL because the PKRU value
> -                * in memory is not valid. This means pkru_val has to be
> -                * set to 0 and not to init_pkru_value.
> -                */
> -               pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
> -               pkru_val = pk ? pk->pkru : 0;
> -       }
> +       /*
> +        * If the PKRU bit in xsave.header.xfeatures is not set,
> +        * then the PKRU component was in init state, which means
> +        * XRSTOR will set PKRU to 0. If the bit is not set then
> +        * get_xsave_addr() will return NULL because the PKRU value
> +        * in memory is not valid. This means pkru_val has to be
> +        * set to 0 and not to init_pkru_value.
> +        */
> +       pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
> +       pkru_val = pk ? pk->pkru : 0;
>         __write_pkru(pkru_val);
>  }

This hunk doesn't make any sense to me.  new_fpu should be for
'current', and if 'current' is a PF_KTHREAD, it shouldn't be using PKRU.

Why does this hunk matter?

> index b1099f2d9800..d00fc2df4cfe 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -137,18 +137,19 @@ static inline u32 read_pkru(void)
>  static inline void write_pkru(u32 pkru)
>  {
>         struct pkru_state *pk;
> +       struct fpu *fpu = &current->thread.fpu;
> 
>         if (!boot_cpu_has(X86_FEATURE_OSPKE))
>                 return;
> 
> -       pk = get_xsave_addr(&current->thread.fpu.state.xsave, XFEATURE_PKRU);
> -
>         /*
>          * The PKRU value in xstate needs to be in sync with the value that is
>          * written to the CPU. The FPU restore on return to userland would
>          * otherwise load the previous value again.
>          */
> +       fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_PKRU;

This needs to be inside fpregs_lock().  This task can get preempted at
any time and the xfeatures bit is not stable.

>         fpregs_lock();
> +       pk = get_xsave_addr(&fpu->state.xsave, XFEATURE_PKRU);
>         if (pk)
>                 pk->pkru = pkru;
>         __write_pkru(pkru);

I still don't think this quite matches up with the symptoms that you are
seeing.  This fix would ensure that we don't forget to update the XSAVE
buffer when it is in the init state.  But, if we did that, we would see
PKRU *going* to the init state: all 0's.  What you were seeing instead
was it going from 0x55555550 to 0x55555554, not 0x0.

I don't doubt that this makes the symptoms away, I just don't think this
really explains what's going on thoroughly enough.
