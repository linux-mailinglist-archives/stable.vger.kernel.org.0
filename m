Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F1F2E94B1
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 13:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbhADMVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 07:21:42 -0500
Received: from mail-40131.protonmail.ch ([185.70.40.131]:30545 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbhADMVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 07:21:42 -0500
Date:   Mon, 04 Jan 2021 12:20:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1609762860; bh=FmvdsZCHCCE79sjLAYIX/gq7paKAr3hB9iXFALHlrb4=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=iA7fIKU+iUGl8//KALpAwglGMr5bbfoGRBV0KXWxYGgiY+xJfFF0Uu/ZnFJ3d9zf6
         F5IzM9pVLffdB9/RrvxNF75hHhZUmHIEDUD4TdEGjqZcwtsgkaMGT/QiwlgjlQz11n
         WD2k0M/tQeEc6eQZ84AT41ZjdG9o9VQOxJYDkH+unsRuZnRCeJQT4vaBjW80qIFhRZ
         nvVb1CbKri8IbpOKf6CCbrrvZdGlFuhC3mYue+leQ72E3cAcutiyYjVguTNtb19gOU
         dzpj9taWqP1L0j8ex9aoneS99+iQixpcPcuzZJ31ZI5wzLlxmkoIUxrKlxnrhtuumv
         e1Wm73KNVeLcw==
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Kees Cook <keescook@chromium.org>,
        Ingo Molnar <mingo@kernel.org>,
        Fangrui Song <maskray@google.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Alex Smith <alex.smith@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH mips-next 4/4] MIPS: select ARCH_WANT_LD_ORPHAN_WARN
Message-ID: <20210104122016.47308-4-alobakin@pm.me>
In-Reply-To: <20210104122016.47308-1-alobakin@pm.me>
References: <20210104121729.46981-1-alobakin@pm.me> <20210104122016.47308-1-alobakin@pm.me>
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


