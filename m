Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A67A51AA400
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506215AbgDONP4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:15:56 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33941 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505098AbgDONPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 09:15:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 495025C01AA;
        Wed, 15 Apr 2020 09:15:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 09:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IKvCTd
        Ufr1rMC1FGfwi8xJJmjM7kPfZ6dCA5mwk+Ehw=; b=VqypMZTC2r1TXnGrG/pqr+
        NOUdNNsVPNKmuAYLsKWn15WUuazNDUWwUk/DwEY52zRVIXfqPTQeDtM3V5yvSFFA
        p0D8Yl+njHmql/kPM1xYDnLzmZSnWC3zXqqcWVmItHD14Tb+2uS3UpaMdTKqHMHB
        rblOOok3yQu8Wk7Qla4+6Wu9cOYlgwDFKwi4ZvxNPFVCKQQsm5HIo0HGqYQlJb1h
        q7CMMzMbT6X4/2Ooo4ck+CX5FdPHckIxDFXKGvAH3idYBacgcsL5D7bZKvORs5ey
        ikri5+DBIbYc1bqlH7LJ6LsUYHAL8f538kQpI4vxNoEz/KjFRRB7sps9w0gO1b1Q
        ==
X-ME-Sender: <xms:AwmXXp0Zx1FWN_ONMfdeTmIvyPR9tbD85_8nlePAO8A2bRg8bB9RfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:AwmXXkXrqRZrfFMNYSrK0oZ0OMxJFXw0jOC-qvFV985FemB13T0qhA>
    <xmx:AwmXXk4XAMth81XbQITVbzrx4CulfMbWIbXx8X1Tr1ekHYqlDrRxaA>
    <xmx:AwmXXrIJ4bLu9tg-wgsZkKtRrAny4436VEJ07W0_JyAKvAqDYiKwkQ>
    <xmx:BAmXXsmkapFluGDKMJFLoxWGTwWz_TGZpDBmRMlK_apLLyqZIq7fJw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 85E993060067;
        Wed, 15 Apr 2020 09:15:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc: Make setjmp/longjmp signature standard" failed to apply to 4.14-stable tree
To:     courbet@google.com, mpe@ellerman.id.au, natechancellor@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 15:15:46 +0200
Message-ID: <15869565461129@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c17eb4dca5a353a9dbbb8ad6934fe57af7165e91 Mon Sep 17 00:00:00 2001
From: Clement Courbet <courbet@google.com>
Date: Mon, 30 Mar 2020 10:03:56 +0200
Subject: [PATCH] powerpc: Make setjmp/longjmp signature standard

Declaring setjmp()/longjmp() as taking longs makes the signature
non-standard, and makes clang complain. In the past, this has been
worked around by adding -ffreestanding to the compile flags.

The implementation looks like it only ever propagates the value
(in longjmp) or sets it to 1 (in setjmp), and we only call longjmp
with integer parameters.

This allows removing -ffreestanding from the compilation flags.

Fixes: c9029ef9c957 ("powerpc: Avoid clang warnings around setjmp and longjmp")
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Clement Courbet <courbet@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200330080400.124803-1-courbet@google.com

diff --git a/arch/powerpc/include/asm/setjmp.h b/arch/powerpc/include/asm/setjmp.h
index e9f81bb3f83b..f798e80e4106 100644
--- a/arch/powerpc/include/asm/setjmp.h
+++ b/arch/powerpc/include/asm/setjmp.h
@@ -7,7 +7,9 @@
 
 #define JMP_BUF_LEN    23
 
-extern long setjmp(long *) __attribute__((returns_twice));
-extern void longjmp(long *, long) __attribute__((noreturn));
+typedef long jmp_buf[JMP_BUF_LEN];
+
+extern int setjmp(jmp_buf env) __attribute__((returns_twice));
+extern void longjmp(jmp_buf env, int val) __attribute__((noreturn));
 
 #endif /* _ASM_POWERPC_SETJMP_H */
diff --git a/arch/powerpc/kexec/Makefile b/arch/powerpc/kexec/Makefile
index 378f6108a414..86380c69f5ce 100644
--- a/arch/powerpc/kexec/Makefile
+++ b/arch/powerpc/kexec/Makefile
@@ -3,9 +3,6 @@
 # Makefile for the linux kernel.
 #
 
-# Avoid clang warnings around longjmp/setjmp declarations
-CFLAGS_crash.o += -ffreestanding
-
 obj-y				+= core.o crash.o core_$(BITS).o
 
 obj-$(CONFIG_PPC32)		+= relocate_32.o
diff --git a/arch/powerpc/xmon/Makefile b/arch/powerpc/xmon/Makefile
index c3842dbeb1b7..6f9cccea54f3 100644
--- a/arch/powerpc/xmon/Makefile
+++ b/arch/powerpc/xmon/Makefile
@@ -1,9 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for xmon
 
-# Avoid clang warnings around longjmp/setjmp declarations
-subdir-ccflags-y := -ffreestanding
-
 GCOV_PROFILE := n
 KCOV_INSTRUMENT := n
 UBSAN_SANITIZE := n

