Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF8F6E91
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 07:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfKKGam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 01:30:42 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60449 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726834AbfKKGal (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 01:30:41 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 29B6C20F2E;
        Mon, 11 Nov 2019 01:30:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 11 Nov 2019 01:30:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=S+c1ZF
        V5T+xZMfTHCnNll2Yty4VPP/kt9Pj+0JSXwWQ=; b=orHPOzR6LWYsLeJb+eaql4
        D/59Ils7jrZIAO550/1pDdP9ia42i5zA6Cko80/mAJMfCzLfZuW7LZ71LVsT5JL6
        m0+rxe2C/tjenGRxbJmW5wGeNp41yEss6CGFjZrYv1c2PzZmHH3ubxPBNdmT78tq
        jzS0JuoOADsIW86xJfnkXNQB7rFIoN/sGVoYuy0gYRmgB12Q3KLstg7bKuCgnO+0
        +sp3mTrA4fxtDTBvPgJSsNL3plWHRycyQsBtzm/dDDW+51VfSeOW2vu9qohONiuf
        ZAKM1tc23m7MRxylJ56T5W379ctPYwBcFgaKI8Agzg0BCtcUDQu0/pDJdZ4ozkNg
        ==
X-ME-Sender: <xms:DwDJXSfLpdtbJFjd13rSGs4dTVeqIvlKgR7fLXgzSEcXZ-Y_5AWTGA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddviedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:DwDJXVj5_Xc5vS2ZjVOWMvDpeALcQh_J9wUuyEcoR2rm7Kf-5b112w>
    <xmx:DwDJXawJvthItaNoejIfHmSHkub11X43lMF8GGnmLyKDYD6aBIZ-gg>
    <xmx:DwDJXRPFWqdzcXEx-6MLJIqvajdL6d41sTQuQlI5B0P3oFnSKW6j2A>
    <xmx:EADJXcVY5-gLZbBt-tRnzercuaHBf3_gZfgGB1xvlWysEvKX1thkzw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E80C480063;
        Mon, 11 Nov 2019 01:30:38 -0500 (EST)
Subject: FAILED: patch "[PATCH] timekeeping/vsyscall: Update VDSO data unconditionally" failed to apply to 5.3-stable tree
To:     chenhc@lemote.com, arnd@arndb.de, luto@kernel.org,
        paul.burton@mips.com, tglx@linutronix.de, vincenzo.frascino@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Nov 2019 07:30:37 +0100
Message-ID: <1573453837131100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.3-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 52338415cf4d4064ae6b8dd972dadbda841da4fa Mon Sep 17 00:00:00 2001
From: Huacai Chen <chenhc@lemote.com>
Date: Thu, 24 Oct 2019 11:28:29 +0800
Subject: [PATCH] timekeeping/vsyscall: Update VDSO data unconditionally

The update of the VDSO data is depending on __arch_use_vsyscall() returning
True. This is a leftover from the attempt to map the features of various
architectures 1:1 into generic code.

The usage of __arch_use_vsyscall() in the actual vsyscall implementations
got dropped and replaced by the requirement for the architecture code to
return U64_MAX if the global clocksource is not usable in the VDSO.

But the __arch_use_vsyscall() check in the update code stayed which causes
the VDSO data to be stale or invalid when an architecture actually
implements that function and returns False when the current clocksource is
not usable in the VDSO.

As a consequence the VDSO implementations of clock_getres(), time(),
clock_gettime(CLOCK_.*_COARSE) operate on invalid data and return bogus
information.

Remove the __arch_use_vsyscall() check from the VDSO update function and
update the VDSO data unconditionally.

[ tglx: Massaged changelog and removed the now useless implementations in
  	asm-generic/ARM64/MIPS ]

Fixes: 44f57d788e7deecb50 ("timekeeping: Provide a generic update_vsyscall() implementation")
Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1571887709-11447-1-git-send-email-chenhc@lemote.com

diff --git a/arch/arm64/include/asm/vdso/vsyscall.h b/arch/arm64/include/asm/vdso/vsyscall.h
index 0c731bfc7c8c..0c20a7c1bee5 100644
--- a/arch/arm64/include/asm/vdso/vsyscall.h
+++ b/arch/arm64/include/asm/vdso/vsyscall.h
@@ -30,13 +30,6 @@ int __arm64_get_clock_mode(struct timekeeper *tk)
 }
 #define __arch_get_clock_mode __arm64_get_clock_mode
 
