Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB3B23D517
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 03:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgHFB2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 21:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgHFB2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 21:28:50 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D972EC061574
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 18:28:49 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s15so14278104pgc.8
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 18:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IGx7YAnxVPWW5jB7dCzlu8YwhaVB96cmPWhZ+2cwFac=;
        b=vAW0HHy2eKk4CUooLYx9h1eCi0c5d9ZL4upPPC8ZLqX1W7SD5BNXt5sf3SdO09ezp9
         S753TAxJmtClTFzq82YEWMECsxGawSiuSg5UVeJTTnMFG8k3I0oK/2ogVepA9dAgIuJ8
         y7VIGNVG03n0yephIysHHYXBi1SFtC5pdw519LzibJNTSev4H/R2eWHr3cg1CYPd9kfj
         e3Sn7Ktta8aYTnbF5kIDd/LqoQigYf/rZKamXBGk57DBRsk/8N7f4yw9485hnAIYrx1u
         XzHAiwKMxWfKIerT2/Nd94iRoIrxBXzLO8vrrM8c9cYwFbT1NvXyjye8gY65DtlTytLb
         wpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IGx7YAnxVPWW5jB7dCzlu8YwhaVB96cmPWhZ+2cwFac=;
        b=AzJ+gzzw648rAPmgwq4V9hXj/WUM+5LJcMPiX/GZ5P+hdShX59Sm0VYwiNyTykK+I+
         e+5Mdj0NWTPmR+CIeCM71cZbcNuRTajlkBCbxuq9F4kl2pK69Prpdx3IgRDJrmUmiOJQ
         lHLjVSON9nQEoD/47WVz1DqgulTYLGXmGxfTeN2yXHnk2M783Rym/2EKqmaGRXAD4vlv
         mVD6KrL3/6kq1ymrIZIo+iCtrzT5fQrO5gVynDSA71puLrBGRzGOguHvIKKAyyt24pXj
         GQ/eLhjQEZlSohVLSQCevj/4+a0tHC4V6MWZ/0kZbITRnmqRrS10HsHbapJX48Lp/iNn
         TKaA==
X-Gm-Message-State: AOAM531w9cMXhR67jsaYJXu1Z0I/qefy0m9gjRrSvhSl85ib0xJcRxMV
        ROxE5RfWmqMjDb/f1pywcuZxrrTwjVUMEZk1s+remg==
X-Google-Smtp-Source: ABdhPJyaZP7VjflYSEEpii17+Sc7oTWqenSVopHmjxCkCw2vW5hjyF47Ax9disAHg827bCHZooGJ1s5btPxJanCz3LY=
X-Received: by 2002:a05:6a00:14d0:: with SMTP id w16mr5850934pfu.39.1596677329036;
 Wed, 05 Aug 2020 18:28:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200731230820.1742553-14-keescook@chromium.org> <20200806012406.D4A1E22D02@mail.kernel.org>
In-Reply-To: <20200806012406.D4A1E22D02@mail.kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 5 Aug 2020 18:28:36 -0700
Message-ID: <CAKwvOdmzTNyrYmW7wnB9v-bD916S83rSU-kfEnt0VwnPwu80Sw@mail.gmail.com>
Subject: Re: [PATCH v5 13/36] vmlinux.lds.h: add PGO and AutoFDO input sections
To:     Sasha Levin <sashal@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks for the report. We can provide manual backports then.  Our
prodkernel and CrOS teams both hit this issue within the past month.

