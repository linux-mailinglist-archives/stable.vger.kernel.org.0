Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216FE2A7802
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 08:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgKEH1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 02:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbgKEH1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 02:27:00 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793FAC0613D4
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 23:26:58 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id z3so721802pfb.10
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 23:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V0nJfAeq3JFSY5yN0H+uBOSwyjDPQ9GUT0hanP1k660=;
        b=RuVHQPKxtxfoOThH7XJOEGi1n7OVLxAPwQYgZRxGhPQgxOnXmn1dIAteRQtMOQkLLn
         XZqPtUxh2to3RTU3k942+Al6R3nEwBf6t3sOBz9jdoXjI/+6JH/MrDEYXAPDRuY+SqPT
         wfPKsy2RwFFR6P4RpzhBg9gAj5KxGHpOghashFYJPLnU8aq4oaldLoCkPfx9wL9EH0eI
         JkG++ejRWc6PNDyhBd6aQzOGAJtZzIyPfMBs1Z8sJUhK0LL3uZntt7pwdPTqyPxWogx3
         wPY9djxtgRhVoUuPKMLJFVhF8u+imdmRU2S6qzfla+OlMI7TCoVQhwkh2/ev+4ogkAz1
         Ny8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V0nJfAeq3JFSY5yN0H+uBOSwyjDPQ9GUT0hanP1k660=;
        b=GzebxKC6Ln0bojfrIbyknoMVxuJf9Sbiq9rT1sCGzzDojlIxCiPgbm0t96hxcGd2DW
         Vax/x8Q++MYC09r8ANYw8U2UKivquvlZIqR+5lGruf8wXToJB4BLfMP/pQr/vMfjJ3Di
         bmrOVXLZevzIsYpb81xBK3p0DULxutLDhMP1LhSOp7mzHEcfg8yZOPfe1sx5Os+hXgJL
         NyuY6advgXZtD7kjmuqgqmtkUVEKdn4pym4ns0yfZCpdg+xJXwWY3DggOI0x9bVA8VwX
         j1n3jrEaO6SaWrHxEta0G76FWcb0CGKN9TM7SdEo8a8FluJwvMiElty6S6mWuVEKZP0U
         WnPA==
X-Gm-Message-State: AOAM532rtvDOtSOLDxqteRZHk4smqSY0XWgTnjaySnfOdKldLZ9/9IZO
        aKS70ZJ5k2XsuwFgaVqr2eJtHg==
X-Google-Smtp-Source: ABdhPJyAivdWoqD2MH6Gviecrs0Vhv4SxB4eoXeM1V0XYNSmIJ6yy5L13PjNLelkEKgRJGMMUvOrCg==
X-Received: by 2002:a63:f445:: with SMTP id p5mr1200747pgk.293.1604561217561;
        Wed, 04 Nov 2020 23:26:57 -0800 (PST)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id j11sm1203750pfh.143.2020.11.04.23.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 23:26:56 -0800 (PST)
Date:   Wed, 4 Nov 2020 23:26:53 -0800
From:   Fangrui Song <maskray@google.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-toolchains@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dmitry Golovin <dima@golovin.in>,
        Alistair Delva <adelva@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] Kbuild: do not emit debug info for assembly with
 LLVM_IAS=1
Message-ID: <20201105072653.wxlzat5azj7h4ttj@google.com>
References: <CAK7LNAST0Ma4bGGOA_HATzYAmRhZG=x_X=8p_9dKGX7bYc2FMA@mail.gmail.com>
 <20201104005343.4192504-1-ndesaulniers@google.com>
 <20201104005343.4192504-3-ndesaulniers@google.com>
 <20201105065844.GA3243074@ubuntu-m3-large-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201105065844.GA3243074@ubuntu-m3-large-x86>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2020-11-04, Nathan Chancellor wrote:
>On Tue, Nov 03, 2020 at 04:53:41PM -0800, Nick Desaulniers wrote:
>> Clang's integrated assembler produces the warning for assembly files:
>>
>> warning: DWARF2 only supports one section per compilation unit
>>
>> If -Wa,-gdwarf-* is unspecified, then debug info is not emitted.  This
>
>Is this something that should be called out somewhere? If I understand
>this correctly, LLVM_IAS=1 + CONFIG_DEBUG_INFO=y won't work? Maybe this
>should be handled in Kconfig?
>
>> will be re-enabled for new DWARF versions in a follow up patch.
>>
>> Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
>> LLVM=1 LLVM_IAS=1 for x86_64 and arm64.
>>
>> Cc: <stable@vger.kernel.org>
>> Link: https://github.com/ClangBuiltLinux/linux/issues/716
>> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> Suggested-by: Dmitry Golovin <dima@golovin.in>
>
>If you happen to respin, Dmitry deserves a Reported-by tag too :)
>
>> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
>> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>
>Regardless of the other two comments, this is fine as is as a fix for
>stable to unblock Android + CrOS since we have been running something
>similar to it in CI:
>
>Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>
>> ---
>>  Makefile | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/Makefile b/Makefile
>> index f353886dbf44..75b1a3dcbf30 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -826,7 +826,9 @@ else
>>  DEBUG_CFLAGS	+= -g
>>  endif
>>
>> +ifndef LLVM_IAS
>
>Nit: this should probably match the existing LLVM_IAS check
>
>ifneq ($(LLVM_IAS),1)
>
>>  KBUILD_AFLAGS	+= -Wa,-gdwarf-2
>> +endif
>>
>>  ifdef CONFIG_DEBUG_INFO_DWARF4
>>  DEBUG_CFLAGS	+= -gdwarf-4
>> --
>> 2.29.1.341.ge80a0c044ae-goog
>>

The root cause is that DWARF v2 has no DW_AT_ranges, so it cannot
represent non-contiguous address ranges. It seems that GNU as -gdwarf-3
emits DW_AT_ranges as well and emits an entry for a non-executable section.
In any case, the option is of very low value, at least for LLVM.


Reviewed-by: Fangrui Song <maskray@google.com>
