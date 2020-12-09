Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69A52D45F7
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731322AbgLIPya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:30 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:60059 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731257AbgLIPy3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8951019439A8;
        Wed,  9 Dec 2020 03:39:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 03:39:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=CuB4jX
        grLiAZS8ot4SU/bNhycs8t6jxcRNss8ZhDEbc=; b=TGtkN/2xty5TX59AQKyMmF
        ESCCEBETuE3YRsRYILGjuo8xJPYWQ7AzHtzPF2GFYRrINwLs3V5q+Y2v2Po293Mt
        vWV4hcrH2okk+Oo6ky+Yae1nXmXEcLnsMvOyBDQCqn3DrljkrHJVsFJZlKaSN/nU
        pcM8J/0X3GK0BluZMSVxp11Ng2KE8dWMFYYuD6D3D2ShH3ryBItay8SyPFCwp9f0
        ZMmY3IFJH+E6ngda2/bGSS4GZn/MM3Kg7/5gjgU0TFqZ33fogNeanr1Pi5Q+iAld
        wOmZN9VRAPPQFXLbCIqJ1wfPQCAID4g8vJppRJl+B4p98bCb19VtQtsLfCowzhMw
        ==
X-ME-Sender: <xms:RY3QXw0gIuV3FIYEnhoR1VzxwkKpgCqQZxt80LSQamaMivgshrcYyw>
    <xme:RY3QX7FvRVKreCXmWQBlGjApl3sL0WrNRUQvmIRD6XYas5hMEM8GC6x2BYC2LtTIS
    LFvPegcqukNmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejjedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehje
    duteevueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:RY3QX47sddZWuIzxAQMtwOJhM0LXyGAxSOQ2dHdTUCrqUAHLSn1Rgg>
    <xmx:RY3QX524iL6tvI1O1HeUp-gF7zylKxiUYcJjlvKrhr2wWYmL9DGLAQ>
    <xmx:RY3QXzFtE4lVm0TXKm765BTOUp-7A31pQILlVmhNOu_vsmsCvVuRhg>
    <xmx:RY3QX2PN8m2DzIZJk4_uuwCXevFI2OrpQ45m97idChAaLV5upjMkMQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F51B24005A;
        Wed,  9 Dec 2020 03:39:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] block: fix incorrect branching in blk_max_size_offset()" failed to apply to 5.9-stable tree
To:     snitzer@redhat.com, jdorminy@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:40:51 +0100
Message-ID: <160750325122656@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 65f33b35722952fa076811d5686bfd8a611a80fa Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 4 Dec 2020 17:21:03 -0500
Subject: [PATCH] block: fix incorrect branching in blk_max_size_offset()

If non-zero 'chunk_sectors' is passed in to blk_max_size_offset() that
override will be incorrectly ignored.

Old blk_max_size_offset() branching, prior to commit 3ee16db390b4,
must be used only if passed 'chunk_sectors' override is zero.

Fixes: 3ee16db390b4 ("dm: fix IO splitting")
Cc: stable@vger.kernel.org # 5.9
Reported-by: John Dorminy <jdorminy@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 24ae504cf77d..033eb5f73b65 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1076,10 +1076,12 @@ static inline unsigned int blk_max_size_offset(struct request_queue *q,
 					       sector_t offset,
 					       unsigned int chunk_sectors)
 {
-	if (!chunk_sectors && q->limits.chunk_sectors)
-		chunk_sectors = q->limits.chunk_sectors;
-	else
-		return q->limits.max_sectors;
+	if (!chunk_sectors) {
+		if (q->limits.chunk_sectors)
+			chunk_sectors = q->limits.chunk_sectors;
+		else
+			return q->limits.max_sectors;
+	}
 
 	if (likely(is_power_of_2(chunk_sectors)))
 		chunk_sectors -= offset & (chunk_sectors - 1);

