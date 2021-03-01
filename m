Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61463327FA7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbhCANhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:37:19 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:42825 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235853AbhCANhT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:37:19 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 688661941DC2;
        Mon,  1 Mar 2021 08:36:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bmloig
        AeEqBZ5lgz3RGBHE48PVry1urXxzkbm8XMNJU=; b=F6Znv+iM7XBWBPW33UJSsm
        LKCWkhm+SyfPxuqrQFTuRo7sppsI2Y/C3mkV1DVwEMt03Zw3JeaZVGgDpv+2QcwP
        ZUfGtAz7l/DzPJ9wnfmPGxQppEv3ait+yHvbelSj8znka2PnzG8Zg1kFRLJtHrvq
        6ZKAoFqmeR4A/z9o99tSnAAZvg3FbXt2GQ2V3ohSU4fZcqLMUNTuNvN6QXWY9KUv
        DitSMRPpkPdtJ1mCoJECmf/J6p9KhvDM5zWtDFhKyJDUYS95ZheCLGQsTaCA9O/s
        24sSM0GxwxfarEXXvft9ThQDt8zE25S1UiQk0IlGAmHOhqxuoVPis+RlFsmQx0Pw
        ==
X-ME-Sender: <xms:4O08YB1MV7-IsJaa8YpP6AhWiQmcJspQiIdlBQ0TQL-SHeMJDqrVQQ>
    <xme:4O08YIGSP3-YpQsh4cm3uIEl1_C56_Pt8UZt460mlVyBR8JN3dGlqkAENFfuYHT3G
    ovZVlcrUZheWw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeevuedukeegheeitdfhfefgvedvteethedvieehheduge
    dtvdevgfdtieehkeeuheenucffohhmrghinhepvghnthhrhidrshgsnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:4O08YB6f_S_o9c-Rh2laDiUbIECldZxOY9dh3Zk3KbUH6ssof3ZDpg>
    <xmx:4O08YO0ffUQlmsm7FmqydOUYs8GDljIGHv50suAhG4n2iXK5QH3udA>
    <xmx:4O08YEFKtcSHMjYGd4_uI13fJUDmcXe1Hb0OPIPURup8JVpKIHYQyg>
    <xmx:4O08YJT-rMuYeo5Zswop3lXNw0xV7to8GXfOxtu299YGzux27ZtuAA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 14E98240065;
        Mon,  1 Mar 2021 08:36:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390: open code SWITCH_KERNEL macro" failed to apply to 5.10-stable tree
To:     svens@linux.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:36:22 +0100
Message-ID: <1614605782145108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b0d31159a46787380353426faaad8febc9bef009 Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Thu, 28 Jan 2021 13:06:05 +0100
Subject: [PATCH] s390: open code SWITCH_KERNEL macro

This is a preparation patch for two later bugfixes. In the past both
int_handler and machine check handler used SWITCH_KERNEL to switch to
the kernel stack. However, SWITCH_KERNEL doesn't work properly in machine
check context. So instead of adding more complexity to this macro, just
remove it.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Cc: <stable@kernel.org> # v5.8+
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 9b3aea98f886..ed5acf95235f 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -81,32 +81,6 @@ _LPP_OFFSET	= __LC_LPP
 #endif
 	.endm
 
-	.macro	SWITCH_KERNEL savearea
-	tmhh	%r8,0x0001		# interrupting from user ?
-	jnz	1f
-#if IS_ENABLED(CONFIG_KVM)
-	lgr	%r14,%r9
-	larl	%r13,.Lsie_gmap
-	slgr	%r14,%r13
-	lghi	%r13,.Lsie_done - .Lsie_gmap
-	clgr	%r14,%r13
-	jhe	0f
-	lghi	%r11,\savearea		# inside critical section, do cleanup
-	brasl	%r14,.Lcleanup_sie
-#endif
-0:	CHECK_STACK \savearea
-	lgr	%r11,%r15
-	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
-	stg	%r11,__SF_BACKCHAIN(%r15)
-	j	2f
-1:	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
-	lctlg	%c1,%c1,__LC_KERNEL_ASCE
-	lg	%r15,__LC_KERNEL_STACK
-	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
-2:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
-	.endm
-
-	# Use STORE CLOCK by default, switch to STORE CLOCK FAST if available.
 	.macro STCK savearea
 	ALTERNATIVE ".insn	s,0xb2050000,\savearea", \
 		    ".insn	s,0xb27c0000,\savearea", 25
@@ -413,7 +387,28 @@ ENTRY(\name)
 	stmg	%r8,%r15,__LC_SAVE_AREA_ASYNC
 	lg	%r12,__LC_CURRENT
 	lmg	%r8,%r9,\lc_old_psw
-	SWITCH_KERNEL __LC_SAVE_AREA_ASYNC
+	tmhh	%r8,0x0001			# interrupting from user ?
+	jnz	1f
+#if IS_ENABLED(CONFIG_KVM)
+	lgr	%r14,%r9
+	larl	%r13,.Lsie_gmap
+	slgr	%r14,%r13
+	lghi	%r13,.Lsie_done - .Lsie_gmap
+	clgr	%r14,%r13
+	jhe	0f
+	lghi	%r11,__LC_SAVE_AREA_ASYNC	# inside critical section, do cleanup
+	brasl	%r14,.Lcleanup_sie
+#endif
+0:	CHECK_STACK __LC_SAVE_AREA_ASYNC
+	lgr	%r11,%r15
+	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
+	stg	%r11,__SF_BACKCHAIN(%r15)
+	j	2f
+1:	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
+	lctlg	%c1,%c1,__LC_KERNEL_ASCE
+	lg	%r15,__LC_KERNEL_STACK
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
+2:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 	stmg	%r0,%r7,__PT_R0(%r11)
 	# clear user controlled registers to prevent speculative use
 	xgr	%r0,%r0
@@ -542,7 +537,30 @@ ENTRY(mcck_int_handler)
 	TSTMSK	__LC_MCCK_CODE,MCCK_CODE_PSW_IA_VALID
 	jno	.Lmcck_panic
 4:	ssm	__LC_PGM_NEW_PSW	# turn dat on, keep irqs off
-	SWITCH_KERNEL __LC_GPREGS_SAVE_AREA+64
+	tmhh	%r8,0x0001			# interrupting from user ?
+	jnz	.Lmcck_user
+#if IS_ENABLED(CONFIG_KVM)
+	lgr	%r14,%r9
+	larl	%r13,.Lsie_gmap
+	slgr	%r14,%r13
+	lghi	%r13,.Lsie_done - .Lsie_gmap
+	clgr	%r14,%r13
+	jhe	.Lmcck_stack
+	lghi	%r11,__LC_GPREGS_SAVE_AREA+64	# inside critical section, do cleanup
+	brasl	%r14,.Lcleanup_sie
+.Lmcck_stack:
+#endif
+	CHECK_STACK __LC_GPREGS_SAVE_AREA+64
+	lgr	%r11,%r15
+	aghi	%r15,-(STACK_FRAME_OVERHEAD + __PT_SIZE)
+	stg	%r11,__SF_BACKCHAIN(%r15)
+	j	5f
+.Lmcck_user:
+	BPENTER __TI_flags(%r12),_TIF_ISOLATE_BP
+	lctlg	%c1,%c1,__LC_KERNEL_ASCE
+	lg	%r15,__LC_KERNEL_STACK
+	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
+5:	la	%r11,STACK_FRAME_OVERHEAD(%r15)
 .Lmcck_skip:
 	lghi	%r14,__LC_GPREGS_SAVE_AREA+64
 	stmg	%r0,%r7,__PT_R0(%r11)

