Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE4E25EC47
	for <lists+stable@lfdr.de>; Sun,  6 Sep 2020 05:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbgIFDQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Sep 2020 23:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbgIFDQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 5 Sep 2020 23:16:10 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E37B520797;
        Sun,  6 Sep 2020 03:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599362169;
        bh=vQOlh2Sljb/Rw7CFhysTj2r+a2P/WT3i3YNlfv9CdsM=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=PK0JzQatKMcoIVttihPPAFQi1vl0LdUlkE5NLczaZ5L9yZJYcM5XCI8XEKMudG+Z9
         rqJ8Kj1eUpovwZzG07mU8m73JtKq29Wbqz5MGRH8rLr1w83fm+95xBzviSaSsvLOyH
         Za0oM+X4jypV2GTZ0UtiUD1h9M2na5PPWKpt8X8Y=
Date:   Sun, 06 Sep 2020 03:16:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sami Tolvanen <samitolvanen@google.com>
To:     Arvind Sankar <nivedita@alum.mit.edu>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 01/28] x86/boot/compressed: Disable relocation relaxation
In-Reply-To: <20200903203053.3411268-2-samitolvanen@google.com>
References: <20200903203053.3411268-2-samitolvanen@google.com>
Message-Id: <20200906031608.E37B520797@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.6, v5.4.62, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.6: Failed to apply! Possible dependencies:
    fb46d057db82 ("x86: Add support for ZSTD compressed kernel")

v5.4.62: Failed to apply! Possible dependencies:
    003602ad5516 ("x86/*/Makefile: Use -fno-asynchronous-unwind-tables to suppress .eh_frame sections")
    9e2276fa6eb3 ("arch/x86/boot: Use prefix map to avoid embedded paths")
    fb46d057db82 ("x86: Add support for ZSTD compressed kernel")

v4.19.143: Failed to apply! Possible dependencies:
    003602ad5516 ("x86/*/Makefile: Use -fno-asynchronous-unwind-tables to suppress .eh_frame sections")
    30cc0b6c1220 ("doc: add boot protocol 2.13 description to Documentation/x86/boot.txt")
    384184044981 ("x86/boot: Mostly revert commit ae7e1238e68f2a ("Add ACPI RSDP address to setup_header")")
    9e2276fa6eb3 ("arch/x86/boot: Use prefix map to avoid embedded paths")
    ae7e1238e68f ("x86/boot: Add ACPI RSDP address to setup_header")
    c5ed311b4e31 ("x86, boot: documentation whitespace fixup")
    f1f238a9f1ca ("Documentation: x86: convert boot.txt to reST")
    fb46d057db82 ("x86: Add support for ZSTD compressed kernel")

v4.14.196: Failed to apply! Possible dependencies:
    003602ad5516 ("x86/*/Makefile: Use -fno-asynchronous-unwind-tables to suppress .eh_frame sections")
    0b3e336601b8 ("arm64: Add support for STACKLEAK gcc plugin")
    1fc5dce78ad1 ("arm64/sve: Low-level SVE architectural state manipulation functions")
    2d2123bc7c7f ("arm64/sve: Add prctl controls for userspace vector length management")
    33b6d03469b2 ("efi: call get_event_log before ExitBootServices")
    36b649760e94 ("efi: Use string literals for efi_char16_t variable initializers")
    3db5e0ba8b8f ("efi/libstub: Disable some warnings for x86{,_64}")
    6c3b56b19730 ("x86/boot: Disable Clang warnings about GNU extensions")
    7582e22038a2 ("arm64/sve: Backend logic for setting the vector length")
    9e2276fa6eb3 ("arch/x86/boot: Use prefix map to avoid embedded paths")
    9e8084d3f761 ("arm64: Implement thread_struct whitelist for hardened usercopy")
    bc0ee4760364 ("arm64/sve: Core task context handling")
    ce279d374ff3 ("efi/libstub: Only disable stackleak plugin for arm64")
    dca5203e3fe2 ("x86/boot: Add -Wno-pointer-sign to KBUILD_CFLAGS")
    f779ca740f25 ("efi: Make const array 'apple' static")

v4.9.235: Failed to apply! Possible dependencies:
    003602ad5516 ("x86/*/Makefile: Use -fno-asynchronous-unwind-tables to suppress .eh_frame sections")
    06cbbac0f57d ("x86/build: Don't use $(LINUXINCLUDE) twice")
    0acba3f91823 ("x86/boot/build: Remove always empty $(USERINCLUDE)")
    2959c95d510c ("efi/capsule: Add support for Quark security header")
    36b649760e94 ("efi: Use string literals for efi_char16_t variable initializers")
    3db5e0ba8b8f ("efi/libstub: Disable some warnings for x86{,_64}")
    46cd4b75cd0e ("efi: Add device path parser")
    5520b7e7d2d2 ("x86/boot/e820: Remove spurious asm/e820/api.h inclusions")
    568bc4e87033 ("efi/arm*/libstub: Invoke EFI_RNG_PROTOCOL to seed the UEFI RNG table")
    58c5475aba67 ("x86/efi: Retrieve and assign Apple device properties")
    66441bd3cfdc ("x86/boot/e820: Move asm/e820.h to asm/e820/api.h")
    6c3b56b19730 ("x86/boot: Disable Clang warnings about GNU extensions")
    70a9d8184cce ("x86/boot/e820: Introduce arch/x86/include/asm/e820/types.h")
    846221cfb8f6 ("Remove references to dead make variable LINUX_INCLUDE")
    9d2f86c6cad5 ("x86: Make E820_X_MAX unconditionally larger than E820MAX")
    9e2276fa6eb3 ("arch/x86/boot: Use prefix map to avoid embedded paths")
    dca5203e3fe2 ("x86/boot: Add -Wno-pointer-sign to KBUILD_CFLAGS")
    f779ca740f25 ("efi: Make const array 'apple' static")

v4.4.235: Failed to apply! Possible dependencies:
    0acba3f91823 ("x86/boot/build: Remove always empty $(USERINCLUDE)")
    21266be9ed54 ("arch: consolidate CONFIG_STRICT_DEVM in lib/Kconfig.debug")
    9e2276fa6eb3 ("arch/x86/boot: Use prefix map to avoid embedded paths")
    c6d308534aef ("UBSAN: run-time undefined behavior sanity checker")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
