Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7596327B6E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbhCAKBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:01:55 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53853 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234417AbhCAJ7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:59:49 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7FA2F1940B76;
        Mon,  1 Mar 2021 04:58:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 04:58:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=111nJV
        Rp0JS/AjMp6pNk/b18hlbyP9+PZd48Yi9T1Bs=; b=n7jGfcJisGHcGsKzsGi4bt
        5WD3CCUn/58LC9PrhOCPqsDHFYESXYJ1HY1d1wVVcoJauxp5cXRbQ5ikzLb7/uvX
        1FvaThpNTDzDy1VwKqLr6zggd1t/4UG+ym99bZfg/N0DY3vJoZCp4n+tFEGIm676
        vnqfWFA1+2KRS+1CnZlHx9ncfG7GDMcQ5X9CArE2JRZjS7ah8g2WUjdqbeuz3pU7
        AQZ3BVdOODdvg0lKITSvVqtv7rbohmt8r81c+PYk9GgopkocavQsnrXxpCbLuRXi
        /jEoqSFh3ax9Twm5YOhkeZKKNAKKXhi813oZ3M3B6C1XdsZojaELivwZLSMIVPqA
        ==
X-ME-Sender: <xms:0bo8YFuva4uKw1uqtClYeaPoO_jM0R6Zp9i0FjWLgRvHi7pNapn1sA>
    <xme:0bo8YOeHP_aH7dRlY5LBokEKRYWrT0FJQiOZimodMxr0SL2_kUFc7ONiv2OCt38B1
    213JISMPTGeCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:0bo8YIy_en94Ny1DZAENPLEWM9DmKa38D3vqEWgz9VXIP23qHYh0TQ>
    <xmx:0bo8YMPCTtGkwfiIA1e6qCVfdFNUjebK45TOKNrzs62AKPLY-geFjA>
    <xmx:0bo8YF_ji8OXfD-K4mdB1cJYi-ZQBt0CYGC_JLRqQL4hVNp25NIvGw>
    <xmx:0bo8YCHCU3fXavCXfbnDm7_1oBRTodNbOGYc8cP0GTRrIajgUnct_A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id F3B1A24005C;
        Mon,  1 Mar 2021 04:58:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: compressed: fix build with enabled UBSAN" failed to apply to 5.4-stable tree
To:     alobakin@pm.me, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 10:58:39 +0100
Message-ID: <161459271913072@kroah.com>
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

