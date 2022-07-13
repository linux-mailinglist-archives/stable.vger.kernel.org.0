Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDDA572F75
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 09:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbiGMHpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 03:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiGMHpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 03:45:30 -0400
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93433E5860;
        Wed, 13 Jul 2022 00:45:29 -0700 (PDT)
Received: by mail-ej1-f43.google.com with SMTP id z23so1829994eju.8;
        Wed, 13 Jul 2022 00:45:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=L9TobJTZebR8oOcj6p3GEvPrGcR5qIWjptoMGu+nIhc=;
        b=vTaAYRGYgexS6BvBRELeSzfIo/Dx+Ai7WrS7fFPFxwS9YQYsihvLCD+t0B702ftScZ
         wJHCTqsOlGL4txp01yaSN7FQ4Q8t6blNbvv9yIPPQeFvfmJeisaN5jm4eqGtXQa++izF
         gBpPOEG1FM8Xy4FlbegW0S5aIZbyOzDc5x6hs0MVNqhTh1tgsdMBv8la3CQ09Yo1iFLW
         kRqIStogmv+ysHUSe2GQeBzHrpdi2er+4vqJD80inWwgfKnWIKFQuwMxk5LJ/RXDQH1A
         bbYTBRrUgGDESe8KihTLAg9Mp9pZxodA7HcpWmsqAXEvhlL0rat9n6dZvxUKkOQPa3Da
         VdOQ==
X-Gm-Message-State: AJIora9Kqa0F0+ysg6MeJ46idVh3QUYzosl2tkVNMwphIPDwx+NDo24/
        R5FIX17+37XPx5K8d2pFg0zVEz33SDU=
X-Google-Smtp-Source: AGRyM1u6SS8+hSjquiNB8ZCGeVqo86Pg8szzNu/ZzyIElA1BCe6ITzcgSckDsQjA9gw56HiK3w030g==
X-Received: by 2002:a17:907:94c3:b0:72b:335f:6f02 with SMTP id dn3-20020a17090794c300b0072b335f6f02mr2059166ejc.40.1657698328167;
        Wed, 13 Jul 2022 00:45:28 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id m6-20020aa7c486000000b0043a1255bc68sm7392391edq.94.2022.07.13.00.45.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 00:45:27 -0700 (PDT)
Message-ID: <63e23f80-033f-f64e-7522-2816debbc367@kernel.org>
Date:   Wed, 13 Jul 2022 09:45:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.18 34/61] objtool: Update Retpoline validation
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
References: <20220712183236.931648980@linuxfoundation.org>
 <20220712183238.342232911@linuxfoundation.org>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220712183238.342232911@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12. 07. 22, 20:39, Greg Kroah-Hartman wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 9bb2ec608a209018080ca262f771e6a9ff203b6f upstream.
> 
> Update retpoline validation with the new CONFIG_RETPOLINE requirement of
> not having bare naked RET instructions.

Hi,

this breaks compilation on i386:
 > arch/x86/kernel/../../x86/xen/xen-head.S:35: Error: no such 
instruction: `annotate_unret_safe'

Config:
https://raw.githubusercontent.com/openSUSE/kernel-source/stable/config/i386/pae

And yeah, upstream¹⁾ is affected too.

¹⁾I am at commit b047602d579b4fb028128a525f056bbdc890e7f0.

> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   arch/x86/include/asm/nospec-branch.h |    6 ++++++
>   arch/x86/mm/mem_encrypt_boot.S       |    2 ++
>   arch/x86/xen/xen-head.S              |    1 +
>   tools/objtool/check.c                |   19 +++++++++++++------
>   4 files changed, 22 insertions(+), 6 deletions(-)
> 
> --- a/arch/x86/include/asm/nospec-branch.h
> +++ b/arch/x86/include/asm/nospec-branch.h
> @@ -76,6 +76,12 @@
>   .endm
>   
>   /*
> + * (ab)use RETPOLINE_SAFE on RET to annotate away 'bare' RET instructions
> + * vs RETBleed validation.
> + */
> +#define ANNOTATE_UNRET_SAFE ANNOTATE_RETPOLINE_SAFE
> +
> +/*
>    * JMP_NOSPEC and CALL_NOSPEC macros can be used instead of a simple
>    * indirect jmp/call which may be susceptible to the Spectre variant 2
>    * attack.
> --- a/arch/x86/mm/mem_encrypt_boot.S
> +++ b/arch/x86/mm/mem_encrypt_boot.S
> @@ -66,6 +66,7 @@ SYM_FUNC_START(sme_encrypt_execute)
>   	pop	%rbp
>   
>   	/* Offset to __x86_return_thunk would be wrong here */
> +	ANNOTATE_UNRET_SAFE
>   	ret
>   	int3
>   SYM_FUNC_END(sme_encrypt_execute)
> @@ -154,6 +155,7 @@ SYM_FUNC_START(__enc_copy)
>   	pop	%r15
>   
>   	/* Offset to __x86_return_thunk would be wrong here */
> +	ANNOTATE_UNRET_SAFE
>   	ret
>   	int3
>   .L__enc_copy_end:
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -26,6 +26,7 @@ SYM_CODE_START(hypercall_page)
>   	.rept (PAGE_SIZE / 32)
>   		UNWIND_HINT_FUNC
>   		ANNOTATE_NOENDBR
> +		ANNOTATE_UNRET_SAFE
>   		ret
>   		/*
>   		 * Xen will write the hypercall page, and sort out ENDBR.
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -2114,8 +2114,9 @@ static int read_retpoline_hints(struct o
>   		}
>   
>   		if (insn->type != INSN_JUMP_DYNAMIC &&
> -		    insn->type != INSN_CALL_DYNAMIC) {
> -			WARN_FUNC("retpoline_safe hint not an indirect jump/call",
> +		    insn->type != INSN_CALL_DYNAMIC &&
> +		    insn->type != INSN_RETURN) {
> +			WARN_FUNC("retpoline_safe hint not an indirect jump/call/ret",
>   				  insn->sec, insn->offset);
>   			return -1;
>   		}
> @@ -3648,7 +3649,8 @@ static int validate_retpoline(struct obj
>   
>   	for_each_insn(file, insn) {
>   		if (insn->type != INSN_JUMP_DYNAMIC &&
> -		    insn->type != INSN_CALL_DYNAMIC)
> +		    insn->type != INSN_CALL_DYNAMIC &&
> +		    insn->type != INSN_RETURN)
>   			continue;
>   
>   		if (insn->retpoline_safe)
> @@ -3663,9 +3665,14 @@ static int validate_retpoline(struct obj
>   		if (!strcmp(insn->sec->name, ".init.text") && !module)
>   			continue;
>   
> -		WARN_FUNC("indirect %s found in RETPOLINE build",
> -			  insn->sec, insn->offset,
> -			  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
> +		if (insn->type == INSN_RETURN) {
> +			WARN_FUNC("'naked' return found in RETPOLINE build",
> +				  insn->sec, insn->offset);
> +		} else {
> +			WARN_FUNC("indirect %s found in RETPOLINE build",
> +				  insn->sec, insn->offset,
> +				  insn->type == INSN_JUMP_DYNAMIC ? "jump" : "call");
> +		}
>   
>   		warnings++;
>   	}
> 
> 


-- 
js
suse labs
