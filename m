Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77CD6BB308
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbjCOMlR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjCOMkq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D64A0B1E
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:39:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D06F61ABD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6477AC433EF;
        Wed, 15 Mar 2023 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883928;
        bh=73VDkdhvp8DptUWQKx6X9gGhgq9auJRAd/La6CdxzTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dijeFQw0VS1hWQwWOl6Dg9s3sFS5NkG16NK040pz6Tyg6o94v+2X1oyK4kBG4PH4L
         yBnrvokjhYv7/dYE6xMc+PlJNVkrUh7JweYVL/bCr0rgPhSCoiiKrjkrZaROFn7NYi
         4mIt3uytXGqShcAc0syW1UwUwC9y6KsJTanRwbSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liao Chang <liaochang1@huawei.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 042/141] riscv: Add header include guards to insn.h
Date:   Wed, 15 Mar 2023 13:12:25 +0100
Message-Id: <20230315115741.242680528@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liao Chang <liaochang1@huawei.com>

[ Upstream commit 8ac6e619d9d51b3eb5bae817db8aa94e780a0db4 ]

Add header include guards to insn.h to prevent repeating declaration of
any identifiers in insn.h.

Fixes: edde5584c7ab ("riscv: Add SW single-step support for KDB")
Signed-off-by: Liao Chang <liaochang1@huawei.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Fixes: c9c1af3f186a ("RISC-V: rename parse_asm.h to insn.h")
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20230129094242.282620-1-liaochang1@huawei.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/parse_asm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/riscv/include/asm/parse_asm.h b/arch/riscv/include/asm/parse_asm.h
index f36368de839f5..3cd00332d70f5 100644
--- a/arch/riscv/include/asm/parse_asm.h
+++ b/arch/riscv/include/asm/parse_asm.h
@@ -3,6 +3,9 @@
  * Copyright (C) 2020 SiFive
  */
 
+#ifndef _ASM_RISCV_INSN_H
+#define _ASM_RISCV_INSN_H
+
 #include <linux/bits.h>
 
 /* The bit field of immediate value in I-type instruction */
@@ -217,3 +220,5 @@ static inline bool is_ ## INSN_NAME ## _insn(long insn) \
 	(RVC_X(x_, RVC_B_IMM_5_OPOFF, RVC_B_IMM_5_MASK) << RVC_B_IMM_5_OFF) | \
 	(RVC_X(x_, RVC_B_IMM_7_6_OPOFF, RVC_B_IMM_7_6_MASK) << RVC_B_IMM_7_6_OFF) | \
 	(RVC_IMM_SIGN(x_) << RVC_B_IMM_SIGN_OFF); })
+
+#endif /* _ASM_RISCV_INSN_H */
-- 
2.39.2



