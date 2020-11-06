Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBB92A8E9D
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 06:12:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgKFFM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 00:12:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbgKFFM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 00:12:26 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F6BC0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 21:12:26 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id z24so34434pgk.3
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 21:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=QlKPVJvptSHxEo+A5+CSfIRFa+87UtK/Q6phgNwsV8I=;
        b=dcgfMzLFZmYuzvKbWpSyLn3yZbBXUYIKer8hm6GKZKrtAw7q9ud/jSluymni/42ik6
         QGsBWv9/gLfdIwFJ4zD9lNvo2cOpO1Sgz8QWiG6k86TNz2QCnorozLiq5KjAqc8cTXzL
         Hs1n1zTl05QTF9zNCe9bYM7yKZMR5KGklGGLEwXGJ6CsQ5yCWrLvO86c4RpiBZ+xognQ
         dAZzC9dPHYAGFLFF5vMjYZFVk/jSptTSdLkEltYqqdFqsqJx7a33sqEpNqzpMNyrSx08
         4PQBKUM4GSW6XQOFYQ6872x+wbm2a2qJ0nxen8yUYK7cj8vzmneFg44RaVM1ptWmfg1W
         4L2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=QlKPVJvptSHxEo+A5+CSfIRFa+87UtK/Q6phgNwsV8I=;
        b=mJpsu989iR0V/uVsdV9oUsfsyRRCoNlug0SiOm/YBzclVSSJhGg4+RNUDYDCwe3r3O
         ZfRikrmDF3cn0L/Lt0wydRrfSMhmUHgG2WMVc467YcokMI+VnlSdBXfyHriAtCeC05lN
         7M8lhAIc/n6tElXVphhItj10hi5ST5x/NlXGLiU8iTT32+gwBitRhG73ramNPLAHFKCo
         j4TJgEusJ1JyT7J3rz+9xo93SJt2yuJJIzLnvQ+0fqyZgS440PyRrj7UqiupTn0pg2x1
         0L/wwBDijAGHcBCXwArShdcqW/vY0hjsckqK5XFBr7fH8Nu+3kIy5YDFzvhWMMKEl/fP
         dHHg==
X-Gm-Message-State: AOAM531dtWZ0vFGATMI0SZHYUbFbaeyMiaQR2Kk0ZRNjh3FpdFxO8Kkp
        DC0OOYNfauy7YiFOMxm59imd3w==
X-Google-Smtp-Source: ABdhPJxKBeZSmKe9QbTA2H+1hOdlI+wLSP61JYS8ax2nAW+5MKZ/IeAF5H1MkPBY5kxCJJyxy0UZKw==
X-Received: by 2002:a63:455b:: with SMTP id u27mr288406pgk.25.1604639545874;
        Thu, 05 Nov 2020 21:12:25 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id v191sm399421pfc.19.2020.11.05.21.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 21:12:25 -0800 (PST)
