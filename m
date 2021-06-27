Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CEB3B53AD
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhF0OXE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 10:23:04 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58201 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229973AbhF0OXD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Jun 2021 10:23:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 10A7219405DB;
        Sun, 27 Jun 2021 10:20:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 27 Jun 2021 10:20:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xaD1PR
        gGzrWP5hM7/bQjNn8BucXGJ/HMH14RJq0uRa0=; b=K8d2gojXU5wTwYmBJGc3yA
        kc1STzRYZ81ztAjOlq0rtLNwaTcgePhxgTBz9+5GnsaF0L5meDP+xntcCGgvocMy
        DsGSrUEflrrn7rVAM5aMzhHDOJn3KCzQTd/Lmw45FtZ+oDGeQQVL8lwNOejb88At
        hLahvZ3kIhMa/fBYfcfkecMEvWXL/BZK1YtLdBDH02Fnk5MW2M78hg91Pu5RYQ96
        /DdkN2aJq9mUqWsMpRsX0taw1fG32bKecdDA0YPnnPZhdF8tFQB5Bklcdmxo0F9m
        rVKagqeIgUUEZxFLicQ3OK0+rjccH8PSIEJLTAz/LVxEelzyheCl8IZw3DOYhaUA
        ==
X-ME-Sender: <xms:NonYYKnqoASeqyHM_wIgB3RBU7ge3djwpAs9GzcjWP1-nlcsxdzlTw>
    <xme:NonYYB3cGbXVogfYz67dqxM0Q6MheX3Xlavg60KBF4q6nWYvKLdjVGBykxfhMnX84
    3tmvrQbP1xtiw>
X-ME-Received: <xmr:NonYYIoe4V9kjmFllDWaqfDzh1YClYFRfXFTvNojHbLO4czVoJacPKW_IVaXR28Qjlc5NPXmYpRYlwsBdYdnl-G-ZrFc6T0J>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeehvddgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:NonYYOloZSxYt0wTmjOa0JuEKa_yCb9q743lxF9lsjzw56hz01n2zQ>
    <xmx:NonYYI3FfgSnsuBmVEkpx-jPl5rJGG2LIlOYTm4Gr7tm2rR9ivc5ww>
    <xmx:NonYYFtnWbREhvtT7u8rgiH7Tbi8X5vNEYWXkfakE13n5BVTH2swvQ>
    <xmx:N4nYYGAXNi4FJh3xygx3qOF8HcfnJCdo-yvMUNGDPU2gTBhiGNhBmQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Jun 2021 10:20:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] s390/stack: fix possible register corruption with stack" failed to apply to 5.4-stable tree
To:     hca@linux.ibm.com, gor@linux.ibm.com, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 27 Jun 2021 16:20:36 +0200
Message-ID: <16248036362480@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 67147e96a332b56c7206238162771d82467f86c0 Mon Sep 17 00:00:00 2001
From: Heiko Carstens <hca@linux.ibm.com>
Date: Fri, 18 Jun 2021 16:58:47 +0200
Subject: [PATCH] s390/stack: fix possible register corruption with stack
 switch helper

The CALL_ON_STACK macro is used to call a C function from inline
assembly, and therefore must consider the C ABI, which says that only
registers 6-13, and 15 are non-volatile (restored by the called
function).

The inline assembly incorrectly marks all registers used to pass
parameters to the called function as read-only input operands, instead
of operands that are read and written to. This might result in
register corruption depending on usage, compiler, and compile options.

Fix this by marking all operands used to pass parameters as read/write
operands. To keep the code simple even register 6, if used, is marked
as read-write operand.

Fixes: ff340d2472ec ("s390: add stack switch helper")
Cc: <stable@kernel.org> # 4.20
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index 2b543163d90a..76c6034428be 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -91,12 +91,16 @@ struct stack_frame {
 	CALL_ARGS_4(arg1, arg2, arg3, arg4);				\
 	register unsigned long r4 asm("6") = (unsigned long)(arg5)
 
-#define CALL_FMT_0 "=&d" (r2) :
-#define CALL_FMT_1 "+&d" (r2) :
-#define CALL_FMT_2 CALL_FMT_1 "d" (r3),
-#define CALL_FMT_3 CALL_FMT_2 "d" (r4),
-#define CALL_FMT_4 CALL_FMT_3 "d" (r5),
-#define CALL_FMT_5 CALL_FMT_4 "d" (r6),
+/*
+ * To keep this simple mark register 2-6 as being changed (volatile)
+ * by the called function, even though register 6 is saved/nonvolatile.
+ */
+#define CALL_FMT_0 "=&d" (r2)
+#define CALL_FMT_1 "+&d" (r2)
+#define CALL_FMT_2 CALL_FMT_1, "+&d" (r3)
+#define CALL_FMT_3 CALL_FMT_2, "+&d" (r4)
+#define CALL_FMT_4 CALL_FMT_3, "+&d" (r5)
+#define CALL_FMT_5 CALL_FMT_4, "+&d" (r6)
 
 #define CALL_CLOBBER_5 "0", "1", "14", "cc", "memory"
 #define CALL_CLOBBER_4 CALL_CLOBBER_5
@@ -118,7 +122,7 @@ struct stack_frame {
 		"	brasl	14,%[_fn]\n"				\
 		"	la	15,0(%[_prev])\n"			\
 		: [_prev] "=&a" (prev), CALL_FMT_##nr			\
-		  [_stack] "R" (stack),					\
+		: [_stack] "R" (stack),					\
 		  [_bc] "i" (offsetof(struct stack_frame, back_chain)),	\
 		  [_frame] "d" (frame),					\
 		  [_fn] "X" (fn) : CALL_CLOBBER_##nr);			\

