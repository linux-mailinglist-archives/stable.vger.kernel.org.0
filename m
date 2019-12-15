Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2037E11F990
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfLORNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 12:13:02 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41209 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbfLORNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 12:13:02 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id F1D3022280;
        Sun, 15 Dec 2019 12:13:00 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 12:13:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZM9fTF
        eKbKBWUxtxqPiPKNJcI2qtdTrq6r65N1D0Kmo=; b=myLfztWLgWGpsmGVK5gyJP
        ZFVup3M97H4C6u5+03HYNb+gG6n0/Qud40T8G52xJ0jqFecYIa82usYmgsaompbS
        ACLYwFbtehh6eEBy8Se5fiU3GC0XEg2XzVceNuusgs7Ja43+72vazyMZiPQqiWHO
        X6P4v4SzVKQFQpIQxqBjUhy9jK0WEvpJgDhnT2ErEPpfIdqpNHgxJ2Sfxn7/obD7
        zoRXI1anyuJBJS8YHB7GpKGgxWHKeZO5XiK5X3OQVU7IMOngOg52hCl+Ae2QZ+xF
        2PZvhITiM5l5Y1jWp8ARf0caivGz2P3hT/UhHCMqGKw85rbOrhqmNMTTZEM0DzWA
        ==
X-ME-Sender: <xms:nGn2XdM7-iBzlPnzMFJqwceZg9RX4EN-r35cQ5-uGpeMHiHDmlHQTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhgvghtthhimhgvohhfuggrhi
    drshgsnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhho
    mhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:nGn2XWWJOU97-Ea2HtSXtbRUGvrWFqS69S5wxPmoZr_g9MV60XmRaQ>
    <xmx:nGn2XYhf_ChLJb0BtjpFupZD7bBSVp_d0Dy-rcPW9WwxsSMsODZAcQ>
    <xmx:nGn2XXh8FpjZsGbgvHIg87ojtnouSTLWIy8vBG77arSqXCVVLzTlow>
    <xmx:nGn2XQN7P9_CDHY1uI2ex0oFNFc8XDTBSnN2AaJAfPDcuEKerk6ObQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C15468005A;
        Sun, 15 Dec 2019 12:12:59 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Fix vDSO clock_getres()" failed to apply to 5.4-stable tree
To:     vincenzo.frascino@arm.com, christophe.leroy@c-s.fr,
        mpe@ellerman.id.au, skhan@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 18:12:57 +0100
Message-ID: <157642997725350@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 552263456215ada7ee8700ce022d12b0cffe4802 Mon Sep 17 00:00:00 2001
From: Vincenzo Frascino <vincenzo.frascino@arm.com>
Date: Mon, 2 Dec 2019 07:57:29 +0000
Subject: [PATCH] powerpc: Fix vDSO clock_getres()

clock_getres in the vDSO library has to preserve the same behaviour
of posix_get_hrtimer_res().

In particular, posix_get_hrtimer_res() does:
    sec = 0;
    ns = hrtimer_resolution;
and hrtimer_resolution depends on the enablement of the high
resolution timers that can happen either at compile or at run time.

Fix the powerpc vdso implementation of clock_getres keeping a copy of
hrtimer_resolution in vdso data and using that directly.

Fixes: a7f290dad32e ("[PATCH] powerpc: Merge vdso's and add vdso support to 32 bits kernel")
Cc: stable@vger.kernel.org
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
[chleroy: changed CLOCK_REALTIME_RES to CLOCK_HRTIMER_RES]
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a55eca3a5e85233838c2349783bcb5164dae1d09.1575273217.git.christophe.leroy@c-s.fr

diff --git a/arch/powerpc/include/asm/vdso_datapage.h b/arch/powerpc/include/asm/vdso_datapage.h
index a115970a6809..40f13f3626d3 100644
--- a/arch/powerpc/include/asm/vdso_datapage.h
+++ b/arch/powerpc/include/asm/vdso_datapage.h
@@ -83,6 +83,7 @@ struct vdso_data {
 	__s64 wtom_clock_sec;			/* Wall to monotonic clock sec */
 	__s64 stamp_xtime_sec;			/* xtime secs as at tb_orig_stamp */
 	__s64 stamp_xtime_nsec;			/* xtime nsecs as at tb_orig_stamp */
+	__u32 hrtimer_res;			/* hrtimer resolution */
    	__u32 syscall_map_64[SYSCALL_MAP_SIZE]; /* map of syscalls  */
    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
 };
