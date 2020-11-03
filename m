Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDB82A500B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729656AbgKCTXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:23:50 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:37489 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgKCTXt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:23:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D156C1942BE9;
        Tue,  3 Nov 2020 14:23:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DaWluj
        XPiPyIS4v566xQr+3cLII3qjrL2I27fYYkh18=; b=HMex9Eodna1GMmladDM900
        moTDgaC+2FdNBiSJ9wgr1wP0OMnZIDCxUFSRihwcnedRe7Y4oyrHU6vIKWMP4DkM
        AJYYy6jQ6UcCTd4ImjjfuS49nwgQK03zVam4pFaIg1DLpDBjcxytHlMGVVQW9cTz
        xg5zbmnZOjvj2F3dpSOgwsJKWnjj66kafixdztNT9qMfhDGmp2B2zDBJ1k6XnOi2
        Ak4I4XE/dRdCMDVd7qWMOf8bIA6c3PwcbCdnVaNZdEvd4L7Qnn6xEhtjzhqrzqQk
        vuGr1MNJbsLyAACfqNBAKDDRShpKmSl9FmXh2HaEFooAWPbKQBoMwJh7hAxU30Sg
        ==
X-ME-Sender: <xms:RK6hX5TzFgIvvWrFBwaSQ-oGIU1VwZf0VsI-8D3t6zPolbhJ8h_Hjw>
    <xme:RK6hXyzKAq9ixScyPan17C0_1ezbTD9287kM7q-xtCAk28UYG3vl9G1NfTKTdU1b0
    qYZ_tKD5qn8nA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:RK6hX-30w4XIhZZ8sO1fNYpYbdmbhQiqkFq24xUUxmk9_f0hv1VQWQ>
    <xmx:RK6hXxCj25fxeQ9Y7D2jFvdZ9LvBOWtLfc9shcoKmShO_SLY87iWVw>
    <xmx:RK6hXyiSCGx58Q4dhANQXIcf0zGlptKZ9KZOqM09PJls-FPYHNIa4Q>
    <xmx:RK6hX4eWDUfoh6pzbBbF1zHHLWc7_B6gAP-p0TY1vFCVnoa05F0iNg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6BEE73064610;
        Tue,  3 Nov 2020 14:23:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and" failed to apply to 4.4-stable tree
To:     maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:23:47 +0100
Message-ID: <1604431427106185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 4a1c2c7f63c52ccb11770b5ae25920a6b79d3548 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 29 Oct 2020 17:24:09 +0000
Subject: [PATCH] KVM: arm64: Fix AArch32 handling of DBGD{CCINT,SCRext} and
 DBGVCR

The DBGD{CCINT,SCRext} and DBGVCR register entries in the cp14 array
are missing their target register, resulting in all accesses being
targetted at the guard sysreg (indexed by __INVALID_SYSREG__).

Point the emulation code at the actual register entries.

Fixes: bdfb4b389c8d ("arm64: KVM: add trap handlers for AArch32 debug registers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20201029172409.2768336-1-maz@kernel.org

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0aecbab6a7fb..781d029b8aa8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -239,6 +239,7 @@ enum vcpu_sysreg {
 #define cp14_DBGWCR0	(DBGWCR0_EL1 * 2)
 #define cp14_DBGWVR0	(DBGWVR0_EL1 * 2)
 #define cp14_DBGDCCINT	(MDCCINT_EL1 * 2)
+#define cp14_DBGVCR	(DBGVCR32_EL2 * 2)
 
 #define NR_COPRO_REGS	(NR_SYS_REGS * 2)
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 3c203cb8c103..983994f01a63 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1881,9 +1881,9 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 1), Op2( 0), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(1),
 	/* DBGDCCINT */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 0), trap_debug32, NULL, cp14_DBGDCCINT },
 	/* DBGDSCRext */
-	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 2), Op2( 2), trap_debug32, NULL, cp14_DBGDSCRext },
 	DBG_BCR_BVR_WCR_WVR(2),
 	/* DBGDTR[RT]Xint */
 	{ Op1( 0), CRn( 0), CRm( 3), Op2( 0), trap_raz_wi },
@@ -1898,7 +1898,7 @@ static const struct sys_reg_desc cp14_regs[] = {
 	{ Op1( 0), CRn( 0), CRm( 6), Op2( 2), trap_raz_wi },
 	DBG_BCR_BVR_WCR_WVR(6),
 	/* DBGVCR */
-	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32 },
+	{ Op1( 0), CRn( 0), CRm( 7), Op2( 0), trap_debug32, NULL, cp14_DBGVCR },
 	DBG_BCR_BVR_WCR_WVR(7),
 	DBG_BCR_BVR_WCR_WVR(8),
 	DBG_BCR_BVR_WCR_WVR(9),

