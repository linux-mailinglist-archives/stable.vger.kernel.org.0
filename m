Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBFB2A4FD9
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKCTSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:18:21 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:46255 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgKCTSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:18:20 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id CB8291942ACD;
        Tue,  3 Nov 2020 14:18:19 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 14:18:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NuUg/Q
        s1W1GLXoQL1BMGgpyjk+VaHGCXUUVLY4wJPM0=; b=SqkOw8hUinMUN1bR7DB1g9
        iNJIpM5+ZdZItTrZcnPt+di9DCoSZ14yvwA51K0SQkwapvmL/V/+k2umjtvk1Gsd
        bmUGwNUSKGjyrFpySP2Ge7Ww1iOjaCCekuGp2C6sSWyM5yNzd2usHgCJC0dmtIZP
        QN9gHlIJd7/KCES0PsvUUEz+8S04MlIQezf50ym1yRz4GikFtgd2yOSjs5l9x/0r
        XqLyfM8lpDlLY2nID259T5mW9XJGbwnIcWgR2DLapLIVyLEdU57O3Lp5oRTM3Aya
        OFTPRwmTVp5WybKtlgmgfjyAOKdOT1Q6i/VuQbGTniP/9nV+hHShqoyTeXSj/hHA
        ==
X-ME-Sender: <xms:-6yhX_bOP3ePsWguxU_9QgZ7L3r5cyixlhf7ValPhYEKu5CwdqYOgA>
    <xme:-6yhX-Y-2oBhkqYwstrsfB50ZhO_HwAMy_Gc0CaemoyQjeYz1H7lvCkLaREeSA4ST
    r2Lxk300KyA2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpefhteeihedtgfevvdefudevjefhuddvieetgeffje
    duieelfeelteejgffgjeetleenucffohhmrghinheplhhlvhhmrdhorhhgpdhkvghrnhgv
    lhdrohhrghdpmhgvmhgtphihrdhssgdpmhgvmhhmohhvvgdrshgspdhmvghmshgvthdrsh
    gsnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-6yhXx_E11h3I38rlCZMlV-BHSSsSDkt3xbVsNCBWsJGJ8wiFgXKxA>
    <xmx:-6yhX1rHiaFF_3xJmwcal6XphaDs3CofBPstrMq3PbX-GH1LDJqKlA>
    <xmx:-6yhX6qBAKAFLQPQcq-97ha6B5hZOLbzMo4Kftk-DvHMKocVCcl91Q>
    <xmx:-6yhXx1a9gB20orkge4hqQ6e0NAotqTdVDRdPV6pVu6cLC7x6KYKdQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 64D423280115;
        Tue,  3 Nov 2020 14:18:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for" failed to apply to 4.14-stable tree
To:     maskray@google.com, ndesaulniers@google.com,
        samitolvanen@google.com, stable@vger.kernel.org, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 20:18:16 +0100
Message-ID: <160443109676223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From ec9d78070de986ecf581ea204fd322af4d2477ec Mon Sep 17 00:00:00 2001
From: Fangrui Song <maskray@google.com>
Date: Thu, 29 Oct 2020 11:19:51 -0700
Subject: [PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for
 arch/arm64/lib/mem*.S

Commit 39d114ddc682 ("arm64: add KASAN support") added .weak directives to
arch/arm64/lib/mem*.S instead of changing the existing SYM_FUNC_START_PI
macros. This can lead to the assembly snippet `.weak memcpy ... .globl
memcpy` which will produce a STB_WEAK memcpy with GNU as but STB_GLOBAL
memcpy with LLVM's integrated assembler before LLVM 12. LLVM 12 (since
https://reviews.llvm.org/D90108) will error on such an overridden symbol
binding.

Use the appropriate SYM_FUNC_START_WEAK_PI instead.

Fixes: 39d114ddc682 ("arm64: add KASAN support")
Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Tested-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201029181951.1866093-1-maskray@google.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
index e0bf83d556f2..dc8d2a216a6e 100644
--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -56,9 +56,8 @@
 	stp \reg1, \reg2, [\ptr], \val
 	.endm
 
-	.weak memcpy
 SYM_FUNC_START_ALIAS(__memcpy)
-SYM_FUNC_START_PI(memcpy)
+SYM_FUNC_START_WEAK_PI(memcpy)
 #include "copy_template.S"
 	ret
 SYM_FUNC_END_PI(memcpy)
diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
index 02cda2e33bde..1035dce4bdaf 100644
--- a/arch/arm64/lib/memmove.S
+++ b/arch/arm64/lib/memmove.S
@@ -45,9 +45,8 @@ C_h	.req	x12
 D_l	.req	x13
 D_h	.req	x14
 
-	.weak memmove
 SYM_FUNC_START_ALIAS(__memmove)
-SYM_FUNC_START_PI(memmove)
+SYM_FUNC_START_WEAK_PI(memmove)
 	cmp	dstin, src
 	b.lo	__memcpy
 	add	tmp1, src, count
diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
index 77c3c7ba0084..a9c1c9a01ea9 100644
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -42,9 +42,8 @@ dst		.req	x8
 tmp3w		.req	w9
 tmp3		.req	x9
 
-	.weak memset
 SYM_FUNC_START_ALIAS(__memset)
-SYM_FUNC_START_PI(memset)
+SYM_FUNC_START_WEAK_PI(memset)
 	mov	dst, dstin	/* Preserve return value.  */
 	and	A_lw, val, #255
 	orr	A_lw, A_lw, A_lw, lsl #8

