Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E0D327B6A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhCAKBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:01:39 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53737 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234234AbhCAJ7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:59:39 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4FEA61940BA1;
        Mon,  1 Mar 2021 04:58:50 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 01 Mar 2021 04:58:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=wy8QtG
        SnbddFQyz3srC8idpaL6SurHOo73z3YZqZ6Ts=; b=bfg6zSik5njEmxdE2LMrEz
        MiVMDy2z1YenCRW8RXwHEmqhTMJpordaPG2SFLXAwsTiyrppa8lhaDicZpSN6VWW
        AVZXYzzIBuQQwSlQF8TtjC2AYXIVxRkJifh9WaRTY35f74z9H1RN4qL5sSuc9otJ
        2TVRjV449lAacjIxHmCBysb0JTZ4itQYhpJ2RX09m9PX5bBEKxGErFb4imcCvLof
        Xi9HZzhJH39UKULlQc560k7HiaYDNlUOykpvcfJpHESJwpM0/MMiAONKmvTfxisa
        IsIojlJdqQogkWJw1bln5P/Wv16cPVw1QGPXMeLNpDVbyHHBzsM4urMZYQ3BZAPw
        ==
X-ME-Sender: <xms:2ro8YPZQ5no0lDA8sX7GysgNDoZI-pttzF6FZClsd1qxzTzDBpSaAQ>
    <xme:2ro8YCtoLdUTo3FNESWQwoST9I5fdVmA7RSWHIQbkSjbgMUJcfOkcXgojLkfVC1c4
    yuS_yHfYQPwng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:2ro8YBGvJL3AH9xvxkpHQz4qifq7IKWNMDD7Qi7YO9v737ZpAIBH0A>
    <xmx:2ro8YNzHZVEOgqRhcma_9zU9uKH3gOeRa4VPL0CbtWoOg5Vjv2yRLA>
    <xmx:2ro8YAjJM1UB-MUDg_NApmgDnFUn7aTbLDH2TKd2uiqh5p_wzE0lzQ>
    <xmx:2ro8YNN7_SIEHF57-UvEaaNviA5uKpdPG7KSYixIf61SX6jxyzbjkw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CC02D1080057;
        Mon,  1 Mar 2021 04:58:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: compressed: fix build with enabled UBSAN" failed to apply to 5.10-stable tree
To:     alobakin@pm.me, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 10:58:40 +0100
Message-ID: <161459272057180@kroah.com>
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

From fc4cac4cfc437659ce445c3c47b807e1cc625b66 Mon Sep 17 00:00:00 2001
From: Alexander Lobakin <alobakin@pm.me>
Date: Mon, 8 Feb 2021 12:37:42 +0000
Subject: [PATCH] MIPS: compressed: fix build with enabled UBSAN

Commit 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer
UBSAN") added a possibility to build the entire kernel with UBSAN
instrumentation for MIPS, with the exception for VDSO.
However, self-extracting head wasn't been added to exceptions, so
this occurs:

mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
in function `FSE_buildDTable_wksp':
decompress.c:(.text.FSE_buildDTable_wksp+0x278): undefined reference
to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2a8):
undefined reference to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: decompress.c:(.text.FSE_buildDTable_wksp+0x2c4):
undefined reference to `__ubsan_handle_shift_out_of_bounds'
mips-alpine-linux-musl-ld: arch/mips/boot/compressed/decompress.o:
decompress.c:(.text.FSE_buildDTable_raw+0x9c): more undefined references
to `__ubsan_handle_shift_out_of_bounds' follow

Add UBSAN_SANITIZE := n to mips/boot/compressed/Makefile to exclude
it from instrumentation scope and fix this issue.

Fixes: 1e35918ad9d1 ("MIPS: Enable Undefined Behavior Sanitizer UBSAN")
Cc: stable@vger.kernel.org # 5.0+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/boot/compressed/Makefile b/arch/mips/boot/compressed/Makefile
index 47cd9dc7454a..f93f72bcba97 100644
--- a/arch/mips/boot/compressed/Makefile
+++ b/arch/mips/boot/compressed/Makefile
@@ -37,6 +37,7 @@ KBUILD_AFLAGS := $(KBUILD_AFLAGS) -D__ASSEMBLY__ \
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT		:= n
 GCOV_PROFILE := n
+UBSAN_SANITIZE := n
 
 # decompressor objects (linked with vmlinuz)
 vmlinuzobjs-y := $(obj)/head.o $(obj)/decompress.o $(obj)/string.o