Date:   Thu, 05 Nov 2020 21:12:25 -0800 (PST)
X-Google-Original-Date: Thu, 05 Nov 2020 21:12:23 PST (-0800)
Subject:     Re: [PATCH v3] RISC-V: Fix the VDSO symbol generaton for binutils-2.35+
In-Reply-To: <20201106045902.GA2585953@ubuntu-m3-large-x86>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-riscv@lists.infradead.org, kernel-team@android.com,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     natechancellor@gmail.com
Message-ID: <mhng-e82ecf40-679a-41ed-b2b1-69c64a78f0b2@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 05 Nov 2020 20:59:02 PST (-0800), natechancellor@gmail.com wrote:
> On Thu, Nov 05, 2020 at 08:42:22PM -0800, 'Palmer Dabbelt' via Clang Built Linux wrote:
>> On Mon, 26 Oct 2020 12:48:08 PDT (-0700), Nick Desaulniers wrote:
>> > On Fri, Oct 23, 2020 at 10:03 PM 'Palmer Dabbelt' via Clang Built
>> > Linux <clang-built-linux@googlegroups.com> wrote:
>> > >
>> > > We were relying on GNU ld's ability to re-link executable files in order
>> > > to extract our VDSO symbols.  This behavior was deemed a bug as of
>> > > binutils-2.35 (specifically the binutils-gdb commit a87e1817a4 ("Have
>> > > the linker fail if any attempt to link in an executable is made."), but as that
>> > > has been backported to at least Debian's binutils-2.34 in may manifest in other
>> > > places.
>> > >
>> > > The previous version of this was a bit of a mess: we were linking a
>> > > static executable version of the VDSO, containing only a subset of the
>> > > input symbols, which we then linked into the kernel.  This worked, but
>> > > certainly wasn't a supported path through the toolchain.  Instead this
>> > > new version parses the textual output of nm to produce a symbol table.
>> > > Both rely on near-zero addresses being linkable, but as we rely on weak
>> > > undefined symbols being linkable elsewhere I don't view this as a major
>> > > issue.
>> > >
>> > > Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
>> > > Cc: clang-built-linux@googlegroups.com
>> > > Cc: stable@vger.kernel.org
>> > > Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
>> >
>> > Any way to improve the error message if/when this fails?
>> > https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/407165683
>>
>> Probably, but I can't get that command to actually run this stuff.  I tried
>> pulling the commands, but I'm getting some weirdness
>>
>> $ rm -f arch/riscv/kernel/vdso/vdso-syms.S
>> $ make ARCH=riscv defconfig
>> $ make -j2 AR=llvm-ar 'CC=clang' 'HOSTCC=clang' HOSTLD=ld KCFLAGS=-Wno-implicit-fallthrough LD=riscv64-linux-gnu-ld LLVM_IAS=1 NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump OBJSIZE=llvm-size READELF=llvm-readelf STRIP=llvm-strip ARCH=riscv Image
>
> This command is simpler and reproduces it for me locally on next-20201105.
>
> $ make -skj"$(nproc)" ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- LD=riscv64-linux-gnu-ld LLVM=1 distclean defconfig Image
> clang-12: warning: argument unused during compilation: '-no-pie' [-Wunused-command-line-argument]
> make[4]: *** [arch/riscv/kernel/vdso/Makefile:53: arch/riscv/kernel/vdso/vdso-syms.S] Error 1
> make[4]: *** Deleting file 'arch/riscv/kernel/vdso/vdso-syms.S'
> make[4]: Target '__build' not remade because of errors.
> make[3]: *** [scripts/Makefile.build:500: arch/riscv/kernel/vdso] Error 2
> make[3]: Target '__build' not remade because of errors.
> make[2]: *** [scripts/Makefile.build:500: arch/riscv/kernel] Error 2
> make[2]: Target '__build' not remade because of errors.
> make[1]: *** [Makefile:1797: arch/riscv] Error 2
> make[1]: Target 'Image' not remade because of errors.
> make: *** [Makefile:335: __build_one_by_one] Error 2
> make: Target 'distclean' not remade because of errors.
> make: Target 'defconfig' not remade because of errors.
> make: Target 'Image' not remade because of errors.
>
> <snip>
>
>> diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
>> index 3a19def868ec..88206dd8b472 100644
>> --- a/arch/riscv/kernel/vdso/.gitignore
>> +++ b/arch/riscv/kernel/vdso/.gitignore
>> @@ -2,3 +2,4 @@
>> vdso.lds
>> *.tmp
>> vdso-syms.S
>> +vdso-syms.nm
>> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
>> index a8ecf102e09b..fe5c969a6bf4 100644
>> --- a/arch/riscv/kernel/vdso/Makefile
>> +++ b/arch/riscv/kernel/vdso/Makefile
>> @@ -49,8 +49,11 @@ SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
>> # We also create a special relocatable object that should mirror the symbol
>> # table and layout of the linked DSO. With ld --just-symbols we can then
>> # refer to these symbols in the kernel code rather than hand-coded addresses.
>> -$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
>> -	$(call if_changed,so2s)
>> +$(obj)/vdso-syms.nm: $(obj)/vdso.so
>> +	$(call if_changed,nm_d)
>> +
>> +$(obj)/vdso-syms.S: $(obj)/vdso-syms.nm
>> +	$(call if_changed,nm2s)
>>
>> # strip rule for the .so file
>> $(obj)/%.so: OBJCOPYFLAGS := -S
>> @@ -68,9 +71,13 @@ quiet_cmd_vdsold = VDSOLD  $@
>>                            $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
>>                    rm $@.tmp
>>
>> -# Extracts
>> -quiet_cmd_so2s = SO2S    $@
>> -      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
>> +# Extracts symbol offsets from the VDSO, converting them into an assembly file
>> +# that contains the same symbols at the same offsets.
>> +quiet_cmd_nm_d = NM -D   $@
>> +      cmd_nm_d = $(NM) -D $< > $@
>> +
>> +quiet_cmd_nm2s = SYMS2S  $@
>> +      cmd_nm2s = cat $< | $(srctree)/$(src)/so2s.sh > $@
>>
>> # install commands for the unstripped file
>> quiet_cmd_vdso_install = INSTALL $@
>>
>> For reference, here's the output of nmo for me:
>>
>> $ cat arch/riscv/kernel/vdso/vdso-syms.nm 0000000000000000 A LINUX_4.15
>> 00000000000009e0 T __vdso_clock_getres@@LINUX_4.15
>> 000000000000080a T __vdso_clock_gettime@@LINUX_4.15
>> 0000000000000a48 T __vdso_flush_icache@@LINUX_4.15
>> 0000000000000a3c T __vdso_getcpu@@LINUX_4.15
>> 0000000000000916 T __vdso_gettimeofday@@LINUX_4.15
>> 0000000000000800 T __vdso_rt_sigreturn@@LINUX_4.15
>
> This diff does not solve the issue for me with the above command.

It wasn't really meant to solve anything, just split the commands up a touch
more so we could see what's going on.

I just installed Debian's toolchain, which is LLVM 9.  IIRC that's pretty
ancient WRT RISC-V, so my guess is that it's just a long way from building
Linux.  Looks like llvm-nm on my system doesn't put the @@LINUX_4.15 after the
symbol names, I think this should do it?

diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
index 3c5b43207658..e64cb6d9440e 100755
--- a/arch/riscv/kernel/vdso/so2s.sh
+++ b/arch/riscv/kernel/vdso/so2s.sh
@@ -2,5 +2,5 @@
 # SPDX-License-Identifier: GPL-2.0+
 # Copyright 2020 Palmer Dabbelt <palmerdabbelt@google.com>
 
-sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)@@LINUX_4.15!.global \2\n.set \2,0x\1!' \
+sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)\(@@LINUX_4.15\)*!.global \2\n.set \2,0x\1!' \
 | grep '^\.'

It works for me, at least for this specific problem.

$ llvm-nm-9 -D arch/riscv/kernel/vdso/vdso.so | ./arch/riscv/kernel/vdso/so2s.sh 
.global __vdso_clock_getres
.set __vdso_clock_getres,0x00000000000009e0
.global __vdso_clock_gettime
.set __vdso_clock_gettime,0x000000000000080a
.global __vdso_flush_icache
.set __vdso_flush_icache,0x0000000000000a48
.global __vdso_getcpu
.set __vdso_getcpu,0x0000000000000a3c
.global __vdso_gettimeofday
.set __vdso_gettimeofday,0x0000000000000916
.global __vdso_rt_sigreturn
.set __vdso_rt_sigreturn,0x0000000000000800
$ nm -D arch/riscv/kernel/vdso/vdso.so | ./arch/riscv/kernel/vdso/so2s.sh 
.global __vdso_clock_getres
.set __vdso_clock_getres,0x00000000000009e0
.global __vdso_clock_gettime
.set __vdso_clock_gettime,0x000000000000080a
.global __vdso_flush_icache
.set __vdso_flush_icache,0x0000000000000a48
.global __vdso_getcpu
.set __vdso_getcpu,0x0000000000000a3c
.global __vdso_gettimeofday
.set __vdso_gettimeofday,0x0000000000000916
.global __vdso_rt_sigreturn
.set __vdso_rt_sigreturn,0x0000000000000800

>
> Cheers,
> Nathan
