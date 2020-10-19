Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB7E29320D
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 01:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388972AbgJSXiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 19:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgJSXiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 19:38:14 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70880C0613CE
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 16:38:14 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w11so625386pll.8
        for <stable@vger.kernel.org>; Mon, 19 Oct 2020 16:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=mMyOOTA+qM4WB3OIOjM+vOGGfCTR7HflUyF9on66ERI=;
        b=fTz46wi0hX/hafe9fY6bnj1wzDQHVKz304OWwp70trJuXtEsq3NBE+VvS9fswx2ySk
         VmGgf/AxESiP8Q5Re25xBTZ0nzC0eTowKo/vjW5NuOcifnG/DI5ihsNfISQ3bvqa1qnn
         ykkKlTnZ8QItkQFSyP8ymmukcQb4hB5mlFkKlCOrXXYie1LCh8qUnRpbZwCdgeXKZW0C
         2SQrPBcAI7bOWvB1sRAl79jPONoQhjoa0oXhYsVY8XK3TOZPB4/avdMXxAix4vEY0++3
         NH27kP4pYE+SG8e3vuYHX8GdmP6TGIXm7iOHZXihONRVVaQLgbu2s1VtvfLdcadUyZOA
         WSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=mMyOOTA+qM4WB3OIOjM+vOGGfCTR7HflUyF9on66ERI=;
        b=YwvIyoq7vP92fUweGEnNzUw8cFZ+ii1wjWbff0VNiG03j+I536lskdWn0vgODnwSLU
         tsfLDWA2oRTBUdiAhJvpCDU2Puq/IPHnumEUJvAHrt7k4Bf9j8KrnItGQeNwGpX8UIt9
         PlmjNj0O743wx99YAaeKLIsNG5bLrGOtMiLhvI4gND3aMlBaQOKHC26f1DHmprfqXeN2
         tWZnabvmKg9UBVpnVs7aS8kFiTYx8JuGeCLL0xq43AJWjkQNQ0I8T4dy0CXOvO6IrcFj
         ZFXcG8c8aP4stYnP4cCU5Vw7gMWMYjthvm1fYBhUeQI6q7/YPHOOrID2vgMQdvtlkxwc
         r61g==
X-Gm-Message-State: AOAM532Ws8w1iuDCimJu14zyV8Z1sCDrtvNNe78fcoi2pUXyY3wstrep
        xtThBltDSVTg8HZr+mbq1v2x3g==
X-Google-Smtp-Source: ABdhPJwjCCG6LX/pjQJTuF7rncGuieqnBd8IEbtSRb49e4/4aqM4+E9+1mnzLK8gWK4uTDqgL4N0AQ==
X-Received: by 2002:a17:902:9681:b029:d5:cdbd:c38c with SMTP id n1-20020a1709029681b02900d5cdbdc38cmr86753plp.85.1603150693662;
        Mon, 19 Oct 2020 16:38:13 -0700 (PDT)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id t5sm582639pgs.74.2020.10.19.16.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 16:38:12 -0700 (PDT)
Date:   Mon, 19 Oct 2020 16:38:12 -0700 (PDT)
X-Google-Original-Date: Mon, 19 Oct 2020 16:37:21 PDT (-0700)
Subject:     Re: [PATCH] RISC-V: Fix the VDSO symbol generaton for binutils-2.34+
In-Reply-To: <20201019204121.jaw7mqn4bkn2h6mx@google.com>
CC:     Nick Desaulniers <ndesaulniers@google.com>,
        linux-riscv@lists.infradead.org, kernel-team@android.com,
        stable@vger.kernel.org, clang-built-linux@googlegroups.com
