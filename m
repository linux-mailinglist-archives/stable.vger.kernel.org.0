Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C1D1E4D48
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 20:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgE0Srq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 14:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgE0Srh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 14:47:37 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3E8C08C5C1
        for <stable@vger.kernel.org>; Wed, 27 May 2020 11:28:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n15so12242799pfd.0
        for <stable@vger.kernel.org>; Wed, 27 May 2020 11:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iA+KkSp+x1pCOvFG2laI62cGHgeFrOqb4fOzsNTxNXU=;
        b=s5sgK5hVj6s8lKi3Rri8hD77o4Tgsh/f//XKeSLPPL6IoaX/9mCJYEHRJ32vVuTTGB
         dFOJ6DX54r/GDHqGsERVaSkKn7VZP6w7vmoq01S+s7Vgp4NCjhtVzBjBz/ibFnvGcWta
         mSfHvumiHewYuXpM4XZwLfp01LJYUKENxLfVUkXnOtA0BezWqdmG+dG9FruFxrFvx+z0
         OLSDlugaSodJcE0avHyTiDxelPvs1YxJU3Ddg4TK5lzP7IpA32ZcQqmyQOKAlpQDiDDP
         fF30dP0+KbJyDOf08di6glcZut8WphRJqfLPENPijbkDbzZ6pcV6gQGYyCj6OH9Rd9v6
         fRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iA+KkSp+x1pCOvFG2laI62cGHgeFrOqb4fOzsNTxNXU=;
        b=UxJkILOZX7DKnbvvUu6X2vd5TIkRPEtnBMKqWAZBq6usT7XAZ6eCvTSb9CJW3iiaI4
         OHABIeXXxKwn7jx7LZS5DKu6o6ZBc0XxaBau5qGBDh6bnW4QxdqjWz/Bt1sMISuXEMjh
         crzjnP+XOZAYip/09iuHmBbJFeUKiuvfQSIxu1HF2O2PPthk+YzHael1mE6JYmD1mksN
         o32jA2O3ipZFzR5noL6QiaIIkcyJvh/FiCxRiUcE/lhdZeY0+5LFxk/RTyXiLHD2QP2U
         DjSKJAMIYCMZ7bgSvcksJGGK025NOYgnMmAT4Dko0/mshpyjEo64XSFYAjquuIvlAaTA
         Bjjw==
X-Gm-Message-State: AOAM531WiVbmYScFMKpxWs2pOJl54fmM+qdbawSOJGix0xUObJVpHFnf
        mN+kenNSAirCaS518GD9mCo+UA==
X-Google-Smtp-Source: ABdhPJy79EBrfQSWmv0ROoxKkjCOvcXwdJtlDQLwN27cdTeaTy6nksFR7zHfbpPjZAN2LXNgjfyAZw==
X-Received: by 2002:a63:e008:: with SMTP id e8mr5139090pgh.451.1590604128900;
        Wed, 27 May 2020 11:28:48 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:9efe:9f1:9267:2b27])
        by smtp.gmail.com with ESMTPSA id z8sm2517225pgc.80.2020.05.27.11.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 11:28:48 -0700 (PDT)
Date:   Wed, 27 May 2020 11:28:43 -0700
From:   Fangrui Song <maskray@google.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Enrico Weigelt <info@metux.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Bill Wendling <morbo@google.com>, Jian Cai <jiancai@google.com>
Subject: Re: [PATCH] arm64: fix clang integrated assembler build
Message-ID: <20200527182843.g6tbow4lqsvwl2ah@google.com>
References: <20200527141435.1716510-1-arnd@arndb.de>
 <CAKwvOdnNxj-MdKj3aWoefF2W9PPG-TSeNU4Ym-N8NODJB5Yw_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKwvOdnNxj-MdKj3aWoefF2W9PPG-TSeNU4Ym-N8NODJB5Yw_w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020-05-27, 'Nick Desaulniers' via Clang Built Linux wrote:
