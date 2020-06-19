Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B4B200A9B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731131AbgFSNsm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:48:42 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:38561 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgFSNsm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:48:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D113B1945791;
        Fri, 19 Jun 2020 09:48:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZztEDT
        Y0hpmEb6kegmugi0LDuuLYHhQH1WusXUmaF/M=; b=h0WqP/sYqdnz07HwtX8q0X
        Xb41bf2dcN+lr+/rZBabFnRepwkfrEXZLBoyvBqwfVp6XLsj+dMGh7sciEaK3wDo
        ih5p23QeceiIE/1O7z6wtYZVoVNXCD7vHZL3nByK6LW/Q28FlF8rIvbMiQavaNaM
        iMnvR5igIwc7sjANCvz4LRUfeJ8Mx7aQZy2zABWu6ETCNQwM5QwahcNeXcgJO1Y9
        790nbGGNFw1EKiXuGuDpBkewxvRAXIMDVwq4nDmsmm4BjqnxEbeNdK3uuYlHegME
        kWJf/RrWrLf7mlBhb9260Zxj138u8wGEBrChLKosFZj6N3VqszZEVCOpkktlwgaw
        ==
X-ME-Sender: <xms:OMLsXmzNehzoM-08inwIPm65zUALV4BNsUKKaqeMVWAX8xo60Bxb7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepieenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:OMLsXiSbXsT2FbjDMjeOQQAzCwkVzLlQ_v4tf4Wwo07bnxEhhazCdA>
    <xmx:OMLsXoW-OtDxczi9S0lsppPca0cwFxkeP5AGG2uFw3v6knPYpp2vXQ>
    <xmx:OMLsXsgIrq33PE-oPhSnnyKrpyumm4N6vOY4XjRn4yCanUDDqc94fA>
    <xmx:OMLsXjpHbaBmOKOHr9knC83IBBnfCD3zWYlJUktpdf-aEAm9zdP8kg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 54A273061CCB;
        Fri, 19 Jun 2020 09:48:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: ingenic: Fix the probe error path" failed to apply to 4.9-stable tree
To:     miquel.raynal@bootlin.com, harveyhuntnexus@gmail.com,
        paul@crapouillou.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:48:38 +0200
Message-ID: <15925745187257@kroah.com>
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

From de17cade0e034e9b721a6db9b488014effac1e5a Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 14:59:54 +0200
Subject: [PATCH] mtd: rawnand: ingenic: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. Hence, pointing it as the commit to
fix for backporting purposes, even if this commit is not introducing
any bug makes sense.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Harvey Hunt <harveyhuntnexus@gmail.com>
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-22-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
index e7bd845fdbf5..3bfb6fa8bad9 100644
--- a/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
+++ b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
@@ -376,7 +376,7 @@ static int ingenic_nand_init_chip(struct platform_device *pdev,
 
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
-		nand_release(chip);
+		nand_cleanup(chip);
 		return ret;
 	}
 

