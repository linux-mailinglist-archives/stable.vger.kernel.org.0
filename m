Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6462327E1B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhCAMRs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:17:48 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40547 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233871AbhCAMRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 07:17:44 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7E61A19415C5;
        Mon,  1 Mar 2021 07:16:35 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 01 Mar 2021 07:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PsdgHp
        ZlbzMmDo/pXII3l443hs4duy7uH+gkkDEVmHU=; b=V1zyZb3+pJhtE3Fwc6fsnH
        Fc9lTzi6Eh1yZcs5lYV/VQo7u2YSyUKFzjKtfkmvcJL6KtQxEr0qwdp6lTsz62Ya
        6O6ooGTzusuP6moT+V1Iub3r8iec3A6jhETSOkv8EzLwqLrs4/3EIrZTD5G3yBBY
        HHnsHlzMRJqOC7y5OM/b6ryFCHQcCPD4UP3KNxegGQbXSD6/fQDZY/YLL/q9djUt
        NwmGK6QYL/SRi9MAiQq5YXm0gjRjJN6f06K17qKERr6AjhEt7lVE5cxeqCR1sSGE
        wg1cmkhC1HSYDSIaDUsP3RrHewQj4hMxSr1dFuzhtKap1DXrAT7byiHNzYFmlzkg
        ==
X-ME-Sender: <xms:I9s8YMsYJaBqTXqBO5AEI1E8ERr68fDBPHrYM_8RCYFQpwACi89XeA>
    <xme:I9s8YA7oBxuJoT0IxwYtrVPmh8TyzgK7cYAz8KzpalIaqGPwSa1tqjhgRt6doN0Mn
    wk-krKvysmxvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:I9s8YFJqQOKFfdspTi6FC7dRYJkuP_knCM6JMal5inUZG2-OFlByCw>
    <xmx:I9s8YI50VT3VmaJPIsvjaFrxd2a2HsrSjS9RwL3LzJW5qRrk6_TtTg>
    <xmx:I9s8YAywY-XzQCEBM_P-Z47kxu1Vrq9kYd37170S8lOUbGmhOoUTkw>
    <xmx:I9s8YDDLJt4HaWwijJPFKYNDnKHI0K8-SDZDGoTyCXvn_WQXqRia6Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17A611080064;
        Mon,  1 Mar 2021 07:16:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64 module: set plt* section addresses to 0x0" failed to apply to 5.4-stable tree
To:     shaoyi@amazon.com, fllinden@amazon.com, stable@vger.kernel.org,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 13:16:29 +0100
Message-ID: <1614600989107131@kroah.com>
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