-static __always_inline
-int __arm64_use_vsyscall(struct vdso_data *vdata)
-{
-	return !vdata[CS_HRES_COARSE].clock_mode;
-}
-#define __arch_use_vsyscall __arm64_use_vsyscall
-
 static __always_inline
 void __arm64_update_vsyscall(struct vdso_data *vdata, struct timekeeper *tk)
 {
diff --git a/arch/mips/include/asm/vdso/vsyscall.h b/arch/mips/include/asm/vdso/vsyscall.h
index 195314732233..00d41b94ba31 100644
--- a/arch/mips/include/asm/vdso/vsyscall.h
+++ b/arch/mips/include/asm/vdso/vsyscall.h
@@ -28,13 +28,6 @@ int __mips_get_clock_mode(struct timekeeper *tk)
 }
 #define __arch_get_clock_mode __mips_get_clock_mode
 
-static __always_inline
-int __mips_use_vsyscall(struct vdso_data *vdata)
-{
-	return (vdata[CS_HRES_COARSE].clock_mode != VDSO_CLOCK_NONE);
-}
-#define __arch_use_vsyscall __mips_use_vsyscall
-
 /* The asm-generic header needs to be included after the definitions above */
 #include <asm-generic/vdso/vsyscall.h>
 
diff --git a/include/asm-generic/vdso/vsyscall.h b/include/asm-generic/vdso/vsyscall.h
index e94b19782c92..ce4103208619 100644
--- a/include/asm-generic/vdso/vsyscall.h
+++ b/include/asm-generic/vdso/vsyscall.h
@@ -25,13 +25,6 @@ static __always_inline int __arch_get_clock_mode(struct timekeeper *tk)
 }
 #endif /* __arch_get_clock_mode */
 
-#ifndef __arch_use_vsyscall
-static __always_inline int __arch_use_vsyscall(struct vdso_data *vdata)
-{
-	return 1;
-}
-#endif /* __arch_use_vsyscall */
-
 #ifndef __arch_update_vsyscall
 static __always_inline void __arch_update_vsyscall(struct vdso_data *vdata,
 						   struct timekeeper *tk)
diff --git a/kernel/time/vsyscall.c b/kernel/time/vsyscall.c
index 4bc37ac3bb05..5ee0f7709410 100644
--- a/kernel/time/vsyscall.c
+++ b/kernel/time/vsyscall.c
@@ -110,8 +110,7 @@ void update_vsyscall(struct timekeeper *tk)
 	nsec		= nsec + tk->wall_to_monotonic.tv_nsec;
 	vdso_ts->sec	+= __iter_div_u64_rem(nsec, NSEC_PER_SEC, &vdso_ts->nsec);
 
-	if (__arch_use_vsyscall(vdata))
-		update_vdso_data(vdata, tk);
+	update_vdso_data(vdata, tk);
 
 	__arch_update_vsyscall(vdata, tk);
 
@@ -124,10 +123,8 @@ void update_vsyscall_tz(void)
 {
 	struct vdso_data *vdata = __arch_get_k_vdso_data();
 
-	if (__arch_use_vsyscall(vdata)) {
-		vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
-		vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
-	}
+	vdata[CS_HRES_COARSE].tz_minuteswest = sys_tz.tz_minuteswest;
+	vdata[CS_HRES_COARSE].tz_dsttime = sys_tz.tz_dsttime;
 
 	__arch_sync_vdso_data(vdata);
 }

