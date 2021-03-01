Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30A7327E15
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhCAMRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:17:24 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:37311 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233755AbhCAMRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:17:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6DD8919415B0;
        Mon,  1 Mar 2021 07:16:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 07:16:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Gs719c
        BtSw5aX9zQgNkB5lG9lYED3Z5bnViiEXXpZ2E=; b=velNWaSa6LDCwRCzA0L0oP
        XLjN+2gi6vB1iqJZ/k0tkLRRsJRCldG++khRft+/5XoBRHEWNYFLMPH5YvkyCEEV
        6TuPNk7NzUpPy9d32yqglDAx9trptfNppRnxIXlaT/7sj1muSCZMj5pROIamUOuc
        tewqjo5kpOA30/OE45/41wO3nK1u/bC3oXF5niFqnBElI2YZToosOat52GeM29ve
        HVYLnR/GBfJb6fIRCjPn6Avm1jdpnnxTR2r8kEU0qD4rHkEwper8j2lzUzOAhcPh
        3rsMWj2lFIvtpPsWbxEv9sb41TKqzEt0XWnWNggZuJYgH4AM13xrKEHBW6C4P3BQ
        ==
X-ME-Sender: <xms:Ids8YBeSKyyTTDSvcJhM2tzHxV0x1RXpfUyl5VLyCC1z51s179o55A>
    <xme:Ids8YPP599pVF1YGuf1eY3oEWg81AZVVCMMmHPbjUb1ERwUcAihmESpkJ1wu8VDaR
    GQ7prn5ZurdYA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Ids8YKgWiiNBpDv2WDgrcwTVIoesHrJqekboiciA7nlrxv75gNoAUw>
    <xmx:Ids8YK8B6gm3Ni-mHXdH-_hoz36hL8u6gAS23QKI8XPzE7utVvGBPA>
    <xmx:Ids8YNu1vQGLGW57bG6OraGz7XQo1dJnjNsUGaVrsSzYIy-PxF1R4w>
    <xmx:Ids8YOXz16jhwjeEG2tvqzxg6ANJ12b-iBfesN3FK9-Gx2vWGX9mpg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0C6881080063;
        Mon,  1 Mar 2021 07:16:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64 module: set plt* section addresses to 0x0" failed to apply to 4.14-stable tree
To:     shaoyi@amazon.com, fllinden@amazon.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:16:28 +0100
Message-ID: <161460098816186@kroah.com>
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

