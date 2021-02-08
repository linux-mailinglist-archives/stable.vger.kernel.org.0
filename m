Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7CD5312FC2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhBHKzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:55:05 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:52789 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhBHKwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:52:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id AEB1F964;
        Mon,  8 Feb 2021 05:51:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:51:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=E5+z/J
        QICh8ygNpGipQFqN3cO5OaqHg1Fp9JcONt194=; b=tTc9byGciId3FYplXbZFhC
        I5gXDsBe7PGMDP7/tQkh91CA9Rowr7nYGTqZShPTJM1kELSzXZQYeTg6t6k3gyiD
        DgreF8Aov0tyNEOJKq2Q0iGOzyrQ4bljFbCs9DtQgFxYCojvVrKpOJ/mxFm9vyN6
        Bfi0DXzI07B6CTMna+uBkDs1guu2nuREkDWxN/4r+mMgWwHJ6VifkdriOTZaBrV1
        lH/95ulLeMzSq4vYhWT2J8UJ7tK1pZX8ttuTXDZ2ndrBFVy0+jZth4G/gOWL1Bq1
        4JiE69GRMNTGVw/F//Suptzlnv+iILZKouHuDUvPcx/ZYp1PIdluA9qExLe8Qp+A
        ==
X-ME-Sender: <xms:pRchYAFYKitNnfDiWyXjjDpsWQyblXjufAJzYf13DvcfRFWxgf67tw>
    <xme:pRchYJV6-rKWHD_bzZ_7o3oyw7xgus2P7keyDboiAMno-7JWZ-Sbtb5mKhciIBU_v
    U4ZD-eL0Tyb2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeffjeejueegueevffeiieekheeihfeuudevvddttdduke
    fgjefhudehkeeiiedvfeenucffohhmrghinhepohiilhgrsghsrdhorhhgpdhkvghrnhgv
    lhdrohhrghdpshhighhtrhgrmhhprdhssgdplhgushdrshgsnecukfhppeekfedrkeeird
    ejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:pRchYKJnhG2oqGdwBiUIuuCjSDYrIn-lxU9pMrFjhW8X_AoxfB_EHw>
    <xmx:pRchYCEYt-DwtpcHoYygnatkvcIA82Wh-jjr7CGyhtOYlePzU8oJzw>
    <xmx:pRchYGWwUkb0ChMb-jOt9YCty4aoM0g9uWuyPMZz_K1uty5JSM6xyA>
    <xmx:phchYJemssZNeSgMAy46upgu4_xDZRY8chqgNbGz9YGSrUc7mWGm2PUn1Ig>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1817D108005F;
        Mon,  8 Feb 2021 05:51:17 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/64/signal: Fix regression in __kernel_sigtramp_rt64()" failed to apply to 5.10-stable tree
To:     raoni@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:51:15 +0100
Message-ID: <161278147580199@kroah.com>
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

From 24321ac668e452a4942598533d267805f291fdc9 Mon Sep 17 00:00:00 2001
From: Raoni Fassina Firmino <raoni@linux.ibm.com>
Date: Mon, 1 Feb 2021 17:05:05 -0300
Subject: [PATCH] powerpc/64/signal: Fix regression in __kernel_sigtramp_rt64()
 semantics

Commit 0138ba5783ae ("powerpc/64/signal: Balance return predictor
stack in signal trampoline") changed __kernel_sigtramp_rt64() VDSO and
trampoline code, and introduced a regression in the way glibc's
backtrace()[1] detects the signal-handler stack frame. Apart from the
practical implications, __kernel_sigtramp_rt64() was a VDSO function
with the semantics that it is a function you can call from userspace
to end a signal handling. Now this semantics are no longer valid.

I believe the aforementioned change affects all releases since 5.9.

This patch tries to fix both the semantics and practical aspect of
__kernel_sigtramp_rt64() returning it to the previous code, whilst
keeping the intended behaviour of 0138ba5783ae by adding a new symbol
to serve as the jump target from the kernel to the trampoline. Now the
trampoline has two parts, a new entry point and the old return point.

[1] https://lists.ozlabs.org/pipermail/linuxppc-dev/2021-January/223194.html

Fixes: 0138ba5783ae ("powerpc/64/signal: Balance return predictor stack in signal trampoline")
Cc: stable@vger.kernel.org # v5.9+
Signed-off-by: Raoni Fassina Firmino <raoni@linux.ibm.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
[mpe: Minor tweaks to change log formatting, add stable tag]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210201200505.iz46ubcizipnkcxe@work-tp

diff --git a/arch/powerpc/kernel/vdso64/sigtramp.S b/arch/powerpc/kernel/vdso64/sigtramp.S
index bbf68cd01088..2d4067561293 100644
--- a/arch/powerpc/kernel/vdso64/sigtramp.S
+++ b/arch/powerpc/kernel/vdso64/sigtramp.S
@@ -15,11 +15,20 @@
 
 	.text
 
+/*
+ * __kernel_start_sigtramp_rt64 and __kernel_sigtramp_rt64 together
+ * are one function split in two parts. The kernel jumps to the former
+ * and the signal handler indirectly (by blr) returns to the latter.
+ * __kernel_sigtramp_rt64 needs to point to the return address so
+ * glibc can correctly identify the trampoline stack frame.
+ */
 	.balign 8
 	.balign IFETCH_ALIGN_BYTES
-V_FUNCTION_BEGIN(__kernel_sigtramp_rt64)
+V_FUNCTION_BEGIN(__kernel_start_sigtramp_rt64)
 .Lsigrt_start:
 	bctrl	/* call the handler */
+V_FUNCTION_END(__kernel_start_sigtramp_rt64)
+V_FUNCTION_BEGIN(__kernel_sigtramp_rt64)
 	addi	r1, r1, __SIGNAL_FRAMESIZE
 	li	r0,__NR_rt_sigreturn
 	sc
diff --git a/arch/powerpc/kernel/vdso64/vdso64.lds.S b/arch/powerpc/kernel/vdso64/vdso64.lds.S
index 6164d1a1ba11..2f3c359cacd3 100644
--- a/arch/powerpc/kernel/vdso64/vdso64.lds.S
+++ b/arch/powerpc/kernel/vdso64/vdso64.lds.S
@@ -131,4 +131,4 @@ VERSION
 /*
  * Make the sigreturn code visible to the kernel.
  */
-VDSO_sigtramp_rt64	= __kernel_sigtramp_rt64;
+VDSO_sigtramp_rt64	= __kernel_start_sigtramp_rt64;

