Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3084D2F1A8E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 17:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729483AbhAKQKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 11:10:07 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41071 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728173AbhAKQKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 11:10:07 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 04F2419C3A53;
        Mon, 11 Jan 2021 11:09:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 11 Jan 2021 11:09:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=WfVNCv
        ZVDhNkOsVDJ4I2hi/nDhOq49jm8nWInMUCbQ8=; b=Yu1VGAEc+2I7sZbUAW+P00
        WqPM6gN4daBQy/A8cINynXpzW6aVJEHxZmTtIgix57FWnzQcFlq5BaU84z6vXNPJ
        uyYxXkEkYtuUdMTE0m+GmkOnyliYmbtCuV2uqWBn94G8NLBBs9mx/2OM01g8aZCK
        nMiartiP5yPqHu0t0YBxXZIGQQnut273mO4ywJx1HLlI4pWb4X5rs6JDzyQDtqag
        x1xTXzpUyTQODuq4IDMhr1I2b8EYsxzSCgtlv6XrinC+DPuc0gjCKyS1k8OYBRUR
        dfjLdfEUKbdsp3+LVi9vQu6xijYOqazD5D+PYary4HIc30Q63/II42Fy5L77CR3Q
        ==
X-ME-Sender: <xms:Lnj8X_-xHzAF1WiFVJwdqJuz6Pjyn_7E191L4HfeXcJrc6-L0dbOjA>
    <xme:Lnj8X7pk85hd2EDz7KM-dhZPoO0u18ZWaHi_q8agAuYYu4UpDsj84Xo6pspgqORpm
    PPLEI3Zo5k8KQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehuddgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleevlefhtdeuvdetvdehhfdtkefhleevieeuiefftd
    ehtdetveevteffuedvffegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpfedvrdhs
    sgenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Lnj8X570vZTwfgQ0psF1YFIysft6UiZfcAsQpjqQNCfD9A6yYLHEJw>
    <xmx:Lnj8XzMI-kWVssyem4aRyCBllsJgk9F4mnsCd01XVkbwNidsDZpoMg>
    <xmx:Lnj8XzNZ1kZbEW90aP1-QSrAfUPJKcLljIRcgk5Q-ls0v4en0ik4yA>
    <xmx:MHj8XwvrpB1K4gzMz-QXcL5ErxPPR3tRO0oHLGko9W8i_0iXh5bAxw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74ABD108005B;
        Mon, 11 Jan 2021 11:09:18 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc/32s: Fix RTAS machine check with VMAP stack" failed to apply to 5.10-stable tree
To:     christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 17:10:29 +0100
Message-ID: <1610381429231172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 98bf2d3f4970179c702ef64db658e0553bc6ef3a Mon Sep 17 00:00:00 2001
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Date: Tue, 22 Dec 2020 07:11:18 +0000
Subject: [PATCH] powerpc/32s: Fix RTAS machine check with VMAP stack

When we have VMAP stack, exception prolog 1 sets r1, not r11.

When it is not an RTAS machine check, don't trash r1 because it is
needed by prolog 1.

Fixes: da7bb43ab9da ("powerpc/32: Fix vmap stack - Properly set r1 before activating MMU")
Fixes: d2e006036082 ("powerpc/32: Use SPRN_SPRG_SCRATCH2 in exception prologs")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
[mpe: Squash in fixup for RTAS machine check from Christophe]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/bc77d61d1c18940e456a2dee464f1e2eda65a3f0.1608621048.git.christophe.leroy@csgroup.eu

diff --git a/arch/powerpc/kernel/head_book3s_32.S b/arch/powerpc/kernel/head_book3s_32.S
index 349bf3f0c3af..858fbc8b19f3 100644
--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -260,10 +260,19 @@ __secondary_hold_acknowledge:
 MachineCheck:
 	EXCEPTION_PROLOG_0
 #ifdef CONFIG_PPC_CHRP
+#ifdef CONFIG_VMAP_STACK
+	mtspr	SPRN_SPRG_SCRATCH2,r1
+	mfspr	r1, SPRN_SPRG_THREAD
+	lwz	r1, RTAS_SP(r1)
+	cmpwi	cr1, r1, 0
+	bne	cr1, 7f
+	mfspr	r1, SPRN_SPRG_SCRATCH2
+#else
 	mfspr	r11, SPRN_SPRG_THREAD
 	lwz	r11, RTAS_SP(r11)
 	cmpwi	cr1, r11, 0
 	bne	cr1, 7f
+#endif
 #endif /* CONFIG_PPC_CHRP */
 	EXCEPTION_PROLOG_1 for_rtas=1
 7:	EXCEPTION_PROLOG_2

