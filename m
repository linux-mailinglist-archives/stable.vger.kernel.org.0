Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 913671E2E71
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403767AbgEZTBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:01:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390971AbgEZTBb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:01:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DEC20849;
        Tue, 26 May 2020 19:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519691;
        bh=+Dvm2rdDVTfbgx2YcMhPo7v8qPnIq2C9eoViBsYKTEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNC2k7uLmcEBq9Hg93sg6JUyOGrQntHuJ9+tCbGm1Oz5D4j1XLQ6j4K1pDIzJCkYt
         2RElwb3QAEvXQmYRf15FEIf9J+dFHvrCBI+PBRWM1+RdCYr0QrNaoy6FS/C1zFcSjh
         fQcfJDLwFZJm2csnKFmtJ7V/VgKvReu3DkWZMj6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Balbir Singh <bsingharora@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 39/59] powerpc: restore alphabetic order in Kconfig
Date:   Tue, 26 May 2020 20:53:24 +0200
Message-Id: <20200526183919.859893348@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183907.123822792@linuxfoundation.org>
References: <20200526183907.123822792@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 4ec591e51a4b0aedb6c7f1a8cd722aa58d7f61ba ]

This patch restores the alphabetic order which was broken by
commit 1e0fc9d1eb2b0 ("powerpc/Kconfig: Enable STRICT_KERNEL_RWX
for some configs")

Fixes: 1e0fc9d1eb2b0 ("powerpc/Kconfig: Enable STRICT_KERNEL_RWX for some configs")
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 277e4ffb928b..6b73ef2bba2e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -141,12 +141,14 @@ config PPC
 	select ARCH_HAS_GCOV_PROFILE_ALL
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE
 	select ARCH_HAS_SG_CHAIN
+	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
 	select ARCH_HAS_ZONE_DEVICE		if PPC_BOOK3S_64
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_MIGHT_HAVE_PC_SERIO
+	select ARCH_OPTIONAL_KERNEL_RWX		if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
 	select ARCH_USE_BUILTIN_BSWAP
@@ -178,8 +180,6 @@ config PPC
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if COMPAT
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_TRACEHOOK
-	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
-	select ARCH_OPTIONAL_KERNEL_RWX		if ARCH_HAS_STRICT_KERNEL_RWX
 	select HAVE_CBPF_JIT			if !PPC64
 	select HAVE_CONTEXT_TRACKING		if PPC64
 	select HAVE_DEBUG_KMEMLEAK
-- 
2.25.1



