Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A234327FAC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbhCANiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:38:17 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:35463 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235787AbhCANiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:38:16 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 328471941E7B;
        Mon,  1 Mar 2021 08:37:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Mar 2021 08:37:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kqeT5t
        X1/dVQPgIExpentprj/zie9Gj59g6ncXVCj28=; b=Ce/xOqPWmSIOB0pgL0ATqX
        0oFeFJpGUL7KWAB7cm4R9cnLd7DR9tpti14X4O14rhnNnJkx8Sv4e4qPLAnD+G4/
        VMA189zgCsOF4TLcEhYjxhu8EfTTFOiDjs2FLNcO7W2bxAyqJWn0j6Yn8cwPMJKq
        kRN46FwsY3WX1Z2WbbAz4NhuZ69p9sNKdGVyJiBfz7xhgU8W6vpAiADS9Cko6tjc
        RnixM06aQ6nxO7eGIap8vxg8u2CBjX4iYHOHIXGN94kKmb36nDWHhwOTaIsNt+AB
        WftilTe9St/pNKImjJxGylPsAxIQ+Ge+IsDVbjzWCDRK7c88aUkjYPflJivhHksg
        ==
X-ME-Sender: <xms:Ae48YOLEtfCwJth72C9Ij0kcO_FGgx-2XrCzN63dLvrluuLS2HOjwA>
    <xme:Ae48YGFhFbH1OgT0JjmC0ydqyZ3BO6xQ_EpQayKEJpObxHS5I3GWobAUP7jC5bDgV
    gdiiBhWUUqmZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeevuedukeegheeitdfhfefgvedvteethedvieehheduge
    dtvdevgfdtieehkeeuheenucffohhmrghinhepvghnthhrhidrshgsnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Ae48YLmRKCAmQ1tJH-0Q0GvvqrWLaDyelnUQNJeV58ftVOUfLGC4Zg>
    <xmx:Ae48YLIuaarLf9Q5rNsZgqylLJTn4GXSr7jwBPpYYmgeyPLP5UjG7w>
    <xmx:Ae48YEbX04UTb0U-KEWP7VCuv9dtdOxgbRomL47EtgUTfsYilgHhRw>
    <xmx:Au48YAU0nsfwPQ5KtP3kQIKMavz6_V1WFYdiFIDLYzvco01sMG7YAA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6BFC024005B;
        Mon,  1 Mar 2021 08:37:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] s390: fix kernel asce loading when sie is interrupted" failed to apply to 5.10-stable tree
To:     svens@linux.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:36:55 +0100
Message-ID: <161460581522215@kroah.com>
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

