Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5948C2E3570
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgL1JZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:25:28 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40471 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:25:28 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 123877EA;
        Mon, 28 Dec 2020 04:24:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Ddlghu
        ARwDmW2qv2zJPnDkeya3PvzKQYJZ9BRqot8F0=; b=G8Rq3VT33ojOHDdU2bKuXp
        NllD/zLw35kv46VsOZdJifzx9YzNrcV9afnr80iuICVUhOBY/xG7zVJ76lNQFbfR
        PJflTUV1PXGYgaYNA67SG2uM/Sw7b6Nf+yrb4vRAiacn2PpcxXfr6KPmEJaZTyj5
        pzEEifH4FcIQLzQpVBOhxiJKES4zC3FlZTfSVUi2rlUxa8I4Nl87sR2TIKIST5FU
        umjU86dC1ozs+OWMcPPYiOQxw86gSLOu24Rq7AKBjZtuXmgQRIBn4JHuURF1R7uF
        ggm/fymriMJBp2MrG1638FM7N+LhLqCvGYQ3HEN1dFB6EZBR5I6uQr9o1lN5QIaw
        ==
X-ME-Sender: <xms:WaTpX3HTrZBXUSLasoxNye3fZds7HuX5uAuZ3KhLxEG6eyZV8OC07Q>
    <xme:WaTpX0WpHPgHWaanq-yPpWqDlNTw6DzUM8hVSs8XhycfUsazG84DSd5c9NEffhG8E
    wcyg3dxZqWS-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:WaTpX5JoRD3M6W7JA9_-1ifXS3snuW26qKQVKhPG9ivq9x8vs60tBQ>
    <xmx:WaTpX1Eej9NdUBZ6tMyIjHgIRk-hKFYbKr0d82tIGcOGvMFWtNrb2Q>
    <xmx:WaTpX9VyHBZUyI1Wl0h0jqg-hx5wTmBbWW6QbS3oSeD-xYsmrnOIoA>
    <xmx:WaTpX8dCU_XSNvHo6-a-nPp8s_li83qToSDiDb9KIVfQAEMsZxBKAeNgGXM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CFD11080064;
        Mon, 28 Dec 2020 04:24:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/bitops: Fix possible undefined behaviour with fls()" failed to apply to 4.19-stable tree
To:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        segher@kernel.crashing.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:26:05 +0100
Message-ID: <1609147565248135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1891ef21d92c4801ea082ee8ed478e304ddc6749 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Thu, 22 Oct 2020 14:05:46 +0000
Subject: [PATCH] powerpc/bitops: Fix possible undefined behaviour with fls()
 and fls64()

fls() and fls64() are using __builtin_ctz() and _builtin_ctzll().
On powerpc, those builtins trivially use ctlzw and ctlzd power
instructions.

Allthough those instructions provide the expected result with
input argument 0, __builtin_ctz() and __builtin_ctzll() are
documented as undefined for value 0.

The easiest fix would be to use fls() and fls64() functions
defined in include/asm-generic/bitops/builtin-fls.h and
include/asm-generic/bitops/fls64.h, but GCC output is not optimal:

00000388 <testfls>:
 388:   2c 03 00 00     cmpwi   r3,0
 38c:   41 82 00 10     beq     39c <testfls+0x14>
 390:   7c 63 00 34     cntlzw  r3,r3
 394:   20 63 00 20     subfic  r3,r3,32
 398:   4e 80 00 20     blr
 39c:   38 60 00 00     li      r3,0
 3a0:   4e 80 00 20     blr

000003b0 <testfls64>:
 3b0:   2c 03 00 00     cmpwi   r3,0
 3b4:   40 82 00 1c     bne     3d0 <testfls64+0x20>
 3b8:   2f 84 00 00     cmpwi   cr7,r4,0
 3bc:   38 60 00 00     li      r3,0
 3c0:   4d 9e 00 20     beqlr   cr7
 3c4:   7c 83 00 34     cntlzw  r3,r4
 3c8:   20 63 00 20     subfic  r3,r3,32
 3cc:   4e 80 00 20     blr
 3d0:   7c 63 00 34     cntlzw  r3,r3
 3d4:   20 63 00 40     subfic  r3,r3,64
 3d8:   4e 80 00 20     blr

When the input of fls(x) is a constant, just check x for nullity and
return either 0 or __builtin_clz(x). Otherwise, use cntlzw instruction
directly.

For fls64() on PPC64, do the same but with __builtin_clzll() and
cntlzd instruction. On PPC32, lets take the generic fls64() which
will use our fls(). The result is as expected:

00000388 <testfls>:
 388:   7c 63 00 34     cntlzw  r3,r3
 38c:   20 63 00 20     subfic  r3,r3,32
 390:   4e 80 00 20     blr

000003a0 <testfls64>:
 3a0:   2c 03 00 00     cmpwi   r3,0
 3a4:   40 82 00 10     bne     3b4 <testfls64+0x14>
 3a8:   7c 83 00 34     cntlzw  r3,r4
 3ac:   20 63 00 20     subfic  r3,r3,32
 3b0:   4e 80 00 20     blr
 3b4:   7c 63 00 34     cntlzw  r3,r3
 3b8:   20 63 00 40     subfic  r3,r3,64
 3bc:   4e 80 00 20     blr

Fixes: 2fcff790dcb4 ("powerpc: Use builtin functions for fls()/__fls()/fls64()")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/348c2d3f19ffcff8abe50d52513f989c4581d000.1603375524.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/include/asm/bitops.h b/arch/powerpc/include/asm/bitops.h
index 4a4d3afd5340..299ab33505a6 100644
--- a/arch/powerpc/include/asm/bitops.h
+++ b/arch/powerpc/include/asm/bitops.h
@@ -216,15 +216,34 @@ static inline void arch___clear_bit_unlock(int nr, volatile unsigned long *addr)
  */
 static inline int fls(unsigned int x)
 {
-	return 32 - __builtin_clz(x);
+	int lz;
+
+	if (__builtin_constant_p(x))
+		return x ? 32 - __builtin_clz(x) : 0;
+	asm("cntlzw %0,%1" : "=r" (lz) : "r" (x));
+	return 32 - lz;
 }
 
 #include <asm-generic/bitops/builtin-__fls.h>
 
+/*
+ * 64-bit can do this using one cntlzd (count leading zeroes doubleword)
+ * instruction; for 32-bit we use the generic version, which does two
+ * 32-bit fls calls.
+ */
+#ifdef CONFIG_PPC64
 static inline int fls64(__u64 x)
 {
-	return 64 - __builtin_clzll(x);
+	int lz;
+
+	if (__builtin_constant_p(x))
+		return x ? 64 - __builtin_clzll(x) : 0;
+	asm("cntlzd %0,%1" : "=r" (lz) : "r" (x));
+	return 64 - lz;
 }
+#else
+#include <asm-generic/bitops/fls64.h>
+#endif
 
 #ifdef CONFIG_PPC64
 unsigned int __arch_hweight8(unsigned int w);

