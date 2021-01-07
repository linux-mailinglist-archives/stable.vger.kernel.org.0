Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129CC2ED09D
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 14:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbhAGNVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 08:21:53 -0500
Received: from mail-40134.protonmail.ch ([185.70.40.134]:34988 "EHLO
        mail-40134.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbhAGNVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 08:21:52 -0500
Date:   Thu, 07 Jan 2021 13:21:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610025670; bh=1c0zIRSp5j+9jPf96D96lWaXSqjKgRxuaqZWXnp1GJA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=j9+A6Rzo1K+21lSv9jbkpyTi94X4L1AEwY8GcldoLZ22ZOUGSJ2Z47oH8suBecI7Q
         WiRlK625R9bjiAh+jufBUDUGMSs/+RDV5y4Z6dvm9fEWFltioUP7EwDFJb+s9kN4Cx
         XM7hZQ/se4n+AoYwpLsiG7RfO9+npoochn7IoUxYMEA67UpupTAQQv+YdFOBjPUQFy
         J2dBlB1x62phBmSEqHe2bRSGtOAf2fvUCxi8b3A6w81TRJtNYKkMQmxZdj65DOdbWB
         6Xr4F4YSvphfRHebhxl8jGB6JoJhsj3a3AhsD0l6YhAEk0Lf9Lf9aehhOvwabr1DLz
         6lbOrPfdehkLA==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Pei Huang <huangpei@loongson.cn>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Corey Minyard <cminyard@mvista.com>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, stable@vger.kernel.org,
        clang-built-linux@googlegroups.com
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v4 mips-next 7/7] MIPS: select ARCH_WANT_LD_ORPHAN_WARN
Message-ID: <20210107132010.463129-4-alobakin@pm.me>
In-Reply-To: <20210107132010.463129-1-alobakin@pm.me>
References: <20210107123331.354075-1-alobakin@pm.me> <20210107132010.463129-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now, after that all the sections are explicitly described and
declared in vmlinux.lds.S, we can enable ld orphan warnings to
prevent from missing any new sections in future.

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index d68df1febd25..d3e64cc0932b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -18,6 +18,7 @@ config MIPS
 =09select ARCH_USE_QUEUED_SPINLOCKS
 =09select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 =09select ARCH_WANT_IPC_PARSE_VERSION
+=09select ARCH_WANT_LD_ORPHAN_WARN
 =09select BUILDTIME_TABLE_SORT
 =09select CLONE_BACKWARDS
 =09select CPU_NO_EFFICIENT_FFS if (TARGET_ISA_REV < 1)
--=20
2.30.0


