Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A09309D2E
	for <lists+stable@lfdr.de>; Sun, 31 Jan 2021 15:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhAaOuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Jan 2021 09:50:09 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:40697 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232122AbhAaOnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 Jan 2021 09:43:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 48A95FB1;
        Sun, 31 Jan 2021 09:42:17 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 31 Jan 2021 09:42:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=UaqJNc
        vQUI0Dkwfy2hQqaeR89AB8qFQcy1n9b0LBpjw=; b=kgdHjwGzMU03mdDleqJPE1
        NOTq3UToqoqRrEZcqOGK4q6f364PTz6SbUg3nEMj0wi54GCcogWvz/VoRTUBmLGZ
        vliTbHZReM5hrItEyKH/cS5iRHKKt9JiwBWLLBSePV0cUqiaLOfqkapiC4iOnZZR
        NPRBTNVhxR3fEVhK4qKrug/lkiMGU35iyYkawWMSEpuWSxqifO/5p2B2fZu375pO
        tMeF9sLpqRmCyrQ3/PPcqC9HjpHiwW2yuGwQt3uwRW20oVEHZRD87WkI47MJXgcs
        60NyoxryGXs0LuWs6foHNQPRQ9a3tw/CkQknHJEX6njWi92NIPYbQL2EQWVyn9Ng
        ==
X-ME-Sender: <xms:yMEWYA6yhvbUc7V1hV3KFgqSN0t5pBpB_VXmcX3Tyd8_JfcEY1KKPQ>
    <xme:yMEWYB6AMIyPhjd9fuRwzBEe4w_5X544AJZ1eosY5jZR0yIsOf2bsNyRXvg5tdmjS
    yLEt25GUcZfTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeigdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:yMEWYPfYyVphY5gZ6jMkrjyXo4EWUQu-IoeR2x_Wpp_IzW_ru-RC_w>
    <xmx:yMEWYFK3dnur9JQPzuDMvR1iufJ3xq8xU0HbzhOyFKf8wG_Jsc_LLw>
    <xmx:yMEWYEJ-G5J0xDFuuc10mGadHK3y0Ktpyx3q7vJAQvtlMAc9lr3Alw>
    <xmx:yMEWYOx9xv5llChcSnVbhfhaF0W-o0c1pUhMkEw6WmLVPlfVsNDGk7DH5-s>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F5E4108005B;
        Sun, 31 Jan 2021 09:42:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] riscv: Fixup pfn_valid error with wrong max_mapnr" failed to apply to 5.4-stable tree
To:     guoren@linux.alibaba.com, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Jan 2021 15:42:14 +0100
Message-ID: <1612104134186139@kroah.com>
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

From 336e8eb2a3cfe2285c314cd85630076da365f6c6 Mon Sep 17 00:00:00 2001
From: Guo Ren <guoren@linux.alibaba.com>
Date: Thu, 21 Jan 2021 14:31:17 +0800
Subject: [PATCH] riscv: Fixup pfn_valid error with wrong max_mapnr

The max_mapnr is the number of PFNs, not absolute PFN offset.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Fixes: d0d8aae64566 ("RISC-V: Set maximum number of mapped pages correctly")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 7cd4993f4ff2..f9f9568d689e 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -196,7 +196,7 @@ void __init setup_bootmem(void)
 	max_pfn = PFN_DOWN(dram_end);
 	max_low_pfn = max_pfn;
 	dma32_phys_limit = min(4UL * SZ_1G, (unsigned long)PFN_PHYS(max_low_pfn));
-	set_max_mapnr(max_low_pfn);
+	set_max_mapnr(max_low_pfn - ARCH_PFN_OFFSET);
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	setup_initrd();

