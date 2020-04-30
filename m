Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7CD1BFF9A
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 17:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgD3PGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 11:06:22 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49483 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbgD3PGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 11:06:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 4C19F879;
        Thu, 30 Apr 2020 11:06:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 30 Apr 2020 11:06:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0WTL63
        hkSbAqQ9BNzEV5waoFOoE+2xaZoawZYCPaslg=; b=RM+qoz6/LMwiIc+l/M5F1D
        SYMOEraqN+riMBtvb8Yr2CMY+RmifTJXiZlk9uAmov6IwTgIPiMtLUZ8fzU6wFqR
        74YaQdmT5D6bvYv98QRvQuXvIOePeTHECTHh/6ejHBYlCBSm3TTTwomeUVVBLcLK
        UJgRtJcPtMZomrr46FBG6pEeuek6lU1pX+iM+jgSBQisIVae8of9P4rNOqhol9IY
        8hmzlU50WmR1/YlqVgPOsdJ/PYHTxmE7+FGF2ivsbfBfkF8wIRjHEgf2lHWCdfTX
        ccFbmtWh9uTQI6IfzZlgXhfvyHn9uomCItlZnp2intBenROBcZ2oCE6drf4NYlBg
        ==
X-ME-Sender: <xms:bOmqXogw1jifK1CHnsaaMNRG-uKgrr_pcEn4trcfVx56JR4-TrCZNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrieehgdekfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bOmqXmGoLj2cCDhZ3lS_ZDwb887XUPFOvB5yxDcc14TLtucVf77-yw>
    <xmx:bOmqXtEctzqq1ffDDD03UjlB1CJli6MvPzeG2TwyZNGnSFfzfBfqog>
    <xmx:bOmqXm-stccuRwfmWilIQUIWqmrlnO_Ix9BNvXeBWA8bTyhMkSYUaA>
    <xmx:bOmqXmoXma5_E4ZXghARmR0FU4cb4hkaNZm3KCpPw4ytpmiA1NumniRNFV8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BF7B3065F31;
        Thu, 30 Apr 2020 11:06:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX" failed to apply to 4.4-stable tree
To:     lukenels@cs.washington.edu, ast@kernel.org, luke.r.nels@gmail.com,
        xi.wang@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 30 Apr 2020 17:06:15 +0200
Message-ID: <1588259175185252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aee194b14dd2b2bde6252b3acf57d36dccfc743a Mon Sep 17 00:00:00 2001
From: Luke Nelson <lukenels@cs.washington.edu>
Date: Sat, 18 Apr 2020 16:26:53 -0700
Subject: [PATCH] bpf, x86: Fix encoding for lower 8-bit registers in BPF_STX
 BPF_B

This patch fixes an encoding bug in emit_stx for BPF_B when the source
register is BPF_REG_FP.

The current implementation for BPF_STX BPF_B in emit_stx saves one REX
byte when the operands can be encoded using Mod-R/M alone. The lower 8
bits of registers %rax, %rbx, %rcx, and %rdx can be accessed without using
a REX prefix via %al, %bl, %cl, and %dl, respectively. Other registers,
(e.g., %rsi, %rdi, %rbp, %rsp) require a REX prefix to use their 8-bit
equivalents (%sil, %dil, %bpl, %spl).

The current code checks if the source for BPF_STX BPF_B is BPF_REG_1
or BPF_REG_2 (which map to %rdi and %rsi), in which case it emits the
required REX prefix. However, it misses the case when the source is
BPF_REG_FP (mapped to %rbp).

The result is that BPF_STX BPF_B with BPF_REG_FP as the source operand
will read from register %ch instead of the correct %bpl. This patch fixes
the problem by fixing and refactoring the check on which registers need
the extra REX byte. Since no BPF registers map to %rsp, there is no need
to handle %spl.

Fixes: 622582786c9e0 ("net: filter: x86: internal BPF JIT")
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200418232655.23870-1-luke.r.nels@gmail.com

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 5ea7c2cf7ab4..42b6709e6dc7 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -158,6 +158,19 @@ static bool is_ereg(u32 reg)
 			     BIT(BPF_REG_AX));
 }
 
+/*
+ * is_ereg_8l() == true if BPF register 'reg' is mapped to access x86-64
+ * lower 8-bit registers dil,sil,bpl,spl,r8b..r15b, which need extra byte
+ * of encoding. al,cl,dl,bl have simpler encoding.
+ */
+static bool is_ereg_8l(u32 reg)
+{
+	return is_ereg(reg) ||
+	    (1 << reg) & (BIT(BPF_REG_1) |
+			  BIT(BPF_REG_2) |
+			  BIT(BPF_REG_FP));
+}
+
 static bool is_axreg(u32 reg)
 {
 	return reg == BPF_REG_0;
@@ -598,9 +611,8 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
 	switch (size) {
 	case BPF_B:
 		/* Emit 'mov byte ptr [rax + off], al' */
-		if (is_ereg(dst_reg) || is_ereg(src_reg) ||
-		    /* We have to add extra byte for x86 SIL, DIL regs */
-		    src_reg == BPF_REG_1 || src_reg == BPF_REG_2)
+		if (is_ereg(dst_reg) || is_ereg_8l(src_reg))
+			/* Add extra byte for eregs or SIL,DIL,BPL in src_reg */
 			EMIT2(add_2mod(0x40, dst_reg, src_reg), 0x88);
 		else
 			EMIT1(0x88);