On Wed, Aug 5, 2020 at 6:24 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.
>
> v5.7.11: Failed to apply! Possible dependencies:
>     655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
>
> v5.4.54: Failed to apply! Possible dependencies:
>     441110a547f8 ("vmlinux.lds.h: Provide EMIT_PT_NOTE to indicate export of .notes")
>     6434efbd9aef ("s390: Move RO_DATA into "text" PT_LOAD Program Header")
>     655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
>     6fc4000656a1 ("powerpc: Remove PT_NOTE workaround")
>     7a42d41d9dc2 ("x86/vmlinux: Restore "text" Program Header with dummy section")
>     eaf937075c9a ("vmlinux.lds.h: Move NOTES into RO_DATA")
>     fbe6a8e618a2 ("vmlinux.lds.h: Move Program Header restoration into NOTES macro")
>
> v4.19.135: Failed to apply! Possible dependencies:
>     15426ca43d88 ("s390: rescue initrd as early as possible")
>     369f91c37451 ("s390/decompressor: rework uncompressed image info collection")
>     3bad719b4954 ("powerpc/prom_init: Make of_workarounds static")
>     441110a547f8 ("vmlinux.lds.h: Provide EMIT_PT_NOTE to indicate export of .notes")
>     4e62d4588500 ("s390: clean up stacks setup")
>     5f69e38885c3 ("powerpc/prom_init: Move __prombss to it's own section and store it in .bss")
>     655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
>     67361cf80712 ("powerpc/ftrace: Handle large kernel configs")
>     8f75582a2fb6 ("s390: remove decompressor's head.S")
>     d1b52a4388ff ("s390: introduce .boot.data section")
>     e63334e556d9 ("powerpc/prom_init: Replace __initdata with __prombss when applicable")
>     eaf937075c9a ("vmlinux.lds.h: Move NOTES into RO_DATA")
>     fbe6a8e618a2 ("vmlinux.lds.h: Move Program Header restoration into NOTES macro")
>
> v4.14.190: Failed to apply! Possible dependencies:
>     01417c6cc7dc ("powerpc/64: Change soft_enabled from flag to bitmask")
>     0b63acf4a0eb ("powerpc/64: Move set_soft_enabled() and rename")
>     1696d0fb7fcd ("powerpc/64: Set DSCR default initially from SPR")
>     4e26bc4a4ed6 ("powerpc/64: Rename soft_enabled to irq_soft_mask")
>     5080332c2c89 ("powerpc/64s: Add workaround for P9 vector CI load issue")
>     5633e85b2c31 ("powerpc64: Add .opd based function descriptor dereference")
>     655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
>     67361cf80712 ("powerpc/ftrace: Handle large kernel configs")
>     9f83e00f4cc1 ("powerpc/64: Improve inline asm in arch_local_irq_disable")
>     ae30cc05bed2 ("powerpc64/ftrace: Implement support for ftrace_regs_caller()")
>     b5c1bd62c054 ("powerpc/64: Fix arch_local_irq_disable() prototype")
>     c2e480ba8227 ("powerpc/64: Add #defines for paca->soft_enabled flags")
>     ea678ac627e0 ("powerpc64/ftrace: Add a field in paca to disable ftrace in unsafe code paths")
>     ff967900c9d4 ("powerpc/64: Fix latency tracing for lazy irq replay")
>
> v4.9.231: Failed to apply! Possible dependencies:
>     096ff2ddba83 ("powerpc/ftrace/64: Split further based on -mprofile-kernel")
>     2f59be5b970b ("powerpc/ftrace: Restore LR from pt_regs")
>     454656155110 ("powerpc/asm: Use OFFSET macro in asm-offsets.c")
>     5633e85b2c31 ("powerpc64: Add .opd based function descriptor dereference")
>     655389666643 ("vmlinux.lds.h: Create section for protection against instrumentation")
>     67361cf80712 ("powerpc/ftrace: Handle large kernel configs")
>     700e64377c2c ("powerpc/ftrace: Move stack setup and teardown code into ftrace_graph_caller()")
>     7853f9c029ac ("powerpc: Split ftrace bits into a separate file")
>     99ad503287da ("powerpc: Add a prototype for mcount() so it can be versioned")
>     a97a65d53d9f ("KVM: PPC: Book3S: 64-bit CONFIG_RELOCATABLE support for interrupts")
>     ae30cc05bed2 ("powerpc64/ftrace: Implement support for ftrace_regs_caller()")
>     b3a7864c6feb ("powerpc/ftrace: Add prototype for prepare_ftrace_return()")
>     c02e0349d7e9 ("powerpc/ftrace: Fix the comments for ftrace_modify_code")
>     c4f3b52ce7b1 ("powerpc/64s: Disallow system reset vs system reset reentrancy")
>     d3918e7fd4a2 ("KVM: PPC: Book3S: Change interrupt call to reduce scratch space use on HV")
>     ea678ac627e0 ("powerpc64/ftrace: Add a field in paca to disable ftrace in unsafe code paths")
>
> v4.4.231: Failed to apply! Possible dependencies:
>     0f4c4af06eec ("kbuild: -ffunction-sections fix for archs with conflicting sections")
>     2aedcd098a94 ("kbuild: suppress annoying "... is up to date." message")
>     9895c03d4811 ("kbuild: record needed exported symbols for modules")
>     a5967db9af51 ("kbuild: allow architectures to use thin archives instead of ld -r")
>     b67067f1176d ("kbuild: allow archs to select link dead code/data elimination")
>     b9ab5ebb14ec ("objtool: Add CONFIG_STACK_VALIDATION option")
>     c1a95fda2a40 ("kbuild: add fine grained build dependencies for exported symbols")
>     cb87481ee89d ("kbuild: linker script do not match C names unless LD_DEAD_CODE_DATA_ELIMINATION is configured")
>     cf4f21938e13 ("kbuild: Allow to specify composite modules with modname-m")
>     e4aca4595005 ("kbuild: de-duplicate fixdep usage")
>     f235541699bc ("export.h: allow for per-symbol configurable EXPORT_SYMBOL()")
>
>
> NOTE: The patch will not be queued to stable trees until it is upstream.
>
> How should we proceed with this patch?
>
> --
> Thanks
> Sasha



-- 
Thanks,
~Nick Desaulniers
