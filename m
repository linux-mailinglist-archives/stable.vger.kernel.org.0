Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA03E2A8E85
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 05:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725837AbgKFE7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 23:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKFE7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 23:59:05 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B179C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 20:59:05 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id u21so180701iol.12
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 20:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AUTEF32bF9kjuo/eDBOdV11pkCJfqfx6fmnPbKlY8U8=;
        b=eaemJZspyt9iVfPe2FtsaUtA0y1aukxEltuXwKp3Ob+Nhk/P9u5qAB/G32obEkREsj
         F7IB2TlEBxNTpxz8LofQkSqkh6FcOc8YG2zX3z618hxmRshFRAaE1BrGo1Z+b5WauOzH
         IOFYmyufBD+IKL8DYEvee1fkF373/P7K0ECnTefAJ0ftlaTaT+j8q00+o8O42e6vNoRo
         23HzyzXdZNaUybaGIbAe7BmgqeXwSHWHNb5qR2hDDdyVuAW2NK67Wb0oEgoqv+JR65KA
         5S7ejcldFA1xSwHXT2XInoBqzTj5QAYgSadqSZFlQM6Qh9yDOKAmRygO4GL5nc6/7LME
         VT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AUTEF32bF9kjuo/eDBOdV11pkCJfqfx6fmnPbKlY8U8=;
        b=sFatnTYMAoRw8xHKaPiwj5G9IoQU9fQHLCauNfRz+WQIaMdynKWogFoILcvX1HA/D8
         tW8HLPLaCZGlxzc12eW+Jp+eMxumawZdaCd0XdFHYUBGccQXCf9faWFNtpKqNlUyF+y/
         aSjkZWKvqa9JYEfu6rnsyI+TN52I57LkBSabgaLudX99PHyov7qNCI00lZDA9gLAYgfa
         7WlMTzRkCMM1dw+cZCVJ60Tsf4ited9LoSLaDDP+aoT9SHjrCFrVOQwqeZGf+99kUnV2
         LXF9LPFcXhRE2IC93+PnlKYjhxG+OqtOqIxUBcQdDOzTaLMXPhfBIdhfRf68i5NNaLzB
         wgDw==
X-Gm-Message-State: AOAM531V4PLXgGwSZ1u0XWFZZ4hW5v3AbUz8zzp9zKzD+GzihxWAtiuG
        OrxSKVsdSt6DnH93J/LdEKBZ0BwRTZM=
X-Google-Smtp-Source: ABdhPJzX+New6GncNJQVgTgEljL2KAXEeo9WrC35B7BAXfZxOkRqA7LkhBXOliHQAtvYAy9SlInnHQ==
X-Received: by 2002:a02:cc84:: with SMTP id s4mr245120jap.126.1604638744568;
        Thu, 05 Nov 2020 20:59:04 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id u18sm53474iob.53.2020.11.05.20.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 20:59:03 -0800 (PST)
Date:   Thu, 5 Nov 2020 21:59:02 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Palmer Dabbelt <palmerdabbelt@google.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-riscv@lists.infradead.org, kernel-team@android.com,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] RISC-V: Fix the VDSO symbol generaton for
 binutils-2.35+
Message-ID: <20201106045902.GA2585953@ubuntu-m3-large-x86>
References: <CAKwvOdn5ib_WHpTg8YpHtqeOMLs+QDxVkzb8fuyDUL_N9BA_xw@mail.gmail.com>
 <mhng-dba8756e-d51b-4ce0-8987-51fcf9674c24@palmerdabbelt-glaptop1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mhng-dba8756e-d51b-4ce0-8987-51fcf9674c24@palmerdabbelt-glaptop1>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 05, 2020 at 08:42:22PM -0800, 'Palmer Dabbelt' via Clang Built Linux wrote:
