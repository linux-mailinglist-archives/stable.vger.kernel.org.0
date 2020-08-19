Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC28E249BE5
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgHSLf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:35:28 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:48213 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgHSLfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:35:20 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id AFAD21941DD5;
        Wed, 19 Aug 2020 07:35:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ruZTaE
        LXhNiobp8VWmLJZY7hgS/aV6lGf87JdD0BHv8=; b=MoHzQXLTyauvQRczQ9oBOM
        584QlfJgkdQoItVUwac1MKl4FQTzCchVCCXBwLp8W5LwummSMvbDnSYb+C5oeDmL
        WDpjf+/AiMC5cmmFuhRiJ0oA4p6krqDnT7X0f2KSnDp+00YgPDbt42H5t4h3xvzT
        upbt+5IDjqSYkiwZm+12PE8Trz0+/teSUzejSTCv9x+jCDcCjY+v/uJgae1AMdpr
        jbEgfKIPWfgB0vZHzxbjz5KzUf+j9XR6uxFlkczUQJ5fQ7WQ9/LLK8rYGQZwURgn
        8p3IVHFWys/4USUPtYqb2zoIeBHIIhsoKFI17S38EO7JzBFIxxvOVAk2bwSyVHNw
        ==
X-ME-Sender: <xms:dg49X-xebOTjp-daMec6SO73ZoZdtq471b_HELMYxvTEh5KTcGX1Eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:dg49X6SO8hBqTdnMBRrTTxK6PR5YZ9wtmhoSV05w5aRV71eyzUJsfQ>
    <xmx:dg49XwVs_tHtfZueu_Fa7zI7mGS846MyL8G653aRsx-IWT_uGY8Ynw>
    <xmx:dg49X0jo3y0BAhfpSeMCUriWCxGh2Ho3uZCV76KnWKkW5_RQYPPGzw>
    <xmx:dg49X_9xVL9NfbnD8q_CHbKtOA08BbJYUqbdoVsRmq7JObr9CTZ4NA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4D84C3060067;
        Wed, 19 Aug 2020 07:35:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: Move free_pages_out label in inline extent handling" failed to apply to 4.14-stable tree
To:     nborisov@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:35:33 +0200
Message-ID: <159783693322742@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From cecc8d9038d164eda61fbcd72520975a554ea63e Mon Sep 17 00:00:00 2001
From: Nikolay Borisov <nborisov@suse.com>
Date: Wed, 17 Jul 2019 14:41:45 +0300
Subject: [PATCH] btrfs: Move free_pages_out label in inline extent handling
 branch in compress_file_range

This label is only executed if compress_file_range fails to create an
inline extent. So move its code in the semantically related inline
extent handling branch. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index db814f555b26..385127ab0841 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -622,7 +622,14 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 						     PAGE_SET_WRITEBACK |
 						     page_error_op |
 						     PAGE_END_WRITEBACK);
-			goto free_pages_out;
+
+			for (i = 0; i < nr_pages; i++) {
+				WARN_ON(pages[i]->mapping);
+				put_page(pages[i]);
+			}
+			kfree(pages);
+
+			return 0;
 		}
 	}
 
@@ -700,15 +707,6 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	compressed_extents++;
 
 	return compressed_extents;
-
-free_pages_out:
-	for (i = 0; i < nr_pages; i++) {
-		WARN_ON(pages[i]->mapping);
-		put_page(pages[i]);
-	}
-	kfree(pages);
-
-	return 0;
 }
 
 static void free_async_extent_pages(struct async_extent *async_extent)

