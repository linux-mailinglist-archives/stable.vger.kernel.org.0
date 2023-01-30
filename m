Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A559681674
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 17:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbjA3QcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 11:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbjA3QcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 11:32:19 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3064F1A96B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:32:18 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id w13so1248794ilv.3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 08:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OWrtWG8MThNoqJJD59hvCVnxXQO10Lw87QwcI21YP84=;
        b=KVmuLAq6+1sLlsEegGJvCE/YAC1AN/dGZFD+I5P4dirBM7Nnz/hVe/+O01yMaSpGeH
         qSdHj1BJcIJzegg2lrrfLCiqOPKZsEoImq6GatwLbKEJAtB8Fm9r++QV7Rl0IYyfbrWk
         JqWixarDELqPKRMRel8ameXlhyEHhbQr0w1Iw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OWrtWG8MThNoqJJD59hvCVnxXQO10Lw87QwcI21YP84=;
        b=mLQ4S53xulojfATY8DITHXNqaQnIFeWXHTxyCjiFpf6T63HqvjinDM6cfXW40FtwMa
         69UiJEgILbhf1VoGQ+a6/ZQyHYnYKQCjtoYVghbpbCVpMTUWWUOhHLD4YrdAF18E7Dwj
         Eb3lGn5e76o6/AFcLHRvURHlKZE0FFGs9CWzzASeTnrOGc5MgVNF/Xa6YLGUxwJqK8JE
         kI/ugZYy2YnKR3YkT+4oD1KeivJFq8UPAa2b5+QsnzfrbU3hTXWIk3JQRT+XcJjjJBmK
         pO1qf8Km9vwfYd6FghmXNCk3IaXy4vbv9bd3Al5jLWx+3/Bxdv3Qo6T7b61ZJCsBEJxf
         rvjA==
X-Gm-Message-State: AFqh2koV1YHEjYgZm9Rh/7xLJfw/LWqXTsEq7hWV9qBoAFm7WABNEWUh
        hk4HdFtr1I0tMX6Ab9RQj2FoOw==
X-Google-Smtp-Source: AMrXdXuU3+9j/Rjvw8C+ukn67BvaWIEI91xJn2ZY7kFLPKG3RDFG4Qms2skTiiP3lY4Uj0ew4JcMgA==
X-Received: by 2002:a92:2a07:0:b0:30c:1dda:42dd with SMTP id r7-20020a922a07000000b0030c1dda42ddmr7228513ile.1.1675096337499;
        Mon, 30 Jan 2023 08:32:17 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c62-20020a029644000000b003a96cc2bbdesm4273919jai.85.2023.01.30.08.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 08:32:16 -0800 (PST)
Message-ID: <0d95f6b4-c949-2f06-62fb-f35d70b1782d@linuxfoundation.org>
Date:   Mon, 30 Jan 2023 09:32:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 21/34] selftests: powerpc: Fix incorrect kernel headers
 search path
Content-Language: en-US
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20230127135755.79929-1-mathieu.desnoyers@efficios.com>
 <20230127135755.79929-22-mathieu.desnoyers@efficios.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230127135755.79929-22-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/27/23 06:57, Mathieu Desnoyers wrote:
> Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
> building against kernel headers from the build environment in scenarios
> where kernel headers are installed into a specific output directory
> (O=...).
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: linux-kselftest@vger.kernel.org
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: <stable@vger.kernel.org>    [5.18+]
> ---
>   tools/testing/selftests/powerpc/ptrace/Makefile   | 2 +-
>   tools/testing/selftests/powerpc/security/Makefile | 2 +-
>   tools/testing/selftests/powerpc/syscalls/Makefile | 2 +-
>   tools/testing/selftests/powerpc/tm/Makefile       | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/powerpc/ptrace/Makefile b/tools/testing/selftests/powerpc/ptrace/Makefile
> index 2f02cb54224d..cbeeaeae8837 100644
> --- a/tools/testing/selftests/powerpc/ptrace/Makefile
> +++ b/tools/testing/selftests/powerpc/ptrace/Makefile
> @@ -33,7 +33,7 @@ TESTS_64 := $(patsubst %,$(OUTPUT)/%,$(TESTS_64))
>   $(TESTS_64): CFLAGS += -m64
>   $(TM_TESTS): CFLAGS += -I../tm -mhtm
>   
> -CFLAGS += -I../../../../../usr/include -fno-pie
> +CFLAGS += $(KHDR_INCLUDES) -fno-pie
>   
>   $(OUTPUT)/ptrace-gpr: ptrace-gpr.S
>   $(OUTPUT)/ptrace-pkey $(OUTPUT)/core-pkey: LDLIBS += -pthread
> diff --git a/tools/testing/selftests/powerpc/security/Makefile b/tools/testing/selftests/powerpc/security/Makefile
> index 7488315fd847..e0d979ab0204 100644
> --- a/tools/testing/selftests/powerpc/security/Makefile
> +++ b/tools/testing/selftests/powerpc/security/Makefile
> @@ -5,7 +5,7 @@ TEST_PROGS := mitigation-patching.sh
>   
>   top_srcdir = ../../../../..
>   
> -CFLAGS += -I../../../../../usr/include
> +CFLAGS += $(KHDR_INCLUDES)
>   
>   include ../../lib.mk
>   
> diff --git a/tools/testing/selftests/powerpc/syscalls/Makefile b/tools/testing/selftests/powerpc/syscalls/Makefile
> index b63f8459c704..d1f2648b112b 100644
> --- a/tools/testing/selftests/powerpc/syscalls/Makefile
> +++ b/tools/testing/selftests/powerpc/syscalls/Makefile
> @@ -1,7 +1,7 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   TEST_GEN_PROGS := ipc_unmuxed rtas_filter
>   
> -CFLAGS += -I../../../../../usr/include
> +CFLAGS += $(KHDR_INCLUDES)
>   
>   top_srcdir = ../../../../..
>   include ../../lib.mk
> diff --git a/tools/testing/selftests/powerpc/tm/Makefile b/tools/testing/selftests/powerpc/tm/Makefile
> index 5881e97c73c1..3876805c2f31 100644
> --- a/tools/testing/selftests/powerpc/tm/Makefile
> +++ b/tools/testing/selftests/powerpc/tm/Makefile
> @@ -17,7 +17,7 @@ $(TEST_GEN_PROGS): ../harness.c ../utils.c
>   CFLAGS += -mhtm
>   
>   $(OUTPUT)/tm-syscall: tm-syscall-asm.S
> -$(OUTPUT)/tm-syscall: CFLAGS += -I../../../../../usr/include
> +$(OUTPUT)/tm-syscall: CFLAGS += $(KHDR_INCLUDES)
>   $(OUTPUT)/tm-tmspr: CFLAGS += -pthread
>   $(OUTPUT)/tm-vmx-unavail: CFLAGS += -pthread -m64
>   $(OUTPUT)/tm-resched-dscr: ../pmu/lib.c

Adding powerpc maitainers.

Would you me to take this patch through kselftest tree? If you
decide to take this through yours:

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
