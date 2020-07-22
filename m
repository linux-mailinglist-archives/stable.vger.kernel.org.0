Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3C622900A
	for <lists+stable@lfdr.de>; Wed, 22 Jul 2020 07:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgGVFpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 01:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbgGVFpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 01:45:19 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39F6C0619DD
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 22:45:18 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m9so605480pfh.0
        for <stable@vger.kernel.org>; Tue, 21 Jul 2020 22:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HjveECGjE3OoKFqTWNIsemnU4Ra081f5febv5hO4Ml8=;
        b=EGqj1zBx1inUAM3XI9KoZrVm+Npz0rN892Sx/ndQFEAMwXFJXlb7tKvSIwdL9jBdSy
         yR3D3wtxizHeqV6S4pTMowuDA8It3LU25FqQ2WnpC0CFjL21KLbYg+9eIRIAQGX8houw
         JuzbOsO8npSZzv66JkpaziXuq3KbYKhu/uNmUbrwqkc//bYcUw/VeHmQ3yvUQQYlMIWY
         MG/4Prb43I3DEtnv24zrljKT1ZBHqRs5+aWlcwTbp4F3z0hNG3ckYBUdck+oam3eUJsV
         6qsM2nQZCOp9jOdZ3LTmZrnl1/NjE6PDf8fT1DpPRIX49pxAECN5uD4s+PXl7zyN0Bp+
         /1cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HjveECGjE3OoKFqTWNIsemnU4Ra081f5febv5hO4Ml8=;
        b=ECHPL+te/TGDEU/FAjvvC3xZIyNtGm39ND66GD2csLy/ZycTGaxDlhm3NsdL+Gp8Uh
         tdiIOo7XyiC6xA3rwBUd4OsdkOa+IBnJthv3tQ8L1zpPCuqbS2wR1YdcThqkwyqVHrA7
         qn88/eBr6oMsX0O7vsSp1MrTSu9vx+TDk//RggEOEtnOLj00uIkPliIQHXxkwO57nmZu
         z1O/o0tHcXqpznewgVvMrULxm9gsRRpQMoQfXjJYCidqeWP+75uX3njbsrp0O8sMSjFy
         xfek0MpznB5zO6N6UBEt8xGnktTsfXge4pue4uxAYCTYOyDlS9XnjY2DSYQ28eo+vR5U
         1DKQ==
X-Gm-Message-State: AOAM531qAttcdTIMDO/Pdq7ZkjgVMP1A9VWBAD6pH2Ugdh6jlAN1K5RZ
        MZJM3UGAaJ/0HVTrdck0vl9HbXOwu3A=
X-Google-Smtp-Source: ABdhPJwPzhH3TEWEpcvxEX8aRBA3QMLWIri07NH/ccuSeJUtj3rZsXy4xWDOjyQTuRScl0pXwyQqIg==
X-Received: by 2002:a63:6e0e:: with SMTP id j14mr24503833pgc.384.1595396717768;
        Tue, 21 Jul 2020 22:45:17 -0700 (PDT)
Received: from google.com ([2620:15c:2ce:0:a6ae:11ff:fe11:4abb])
        by smtp.gmail.com with ESMTPSA id mv6sm4869305pjb.57.2020.07.21.22.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 22:45:17 -0700 (PDT)
Date:   Tue, 21 Jul 2020 22:45:14 -0700
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
Message-ID: <20200722054514.q5fg5dbduq5skwlg@google.com>
References: <20200721173125.1273884-1-maskray@google.com>
 <CAK7LNARjOjr2wSD_iM6yNSZpSGEWrkZZuWKCgCqOrYcA29+LBA@mail.gmail.com>
 <20200722001424.qor3up6357jjsbia@google.com>
 <CAK7LNAQtqdTi49cYL0zVWdqPV2QEsgN+2AACALumanu9L=OuGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAK7LNAQtqdTi49cYL0zVWdqPV2QEsgN+2AACALumanu9L=OuGg@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-07-22, Masahiro Yamada wrote:
