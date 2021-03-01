Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A0F327E1D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhCAMRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:17:50 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:60617 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233721AbhCAMRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:17:38 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A6EE2194159D;
        Mon,  1 Mar 2021 07:16:32 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:16:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/2Ezqy
        MWRiK35NkzV7gHkVAhT6erdiETmcTZLNVVOtg=; b=s/c9REi2h0xK9DQiOe2i3v
        xO4yJPSuoTUfGJYkCPbVn5kCNHtdRFJrcADqZHyNBd2RxSjXdsJxBShJueO1WA1b
        2ge4l3KP2P9S4vL+RTXcgY15gyvnu/53zAM+sxprB8upTWoEVaUkkpXskfYhDhKf
        HFRgRy+t9phfhyVQWD7zydb3mrwyzGhJ0mow2ypIGGYcY5QY7kjDYm9VP7l5m0wY
        j6CfLyT+LaV2g8Cu2Hjobw8iqiwsQ/VWklb8WKdQO+nHCFd0SER+6icWkBu//boF
        kIsL5DEa/V2jSeYnA71ZnD/PQ8iFeVLPmY4eIF4WgfLR7Bh0pw9+6Po3G2nl9hng
        ==
X-ME-Sender: <xms:H9s8YDNGP09pE2eZU-Jswre6gEMUYrCAHopZcs5kEPE693f05NIfLw>
    <xme:H9s8YN_R_M9E4wbuenKxb2-M8cS69w6hErbbUAaMog36Kun5xRuK4YlcyCpMwgfhd
    SVzIRYm-xUwbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:H9s8YCQOKIbDwtDVnIt8JPx4eUB0vCJPdEmLMGwdY4XBjU2sQVoHqg>
    <xmx:H9s8YHvJ1aEnaEOIffRRiTp6KYGjmBb7h7X0srsNs-HEACgD9e3q-g>
    <xmx:H9s8YLcPs54UCRrpUynaeyPL6wF1owRDYU_JaQdG2o0B2KjzxNl0Rg>
    <xmx:INs8YDFp0EM-8sqU2EPL7BrC_-GsVWldxBHQ_VFBYkG-MIb3PesaYQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3789A1080063;
        Mon,  1 Mar 2021 07:16:31 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64 module: set plt* section addresses to 0x0" failed to apply to 4.9-stable tree
To:     shaoyi@amazon.com, fllinden@amazon.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:16:27 +0100
Message-ID: <161460098718371@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f5c6d0fcf90ce07ee0d686d465b19b247ebd5ed7 Mon Sep 17 00:00:00 2001
From: Shaoying Xu <shaoyi@amazon.com>
Date: Tue, 16 Feb 2021 18:32:34 +0000
Subject: [PATCH] arm64 module: set plt* section addresses to 0x0

These plt* and .text.ftrace_trampoline sections specified for arm64 have
non-zero addressses. Non-zero section addresses in a relocatable ELF would
confuse GDB when it tries to compute the section offsets and it ends up
printing wrong symbol addresses. Therefore, set them to zero, which mirrors
the change in commit 5d8591bc0fba ("module: set ksymtab/kcrctab* section
addresses to 0x0").

Reported-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210216183234.GA23876@amazon.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index 691f15af788e..810045628c66 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -1,7 +1,7 @@
 #ifdef CONFIG_ARM64_MODULE_PLTS
 SECTIONS {
-	.plt (NOLOAD) : { BYTE(0) }
-	.init.plt (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline (NOLOAD) : { BYTE(0) }
+	.plt 0 (NOLOAD) : { BYTE(0) }
+	.init.plt 0 (NOLOAD) : { BYTE(0) }
+	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
 }
 #endif

