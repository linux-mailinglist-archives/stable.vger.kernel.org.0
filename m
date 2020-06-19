Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5BD200A96
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731756AbgFSNrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:47:52 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:46169 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbgFSNrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:47:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A17BE1945774;
        Fri, 19 Jun 2020 09:47:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:47:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=oyeZdh
        jVTs1HnyeTdGWLdGpT+1zfXynMngZF8FhFl/E=; b=PBdL8tce/lkBldUA4is5KD
        EhM/Vp4YFCV5iX8Ce2a/W5hM5thvofr6cUOIkScH/UEU6SeTA/+uSzy0qFl+//of
        ehC5I5gfrqWvne9r/zHekM2sEfuaLUEHcNWPw+eq4GTrrNiG9McuG1BXvVt4Qjml
        dlSdMwQIjkzTvCHsTYCVPNIBiisKm9pVq/F72GpEfU8gGSzbbKzqdbioS2c/amw5
        GAhKD0ekICN6HJYBrTez1g3dqx1qbDE6KfamHeKQxFU+8ZpX5jYnBoKGhhhyOsZB
        4jb+POttB5jPOJmL/FjD0RnQuVos+jPbmgLinYLPNjJNGylaDlL9VEtG62Fn3cVQ
        ==
X-ME-Sender: <xms:BsLsXplbpI1ROxtYv66f58pHwWcrmpXQzQPHtF0fXEwN1eAxxljI5A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BsLsXk2SSGD19yQ_yl4LC0YI1GjCfW0cfOKO1AjZUaOCPBxuAy33Yw>
    <xmx:BsLsXvrQs85K_gzbWlUu_hozdoY0WB35LaIjvHPy4RDRd8fuFYfYIw>
    <xmx:BsLsXpkCrEf9NqFtct0MybJyEYSTNYK269fXmZI_mYph4168i-AoPA>
    <xmx:BsLsXoBAgScvMS8xzzh7R74ynq6vKhlM9Pw_0fLJ7F8aUBOfflB2OQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41B14328005E;
        Fri, 19 Jun 2020 09:47:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: diskonchip: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:47:47 +0200
Message-ID: <15925744674415@kroah.com>
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

From c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 14:59:45 +0200
Subject: [PATCH] mtd: rawnand: diskonchip: Fix the probe error path

Not sure nand_cleanup() is the right function to call here but in any
case it is not nand_release(). Indeed, even a comment says that
calling nand_release() is a bit of a hack as there is no MTD device to
unregister. So switch to nand_cleanup() for now and drop this
comment.

There is no Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if it did not intruce
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-13-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/diskonchip.c b/drivers/mtd/nand/raw/diskonchip.c
index 97f0b05b47c1..f8ccee797645 100644
--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -1482,13 +1482,10 @@ static int __init doc_probe(unsigned long physadr)
 		numchips = doc2001_init(mtd);
 
 	if ((ret = nand_scan(nand, numchips)) || (ret = doc->late_init(mtd))) {
-		/* DBB note: i believe nand_release is necessary here, as
+		/* DBB note: i believe nand_cleanup is necessary here, as
 		   buffers may have been allocated in nand_base.  Check with
 		   Thomas. FIX ME! */
-		/* nand_release will call mtd_device_unregister, but we
-		   haven't yet added it.  This is handled without incident by
-		   mtd_device_unregister, as far as I can tell. */
-		nand_release(nand);
+		nand_cleanup(nand);
 		goto fail;
 	}
 

