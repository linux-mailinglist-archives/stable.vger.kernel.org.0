Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F2E2E3571
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgL1J0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:26:04 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:42459 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1J0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:26:04 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 377014E4;
        Mon, 28 Dec 2020 04:24:44 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xPYbFz
        mPv1IzKS0Yy6ocefI4Kf4OAW1VDS7uv2dobpM=; b=UqSAHYYe97y290mjqBBdQG
        Sal3tK2yuCSGclap9r3AYU2fHuvcd0PDRrj9N2ax5TAc0AeT7UrDN57eXblBX7Sl
        xL752t++KZGeMGVypiwosmwYwVq0MvSK46qRMwDRrdcIE9JoOz78kvA4ZyEUU88Y
        c7Ln+GKbIMAIAzcYYR4JxVos+3VHjeJchkYOhp72vwMtMJM0l6v8XcMFwIcr+c6R
        VlTyb6JCr5JhjPCm2p4eOpv9ezFUvhNXgRpVodkF5W8e9CwubS/7HkoSx5A+/2ru
        bmBoM3/HvvEm/jyydxKv0grd4YMhF9StKvWuzNWrLTA3vvWpNLQkWcTgcVXIbS2Q
        ==
X-ME-Sender: <xms:W6TpXyLVEocAMj-uBTk6sPoEsu0xmw7nWuBNnpbBw6_KKmZgS2MGtg>
    <xme:W6TpX6Jnz608zfadwCaipPBl9SxEFPZbWmzdJYsEz9nG2hYKYd2oUb97s31WimEaq
    ItUr4WaRQNwZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:W6TpXysEI1WZir1H-AD_tHcYG_KJ6u6qFRi7MdWyU4h2TVG96djZWg>
    <xmx:W6TpX3bULhyd4i2afmnO5Gq4UuyJwrkzoqqDlxP470JHnJt4tCe_2w>
    <xmx:W6TpX5Y-3n-w6YAW0yJiKDv4jfJqEaZmh1aZckzmk2GWKZCItKfH4w>
    <xmx:W6TpX4y4Y9Kf76GEWwXeHvRGorY0ELFRQz6LZ9ER8zQDsG9J1f4_3UpZUoE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C6E424005E;
        Mon, 28 Dec 2020 04:24:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/bitops: Fix possible undefined behaviour with fls()" failed to apply to 5.4-stable tree
To:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        segher@kernel.crashing.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:26:07 +0100
Message-ID: <16091475676539@kroah.com>
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

