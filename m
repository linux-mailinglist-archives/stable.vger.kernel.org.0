Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 089E217E02B
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 13:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgCIMZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 08:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:50806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCIMZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 08:25:06 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5043620866;
        Mon,  9 Mar 2020 12:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583756705;
        bh=yPA9w9zVqEd1n9209AsggUpc6u72Nd3iHGc0tLQavZU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=GAWaz842ND0G6pPkcb4p1DXd1MOFNQLArq/aAPHoMBoAqbnsHQHR+1FrDPbY1KLaT
         na9Lj5+1Se52qtQ+Dlsr+Lftxx7rZXFFwfCIDuYWi2gRzU/vj0z/R3+a5jDSlBbbKz
         QrP3SNdwXFJh1+QAyWjIq5SPpNbia3aV6zZjFBQw=
Date:   Mon, 09 Mar 2020 12:25:04 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Nathan Chancellor <natechancellor@gmail.com>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] kbuild: Disable -Wpointer-to-enum-cast
In-Reply-To: <20200308073400.23398-1-natechancellor@gmail.com>
References: <20200308073400.23398-1-natechancellor@gmail.com>
Message-Id: <20200309122505.5043620866@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172, v4.9.215, v4.4.215.

v5.5.8: Build OK!
v5.4.24: Build OK!
v4.19.108: Failed to apply! Possible dependencies:
    076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
    a1494304346a ("kbuild: add all Clang-specific flags unconditionally")

v4.14.172: Failed to apply! Possible dependencies:
    076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
    a1494304346a ("kbuild: add all Clang-specific flags unconditionally")
    c6d6f4c55f5c ("MIPS: Always specify -EB or -EL when using clang")
    ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")

v4.9.215: Failed to apply! Possible dependencies:
    076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
    0e5e7f5e9700 ("powerpc/64: Reclaim CPU_FTR_SUBCORE")
    1421dc6d4829 ("powerpc/kbuild: Use flags variables rather than overriding LD/CC/AS")
    250122baed29 ("powerpc64/module: Tighten detection of mcount call sites with -mprofile-kernel")
    2a056f58fd33 ("powerpc: consolidate -mno-sched-epilog into FTRACE flags")
    3a849815a136 ("powerpc/book3s64: Always build for power4 or later")
    43c9127d94d6 ("powerpc: Add option to use thin archives")
    471d7ff8b51b ("powerpc/64s: Remove POWER4 support")
    5a61ef74f269 ("powerpc/64s: Support new device tree binding for discovering CPU features")
    6977f95e63b9 ("powerpc: avoid -mno-sched-epilog on GCC 4.9 and newer")
    73aca179d78e ("powerpc/modules: Fix crashes by adding CONFIG_RELOCATABLE to vermagic")
    951eedebcdea ("powerpc/64: Handle linker stubs in low .text code")
    a1494304346a ("kbuild: add all Clang-specific flags unconditionally")
    a73657ea19ae ("powerpc/64: Add GENERIC_CPU support for little endian")
    abba759796f9 ("powerpc/kbuild: move -mprofile-kernel check to Kconfig")
    b40b2386bce9 ("powerpc/Makefile: Fix ld version check with 64-bit LE-only toolchain")
    b71c9ffb1405 ("powerpc: Add arch/powerpc/tools directory")
    baa25b571a16 ("powerpc/64: Do not link crtsavres.o in vmlinux")
    badf436f6fa5 ("powerpc/Makefiles: Convert ifeq to ifdef where possible")
    c0d64cf9fefd ("powerpc: Use feature bit for RTC presence rather than timebase presence")
    c1807e3f8466 ("powerpc/64: Free up CPU_FTR_ICSWX")
    c6d6f4c55f5c ("MIPS: Always specify -EB or -EL when using clang")
    cf43d3b26452 ("powerpc: Enable pkey subsystem")
    ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
    efe0160cfd40 ("powerpc/64: Linker on-demand sfpr functions for modules")
    f188d0524d7e ("powerpc: Use the new post-link pass to check relocations")

v4.4.215: Failed to apply! Possible dependencies:
    076f421da5d4 ("kbuild: replace cc-name test with CONFIG_CC_IS_CLANG")
    07e45c120c9c ("powerpc: Don't disable kernel FP/VMX/VSX MSR bits on context switch")
    152d523e6307 ("powerpc: Create context switch helpers save_sprs() and restore_sprs()")
    20dbe6706206 ("powerpc: Call restore_sprs() before _switch()")
    2a056f58fd33 ("powerpc: consolidate -mno-sched-epilog into FTRACE flags")
    3f3b5dc14c25 ("powerpc/pseries: PACA save area fix for general exception vs MCE")
    579e633e764e ("powerpc: create flush_all_to_thread()")
    57f266497d81 ("powerpc: Use gas sections for arranging exception vectors")
    6977f95e63b9 ("powerpc: avoid -mno-sched-epilog on GCC 4.9 and newer")
    70fe3d980f5f ("powerpc: Restore FPU/VEC/VSX if previously used")
    8c50b72a3b4f ("powerpc/ftrace: Add Kconfig & Make glue for mprofile-kernel")
    951eedebcdea ("powerpc/64: Handle linker stubs in low .text code")
    a1494304346a ("kbuild: add all Clang-specific flags unconditionally")
    a74599a50419 ("powerpc/pseries: PACA save area fix for MCE vs MCE")
    abba759796f9 ("powerpc/kbuild: move -mprofile-kernel check to Kconfig")
    c208505900b2 ("powerpc: create giveup_all()")
    c6d6f4c55f5c ("MIPS: Always specify -EB or -EL when using clang")
    caca285e5ab4 ("powerpc/mm/radix: Use STD_MMU_64 to properly isolate hash related code")
    d1e1cf2e38de ("powerpc: clean up asm/switch_to.h")
    d8d42b0511fe ("powerpc/64: Do load of PACAKBASE in LOAD_HANDLER")
    ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
    f0f558b131db ("powerpc/mm: Preserve CFAR value on SLB miss caused by access to bogus address")
    f3d885ccba85 ("powerpc: Rearrange __switch_to()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
