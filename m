Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F641BAB7F
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 19:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgD0Rli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 13:41:38 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:37579 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgD0Rli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 13:41:38 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 13DC91940E18;
        Mon, 27 Apr 2020 13:41:37 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 13:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EK4cQd
        RiKXX1A0dvHkLitiqetDiVQIf9ysGZEKqehbk=; b=dyhM69RyweX3orJSikwB8R
        Xx7NQPu0YyIvntcwQCLbDl+2tQHyjThglhRWA2aYsMCvRMbyXvcU/dHVU4nJGDrk
        NomcfY7YOHwj6zQHMIxlF1kiDENVVKIIqP8jE7Zx9GPQ9urdMWM5GrUtTV05Wwr0
        MBKwcWAXFSWgNOb5xwucapF8MiA9g+6TjiU9H2prFJNz+ZekVybhEz+4jo485q3n
        DrieuESJItXM4jZNk2RfUr+qUn1BFEhsjA1A8tvCte845zfTxM2aSSi2GDQNJ+in
        uQW2V9INwRmuICY3xdIpIgfiVrdTdDV9NH97uOEDrZhnouSn+n58XyuHuMRO4jUA
        ==
X-ME-Sender: <xms:UBmnXm900-e7wWbQJqNyg1_8MZGy1RAsjwgzaQ2zMBXWrg_7I9RdYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpfedvrdhssgenucfkphepkeefrd
    ekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UBmnXm8CmhKxZBr5_roaK1sdEH2eD9y6NNdVuxvPN0uRPh1Ueea0lA>
    <xmx:UBmnXk52RUT4K_2ZPRUl91U1MZtxgvgbEbjFqazpenx9sEcHNmEw2g>
    <xmx:UBmnXiVYM2AEbUu5jjvYJ7-oXJzldJ0_K2OXP0ookwQB0Nol76AUeg>
    <xmx:URmnXvF6YaNFomGiat5dNzGAizIZakJwQMHF0G3GP-PdnYKbmYW3lA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8CF23065E7A;
        Mon, 27 Apr 2020 13:41:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on PPC32" failed to apply to 5.4-stable tree
To:     christophe.leroy@c-s.fr, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 19:41:27 +0200
Message-ID: <158800928730126@kroah.com>
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

From feb8e960d780e170e992a70491eec9dd68f4dbf2 Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@c-s.fr>
Date: Fri, 17 Apr 2020 11:58:36 +0000
Subject: [PATCH] powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on PPC32

CONFIG_PPC_KUAP_DEBUG is not selectable because it depends on PPC_32
which doesn't exists.

Fixing it leads to a deadlock due to a vital register getting
clobbered in _switch().

Change dependency to PPC32 and use r0 instead of r4 in _switch()

Fixes: e2fb9f544431 ("powerpc/32: Prepare for Kernel Userspace Access Protection")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/540242f7d4573f7cdf1b3bf46bb35f743b2cd68f.1587124651.git.christophe.leroy@c-s.fr

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index a6371fb8f761..8420abd4ea1c 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -732,7 +732,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_SPE)
 	stw	r10,_CCR(r1)
 	stw	r1,KSP(r3)	/* Set old stack pointer */
 
-	kuap_check r2, r4
+	kuap_check r2, r0
 #ifdef CONFIG_SMP
 	/* We need a sync somewhere here to make sure that if the
 	 * previous task gets rescheduled on another CPU, it sees all
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 0c3c1902135c..27a81c291be8 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -397,7 +397,7 @@ config PPC_KUAP
 
 config PPC_KUAP_DEBUG
 	bool "Extra debugging for Kernel Userspace Access Protection"
-	depends on PPC_KUAP && (PPC_RADIX_MMU || PPC_32)
+	depends on PPC_KUAP && (PPC_RADIX_MMU || PPC32)
 	help
 	  Add extra debugging for Kernel Userspace Access Protection (KUAP)
 	  If you're unsure, say N.

