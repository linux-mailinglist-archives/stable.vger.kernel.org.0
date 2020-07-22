Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C12228D02
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 02:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgGVAO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 20:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgGVAO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 20:14:28 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7087DC0619DB
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 17:14:28 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 1so240055pfn.9
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 17:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9qebLmGY/4gEoVD5iagvEbtSEoeLp/rn7yyW5dBLp+g=;
        b=rBfa1OHrzErPK/ONQUP8CbcQunwM1IE/O/X+DkvbhC97maUcc0QhXPg5KgY+bBd34B
         sy/oZcUVUqcOHqnl9FneUGu20jN9QMtGanI+3VN5mQiWq+W+mobBvlTyVg+BHvrwH7kX
         tKVX7UN7C5neEmOdS4GJMCCb2lbDLmMmRAXKmKh3aoXW95u71P4piCNW2zMqfE94VFtI
         2iGkwPflJzEP6DqNiyXyYM+a0tvtiXY+8xbFpQStdrNJwBcknEwv4sqQdYYUEWiUtwao
         4Wcbn11+Dqsh+6i6symRbuK0KuDMFPGcS5hXwS6ISaKxcGKCqPhGaTmkikHFJe+yXfkn
         MjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9qebLmGY/4gEoVD5iagvEbtSEoeLp/rn7yyW5dBLp+g=;
        b=f2BOwJHFIvFR3L8/TctEWFdTkekt6mmcM8eXR8pp/eKzhGqKfyV30YYHQd9q1qq4Hd
         h2EdU3vZIHpKZIp2vso6S2KmS3v8sEfLqpJCwpnxkhuwFx8KGa1y+4C07Ew5TgMcgSsm
         HrG1RUz8QWkp5QVN69etVI4vgKb/GrBQ3eE8AZx+KPVuIlMl8X7cSKVmHVbbiPsTVZhq
         2wBZAeMToBGb+zgfwCrAQ4w5RGuluxUwRzN7dmSsDhg7ispRLHPNjzZaWuY69CqRDKl4
         PnVC2n3EDj2b8VAPR8IWfUU16x3X9zNUGeu/1vIw/Zs+KzOtpYH9FiVXMRyebXy9pdJd
         DdRQ==
X-Gm-Message-State: AOAM533GJvi8GmBxjCI9/AermLbWKiwOCV6HXD8TPkyoDN9C5ykS1ndD
        YItShT5s0/tRriKA/SFA2TrLNA==
X-Google-Smtp-Source: ABdhPJxpClug0jSxEuFfQ647WlLMd6xqykRwn3bkE3najs66S1jKCsrsPBbTOOKCoN3nuLlYWQrRsQ==
X-Received: by 2002:a62:f241:: with SMTP id y1mr26305365pfl.136.1595376867468;
        Tue, 21 Jul 2020 17:14:27 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id t1sm4438981pje.55.2020.07.21.17.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 17:14:26 -0700 (PDT)
Date:   Tue, 21 Jul 2020 17:14:24 -0700
From:   Fangrui Song <maskray@google.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Jian Cai <jiancai@google.com>,
        Bill Wendling <morbo@google.com>,
        Manoj Gupta <manojgupta@google.com>,
        stable <stable@vger.kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v3] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang
 cross compilation
Message-ID: <20200722001424.qor3up6357jjsbia@google.com>
References: <20200721173125.1273884-1-maskray@google.com>
 <CAK7LNARjOjr2wSD_iM6yNSZpSGEWrkZZuWKCgCqOrYcA29+LBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK7LNARjOjr2wSD_iM6yNSZpSGEWrkZZuWKCgCqOrYcA29+LBA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-07-22, Masahiro Yamada wrote:
