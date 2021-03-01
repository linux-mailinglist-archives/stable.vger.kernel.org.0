Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAB3327FAA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235767AbhCANhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:37:46 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:41313 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235859AbhCANhn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:37:43 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9201D1941E7A;
        Mon,  1 Mar 2021 08:36:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:36:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=exZF+u
        ALAfTBoUBH88Avb6LCfX9ZFILP2YBXAnZbiT4=; b=wowFJW6iQaZyOX0UEMTwUg
        YlBQuX/PdMyRIFaoGQMk4n8ZXzUdfSkzFIdzdmCUjHTuUgtP8S4d+sOlZONoVIOw
        lPFLHJYXao6KOgLrIK8cZtrWRYLNSvz9/yyzMXWQgR1GkO2XE01+aM3QeFs30j2E
        Scf2WEApSc9vTUEXYiHPKd3YOR70m7JVrZIy8rIhIDyqOHzSFiYqsuhcBX3EtfJV
        NxqIeMJ5h/sWvLTHNOa43ygVNCI2AQUd6f56kbIbdBbh3Pxk28SQN6PcejL5/47+
        TGoPxfNs4+dXwx/4AFdT71Uy5melf0UkW04tzgfCRj0f5oFjzAp9Ld+3DY2kKiKg
        ==
X-ME-Sender: <xms:-O08YMXVJRRHmq8d1We8AZybE5Y0K3agkR4OJs6_BEv8w78uAWj1sQ>
    <xme:-O08YOLeCmXNfniZteorT4BSHRLUSDcbThxWZJjgzaz4qsN9as0QPkoBSde-9qrlo
    swwKhiy8vgtdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeevuedukeegheeitdfhfefgvedvteethedvieehheduge
    dtvdevgfdtieehkeeuheenucffohhmrghinhepvghnthhrhidrshgsnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-O08YG1g58ySUcHSJ3ti1lsveWZ87F1Ilx--8kgmrGetZ1Rl40p4XQ>
    <xmx:-O08YM7QVtEXWt9Xdfx6cSOOYpmd4VRdl9I42J0Qw2BkoxXbax6HwQ>
    <xmx:-O08YH9bxZVSPO-6xphUy2rkVqA3NWH7pPQhmO06V7POiguRMI50sQ>
    <xmx:-O08YHFRTdVSYD3dTv549yeuLxmfz3jB9SoEn0GxWLOEUlnQnm2d6g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D9AB1080059;
        Mon,  1 Mar 2021 08:36:56 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390: fix kernel asce loading when sie is interrupted" failed to apply to 5.11-stable tree
To:     svens@linux.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:36:54 +0100
Message-ID: <161460581411228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 26521412ae22d06caab98721757b2721c6d7c46c Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@linux.ibm.com>
Date: Wed, 3 Feb 2021 09:16:45 +0100
Subject: [PATCH] s390: fix kernel asce loading when sie is interrupted

If a machine check is coming in during sie, the PU saves the
control registers to the machine check save area. Afterwards
mcck_int_handler is called, which loads __LC_KERNEL_ASCE into
%cr1. Later the code restores %cr1 from the machine check area,
but that is wrong when SIE was interrupted because the machine
check area still contains the gmap asce. Instead it should return
with either __KERNEL_ASCE in %cr1 when interrupted in SIE or
the previous %cr1 content saved in the machine check save area.

Fixes: 87d598634521 ("s390/mm: remove set_fs / rework address space handling")
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Cc: <stable@kernel.org> # v5.8+
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index f7953bb17558..377294969954 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -558,6 +558,7 @@ ENTRY(mcck_int_handler)
 	lg	%r15,__LC_MCCK_STACK
 .Lmcck_skip:
 	la	%r11,STACK_FRAME_OVERHEAD(%r15)
+	stctg	%c1,%c1,__PT_CR1(%r11)
 	lctlg	%c1,%c1,__LC_KERNEL_ASCE
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lghi	%r14,__LC_GPREGS_SAVE_AREA+64
@@ -573,8 +574,6 @@ ENTRY(mcck_int_handler)
 	xgr	%r10,%r10
 	mvc	__PT_R8(64,%r11),0(%r14)
 	stmg	%r8,%r9,__PT_PSW(%r11)
-	la	%r14,4095
-	mvc	__PT_CR1(8,%r11),__LC_CREGS_SAVE_AREA-4095+8(%r14)
 	xc	__PT_FLAGS(8,%r11),__PT_FLAGS(%r11)
 	xc	__SF_BACKCHAIN(8,%r15),__SF_BACKCHAIN(%r15)
 	lgr	%r2,%r11		# pass pointer to pt_regs