>On Wed, May 27, 2020 at 7:14 AM Arnd Bergmann <arnd@arndb.de> wrote:
>>
>> clang and gas seem to interpret the symbols in memmove.S and
>> memset.S differently, such that clang does not make them
>> 'weak' as expected, which leads to a linker error, with both
>> ld.bfd and ld.lld:
>>
>> ld.lld: error: duplicate symbol: memmove
>> >>> defined at common.c
>> >>>            kasan/common.o:(memmove) in archive mm/built-in.a
>> >>> defined at memmove.o:(__memmove) in archive arch/arm64/lib/lib.a
>>
>> ld.lld: error: duplicate symbol: memset
>> >>> defined at common.c
>> >>>            kasan/common.o:(memset) in archive mm/built-in.a
>> >>> defined at memset.o:(__memset) in archive arch/arm64/lib/lib.a
>>
>> Copy the exact way these are written in memcpy_64.S, which does
>> not have the same problem.
>>
>> I don't know why this makes a difference, and it would be good
>> to have someone with a better understanding of assembler internals
>> review it.
>>
>> It might be either a bug in the kernel or a bug in the assembler,
>> no idea which one. My patch makes it work with all versions of
>> clang and gcc, which is probably helpful even if it's a workaround
>> for a clang bug.
>
>+ Bill, Fangrui, Jian
>I think we saw this bug or a very similar bug internally around the
>ordering of .weak to .global.

This may be another instance of
https://sourceware.org/pipermail/binutils/2020-March/000299.html
https://lore.kernel.org/linuxppc-dev/20200325164257.170229-1-maskray@google.com/

I haven't checked but there may be both a .globl directive and a .weak
directive

>> Cc: stable@vger.kernel.org
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>> ---
>>  arch/arm64/lib/memcpy.S  | 3 +--
>>  arch/arm64/lib/memmove.S | 3 +--
>>  arch/arm64/lib/memset.S  | 3 +--
>>  3 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
>> index e0bf83d556f2..dc8d2a216a6e 100644
>> --- a/arch/arm64/lib/memcpy.S
>> +++ b/arch/arm64/lib/memcpy.S
>> @@ -56,9 +56,8 @@
>>         stp \reg1, \reg2, [\ptr], \val
>>         .endm
>>
>> -       .weak memcpy
>>  SYM_FUNC_START_ALIAS(__memcpy)
>> -SYM_FUNC_START_PI(memcpy)
>> +SYM_FUNC_START_WEAK_PI(memcpy)
>>  #include "copy_template.S"
>>         ret
>>  SYM_FUNC_END_PI(memcpy)
>> diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
>> index 02cda2e33bde..1035dce4bdaf 100644
>> --- a/arch/arm64/lib/memmove.S
>> +++ b/arch/arm64/lib/memmove.S
>> @@ -45,9 +45,8 @@ C_h   .req    x12
>>  D_l    .req    x13
>>  D_h    .req    x14
>>
>> -       .weak memmove
>>  SYM_FUNC_START_ALIAS(__memmove)
>> -SYM_FUNC_START_PI(memmove)
>> +SYM_FUNC_START_WEAK_PI(memmove)
>>         cmp     dstin, src
>>         b.lo    __memcpy
>>         add     tmp1, src, count
>> diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
>> index 77c3c7ba0084..a9c1c9a01ea9 100644
>> --- a/arch/arm64/lib/memset.S
>> +++ b/arch/arm64/lib/memset.S
>> @@ -42,9 +42,8 @@ dst           .req    x8
>>  tmp3w          .req    w9
>>  tmp3           .req    x9
>>
>> -       .weak memset
>>  SYM_FUNC_START_ALIAS(__memset)
>> -SYM_FUNC_START_PI(memset)
>> +SYM_FUNC_START_WEAK_PI(memset)
>>         mov     dst, dstin      /* Preserve return value.  */
>>         and     A_lw, val, #255
>>         orr     A_lw, A_lw, A_lw, lsl #8
>> --
>> 2.26.2
>
>-- 
>Thanks,
>~Nick Desaulniers
>
>-- 
>You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAKwvOdnNxj-MdKj3aWoefF2W9PPG-TSeNU4Ym-N8NODJB5Yw_w%40mail.gmail.com.