>On Wed, Jul 22, 2020 at 2:31 AM 'Fangrui Song' via Clang Built Linux
><clang-built-linux@googlegroups.com> wrote:
>>
>> When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
>> $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
>> GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
>> /usr/bin/ and Clang as of 11 will search for both
>> $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
>>
>> GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
>> $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
>> $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
>>
>> To better model how GCC's -B/--prefix takes in effect in practice, newer
>> Clang (since
>> https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
>> only searches for $(prefix)$needle. Currently it will find /usr/bin/as
>> instead of /usr/bin/aarch64-linux-gnu-as.
>>
>> Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
>> (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
>> appropriate cross compiling GNU as (when -no-integrated-as is in
>> effect).
>>
>> Cc: stable@vger.kernel.org
>> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> Signed-off-by: Fangrui Song <maskray@google.com>
>> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
>> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>> Link: https://github.com/ClangBuiltLinux/linux/issues/1099
>> ---
>> Changes in v2:
>> * Updated description to add tags and the llvm-project commit link.
>> * Fixed a typo.
>>
>> Changes in v3:
>> * Add Cc: stable@vger.kernel.org
>> ---
>>  Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Makefile b/Makefile
>> index 0b5f8538bde5..3ac83e375b61 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
>>  ifneq ($(CROSS_COMPILE),)
>>  CLANG_FLAGS    += --target=$(notdir $(CROSS_COMPILE:%-=%))
>>  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
>> -CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)
>> +CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
>
>
>
>CROSS_COMPILE may contain the directory path
>to the cross toolchains.
>
>
>For example, I use aarch64-linux-gnu-*
>installed in
>/home/masahiro/tools/aarch64-linaro-7.5/bin
>
>
>
>Basically, there are two ways to use it.
>
>[1]
>PATH=$PATH:/home/masahiro/tools/aarch64-linaro-7.5/bin
>CROSS_COMPILE=aarch64-linux-gnu-
>
>
>[2]
>Without setting PATH,
>CROSS_COMPILE=~/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
>
>
>
>I usually do [2] (and so does intel's 0day bot).
>
>
>
>This patch works for the use-case [1]
>but if I do [2], --prefix is set to a strange path:
>
>--prefix=/home/masahiro/tools/aarch64-linaro-7.5/bin//home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-

Thanks. I did not know the use-case [2].
This explains why there is a `$(notdir ...)` in
`CLANG_FLAGS     += --target=$(notdir $(CROSS_COMPILE:%-=%))`


>
>
>Interestingly, the build is still successful.
>Presumably Clang searches for more paths
>when $(prefix)$needle is not found ?

The priority order is:

-B(--prefix), COMPILER_PATH, detected gcc-cross paths

(In GCC, -B paths get prepended to the COMPILER_PATH list. Clang<=11 incorrectly
adds -B to the COMPILER_PATH list. I have fixed it for 12.0.0)

If -B fails, the detected gcc-cross paths may still be able to find 
/usr/bin/aarch64-linux-gnu-

For example, on my machine (a variant of Debian testing), Clang finds
$(realpath
/usr/lib/gcc-cross/aarch64-linux-gnu/9/../../../../aarch64-linux-gnu/bin/as),
which is /usr/bin/aarch64-linux-gnu-as

>
>I applied your patch and added -v option
>to see which assembler was internally invoked:
>
> "/home/masahiro/tools/aarch64-linaro-7.5/lib/gcc/aarch64-linux-gnu/7.5.0/../../../../aarch64-linux-gnu/bin/as"
>-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
>./include -I ./arch/arm64/include/uapi -I
>./arch/arm64/include/generated/uapi -I ./include/uapi -I
>./include/generated/uapi -o kernel/smp.o /tmp/smp-2ec2c7.s
>
>
>Ok, it looks like Clang found an alternative path
>to the correct 'as'.
>
>
>
>
>But, to keep the original behavior for both [1] and [2],
>how about this?
>
>CLANG_FLAGS += --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
>
>
>
>Then, I can get this:
>
> "/home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-as"
>-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
>./include -I ./arch/arm64/include/uapi -I
>./arch/arm64/include/generated/uapi -I ./include/uapi -I
>./include/generated/uapi -o kernel/smp.o /tmp/smp-16d76f.s

This looks good.

Agreed that `--prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))` should work for both [1] and [2].

Shall I send a v4? Or you are kind enough that you'll just add your Signed-off-by: tag
and fix that for me? :)

>
>
>>  GCC_TOOLCHAIN  := $(realpath $(GCC_TOOLCHAIN_DIR)/..)
>>  endif
>>  ifneq ($(GCC_TOOLCHAIN),)
>> --
>> 2.28.0.rc0.105.gf9edc3c819-goog
>>
>> --
>> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200721173125.1273884-1-maskray%40google.com.
>
>
>
>--
>Best Regards
>Masahiro Yamada
