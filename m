Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A692437ED8C
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346134AbhELUik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:38:40 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:47021 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376335AbhELSyc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 14:54:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 004911940A9E;
        Wed, 12 May 2021 14:53:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 14:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=7/eqfO
        Weie8sn/jVdJmBQk/jHeTMWBUbMM2aF4OxSTE=; b=hy4CKrMrgxgA5ACSdciQqN
        oLXzK3lvRla7xHeSmzM1Zzit9t0U3xGkyiQ5127/EZESVkkMDUdKZkIHyn4OmM+j
        y7OKcqPvGL44+0xZJVV+C3xgk4lJMzsn9PUAmE9be9BPbI0/+YajdWxQMugH4Kkl
        EdAq7b+HQ0ciYGuNWcJ2W3e37HArPrRFjHrDwfTR/lelfI9/5dxVtm+heOALVZov
        VMmmGh23Yg4VABqiNBr0bcWftEjfH8tqI9kgrjo+DgHWm5PxkQ/LKSODYCID44h+
        m5I8iDI9chAtJPGuR8Y27ykhRjZC+UjA9Ro5eViO0Qs00PbjIOQ/zzixlP7kO4/A
        ==
X-ME-Sender: <xms:IiScYC-glb2a2w0jyBRJwIR-yMA_wi8xSmRlD-_FksvAKfCEmlAm4g>
    <xme:IiScYCuK6durGDf5wKlI32inh_g-6Ja_0qfnCRv-5N9aCi6TC2xKZXNDVQAHFnopk
    X-rTJrTBZyltA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddvkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:IiScYIDOlhXMn2racl4EgpS1pwLwRPv5sFYokvLGkRu9aLmhaJDLgg>
    <xmx:IiScYKdYoFGWQbFk7FEwqZN1xB5leZOecngtL1OW3ICNODO3num-Ug>
    <xmx:IiScYHONI5lsjp28Fnstl5P65xZaCvTKstlWvAEmemTMBpdKEp2wOA>
    <xmx:IiScYN0xNcH22XixnVfdndyTXuB3v06TwGoCaL8TALyzw9QR876XQw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 14:53:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] MIPS: Reinstate platform `__div64_32' handler" failed to apply to 5.4-stable tree
To:     macro@orcam.me.uk, chenhuacai@kernel.org, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 20:53:16 +0200
Message-ID: <1620845596195253@kroah.com>
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

From c49f71f60754acbff37505e1d16ca796bf8a8140 Mon Sep 17 00:00:00 2001
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
Date: Tue, 20 Apr 2021 04:50:40 +0200
Subject: [PATCH] MIPS: Reinstate platform `__div64_32' handler

Our current MIPS platform `__div64_32' handler is inactive, because it
is incorrectly only enabled for 64-bit configurations, for which generic
`do_div' code does not call it anyway.

The handler is not suitable for being called from there though as it
only calculates 32 bits of the quotient under the assumption the 64-bit
divident has been suitably reduced.  Code for such reduction used to be
there, however it has been incorrectly removed with commit c21004cd5b4c
("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0."), which should
have only updated an obsoleted constraint for an inline asm involving
$hi and $lo register outputs, while possibly wiring the original MIPS
variant of the `do_div' macro as `__div64_32' handler for the generic
`do_div' implementation

Correct the handler as follows then:

- Revert most of the commit referred, however retaining the current
  formatting, except for the final two instructions of the inline asm
  sequence, which the original commit missed.  Omit the original 64-bit
  parts though.

- Rename the original `do_div' macro to `__div64_32'.  Use the combined
  `x' constraint referring to the MD accumulator as a whole, replacing
  the original individual `h' and `l' constraints used for $hi and $lo
  registers respectively, of which `h' has been obsoleted with GCC 4.4.
  Update surrounding code accordingly.

  We have since removed support for GCC versions before 4.9, so no need
  for a special arrangement here; GCC has supported the `x' constraint
  since forever anyway, or at least going back to 1991.

