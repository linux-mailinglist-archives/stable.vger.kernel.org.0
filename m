Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1058B37CA47
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbhELQ2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234533AbhELQTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:19:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD5CA61C94;
        Wed, 12 May 2021 15:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834348;
        bh=t8IwMTTP1ZK0Bqdsgb8MtAZ9cv7oY3KY2B3nWCzzxCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFRyVcDTHlAGlYWLoJiAkCACjwDfKgHRZ5ZoZ/ID6dq8X81+kEh0L4NwwYlMG/nJK
         jNj7YLPOkJolkb8g9RgdJB/efgm7Qz4Twe86JuBcwgjsEyhjGLGFSNGgDVOlqEKuyS
         x/XibsAfl1DsufKRbpNi0Q3eKDw/A/g1ZS+VEKF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 508/601] powerpc/syscall: Rename syscall_64.c into interrupt.c
Date:   Wed, 12 May 2021 16:49:45 +0200
Message-Id: <20210512144844.571981107@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit ab1a517d55b01b54ba70f5d54f926f5ab4b18339 ]

syscall_64.c will be reused almost as is for PPC32.

As this file also contains functions to handle other types
of interrupts rename it interrupt.c

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/cddc2deaa8f049d3ec419738e69804934919b935.1612796617.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/Makefile                      | 2 +-
 arch/powerpc/kernel/{syscall_64.c => interrupt.c} | 0
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/powerpc/kernel/{syscall_64.c => interrupt.c} (100%)

diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index b31e2160b233..74dfb09178aa 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -49,7 +49,7 @@ obj-y				:= cputable.o syscalls.o \
 				   hw_breakpoint_constraints.o
 obj-y				+= ptrace/
 obj-$(CONFIG_PPC64)		+= setup_64.o \
-				   paca.o nvram_64.o note.o syscall_64.o
+				   paca.o nvram_64.o note.o interrupt.o
 obj-$(CONFIG_COMPAT)		+= sys_ppc32.o signal_32.o
 obj-$(CONFIG_VDSO32)		+= vdso32_wrapper.o
 obj-$(CONFIG_PPC_WATCHDOG)	+= watchdog.o
diff --git a/arch/powerpc/kernel/syscall_64.c b/arch/powerpc/kernel/interrupt.c
similarity index 100%
rename from arch/powerpc/kernel/syscall_64.c
rename to arch/powerpc/kernel/interrupt.c
-- 
2.30.2



