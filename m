Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAB2574C48
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 13:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbiGNLgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 07:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238121AbiGNLgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 07:36:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E3A89599FE
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 04:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657798590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yzJge1CDFiz3CXcKr0tL6QkQC9brq6bIgDLKquTU284=;
        b=Oe0ZEm54sOkNlt6fwcg29zEiM398Sw6WVpB4A3wBOzv21s4iZ+QLZMwDSToGAMBX/OzVnQ
        06F34+NNNau3Q6qL8lQIlFXi1bu40uzmPzA16kQhTQyzVGiEQrFVCM4l/j5j5diQF6blXx
        EaS9MU1+1RNoIHktcaENRbue8ReQk/Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-SeHw1dORO5uXaCWCyLn2hA-1; Thu, 14 Jul 2022 07:36:27 -0400
X-MC-Unique: SeHw1dORO5uXaCWCyLn2hA-1
Received: by mail-ed1-f71.google.com with SMTP id i9-20020a05640242c900b0043aeffc5cf1so1322258edc.18
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 04:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yzJge1CDFiz3CXcKr0tL6QkQC9brq6bIgDLKquTU284=;
        b=Y+KYXYLPtZwohbQLdQ7LsBh2m2+9FLJO7zpTilYezZLt+H4fNjCylrVqdDrrymQQos
         rXq77i+XKPtVfNyhJ+zYBFeghgl2kgmTRHm9SYUFoioEtQe2AoYGeW4RsIejW9F6zRly
         mtM505d5lFN9tvmak5fejvTcAc5g+T5t6jpiFLoIGA5KB+kYgjAlF+kBeo9OoQJ6vlFY
         feV67NHlbyRLOLk44aaz0VnASPD7Alteba7hPlMsuziw+dmPXRFoX2p0WfDj8ato5D3n
         Y5SyvaqppsxwLhuC4cdDgN3zXoEx7HovVO9F7nMLzwig8tsFcM04bO1WJb6TTPHqO6Ks
         BArw==
X-Gm-Message-State: AJIora/1IlTsnkwgSV4siDcClO1uqy5/MGK1xw9DnypJ3Z3a/E7hKeOX
        tPJKDUxf357pOfnsiwFiBuLxhgAfad+zOA8rB3bFN5gT5a3FBbTbU9R1Yftg4HOzvwX0da/xkXQ
        XtJj85gJKdwTbzPVn
X-Received: by 2002:a17:906:c152:b0:726:35bd:b3bd with SMTP id dp18-20020a170906c15200b0072635bdb3bdmr8547621ejc.201.1657798586267;
        Thu, 14 Jul 2022 04:36:26 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1soMs6ib0bGsSIDUbevpTdLCHlVeXmj1/9cy57IT8JvY+ym0ohu3hRr8eg8qnRzm5l28Qe84Q==
X-Received: by 2002:a17:906:c152:b0:726:35bd:b3bd with SMTP id dp18-20020a170906c15200b0072635bdb3bdmr8547605ejc.201.1657798586018;
        Thu, 14 Jul 2022 04:36:26 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id by28-20020a0564021b1c00b0043acddee068sm881292edb.83.2022.07.14.04.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 04:36:25 -0700 (PDT)
Message-ID: <976510d2-c7ad-2108-27e0-4c3b82c210f1@redhat.com>
Date:   Thu, 14 Jul 2022 13:36:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] x86/kvm: fix FASTOP_SIZE when return thunks are enabled
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Linux Kernel Functional Testing <lkft@linaro.org>
References: <20220713171241.184026-1-cascardo@canonical.com>
 <Ys/ncSnSFEST4fgL@worktop.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Ys/ncSnSFEST4fgL@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/22 11:52, Peter Zijlstra wrote:
> On Wed, Jul 13, 2022 at 02:12:41PM -0300, Thadeu Lima de Souza Cascardo wrote:
>> The return thunk call makes the fastop functions larger, just like IBT
>> does. Consider a 16-byte FASTOP_SIZE when CONFIG_RETHUNK is enabled.
>>
>> Otherwise, functions will be incorrectly aligned and when computing their
>> position for differently sized operators, they will executed in the middle
>> or end of a function, which may as well be an int3, leading to a crash
>> like:
> 
> Bah.. I did the SETcc stuff, but then forgot about the FASTOP :/
> 
>    af2e140f3420 ("x86/kvm: Fix SETcc emulation for return thunks")
> 
>> Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
>> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
>> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Josh Poimboeuf <jpoimboe@kernel.org>
>> Cc: Paolo Bonzini <pbonzini@redhat.com>
>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>> ---
>>   arch/x86/kvm/emulate.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
>> index db96bf7d1122..d779eea1052e 100644
>> --- a/arch/x86/kvm/emulate.c
>> +++ b/arch/x86/kvm/emulate.c
>> @@ -190,7 +190,7 @@
>>   #define X16(x...) X8(x), X8(x)
>>   
>>   #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
>> -#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
>> +#define FASTOP_SIZE (8 * (1 + (HAS_KERNEL_IBT | IS_ENABLED(CONFIG_RETHUNK))))
> 
> Would it make sense to do something like this instead?

Yes, definitely.  Applied with a small tweak to make FASTOP_LENGTH
more similar to SETCC_LENGTH:
  
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index db96bf7d1122..0a15b0fec6d9 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -189,8 +189,12 @@
  #define X8(x...) X4(x), X4(x)
  #define X16(x...) X8(x), X8(x)
  
-#define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
-#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
+#define NR_FASTOP	(ilog2(sizeof(ulong)) + 1)
+#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
+			 IS_ENABLED(CONFIG_SLS))
+#define FASTOP_LENGTH	(ENDBR_INSN_SIZE + 7 + RET_LENGTH)
+#define FASTOP_SIZE	(8 << ((FASTOP_LENGTH > 8) & 1) << ((FASTOP_LENGTH > 16) & 1))
+static_assert(FASTOP_LENGTH <= FASTOP_SIZE);
  
  struct opcode {
  	u64 flags;
@@ -442,8 +446,6 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
   * RET | JMP __x86_return_thunk	[1,5 bytes; CONFIG_RETHUNK]
   * INT3				[1 byte; CONFIG_SLS]
   */
-#define RET_LENGTH	(1 + (4 * IS_ENABLED(CONFIG_RETHUNK)) + \
-			 IS_ENABLED(CONFIG_SLS))
  #define SETCC_LENGTH	(ENDBR_INSN_SIZE + 3 + RET_LENGTH)
  #define SETCC_ALIGN	(4 << ((SETCC_LENGTH > 4) & 1) << ((SETCC_LENGTH > 8) & 1))
  static_assert(SETCC_LENGTH <= SETCC_ALIGN);


Paolo

