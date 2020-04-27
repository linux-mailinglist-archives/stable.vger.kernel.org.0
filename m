Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E19031BAB7E
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 19:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgD0Rle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 13:41:34 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:44703 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgD0Rle (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 13:41:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 32B6C1940E7D;
        Mon, 27 Apr 2020 13:41:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 13:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=d8q9jk
        bCrl1YS+6Y3ffvRLkXFPRr3MO5ppgU51ceFjE=; b=BEYll3Ok/aqSo9/Mzq8oY5
        VeuzwMbZnQiZSV20F0hBKJGc/BFUmieIqyIMRpqYwksnT4L0B6cdbTzFljB4km9b
        Me0gdlG334tbOvSJLy5E7hGYVRUpF3sxXvXGmuLZ91kpgJ3NenZAJ59rcapTk4GX
        iMi+3jriTcsbSL5aZWDCLz8AvdaWOdB6qYD6oeuv2r+Aa3+iRp+CRM1WswYD6dP+
        3eXos0cOBDUFGpnjfCnh4ALdujKLwuMK3vPGt6OxLaEuqtKS0yTyct3Y5B/IL3FB
        Lo4wNnqLQlgvG/pIMfK+Rmsdyt/fjnv3+om7vaQxTAaeFBtcFR10NqQfpD1sb60A
        ==
X-ME-Sender: <xms:TBmnXv_-AfbPx1-J4Z0v7HUi2B6fVgOs-_myBwBa3U0cbo0NY8vK0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpfedvrdhssgenucfkphepkeefrd
    ekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghi
    lhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TBmnXgK74xJ5IoIug-Ju9RXJu6AUUFm88icDWYLZsI6d3pP7911MPA>
    <xmx:TBmnXoWAC6OHl9BE1ZFS7BGgjAIaP05fNmlxvhDoL8STP-7sbJAYcg>
    <xmx:TBmnXozinXQav3gcajuXX00K71NqOxEO2HsQ63R00UWIlkOOow65rw>
    <xmx:TRmnXp4rY1tnzO3kR4zsAT74RB8vlIRzl4fRFxHubJHFzA11ZEfp9Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCADB3280064;
        Mon, 27 Apr 2020 13:41:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc/mm: Fix CONFIG_PPC_KUAP_DEBUG on PPC32" failed to apply to 5.6-stable tree
To:     christophe.leroy@c-s.fr, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 19:41:27 +0200
Message-ID: <158800928720169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.6-stable tree.
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

