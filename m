Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C072F9CD8
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 11:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbhARK0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 05:26:49 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:55631 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389614AbhARKHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 05:07:12 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 2265192E;
        Mon, 18 Jan 2021 04:58:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jan 2021 04:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ZIAmiz
        ibWgWRy8QKp4iGZnabxJ2OQeP3/I9LA3911Ow=; b=meZxqoPKpCXgeot2D5xTYr
        1yvT3+PgztbwjaRJ0cFpnnqg3ZwUK5fifqh5gCNwbf4KRjr57L3guKnoAdwswwM1
        WfYJBN9zHOBwOBRPCAc+jKjq77PycYt1GCO+EQbpolnLtsFbSd5i7Itt7r4r0lH8
        zYI/7cQglUfZ6N9Aa7GbD+60mrPe++VYk55QbdUBPkRMzwSb9U85WqItI+gyJejf
        sQqFFxRQsEt29vDCLhqGzBQcGjLNxXamJwa4bx6hDa+rgloyHIslIoitwFdcsqTi
        Rg55EPD5Ys3pjHEBfYHPvTMr1+mkDxCzlK109OzPOCP115FUYk1Obr5miZgjJ79g
        ==
X-ME-Sender: <xms:w1sFYHXDEXbe8DalEDAdnRuxXnROYTSU-MljKAKzalbr9NYroDU7Fw>
    <xme:w1sFYPly_ShHf9KWIAr-nG-QhU6aWr-jFJkMpaVH_gy0ubvMoUvtsvHeF0oMg1hmG
    _E3aA39mxSlFA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdekgddutdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeejkedvgeffjeetffejuedtkeeutdelteffjeetieeitd
    dvfefhjeeufffgheevkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhlughsrdhs
    sgenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpeefnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:w1sFYDYCIgwcsu7clnRV4G-OB4HpdhT-BgnQmYWhChVnkb8aq4q_gA>
    <xmx:w1sFYCXhItv8oeMau_N5S1uqbDETplfA25M3fQSH8fMPu5ZcVjPjyw>
    <xmx:w1sFYBnfgISI9RqkmwLxdLKKkARzRbq47ALJgZjslLTanupRiAt8Zg>
    <xmx:w1sFYGxWlaGgWhOvizIoPfVRkvJ8iwokPVUSeqIyXhJEoHTp9s65ikYPd_U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6C8D524005B;
        Mon, 18 Jan 2021 04:58:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] powerpc: Fix alignment bug within the init sections" failed to apply to 4.14-stable tree
To:     arielmarcovitch@gmail.com, ariel.marcovitch@gmail.com,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Jan 2021 10:58:20 +0100
Message-ID: <16109639007739@kroah.com>
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

From 2225a8dda263edc35a0e8b858fe2945cf6240fde Mon Sep 17 00:00:00 2001
From: Ariel Marcovitch <arielmarcovitch@gmail.com>
Date: Sat, 2 Jan 2021 22:11:56 +0200
Subject: [PATCH] powerpc: Fix alignment bug within the init sections

This is a bug that causes early crashes in builds with an .exit.text
section smaller than a page and an .init.text section that ends in the
beginning of a physical page (this is kinda random, which might
explain why this wasn't really encountered before).

The init sections are ordered like this:
  .init.text
  .exit.text
  .init.data

Currently, these sections aren't page aligned.

Because the init code might become read-only at runtime and because
the .init.text section can potentially reside on the same physical
page as .init.data, the beginning of .init.data might be mapped
read-only along with .init.text.

Then when the kernel tries to modify a variable in .init.data (like
kthreadd_done, used in kernel_init()) the kernel panics.

To avoid this, make _einittext page aligned and also align .exit.text
to make sure .init.data is always seperated from the text segments.

Fixes: 060ef9d89d18 ("powerpc32: PAGE_EXEC required for inittext")
Signed-off-by: Ariel Marcovitch <ariel.marcovitch@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210102201156.10805-1-ariel.marcovitch@gmail.com

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 8e0b1298bf19..4ab426b8b0e0 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -187,6 +187,12 @@ SECTIONS
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 		_sinittext = .;
 		INIT_TEXT
+
+		/*
+		 *.init.text might be RO so we must ensure this section ends on
+		 * a page boundary.
+		 */
+		. = ALIGN(PAGE_SIZE);
 		_einittext = .;
 #ifdef CONFIG_PPC64
 		*(.tramp.ftrace.init);
@@ -200,6 +206,8 @@ SECTIONS
 		EXIT_TEXT
 	}
 
+	. = ALIGN(PAGE_SIZE);
+
 	INIT_DATA_SECTION(16)
 
 	. = ALIGN(8);

