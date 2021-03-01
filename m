Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E07327E1E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233003AbhCAMRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:17:54 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:34727 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233880AbhCAMRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:17:46 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 488CF19415DA;
        Mon,  1 Mar 2021 07:16:37 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:16:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bMVpe8
        5K+vsNYSr1nqIdIyr7bkRiW2QknZkyNhvAp9E=; b=kzP7WuQ4fYD218rDDkb4hU
        rGz7b5ihXbt17JDSn6Qnfi4UoZLVEe91Wowh3uuLQOPpCmjAs5oZmukI37IliZPF
        DMm6mFxzGMWEd+vcfZDlC0P9SD0IGRQkCcM6/sfFXtpgHyZ2lR8M/Krra3PRVzaZ
        krLZ3ZH7UOxAMBQiVMTC7I82xIrOQi+/1MFwU7o3MxMPy27OzbDeQzMPxUOve28H
        vPFd6xPuzJYrFREji/1xMe8F9uBBdUR1OaCYc6l7oYFzRiI8F14gQ7PNteJ+O+PX
        2uxHWx09lxRqISvmsLNiCENMZX7lPimBGqKwYYvuA05CqtXMBEk0u76LINRHydlg
        ==
X-ME-Sender: <xms:Jds8YJ3LJ3VbMR25isKQV4WFlVOUjZCdCejD-4qwN3oF7YABwKPJcA>
    <xme:Jds8YAHcksVwfae0CLIooBmv23ZdmCDra7QqrfCNAIXCYHrIOt7D9RFezgDpCej2F
    __iUDDyRaUeJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Jds8YJ7qfLcjIwfD2m_lRx5bVyJjvm0NBeMnXYEKpkdBmiCqOTZD3A>
    <xmx:Jds8YG1Fhe3MC_7fJkUarKAqCQWqJ-wLVa8eI0t8OtRfG3Q8xsb6jg>
    <xmx:Jds8YMFB3qCl3URWmiZQf3gLuRJ0cTI1z7TxqP-d52uoIQE6DmpZzw>
    <xmx:Jds8YGOxZDuL_BwcFMh2S70F-70XtNyTWCYmhiJUlNMluuYBNdIouA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DFD4F24005A;
        Mon,  1 Mar 2021 07:16:36 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64 module: set plt* section addresses to 0x0" failed to apply to 4.19-stable tree
To:     shaoyi@amazon.com, fllinden@amazon.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:16:29 +0100
Message-ID: <16146009894631@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

