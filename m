Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49CA8FFAF
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 12:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHPKFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 06:05:03 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44469 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726989AbfHPKFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 06:05:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 339BE21ADD;
        Fri, 16 Aug 2019 06:05:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 16 Aug 2019 06:05:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O/SGUt
        4nbY/bOSXYNdFNyyRYDka6xKUr5NdtIz01YSA=; b=l+OC1n3yQbKAMiNyMPS54q
        tn/np5Wf1/cvT/XJ/lD4dwCF8UbmVITlllwPF5LgFvluftxbRjaWN/SEHhHzCgEf
        sTtihKMXZ88UBx9SvUwbkZazOlUBuEL2PIC9E+KiFDGBsO1XFpk39vBTUY4fNq1G
        8i6gRYap84gpl1qfnTPzy/NWdWOoXRVkSLzvdnaFZET7kRSh68JHUBxeS+wU770l
        JtYwlmf7n83hMocW6lLeatEmDDy/3ApN6hQ3KGzqoDQWXbSgUgwKlbeyglsrB769
        SNP7msk8tVzHS/5wFB7g4FCuJu+tpHxR235Ra582U5YWrnPojtlrPPvLP+h6pSrw
        ==
X-ME-Sender: <xms:zn9WXVNmxs-rpKyJpii8dhp7Vf0dGqDQZI8pyr6X1HuWKG-JlJydNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeffedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeei
X-ME-Proxy: <xmx:zn9WXW-EdYYjTgzw7qq3ACVGcRZiefaXozF6g2uTLpFG7L63GiiIeg>
    <xmx:zn9WXci0_1yEnhqSxqgULF8jnZ1Mkq4GLKf1Rq8TCqPIlpBO-z41NA>
    <xmx:zn9WXeG-HZPGFL1B0dd97EtvU1s_S6Z_hONpCzPZYmvniKQoHyR2oA>
    <xmx:zn9WXe9uE46UDn1DFP7ibdBwni3ECoRxpyfQpt6gqLY1zUmmDHsnTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E151380076;
        Fri, 16 Aug 2019 06:05:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/usercopy: use memory range to be accessed for wraparound" failed to apply to 4.9-stable tree
To:     isaacm@codeaurora.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, keescook@chromium.org,
        psodagud@codeaurora.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, tsoni@codeaurora.org,
        william.kucharski@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 16 Aug 2019 12:04:52 +0200
Message-ID: <156594989217393@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 951531691c4bcaa59f56a316e018bc2ff1ddf855 Mon Sep 17 00:00:00 2001
From: "Isaac J. Manjarres" <isaacm@codeaurora.org>
Date: Tue, 13 Aug 2019 15:37:37 -0700
Subject: [PATCH] mm/usercopy: use memory range to be accessed for wraparound
 check

Currently, when checking to see if accessing n bytes starting at address
"ptr" will cause a wraparound in the memory addresses, the check in
check_bogus_address() adds an extra byte, which is incorrect, as the
range of addresses that will be accessed is [ptr, ptr + (n - 1)].

This can lead to incorrectly detecting a wraparound in the memory
address, when trying to read 4 KB from memory that is mapped to the the
last possible page in the virtual address space, when in fact, accessing
that range of memory would not cause a wraparound to occur.

Use the memory range that will actually be accessed when considering if
accessing a certain amount of bytes will cause the memory address to
wrap around.

Link: http://lkml.kernel.org/r/1564509253-23287-1-git-send-email-isaacm@codeaurora.org
Fixes: f5509cc18daa ("mm: Hardened usercopy")
Signed-off-by: Prasad Sodagudi <psodagud@codeaurora.org>
Signed-off-by: Isaac J. Manjarres <isaacm@codeaurora.org>
Co-developed-by: Prasad Sodagudi <psodagud@codeaurora.org>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Trilok Soni <tsoni@codeaurora.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 2a09796edef8..98e924864554 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -147,7 +147,7 @@ static inline void check_bogus_address(const unsigned long ptr, unsigned long n,
 				       bool to_user)
 {
 	/* Reject if object wraps past end of memory. */
-	if (ptr + n < ptr)
+	if (ptr + (n - 1) < ptr)
 		usercopy_abort("wrapped address", NULL, to_user, 0, ptr + n);
 
 	/* Reject if NULL or ZERO-allocation. */