From:   Palmer Dabbelt <palmerdabbelt@google.com>
To:     maskray@google.com
Message-ID: <mhng-68644eee-bf80-46ee-aecd-466157800f59@palmerdabbelt-glaptop1>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Oct 2020 13:41:21 PDT (-0700), maskray@google.com wrote:
> On 2020-10-19, 'Nick Desaulniers' via Clang Built Linux wrote:
>>On Fri, Oct 16, 2020 at 5:44 PM 'Palmer Dabbelt' via Clang Built Linux
>><clang-built-linux@googlegroups.com> wrote:
>>>
>>> We were relying on GNU ld's ability to re-link executable files in order
>>> to extract our VDSO symbols.  This behavior was deemed a bug as of
>>> binutils-2.34 (specifically the binutils-gdb commit a87e1817a4 ("Have
>>> the linker fail if any attempt to link in an executable is made."),
>>> which IIUC landed in 2.34), which recently installed itself on my build
>>> setup.
>
> I filed the issue https://sourceware.org/bugzilla/show_bug.cgi?id=26047
> The commit is in 2.35 but not in the released 2.34 branch.

Thanks.  Looks like it was backported to the Debian 2.34, I guess I was off by
a release when looking.  Regardless, I think the fix in binutils is reasonable
and that we just shouldn't be doing this sort of thing.

>>> The previous version of this was a bit of a mess: we were linking a
>>> static executable version of the VDSO, containing only a subset of the
>>> input symbols, which we then linked into the kernel.  This worked, but
>>> certainly wasn't a supported path through the toolchain.  Instead this
>>> new version parses the textual output of nm to produce a symbol table.
>>> Both rely on near-zero addresses being linkable, but as we rely on weak
>>> undefined symbols being linkable elsewhere I don't view this as a major
>>> issue.
>>>
>>> Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
>>> Cc: stable@vger.kernel.org
>>> Cc: clang-built-linux@googlegroups.com
>>> Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
>>
>>Ah, I do see a build failure to link the vdso with:
>>$ riscv64-linux-gnu-ld --version
>>GNU ld (GNU Binutils for Debian) 2.34.90.20200706
>>
>>riscv64-linux-gnu-ld: cannot use executable file
>>'arch/riscv/kernel/vdso/vdso-dummy.o' as input to a link
>>
>>This patch fixes that for me, but there's a problem related to related
>>to `nm` below.
>>
>>After this, there's two other things we might want to fix up related
>>to the build of the vdso:
>>1. it looks like $(CC) is being used to link the vdso, rather than
>>$(LD).  While it's generally fine to use the compiler as the driver
>>for building a linked object file, it does not respect the set $(LD).
>>`-fuse-ld=` needs to be passed to invoke the linker the user
>>specified.  See also:
>>https://lore.kernel.org/linux-kbuild/20201013033947.2257501-1-natechancellor@gmail.com/T/#u
>>(this has popped up in a few places when trying to do hermetic builds
>>with LLD).
>>2. I observe the warning when building with clang: `argument unused
>>during compilation: '-no-pie' [-Wunused-command-line-argument]`. IIRC,
>>the top level Makefile sets `-Qunused-arguments` for builds with
>>clang.  `cmd_vdsold` may need that, but it's curious why it's unused
>>and makes me wonder why/if `-no-pie` is necessary?  That also might be
>>fixed by fixing 1.
>>
>>> ---
>>>  arch/riscv/kernel/vdso/.gitignore |  1 +
>>>  arch/riscv/kernel/vdso/Makefile   | 19 +++++++++----------
>>>  arch/riscv/kernel/vdso/so2s.sh    |  7 +++++++
>>>  3 files changed, 17 insertions(+), 10 deletions(-)
>>>  create mode 100755 arch/riscv/kernel/vdso/so2s.sh
>>>
>>> diff --git a/arch/riscv/kernel/vdso/.gitignore b/arch/riscv/kernel/vdso/.gitignore
>>> index 11ebee9e4c1d..3a19def868ec 100644
>>> --- a/arch/riscv/kernel/vdso/.gitignore
>>> +++ b/arch/riscv/kernel/vdso/.gitignore
>>> @@ -1,3 +1,4 @@
>>>  # SPDX-License-Identifier: GPL-2.0-only
>>>  vdso.lds
>>>  *.tmp
>>> +vdso-syms.S
>>> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
>>> index 478e7338ddc1..2e02958f6224 100644
>>> --- a/arch/riscv/kernel/vdso/Makefile
>>> +++ b/arch/riscv/kernel/vdso/Makefile
>>> @@ -43,19 +43,14 @@ $(obj)/vdso.o: $(obj)/vdso.so
>>>  SYSCFLAGS_vdso.so.dbg = $(c_flags)
>>>  $(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
>>>         $(call if_changed,vdsold)
>>> +SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
>>> +       -Wl,--build-id -Wl,--hash-style=both
>>>
>>>  # We also create a special relocatable object that should mirror the symbol
>>>  # table and layout of the linked DSO. With ld --just-symbols we can then
>>>  # refer to these symbols in the kernel code rather than hand-coded addresses.
>>> -
>>> -SYSCFLAGS_vdso.so.dbg = -shared -s -Wl,-soname=linux-vdso.so.1 \
>>> -       -Wl,--build-id -Wl,--hash-style=both
>>> -$(obj)/vdso-dummy.o: $(src)/vdso.lds $(obj)/rt_sigreturn.o FORCE
>>> -       $(call if_changed,vdsold)
>>> -
>>> -LDFLAGS_vdso-syms.o := -r --just-symbols
>>> -$(obj)/vdso-syms.o: $(obj)/vdso-dummy.o FORCE
>>> -       $(call if_changed,ld)
>>> +$(obj)/vdso-syms.S: $(obj)/vdso.so FORCE
>>> +       $(call if_changed,so2s)
>>>
>>>  # strip rule for the .so file
>>>  $(obj)/%.so: OBJCOPYFLAGS := -S
>>> @@ -68,11 +63,15 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
>>>  # Make sure only to export the intended __vdso_xxx symbol offsets.
>>>  quiet_cmd_vdsold = VDSOLD  $@
>>>        cmd_vdsold = $(CC) $(KBUILD_CFLAGS) $(call cc-option, -no-pie) -nostdlib -nostartfiles $(SYSCFLAGS_$(@F)) \
>>> -                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp && \
>>> +                           -Wl,-T,$(filter-out FORCE,$^) -o $@.tmp -Wl,-Map,$@.map && \
>
> Is -Wl,-Map,$@.map needed?

Nope, that's there be accident.  I've fixed it for the v2.

Thanks!

>
>>>                     $(CROSS_COMPILE)objcopy \
>>>                             $(patsubst %, -G __vdso_%, $(vdso-syms)) $@.tmp $@ && \
>>>                     rm $@.tmp
>>>
>>> +# Extracts
>>> +quiet_cmd_so2s = SO2S    $@
>>> +      cmd_so2s = $(CROSS_COMPILE)nm -D $< | $(src)/so2s.sh > $@
>>
>>This should use `$(NM)` rather than `$(CROSS_COMPILE)nm` which
>>hardcodes the use of GNU nm from GNU binutils.
>>
>>> +
>>>  # install commands for the unstripped file
>>>  quiet_cmd_vdso_install = INSTALL $@
>>>        cmd_vdso_install = cp $(obj)/$@.dbg $(MODLIB)/vdso/$@
>>> diff --git a/arch/riscv/kernel/vdso/so2s.sh b/arch/riscv/kernel/vdso/so2s.sh
>>> new file mode 100755
>>> index 000000000000..7862866b5ebb
>>> --- /dev/null
>>> +++ b/arch/riscv/kernel/vdso/so2s.sh
>>> @@ -0,0 +1,6 @@
>>> +#!/bin/sh
>>> +# SPDX-License-Identifier: GPL-2.0+
>>> +# Copyright 2020 Palmer Dabbelt <palmerdabbelt@google.com>
>>> +
>>> +sed 's!\([0-9a-f]*\) T \([a-z0-9_]*\)@@LINUX_4.15!.global \2\n.set \2,0x\1!' \
>>> +| grep '^\.'
>>> --
>>
>>--
>>Thanks,
>>~Nick Desaulniers
>>
>>--
>>You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
>>To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
>>To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/CAKwvOdnsRHA1WMb7OWi-jV662xLrBBBZ%3DzBbB1gvfpBqVFeSfQ%40mail.gmail.com.