- Rename the `__base' local variable in `__div64_32' to `__radix' to
  avoid a conflict with a local variable in `do_div'.

- Actually enable this code for 32-bit rather than 64-bit configurations
  by qualifying it with BITS_PER_LONG being 32 instead of 64.  Include
  <asm/bitsperlong.h> for this macro rather than <linux/types.h> as we
  don't need anything else.

- Finally include <asm-generic/div64.h> last rather than first.

This has passed correctness verification with test_div64 and reduced the
module's average execution time down to 1.0668s and 0.2629s from 2.1529s
and 0.5647s respectively for an R3400 CPU @40MHz and a 5Kc CPU @160MHz.
For a reference 64-bit `do_div' code where we have the DDIVU instruction
available to do the whole calculation right away averages at 0.0660s for
the latter CPU.

Fixes: c21004cd5b4c ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
Reported-by: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: stable@vger.kernel.org # v2.6.30+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
index dc5ea5736440..b252300e299d 100644
--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2000, 2004  Maciej W. Rozycki
+ * Copyright (C) 2000, 2004, 2021  Maciej W. Rozycki
  * Copyright (C) 2003, 07 Ralf Baechle (ralf@linux-mips.org)
  *
  * This file is subject to the terms and conditions of the GNU General Public
@@ -9,25 +9,18 @@
 #ifndef __ASM_DIV64_H
 #define __ASM_DIV64_H
 
-#include <asm-generic/div64.h>
-
-#if BITS_PER_LONG == 64
+#include <asm/bitsperlong.h>
 
-#include <linux/types.h>
+#if BITS_PER_LONG == 32
 
 /*
  * No traps on overflows for any of these...
  */
 
-#define __div64_32(n, base)						\
-({									\
+#define do_div64_32(res, high, low, base) ({				\
 	unsigned long __cf, __tmp, __tmp2, __i;				\
 	unsigned long __quot32, __mod32;				\
-	unsigned long __high, __low;					\
-	unsigned long long __n;						\
 									\
-	__high = *__n >> 32;						\
-	__low = __n;							\
 	__asm__(							\
 	"	.set	push					\n"	\
 	"	.set	noat					\n"	\
@@ -51,18 +44,50 @@
 	"	subu	%0, %0, %z6				\n"	\
 	"	addiu	%2, %2, 1				\n"	\
 	"3:							\n"	\
-	"	bnez	%4, 0b\n\t"					\
-	"	 srl	%5, %1, 0x1f\n\t"				\
+	"	bnez	%4, 0b					\n"	\
+	"	 srl	%5, %1, 0x1f				\n"	\
 	"	.set	pop"						\
 	: "=&r" (__mod32), "=&r" (__tmp),				\
 	  "=&r" (__quot32), "=&r" (__cf),				\
 	  "=&r" (__i), "=&r" (__tmp2)					\
-	: "Jr" (base), "0" (__high), "1" (__low));			\
+	: "Jr" (base), "0" (high), "1" (low));				\
 									\
-	(__n) = __quot32;						\
+	(res) = __quot32;						\
 	__mod32;							\
 })
 
-#endif /* BITS_PER_LONG == 64 */
+#define __div64_32(n, base) ({						\
+	unsigned long __upper, __low, __high, __radix;			\
+	unsigned long long __modquot;					\
+	unsigned long long __quot;					\
+	unsigned long long __div;					\
+	unsigned long __mod;						\
+									\
+	__div = (*n);							\
+	__radix = (base);						\
+									\
+	__high = __div >> 32;						\
+	__low = __div;							\
+	__upper = __high;						\
+									\
+	if (__high) {							\
+		__asm__("divu	$0, %z1, %z2"				\
+		: "=x" (__modquot)					\
+		: "Jr" (__high), "Jr" (__radix));			\
+		__upper = __modquot >> 32;				\
+		__high = __modquot;					\
+	}								\
+									\
+	__mod = do_div64_32(__low, __upper, __low, __radix);		\
+									\
+	__quot = __high;						\
+	__quot = __quot << 32 | __low;					\
+	(*n) = __quot;							\
+	__mod;								\
+})
+
+#endif /* BITS_PER_LONG == 32 */
+
+#include <asm-generic/div64.h>
 
 #endif /* __ASM_DIV64_H */

