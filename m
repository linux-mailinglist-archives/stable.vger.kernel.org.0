Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD9200AAF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732983AbgFSNub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:31 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:41013 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732029AbgFSNua (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:30 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BCB6519457B0;
        Fri, 19 Jun 2020 09:50:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O4gjXy
        DZRlpgmYIiI8RSiKoyLJnz20vErvcMOf5Fe1U=; b=Boe7s/Y7axVsoul87d71mi
        9hxkrfk6XZdOpTjpLPXoeUvaNPzAW9XQQHwyXPkFBkdsFeGNDv3MsoA/12ncbg2C
        hrCj5mwX3pDXW776tyhwd2niG5yWgXK74WkHO623qTKnU3GUzFu1IsbTtlNO9hSv
        BuTi1fKJQe+1K4O6Fxv10J9RUx7xekZSApGzgHgm5xdrVHpmHICswWK6PoLrEM2s
        Zvv7o0yh5L9NO04Z/NLz8OVlXZHjEalZ51h5f1zSlZiqE4nGrIzMepfnaYhs1JmI
        bBjUG49THcjEIouMQxJ0HeV4H7N+1i3hNcThZV8uwx4F9iuwsMVmsmBHV6SGCvNw
        ==
X-ME-Sender: <xms:pMLsXpTx304r1OjwHrNvOvXVw3qnkZl8mhl9g3zX9XsdXLhakkiI9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvddunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:pMLsXizwyhwCrXIjpLWrgSaig7p6EcUrXnLUc-PzWOrFEQIJ9riynw>
    <xmx:pMLsXu0iIB6e6GnPJcEJQXOKR9h3WUTHIawIYhKgN2_wQXZm1d_Nuw>
    <xmx:pMLsXhA5b7ARkE7E8oo_-aOgP37FX90GngPmGzX_18nujgKw6J4IXw>
    <xmx:pMLsXtt6naTFr_-XDor20zAMx0-zZvDovcN3ToNhyENAseBvcE6giA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43A9F3061856;
        Fri, 19 Jun 2020 09:50:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: socrates: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:19 +0200
Message-ID: <159257461961229@kroah.com>
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

From 9c6c2e5cc77119ce0dacb4f9feedb73ce0354421 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:23 +0200
Subject: [PATCH] mtd: rawnand: socrates: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-51-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/socrates_nand.c b/drivers/mtd/nand/raw/socrates_nand.c
index 20f40c0e812c..7c94fc51a611 100644
--- a/drivers/mtd/nand/raw/socrates_nand.c
+++ b/drivers/mtd/nand/raw/socrates_nand.c
@@ -169,7 +169,7 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 	if (!res)
 		return res;
 
-	nand_release(nand_chip);
+	nand_cleanup(nand_chip);
 
 out:
 	iounmap(host->io_base);