@@ -105,6 +106,7 @@ struct vdso_data {
 	__s32 stamp_xtime_sec;		/* xtime seconds as at tb_orig_stamp */
 	__s32 stamp_xtime_nsec;		/* xtime nsecs as at tb_orig_stamp */
 	__u32 stamp_sec_fraction;	/* fractional seconds of stamp_xtime */
+	__u32 hrtimer_res;		/* hrtimer resolution */
    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
 	__u32 dcache_block_size;	/* L1 d-cache block size     */
 	__u32 icache_block_size;	/* L1 i-cache block size     */
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index f22bd6d1fe93..3d47aec7becf 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -388,6 +388,7 @@ int main(void)
 	OFFSET(STAMP_XTIME_SEC, vdso_data, stamp_xtime_sec);
 	OFFSET(STAMP_XTIME_NSEC, vdso_data, stamp_xtime_nsec);
 	OFFSET(STAMP_SEC_FRAC, vdso_data, stamp_sec_fraction);
+	OFFSET(CLOCK_HRTIMER_RES, vdso_data, hrtimer_res);
 	OFFSET(CFG_ICACHE_BLOCKSZ, vdso_data, icache_block_size);
 	OFFSET(CFG_DCACHE_BLOCKSZ, vdso_data, dcache_block_size);
 	OFFSET(CFG_ICACHE_LOGBLOCKSZ, vdso_data, icache_log_block_size);
@@ -413,7 +414,6 @@ int main(void)
 	DEFINE(CLOCK_REALTIME_COARSE, CLOCK_REALTIME_COARSE);
 	DEFINE(CLOCK_MONOTONIC_COARSE, CLOCK_MONOTONIC_COARSE);
 	DEFINE(NSEC_PER_SEC, NSEC_PER_SEC);
-	DEFINE(CLOCK_REALTIME_RES, MONOTONIC_RES_NSEC);
 
 #ifdef CONFIG_BUG
 	DEFINE(BUG_ENTRY_SIZE, sizeof(struct bug_entry));
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 2d13cea13954..1168e8b37e30 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -960,6 +960,7 @@ void update_vsyscall(struct timekeeper *tk)
 	vdso_data->stamp_xtime_sec = xt.tv_sec;
 	vdso_data->stamp_xtime_nsec = xt.tv_nsec;
 	vdso_data->stamp_sec_fraction = frac_sec;
+	vdso_data->hrtimer_res = hrtimer_resolution;
 	smp_wmb();
 	++(vdso_data->tb_update_count);
 }
diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kernel/vdso32/gettimeofday.S
index c8e6902cb01b..3306672f57a9 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -154,12 +154,15 @@ V_FUNCTION_BEGIN(__kernel_clock_getres)
 	cror	cr0*4+eq,cr0*4+eq,cr1*4+eq
 	bne	cr0,99f
 
+	mflr	r12
+  .cfi_register lr,r12
+	bl	__get_datapage@local	/* get data page */
+	lwz	r5, CLOCK_HRTIMER_RES(r3)
+	mtlr	r12
 	li	r3,0
 	cmpli	cr0,r4,0
 	crclr	cr0*4+so
 	beqlr
-	lis	r5,CLOCK_REALTIME_RES@h
-	ori	r5,r5,CLOCK_REALTIME_RES@l
 	stw	r3,TSPC32_TV_SEC(r4)
 	stw	r5,TSPC32_TV_NSEC(r4)
 	blr
diff --git a/arch/powerpc/kernel/vdso64/gettimeofday.S b/arch/powerpc/kernel/vdso64/gettimeofday.S
index 1f24e411af80..1c9a04703250 100644
--- a/arch/powerpc/kernel/vdso64/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso64/gettimeofday.S
@@ -186,12 +186,15 @@ V_FUNCTION_BEGIN(__kernel_clock_getres)
 	cror	cr0*4+eq,cr0*4+eq,cr1*4+eq
 	bne	cr0,99f
 
+	mflr	r12
+  .cfi_register lr,r12
+	bl	V_LOCAL_FUNC(__get_datapage)
+	lwz	r5, CLOCK_HRTIMER_RES(r3)
+	mtlr	r12
 	li	r3,0
 	cmpldi	cr0,r4,0
 	crclr	cr0*4+so
 	beqlr
-	lis	r5,CLOCK_REALTIME_RES@h
-	ori	r5,r5,CLOCK_REALTIME_RES@l
 	std	r3,TSPC64_TV_SEC(r4)
 	std	r5,TSPC64_TV_NSEC(r4)
 	blr

