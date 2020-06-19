Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8C200A3B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgFSNdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:33:45 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:34565 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732786AbgFSNdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:33:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 421D31945588;
        Fri, 19 Jun 2020 09:33:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:33:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WFIDQo
        /gENAXuMeJ5KJT6S7GWe5RQRp2RcL4g0yGyKY=; b=JPf3V/n1dfxCcK3sF8D9+f
        Cjez+JcOj03g6nC+E79wn9OBoqHcnk8ejPWkftGMkFzzljNGDDz2VlncdJmX07Co
        uBbsZHWUEt1Vj5GCu5XQSThDqijGukB2nK0QI0yGEuyzhWX4LGdN/9LpGmLX5n9S
        QjhrC3z5y9vRd0lbwRzALmz9sTx/D4jXW5Rk9/ggvDR+Zid//tcW0SVWQHVD87ZR
        +R7riSvlczJz/mh1C45Ha2cHNXiuFlVUp1Bzr1n2zUfsvTkCqlkp25uUwGjwZWhP
        4yLfJj5j7FzOjkRSVaIOs8Xg5CxG/eTKkM2tibDJOfgYfltqlSwkuMb9TzzGidLw
        ==
X-ME-Sender: <xms:t77sXljQ6ZJH1G6HkpDhyGr0-uAqGAxLx7Y30DNKEdz2-gL43oivtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:t77sXqDh0kcAodJoQjv8p63r1FU5xa93w1a8t5fRVblTSaoYPmABcA>
    <xmx:t77sXlEpYMJy2nzjkMuZw2UYLIANKyxHT4RjZ-a6NqQTI5N1AfoyuQ>
    <xmx:t77sXqTJn8HokKGWGsKErY8OtbePwV5N8TEfBFdyGZsmzEMzaCC3dA>
    <xmx:t77sXoa_EDgkd8kxXiYPLaZRyJGDSdUG7M35ENYTW5XwOWcnuB_V9g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5CFB3280069;
        Fri, 19 Jun 2020 09:33:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] dm crypt: avoid truncating the logical block size" failed to apply to 4.9-stable tree
To:     ebiggers@google.com, mpatocka@redhat.com, snitzer@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:33:32 +0200
Message-ID: <1592573612126194@kroah.com>
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

From 64611a15ca9da91ff532982429c44686f4593b5f Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Thu, 4 Jun 2020 12:01:26 -0700
Subject: [PATCH] dm crypt: avoid truncating the logical block size

queue_limits::logical_block_size got changed from unsigned short to
unsigned int, but it was forgotten to update crypt_io_hints() to use the
new type.  Fix it.

Fixes: ad6bf88a6c19 ("block: fix an integer overflow in logical block size")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 71c651465bdd..000ddfab5ba0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3312,7 +3312,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->max_segment_size = PAGE_SIZE;
 
 	limits->logical_block_size =
-		max_t(unsigned short, limits->logical_block_size, cc->sector_size);
+		max_t(unsigned, limits->logical_block_size, cc->sector_size);
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);

