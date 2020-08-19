Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7E0249BE2
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 13:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgHSLfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 07:35:13 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:41643 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726820AbgHSLfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:35:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 942DC1941A80;
        Wed, 19 Aug 2020 07:35:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ApybsF
        TwqY8gcyE0bWOCbXl3vJfWJdX1XBGy05QcfRs=; b=PWJp5rm/OJPnG4+ciPaTZC
        2T6kIiPJkji/wk6ZeJunMb7vhqQdzPOfZLPCm5ruOa/7u9/+4La7Lk7YArEFdWCW
        9Y81JRdtn5QIEoLIda5aSOa+jv1YceN7zv9/rwLXBKgfW4DfilaOS6lITzFBjfZO
        F8VoJAg22X0+fJSXJnr3tJ9TJuhL4UE4SXrrBPm4QSkC7knxVuIk575A21oDrecW
        rGOwEy1TVpJiE9FOiZKZUyg3gZU+FIOiehDYp+7ZYI2i7GAdDyt2C8lv6jJ1Plnp
        SlAsbRVjN/S8aZn/iHpmwfzBtnGK4RtNMtkQTWNOx0sb9e0yEzwLE9IYO5VZFdqw
        ==
X-ME-Sender: <xms:bw49Xyyv3-_k14mDyLnWCmmuOrRQESCz-lCTnc8MOmchvPtqvQx5Xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:bw49X-Q5JQaI4Vl9sJsqWSMK7wCA8-AvEbaF91qaF6elaelfrgD9TA>
    <xmx:bw49X0XWbB1ZISfSh-sg5-tL7Dk1cykLo0ivgURrNhaUnleaUzjo1Q>
    <xmx:bw49X4ilWPKTHQdgzFhwwfm4GWu4yOg6u6PCMMUhxtEeiTDnTNSFJA>
    <xmx:bw49Xz9FeVOLtw3zkYSpDgDNbgMy91TlZ1fKK1hzpkDOLNdLWsmTeg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 271603060067;
        Wed, 19 Aug 2020 07:35:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] btrfs: Move free_pages_out label in inline extent handling" failed to apply to 4.19-stable tree
To:     nborisov@suse.com, dsterba@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:35:33 +0200
Message-ID: <159783693341103@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

