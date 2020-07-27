Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D146422ED07
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 15:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbgG0NTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 09:19:13 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59161 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726222AbgG0NTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 09:19:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1F8F91942025;
        Mon, 27 Jul 2020 09:19:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Jul 2020 09:19:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7LztCJ
        5RufWBk32fxwDndispscBAJv01vzVyl5kHtmE=; b=CXVbZfkozu0xtv2gWUqaM5
        Vme694IG8KAZdh5udsosaNVTrF7Gh+sgnzT4YPWp4JcNUMD8/+M47+o94Url6itE
        gVhAp9bAxPfei22iqDoyofa9LH1ZWOw7fRfWzdOdhgSwTEH71UH0Ty7dfydyJxjJ
        FSkA0o08RCtP1vYGrAfqcwciizMMXMuYcxr33nrlUFhBrDYi+M14mYrdM4IGjkki
        2BfYoAIgnjJfZ1o+YdXGhLFs5J6dQTGI5JqPdFvQ5aPbcyHc5Oe6RYuhQX4MTyOr
        7wdUfO5UvWSbwPJbkQ9wTeXD1R7abj6JzQMYAOVKPTg5dsbJEO4+XoPE0clUag3g
        ==
X-ME-Sender: <xms:T9QeXzDnfbHdzQyvLm6eSyIFLWtK5TkJ9FpFpxOpAomewxuKYrz8Og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeejkedvgeffjeetffejuedtkeeutdelteffjeetieeitd
    dvfefhjeeufffgheevkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgpdhlughsrdhs
    sgenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UNQeX5irhrharrWw4Iqe5DQc8-iZhdpcEcJeLTWTOq1PzlNXhT5r-w>
    <xmx:UNQeX-n3AYfilahQ9WyzxyxONzY66KFrxZAGxZwx8dU1fAXyCpn65A>
    <xmx:UNQeX1xQQR4MnQp6WnTWG_13qh6-fj1NhtryafmUWCTa9mbbB6k3Mg>
    <xmx:UNQeXx7JNFSMsru_8aXfFCGnDnWBcGA5M3u-BXk7McUak6uADPCKAw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3B5830600A9;
        Mon, 27 Jul 2020 09:19:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86, vmlinux.lds: Page-align end of ..page_aligned sections" failed to apply to 4.4-stable tree
To:     jroedel@suse.de, keescook@chromium.org, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 15:19:03 +0200
Message-ID: <159585594315581@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From de2b41be8fcccb2f5b6c480d35df590476344201 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <jroedel@suse.de>
Date: Tue, 21 Jul 2020 11:34:48 +0200
Subject: [PATCH] x86, vmlinux.lds: Page-align end of ..page_aligned sections

On x86-32 the idt_table with 256 entries needs only 2048 bytes. It is
page-aligned, but the end of the .bss..page_aligned section is not
guaranteed to be page-aligned.

As a result, objects from other .bss sections may end up on the same 4k
page as the idt_table, and will accidentially get mapped read-only during
boot, causing unexpected page-faults when the kernel writes to them.

This could be worked around by making the objects in the page aligned
sections page sized, but that's wrong.

Explicit sections which store only page aligned objects have an implicit
guarantee that the object is alone in the page in which it is placed. That
works for all objects except the last one. That's inconsistent.

Enforcing page sized objects for these sections would wreckage memory
sanitizers, because the object becomes artificially larger than it should
be and out of bound access becomes legit.

Align the end of the .bss..page_aligned and .data..page_aligned section on
page-size so all objects places in these sections are guaranteed to have
their own page.

[ tglx: Amended changelog ]

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200721093448.10417-1-joro@8bytes.org

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 3bfc8dd8a43d..9a03e5b23135 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -358,6 +358,7 @@ SECTIONS
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		__bss_start = .;
 		*(.bss..page_aligned)
+		. = ALIGN(PAGE_SIZE);
 		*(BSS_MAIN)
 		BSS_DECRYPTED
 		. = ALIGN(PAGE_SIZE);
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index db600ef218d7..052e0f05a984 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -341,7 +341,8 @@
 
 #define PAGE_ALIGNED_DATA(page_align)					\
 	. = ALIGN(page_align);						\
-	*(.data..page_aligned)
+	*(.data..page_aligned)						\
+	. = ALIGN(page_align);
 
 #define READ_MOSTLY_DATA(align)						\
 	. = ALIGN(align);						\
@@ -737,7 +738,9 @@
 	. = ALIGN(bss_align);						\
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {				\
 		BSS_FIRST_SECTIONS					\
+		. = ALIGN(PAGE_SIZE);					\
 		*(.bss..page_aligned)					\
+		. = ALIGN(PAGE_SIZE);					\
 		*(.dynbss)						\
 		*(BSS_MAIN)						\
 		*(COMMON)						\

