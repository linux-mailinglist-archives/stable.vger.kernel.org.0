Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2086F299FBD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410071AbgJZXxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:53:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410059AbgJZXxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8441021655;
        Mon, 26 Oct 2020 23:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756404;
        bh=FwGCC5je+qSALh6pUyJFCTlFd8RGLBo3/olgLlei+uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ru3mbC0sTCgi13OaA04ZnI0AY7LDJCn8EiCc37sSFrYPwE26zSN27yMLqV4ANWKpf
         ziAtnKZP1RKrWqucVBbRmjRJ22pl7kuA5+Tn5Vnsb4Kgrt6Av27tv3jrtVlOADSznn
         iTAr99qC2WBHLSBUR14TWojsSTYFuswQtYcPuY1k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong Li <zong.li@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 063/132] riscv: Define AT_VECTOR_SIZE_ARCH for ARCH_DLINFO
Date:   Mon, 26 Oct 2020 19:50:55 -0400
Message-Id: <20201026235205.1023962-63-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

[ Upstream commit b5fca7c55f9fbab5ad732c3bce00f31af6ba5cfa ]

AT_VECTOR_SIZE_ARCH should be defined with the maximum number of
NEW_AUX_ENT entries that ARCH_DLINFO can contain, but it wasn't defined
for RISC-V at all even though ARCH_DLINFO will contain one NEW_AUX_ENT
for the VDSO address.

Signed-off-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/uapi/asm/auxvec.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/auxvec.h b/arch/riscv/include/uapi/asm/auxvec.h
index d86cb17bbabe6..22e0ae8884061 100644
--- a/arch/riscv/include/uapi/asm/auxvec.h
+++ b/arch/riscv/include/uapi/asm/auxvec.h
@@ -10,4 +10,7 @@
 /* vDSO location */
 #define AT_SYSINFO_EHDR 33
 
+/* entries in ARCH_DLINFO */
+#define AT_VECTOR_SIZE_ARCH	1
+
 #endif /* _UAPI_ASM_RISCV_AUXVEC_H */
-- 
2.25.1

