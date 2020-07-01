Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B2521139E
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgGATdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgGATdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:19 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3A5B20760;
        Wed,  1 Jul 2020 19:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593631998;
        bh=zuBKSP7D/NZLwX3HNXq7Bw5SIncmye/Toz5VJqJP7v8=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=DozZ76CnV5Tv/FKbXtsVxC+Qp7onFlFx35MoqQIVye3wnqKgA7OkSOJZtooiIX03A
         /NTQZ4up/RsCvZfg5s/z6Boo9gwkeiVo3H/2roMGI8B/Z1kTcosgcQpf2PxUiNVewo
         wyDDWDt7WztegCw6P9MTqH2G55vn0in++6c8ZSgk=
Date:   Wed, 01 Jul 2020 19:33:18 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] vmlinux.lds: add PGO and AutoFDO input sections
In-Reply-To: <20200625184752.73095-1-ndesaulniers@google.com>
References: <20200625184752.73095-1-ndesaulniers@google.com>
Message-Id: <20200701193318.B3A5B20760@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Failed to apply! Possible dependencies:
    6553896666433 ("vmlinux.lds.h: Create section for protection against instrumentation")

v5.4.49: Failed to apply! Possible dependencies:
    6553896666433 ("vmlinux.lds.h: Create section for protection against instrumentation")

v4.19.130: Failed to apply! Possible dependencies:
    5c67a52f3da0f ("Compiler Attributes: always use the extra-underscores syntax")
    6553896666433 ("vmlinux.lds.h: Create section for protection against instrumentation")
    67361cf807128 ("powerpc/ftrace: Handle large kernel configs")
    71391bdd2e9aa ("include/linux/compiler_types.h: don't pollute userspace with macro definitions")
    77b0bf55bc675 ("kbuild/Makefile: Prepare for using macros in inline assembly code to work around asm() related GCC inlining bugs")
    87b512def7925 ("objtool: Add support for C jump tables")
    96af6cd02a10b ("Revert "x86/objtool: Use asm macros to work around GCC inlining bugs"")
    989bd5000f360 ("Compiler Attributes: remove unneeded sparse (__CHECKER__) tests")
    a3f8a30f3f007 ("Compiler Attributes: use feature checks instead of version checks")
    c06c4d8090513 ("x86/objtool: Use asm macros to work around GCC inlining bugs")
    c2c640aa04cc4 ("Compiler Attributes: remove unneeded tests")
    ec0bbef66f867 ("Compiler Attributes: homogenize __must_be_array")

v4.14.186: Failed to apply! Possible dependencies:
    10259821ac47d ("objtool: Make unreachable annotation inline asms explicitly volatile")
    4c1d9bb0b5d3c ("powerpc: Allow LD_DEAD_CODE_DATA_ELIMINATION to be selected")
    5633e85b2c313 ("powerpc64: Add .opd based function descriptor dereference")
    6553896666433 ("vmlinux.lds.h: Create section for protection against instrumentation")
    67361cf807128 ("powerpc/ftrace: Handle large kernel configs")
    71391bdd2e9aa ("include/linux/compiler_types.h: don't pollute userspace with macro definitions")
    7290d58095712 ("module: use relative references for __ksymtab entries")
    77b0bf55bc675 ("kbuild/Makefile: Prepare for using macros in inline assembly code to work around asm() related GCC inlining bugs")
    815f0ddb346c1 ("include/linux/compiler*.h: make compiler-*.h mutually exclusive")
    8793bb7f4a9dd ("kbuild: add macro for controlling warnings to linux/compiler.h")
    87b512def7925 ("objtool: Add support for C jump tables")
    94e58e0ac3128 ("export.h: remove code for prefixing symbols with underscore")
    96af6cd02a10b ("Revert "x86/objtool: Use asm macros to work around GCC inlining bugs"")
    a10726075dec4 ("powerpc/32: Add .data.rel* sections explicitly")
    ae30cc05bed2f ("powerpc64/ftrace: Implement support for ftrace_regs_caller()")
    b865ea64304ed ("sections: split dereference_function_descriptor()")
    c06c4d8090513 ("x86/objtool: Use asm macros to work around GCC inlining bugs")
    cafa0010cd51f ("Raise the minimum required gcc version to 4.6")
    ea678ac627e01 ("powerpc64/ftrace: Add a field in paca to disable ftrace in unsafe code paths")
    fda784e50aace ("module: export module signature enforcement status")

v4.9.228: Failed to apply! Possible dependencies:
    096ff2ddba83b ("powerpc/ftrace/64: Split further based on -mprofile-kernel")
    2f59be5b970b5 ("powerpc/ftrace: Restore LR from pt_regs")
    4546561551106 ("powerpc/asm: Use OFFSET macro in asm-offsets.c")
    5d451a87e5ebb ("powerpc/64: Retrieve number of L1 cache sets from device-tree")
    6553896666433 ("vmlinux.lds.h: Create section for protection against instrumentation")
    67361cf807128 ("powerpc/ftrace: Handle large kernel configs")
    700e64377c2c8 ("powerpc/ftrace: Move stack setup and teardown code into ftrace_graph_caller()")
    7853f9c029ac9 ("powerpc: Split ftrace bits into a separate file")
    902e06eb86cd6 ("powerpc/32: Change the stack protector canary value per task")
    99ad503287daf ("powerpc: Add a prototype for mcount() so it can be versioned")
    ae30cc05bed2f ("powerpc64/ftrace: Implement support for ftrace_regs_caller()")
    b3a7864c6feb0 ("powerpc/ftrace: Add prototype for prepare_ftrace_return()")
    bd067f83b0840 ("powerpc/64: Fix naming of cache block vs. cache line")
    c02e0349d7e9e ("powerpc/ftrace: Fix the comments for ftrace_modify_code")
    e2827fe5c1566 ("powerpc/64: Clean up ppc64_caches using a struct per cache")
    ea678ac627e01 ("powerpc64/ftrace: Add a field in paca to disable ftrace in unsafe code paths")

v4.4.228: Failed to apply! Possible dependencies:
    0f4c4af06eec5 ("kbuild: -ffunction-sections fix for archs with conflicting sections")
    136cd3450af80 ("powerpc/module: Only try to generate the ftrace_caller() stub once")
    153086644fd1f ("powerpc/ftrace: Add support for -mprofile-kernel ftrace ABI")
    20ef10c1b3068 ("module: Use the same logic for setting and unsetting RO/NX")
    336a7b5dd80a2 ("powerpc/module: Create a special stub for ftrace_caller()")
    6553896666433 ("vmlinux.lds.h: Create section for protection against instrumentation")
    67361cf807128 ("powerpc/ftrace: Handle large kernel configs")
    7523e4dc5057e ("module: use a structure to encapsulate layout.")
    a5967db9af51a ("kbuild: allow architectures to use thin archives instead of ld -r")
    ae30cc05bed2f ("powerpc64/ftrace: Implement support for ftrace_regs_caller()")
    b67067f1176df ("kbuild: allow archs to select link dead code/data elimination")
    cb87481ee89db ("kbuild: linker script do not match C names unless LD_DEAD_CODE_DATA_ELIMINATION is configured")
    f17c4e01e906c ("powerpc/module: Mark module stubs with a magic value")
    f235541699bcf ("export.h: allow for per-symbol configurable EXPORT_SYMBOL()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
