Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691C3376675
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbhEGN4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:56:38 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:45653 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234081AbhEGN4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:56:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E10C3194156C;
        Fri,  7 May 2021 09:55:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 07 May 2021 09:55:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AoFXZJ
        fETnTXlVjjwV8COJyOUgsrpr2OvpHy6WZ8j3E=; b=XEKtiJbhcnB+u7G8lzwp53
        yi26Y/kr4OVMcmsNYoSeh5Jbo9P1rIdhJOxW0CzP1ZcqvVxBc+z0VgL7AzQKctIu
        SEgIVoiZxfQD/myQ9ygn3BemVBqNnlJYxpiS7C8epNjO/H4L99xCxvwK15fhh8fB
        b8ogfXl9a3/ukoa+NXnok5Pf89U/B0Ic4FHv6MMZ2OX6GaVHycahzRlDtEEWzDzL
        ZW4EtJCJPzVcAHWGCVp7DxyvGb25lOuD4xq94/FicjhwVGK/AI4mcKRafy4tlWRM
        NqlCnF7vre5/XZG3hCC+qjiyLelvAUin40uF9FIr7JoMb7FeYHt9ee17RTKUfvIA
        ==
X-ME-Sender: <xms:2EaVYK7BvYYeRz6aySLrrg1qNGCI4o213Kv_oK6fWam81mYH-x8reA>
    <xme:2EaVYD7nK5OiO92JpGZhZGHArYGE7NkN38eC5yH6n9qs9AsxwOnHX1v8LSSJsBZWV
    MfOH9CjuXawew>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegvddgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2EaVYJeB-wNwHBXwionYMw0YcIv4_Oj-zlRlKK05VuYNjhVwiPojcg>
    <xmx:2EaVYHJDm1aVGQuaHMjy6KL-8qimvODbTk_Mhrfrjpb9c4zrrAPNdw>
    <xmx:2EaVYOLnD6REbO-sYltTow91-zeI0cXHaJmPrUpXON4kdB6dQEO4KA>
    <xmx:2UaVYAiLuEG2E7HkR8Qc3As_2_nVYEpQCoEezu6QvKBkR9yg5CDPcQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri,  7 May 2021 09:55:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: atmel: Update ecc_stats.corrected counter" failed to apply to 4.14-stable tree
To:     kai.stuhlemmer@ebee.de, miquel.raynal@bootlin.com,
        tudor.ambarus@microchip.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 07 May 2021 15:55:34 +0200
Message-ID: <162039573410831@kroah.com>
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

From 33cebf701e98dd12b01d39d1c644387b27c1a627 Mon Sep 17 00:00:00 2001
From: "Kai Stuhlemmer (ebee Engineering)" <kai.stuhlemmer@ebee.de>
Date: Mon, 22 Mar 2021 17:07:14 +0200
Subject: [PATCH] mtd: rawnand: atmel: Update ecc_stats.corrected counter

Update MTD ECC statistics with the number of corrected bits.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210322150714.101585-1-tudor.ambarus@microchip.com

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index e6ceec8f50dc..8aab1017b460 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -883,10 +883,12 @@ static int atmel_nand_pmecc_correct_data(struct nand_chip *chip, void *buf,
 							  NULL, 0,
 							  chip->ecc.strength);
 
-		if (ret >= 0)
+		if (ret >= 0) {
+			mtd->ecc_stats.corrected += ret;
 			max_bitflips = max(ret, max_bitflips);
-		else
+		} else {
 			mtd->ecc_stats.failed++;
+		}
 
 		databuf += chip->ecc.size;
 		eccbuf += chip->ecc.bytes;