> On Mon, 26 Oct 2020 12:48:08 PDT (-0700), Nick Desaulniers wrote:
> > On Fri, Oct 23, 2020 at 10:03 PM 'Palmer Dabbelt' via Clang Built
> > Linux <clang-built-linux@googlegroups.com> wrote:
> > > 
> > > We were relying on GNU ld's ability to re-link executable files in order
> > > to extract our VDSO symbols.  This behavior was deemed a bug as of
> > > binutils-2.35 (specifically the binutils-gdb commit a87e1817a4 ("Have
> > > the linker fail if any attempt to link in an executable is made."), but as that
> > > has been backported to at least Debian's binutils-2.34 in may manifest in other
> > > places.
> > > 
> > > The previous version of this was a bit of a mess: we were linking a
> > > static executable version of the VDSO, containing only a subset of the
> > > input symbols, which we then linked into the kernel.  This worked, but
> > > certainly wasn't a supported path through the toolchain.  Instead this
> > > new version parses the textual output of nm to produce a symbol table.
> > > Both rely on near-zero addresses being linkable, but as we rely on weak
> > > undefined symbols being linkable elsewhere I don't view this as a major
> > > issue.
> > > 
> > > Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
> > > Cc: clang-built-linux@googlegroups.com
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
> > 
> > Any way to improve the error message if/when this fails?
> > https://travis-ci.com/github/ClangBuiltLinux/continuous-integration/jobs/407165683
> 
> Probably, but I can't get that command to actually run this stuff.  I tried
> pulling the commands, but I'm getting some weirdness
> 
> $ rm -f arch/riscv/kernel/vdso/vdso-syms.S
> $ make ARCH=riscv defconfig
> $ make -j2 AR=llvm-ar 'CC=clang' 'HOSTCC=clang' HOSTLD=ld KCFLAGS=-Wno-implicit-fallthrough LD=riscv64-linux-gnu-ld LLVM_IAS=1 NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump OBJSIZE=llvm-size READELF=llvm-readelf STRIP=llvm-strip ARCH=riscv Image

This command is simpler and reproduces it for me locally on next-20201105.

$ make -skj"$(nproc)" ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- LD=riscv64-linux-gnu-ld LLVM=1 distclean defconfig Image
clang-12: warning: argument unused during compilation: '-no-pie' [-Wunused-command-line-argument]
make[4]: *** [arch/riscv/kernel/vdso/Makefile:53: arch/riscv/kernel/vdso/vdso-syms.S] Error 1
make[4]: *** Deleting file 'arch/riscv/kernel/vdso/vdso-syms.S'
make[4]: Target '__build' not remade because of errors.
make[3]: *** [scripts/Makefile.build:500: arch/riscv/kernel/vdso] Error 2
make[3]: Target '__build' not remade because of errors.
make[2]: *** [scripts/Makefile.build:500: arch/riscv/kernel] Error 2
make[2]: Target '__build' not remade because of errors.
make[1]: *** [Makefile:1797: arch/riscv] Error 2
make[1]: Target 'Image' not remade because of errors.
make: *** [Makefile:335: __build_one_by_one] Error 2
make: Target 'distclean' not remade because of errors.
make: Target 'defconfig' not remade because of errors.
make: Target 'Image' not remade because of errors.

<snip>

> diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
> index 3a19def868ec..88206dd8b472 100644
> --- a/arch/riscv/kernel/vdso/.gitignore
> +++ b/arch/riscv/kernel/vdso/.gitignore
> @@ -2,3 +2,4 @@
> vdso.lds
> *.tmp
> vdso-syms.S
> +vdso-syms.nm
> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
> index a8ecf102e09b..fe5c969a6bf4 100644
> --- a/arch/riscv/kernel/vdso/Makefile
> +++ b/arch/riscv/kernel/vdso/Makefile
> @@ -49,8 +49,11 @@ SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
> # We also create a special relocatable object that should mirror the symbol
> # table and layout of the linked DSO. With ld --just-symbols we can then
> # refer to these symbols in the kernel code rather than hand-coded addresses.
> -$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
> -	$(call if_changed,so2s)
> +$(obj)/vdso-syms.nm: $(obj)/vdso.so
> +	$(call if_changed,nm_d)
> +
> +$(obj)/vdso-syms.S: $(obj)/vdso-syms.nm
> +	$(call if_changed,nm2s)
> 
> # strip rule for the .so file
> $(obj)/%.so: OBJCOPYFLAGS := -S
> @@ -68,9 +71,13 @@ quiet_cmd_vdsold = VDSOLD  $@
>                            $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
>                    rm $@.tmp
> 
> -# Extracts
> -quiet_cmd_so2s = SO2S    $@
> -      cmd_so2s = $(NM) -D $< | $(srctree)/$(src)/so2s.sh > $@
> +# Extracts symbol offsets from the VDSO, converting them into an assembly file
> +# that contains the same symbols at the same offsets.
> +quiet_cmd_nm_d = NM -D   $@
> +      cmd_nm_d = $(NM) -D $< > $@
> +
> +quiet_cmd_nm2s = SYMS2S  $@
> +      cmd_nm2s = cat $< | $(srctree)/$(src)/so2s.sh > $@
> 
> # install commands for the unstripped file
> quiet_cmd_vdso_install = INSTALL $@
> 
> For reference, here's the output of nmo for me:
> 
> $ cat arch/riscv/kernel/vdso/vdso-syms.nm 0000000000000000 A LINUX_4.15
> 00000000000009e0 T __vdso_clock_getres@@LINUX_4.15
> 000000000000080a T __vdso_clock_gettime@@LINUX_4.15
> 0000000000000a48 T __vdso_flush_icache@@LINUX_4.15
> 0000000000000a3c T __vdso_getcpu@@LINUX_4.15
> 0000000000000916 T __vdso_gettimeofday@@LINUX_4.15
> 0000000000000800 T __vdso_rt_sigreturn@@LINUX_4.15

This diff does not solve the issue for me with the above command.

Cheers,
Nathan