>On Wed, Jul 22, 2020 at 9:14 AM Fangrui Song <maskray@google.com> wrote:
>>
>> On 2020-07-22, Masahiro Yamada wrote:
>> >On Wed, Jul 22, 2020 at 2:31 AM 'Fangrui Song' via Clang Built Linux
>> ><clang-built-linux@googlegroups.com> wrote:
>> >>
>> >> When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
>> >> $(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
>> >> GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
>> >> /usr/bin/ and Clang as of 11 will search for both
>> >> $(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.
>> >>
>> >> GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
>> >> $(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
>> >> $(prefix)aarch64-linux-gnu/$needle rarely contains executables.
>> >>
>> >> To better model how GCC's -B/--prefix takes in effect in practice, newer
>> >> Clang (since
>> >> https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
>> >> only searches for $(prefix)$needle. Currently it will find /usr/bin/as
>> >> instead of /usr/bin/aarch64-linux-gnu-as.
>> >>
>> >> Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
>> >> (/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
>> >> appropriate cross compiling GNU as (when -no-integrated-as is in
>> >> effect).
>> >>
>> >> Cc: stable@vger.kernel.org
>> >> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
>> >> Signed-off-by: Fangrui Song <maskray@google.com>
>> >> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>> >> Tested-by: Nathan Chancellor <natechancellor@gmail.com>
>> >> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>> >> Link: https://github.com/ClangBuiltLinux/linux/issues/1099
>> >> ---
>> >> Changes in v2:
>> >> * Updated description to add tags and the llvm-project commit link.
>> >> * Fixed a typo.
>> >>
>> >> Changes in v3:
>> >> * Add Cc: stable@vger.kernel.org
>> >> ---
>> >>  Makefile | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/Makefile b/Makefile
>> >> index 0b5f8538bde5..3ac83e375b61 100644
>> >> --- a/Makefile
>> >> +++ b/Makefile
>> >> @@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
>> >>  ifneq ($(CROSS_COMPILE),)
>> >>  CLANG_FLAGS    += --target=$(notdir $(CROSS_COMPILE:%-=%))
>> >>  GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
>> >> -CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)
>> >> +CLANG_FLAGS    += --prefix=$(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)
>> >
>> >
>> >
>> >CROSS_COMPILE may contain the directory path
>> >to the cross toolchains.
>> >
>> >
>> >For example, I use aarch64-linux-gnu-*
>> >installed in
>> >/home/masahiro/tools/aarch64-linaro-7.5/bin
>> >
>> >
>> >
>> >Basically, there are two ways to use it.
>> >
>> >[1]
>> >PATH=$PATH:/home/masahiro/tools/aarch64-linaro-7.5/bin
>> >CROSS_COMPILE=aarch64-linux-gnu-
>> >
>> >
>> >[2]
>> >Without setting PATH,
>> >CROSS_COMPILE=~/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
>> >
>> >
>> >
>> >I usually do [2] (and so does intel's 0day bot).
>> >
>> >
>> >
>> >This patch works for the use-case [1]
>> >but if I do [2], --prefix is set to a strange path:
>> >
>> >--prefix=/home/masahiro/tools/aarch64-linaro-7.5/bin//home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
>>
>> Thanks. I did not know the use-case [2].
>> This explains why there is a `$(notdir ...)` in
>> `CLANG_FLAGS     += --target=$(notdir $(CROSS_COMPILE:%-=%))`
>>
>>
>> >
>> >
>> >Interestingly, the build is still successful.
>> >Presumably Clang searches for more paths
>> >when $(prefix)$needle is not found ?
>>
>> The priority order is:
>>
>> -B(--prefix), COMPILER_PATH, detected gcc-cross paths
>>
>> (In GCC, -B paths get prepended to the COMPILER_PATH list. Clang<=11 incorrectly
>> adds -B to the COMPILER_PATH list. I have fixed it for 12.0.0)
>>
>> If -B fails, the detected gcc-cross paths may still be able to find
>> /usr/bin/aarch64-linux-gnu-
>>
>> For example, on my machine (a variant of Debian testing), Clang finds
>> $(realpath
>> /usr/lib/gcc-cross/aarch64-linux-gnu/9/../../../../aarch64-linux-gnu/bin/as),
>> which is /usr/bin/aarch64-linux-gnu-as
>>
>> >
>> >I applied your patch and added -v option
>> >to see which assembler was internally invoked:
>> >
>> > "/home/masahiro/tools/aarch64-linaro-7.5/lib/gcc/aarch64-linux-gnu/7.5.0/../../../../aarch64-linux-gnu/bin/as"
>> >-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
>> >./include -I ./arch/arm64/include/uapi -I
>> >./arch/arm64/include/generated/uapi -I ./include/uapi -I
>> >./include/generated/uapi -o kernel/smp.o /tmp/smp-2ec2c7.s
>> >
>> >
>> >Ok, it looks like Clang found an alternative path
>> >to the correct 'as'.
>> >
>> >
>> >
>> >
>> >But, to keep the original behavior for both [1] and [2],
>> >how about this?
>> >
>> >CLANG_FLAGS += --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
>> >
>> >
>> >
>> >Then, I can get this:
>> >
>> > "/home/masahiro/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-as"
>> >-EL -I ./arch/arm64/include -I ./arch/arm64/include/generated -I
>> >./include -I ./arch/arm64/include/uapi -I
>> >./arch/arm64/include/generated/uapi -I ./include/uapi -I
>> >./include/generated/uapi -o kernel/smp.o /tmp/smp-16d76f.s
>>
>> This looks good.
>>
>> Agreed that `--prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))` should work for both [1] and [2].
>>
>> Shall I send a v4? Or you are kind enough that you'll just add your Signed-off-by: tag
>> and fix that for me? :)
>>
>
>I fixed it up and applied to linux-kbuild/fixes.
>Thanks.

Thanks!

The description 'Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE)'
should probably be fixed to say '$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))'

>While I am here, could you teach me a bit more?
>
>
>The top Makefile sets the following option as well:
>
>CLANG_GCC_TC    := --gcc-toolchain=$(GCC_TOOLCHAIN)
>
>
>
>I checked the manual:
>https://clang.llvm.org/docs/ClangCommandLineReference.html
>
>
>  -B<dir>, --prefix <arg>, --prefix=<arg>
>  Add <dir> to search path for binaries and object files used implicitly
>
>  --gcc-toolchain=<arg>, -gcc-toolchain <arg>
>  Use the gcc toolchain at the given directory
>
>
>
>
>It is not clear to me
>how they work differently when
>clang searches for toolchains.
>
>
>
>
>If I delete --gcc-toolchain from the top Makefile,
>clang fails to link standalone programs
>because it wrongly invokes /usr/bin/ld
>instead of aarch64-linux-gnu-ld.
>
>
>Does Clang search for gnu assembler
>based on --prefix option?
>
>And, searches for a linker
>based on --gcc-toolchain ?
>
>
>
>-- 
>Best Regards
>Masahiro Yamada

While GCC seems to encourage distributions to apply various environment
settings, Clang encourages downstream users to contribute their
configurations to the upstream clangDriver library... So, clang works
seemingly on many operating systems and many distributions without much
additional customization, but the host/target environment detection code
is very messy.

Freestanding builds (if you use integrated assembler/LLD) do not need --gcc-toolchain.

-fhosted builds need --gcc-toolchain to reuse libstdc++ include paths
and runtime libraries (crt1.o libgcc.a libgcc_s.so.1 etc).
I think on most Linux distributions, with distribution shipped GCC
packages, the only meaningful value is --gcc-toolchain=/usr

Clang will find 'lib' or 'lib64' under --gcc-toolchain= (e.g. /usr/lib),
then locate common cross-compiling GCC installations (e.g. /usr/lib +
gcc-cross/aarch-linux-gnu (Debian uses gcc-cross/), or just /usr/lib +
gcc/aarch-linux-gnu). You can see that with an incorrect --gcc-toolchain=/ (or some other arbitrary path):
(https://github.com/llvm/llvm-project/blob/master/clang/lib/Driver/ToolChains/Gnu.cpp#L1903 )

* `clang -v` does not print `Found candidate GCC installation: `
* There is no libstdc++ search path in `#include <...> search starts here:` for a C++ compile
* In the linking stage, ld reports a number of issues like 'cannot find crt1.o'

When --gcc-toolchain is not specified, in many cases Clang can guess the
correct value (usually /usr). So clang++ --target=aarch64-linux-gnu works just fine.

(As you can see from the code, the code --gcc-toolchain= is tangled with
environment detection, which is ugly: specifying a wrong --gcc-toolchain= can remove a lot of file stats...
You can find that the number of syscalls changes with different --gcc-toolchain: `strace -fe file clang`)

External programs like 'as' and 'ld' use the bin/ directory somewhere
relative to the GCC installation directory (they are appended to getProgramPaths).
clang::driver::Driver::GetProgramPath locates these programs.
https://github.com/llvm/llvm-project/blob/master/clang/lib/Driver/ToolChains/Gnu.cpp#L1903
As you see from the code, -B and COMPILER_PATH take precedence over
getProgramPaths.
You can print the 'programs' path with `clang --print-search-dirs [--target=...] [-B...] [--gcc-toolchain=...]`
Latest clang will be closer to GCC.
